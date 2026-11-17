#!/usr/bin/env node

/**
 * Apply a context-window preset to AI coding agents.
 *
 * Usage:
 *   node ./scripts/ai-context.ts [--preset <name>] [--agent a,b,...] [--dry-run]
 *
 * Presets (default: econom):
 *   minimal 200K context, idle compact at 100K, 24K compact reserve
 *   econom  272K context, idle compact at 128K, 28K compact reserve
 *   smart   400K context, idle compact at 160K, 32K compact reserve
 *   max     1M context,   idle compact at 200K, 48K compact reserve
 *
 * Agents (comma-separated, default: all):
 *   claude    .claude/settings.json env + .config/fish/config.fish env
 *   opencode  .config/opencode/opencode.json  providers.*.models.*.limit.context, compaction.buffer
 *   pi        .pi/agent/models.json           providers.*.models[].contextWindow
 *             .pi/agent/settings.json         compaction.reserveTokens
 *   codex     ~/.codex/config.toml            model_context_window, model_auto_compact_token_limit
 *   cmd-code  no context-window setting exists (only compactMode default|fast); reports and skips
 *
 * Paths are relative to the dotfiles repo; `~/` paths (not tracked in the repo) are edited in place.
 * Idle compaction is a Claude Code-only setting; other agents only get the context window.
 * `reserve` (tokens kept free before auto-compact) applies to every agent that has one:
 * opencode `compaction.buffer`, pi `compaction.reserveTokens`, codex context window minus reserve.
 * Claude Code and Command Code have no reserve setting.
 *
 * Examples:
 *   node ./scripts/ai-context.ts                                 # econom, all agents
 *   node ./scripts/ai-context.ts --preset minimal                # all agents
 *   node ./scripts/ai-context.ts --preset smart --agent claude,codex,opencode,pi,cmd-code
 *   node ./scripts/ai-context.ts --preset max --agent claude     # only Claude Code
 */
import { readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import { parseArgs } from "node:util";

const DEFAULT_PRESET = "econom";

const presets = {
  econom: {
    context: 272_000,
    idleCompact: 128_000,
    reserve: 28_000,
  },
  max: {
    context: 1_000_000,
    idleCompact: 200_000,
    reserve: 48_000,
  },
  minimal: {
    context: 200_000,
    idleCompact: 100_000,
    reserve: 24_000,
  },
  smart: {
    context: 400_000,
    idleCompact: 160_000,
    reserve: 32_000,
  },
} as const;

type Preset = ( typeof presets )[ keyof typeof presets ];
type Json = Record< string, any >;
type Setter = ( obj: Json, key: string, value: unknown, path: string ) => void;

const ROOT = join( import.meta.dirname, ".." );

/** Resolve `~/…` to the home directory, anything else to the repo root. */
const resolve = ( file: string ) =>
  file.startsWith( "~/" )
    ? join( homedir(), file.slice( 2 ) )
    : join( ROOT, file );

/** Read a file (see `resolve`); returns `undefined` (with a warning) if it doesn't exist. */
const read = async ( file: string ) => {
  try {
    return await readFile( resolve( file ), "utf8" );
  } catch ( error ) {
    if ( ( error as NodeJS.ErrnoException ).code !== "ENOENT" ) throw error;
    console.warn( `skip ${ file }: not found` );
    return undefined;
  }
};

/** Print collected changes and write the file unless it's a dry run. */
const commit = async (
  file: string,
  changes: string[],
  text: string,
  dryRun: boolean,
) => {
  if ( changes.length === 0 ) {
    console.log( `unchanged ${ file }` );
    return;
  }

  console.log( `${ dryRun ? "would update" : "updated" } ${ file }` );
  console.log( changes.join( "\n" ) );
  if ( ! dryRun ) await writeFile( resolve( file ), text );
};

/** Load a JSON file, let `update` mutate it through `set`, write back only if something changed. */
const editJson = async (
  file: string,
  update: ( config: Json, set: Setter ) => void,
  dryRun: boolean,
) => {
  const raw = await read( file );
  if ( raw === undefined ) return;

  let config: Json;
  try {
    config = JSON.parse( raw );
  } catch ( error ) {
    console.error(
      `skip ${ file }: invalid JSON (${ ( error as Error ).message })`,
    );
    return;
  }

  const changes: string[] = [];
  update( config, ( obj, key, value, path ) => {
    if ( obj[ key ] === value ) return;
    changes.push( `  ${ path }: ${ obj[ key ] } → ${ value }` );
    obj[ key ] = value;
  } );

  const eol = raw.endsWith( "\n" ) ? "\n" : "";
  await commit(
    file,
    changes,
    JSON.stringify( config, null, 2 ) + eol,
    dryRun,
  );
};

/** Replace existing `set -gx NAME value` lines in a fish config. */
const editFish = async (
  file: string,
  vars: Record< string, number >,
  dryRun: boolean,
) => {
  let text = await read( file );
  if ( text === undefined ) return;

  const changes: string[] = [];
  for ( const [ name, value ] of Object.entries( vars ) ) {
    const line = new RegExp( `^set -gx ${ name } (.*)$`, "m" );
    const match = text.match( line );
    if ( ! match ) {
      console.warn(
        `  ${ file }: no "set -gx ${ name }" line, add one manually`,
      );
      continue;
    }
    if ( match[ 1 ] !== String( value ) ) {
      changes.push( `  ${ name }: ${ match[ 1 ] } → ${ value }` );
      text = text.replace( line, `set -gx ${ name } ${ value }` );
    }
  }

  await commit( file, changes, text, dryRun );
};

/** Replace existing top-level `key = value` lines in a TOML file (keys inside [tables] are not touched). */
const editToml = async (
  file: string,
  keys: Record< string, number >,
  dryRun: boolean,
) => {
  const text = await read( file );
  if ( text === undefined ) return;

  // Top-level keys live before the first [table] header
  const tableStart = text.search( /^\s*\[/m );
  const splitAt = tableStart === -1 ? text.length : tableStart;
  let head = text.slice( 0, splitAt );

  const changes: string[] = [];
  for ( const [ key, value ] of Object.entries( keys ) ) {
    const line = new RegExp(
      `^(${ key }\\s*=\\s*)([^#\\n]*?)(\\s*(?:#.*)?)$`,
      "m",
    );
    const match = head.match( line );
    if ( ! match ) {
      console.warn(
        `  ${ file }: no top-level "${ key } = …" line, add one manually`,
      );
      continue;
    }
    if ( match[ 2 ] !== String( value ) ) {
      changes.push( `  ${ key }: ${ match[ 2 ] } → ${ value }` );
      head = head.replace( line, `$1${ value }$3` );
    }
  }

  await commit( file, changes, head + text.slice( splitAt ), dryRun );
};

const agents = {
  async claude( preset: Preset, dryRun: boolean ) {
    const vars = {
      CLAUDE_CODE_AUTO_COMPACT_WINDOW: preset.context,
      CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS: preset.idleCompact,
    };

    await editJson(
      ".claude/settings.json",
      ( config, set ) => {
        config.env ??= {};
        for ( const [ name, value ] of Object.entries( vars ) ) {
          // settings.json env values are strings
          set( config.env, name, String( value ), `env.${ name }` );
        }
      },
      dryRun,
    );

    await editFish( ".config/fish/config.fish", vars, dryRun );
  },

  async "cmd-code"() {
    console.log( "skip cmd-code: Command Code has no context-window setting" );
  },

  async codex( preset: Preset, dryRun: boolean ) {
    await editToml(
      "~/.codex/config.toml",
      {
        model_auto_compact_token_limit: preset.context - preset.reserve,
        model_context_window: preset.context,
      },
      dryRun,
    );
  },

  async opencode( preset: Preset, dryRun: boolean ) {
    await editJson(
      ".config/opencode/opencode.json",
      ( config, set ) => {
        if ( config.compaction ) {
          set(
            config.compaction,
            "buffer",
            preset.reserve,
            "compaction.buffer",
          );
        }

        for ( const [ providerId, provider ] of Object.entries< Json >(
          config.providers ?? {},
        ) ) {
          for ( const [ modelId, model ] of Object.entries< Json >(
            provider.models ?? {},
          ) ) {
            if ( typeof model.limit?.context !== "number" ) continue;
            set(
              model.limit,
              "context",
              preset.context,
              `providers.${ providerId }.models.${ modelId }.limit.context`,
            );
          }
        }
      },
      dryRun,
    );
  },

  async pi( preset: Preset, dryRun: boolean ) {
    await editJson(
      ".pi/agent/settings.json",
      ( config, set ) => {
        if ( config.compaction ) {
          set(
            config.compaction,
            "reserveTokens",
            preset.reserve,
            "compaction.reserveTokens",
          );
        }
      },
      dryRun,
    );

    await editJson(
      ".pi/agent/models.json",
      ( config, set ) => {
        for ( const [ providerId, provider ] of Object.entries< Json >(
          config.providers ?? {},
        ) ) {
          for ( const model of ( provider.models ?? [] ) as Json[] ) {
            if ( typeof model.contextWindow !== "number" ) continue;
            set(
              model,
              "contextWindow",
              preset.context,
              `providers.${ providerId }.models[${ model.id }].contextWindow`,
            );
          }
        }
      },
      dryRun,
    );
  },
} as const;

type Agent = keyof typeof agents;

function usage( code = 1 ): never {
  ( code === 0 ? console.log : console.error )(
    `Usage: ai-context.ts [--preset <${ Object.keys( presets ).join( "|" ) }> (default: ${ DEFAULT_PRESET })] [--agent ${ Object.keys(
      agents,
    ).join( "," ) }] [--dry-run]`,
  );
  process.exit( code );
}

const parseCli = () => {
  try {
    return parseArgs( {
      args: process.argv.slice( 2 ),
      options: {
        agent: {
          short: "a",
          type: "string",
        },
        "dry-run": {
          default: false,
          type: "boolean",
        },
        help: {
          default: false,
          short: "h",
          type: "boolean",
        },
        preset: {
          short: "p",
          type: "string",
        },
      },
    } ).values;
  } catch ( error ) {
    console.error( ( error as Error ).message );
    return usage();
  }
};

const values = parseCli();

const presetName = values.preset ?? DEFAULT_PRESET;
if ( values.help ) usage( 0 );

if ( ! Object.hasOwn( presets, presetName ) ) {
  console.error( `Unknown preset "${ presetName }"` );
  usage();
}

const agentNames = ( values.agent ?? "" )
  .split( "," )
  .map( ( name ) => name.trim() )
  .filter( Boolean );

const unknownAgents = agentNames.filter(
  ( name ) => ! Object.hasOwn( agents, name ),
);
if ( unknownAgents.length > 0 ) {
  console.error( `Unknown agent(s): ${ unknownAgents.join( ", " ) }` );
  usage();
}

const preset = presets[ presetName as keyof typeof presets ];
const selected = (
  agentNames.length > 0
    ? [
        ...new Set( agentNames ),
      ]
    : Object.keys( agents )
) as Agent[];
const dryRun = values[ "dry-run" ];

console.log(
  `Preset "${ presetName }": context ${ preset.context }, idle compact ${ preset.idleCompact }, reserve ${ preset.reserve }${
    dryRun ? " (dry run)" : ""
  }\n`,
);

for ( const agent of selected ) {
  await agents[ agent ]( preset, dryRun );
}
