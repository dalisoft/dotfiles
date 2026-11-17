#!/usr/bin/env bun

/**
 * Script to replace context window for AI Agents
 * Usage example:
 *
 * Claude Code, OpenCode and Pi agent update
 * ```bash
 bun run ./scripts/ai-context.ts \
      --CLAUDE_CODE_AUTO_COMPACT_WINDOW 400000 \
      --CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS 192000 \
      --context 400000 \
      --contextWindow 400000
 * ```
 *
 * Claude Code only
 * ```bash
 bun run ./scripts/ai-context.ts \
      --CLAUDE_CODE_AUTO_COMPACT_WINDOW 400000 \
      --CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS 192000
 * ```
 */
const [ _runtime, _file, ..._args ] = process.argv;

const argsCollect = ( _args as string[] ).reduce(
  ( obj: Record< string, string >, key, index, self ) => {
    if ( key.startsWith( "--" ) ) {
      obj[ key.slice( 2 ) ] = self[ index + 1 ];
    }

    return obj;
  },
  {},
);

const ai_agent_files = {
  claude: [
    ".claude/settings.json",
  ],
  cmd_code: [
    ".commandcode/settings.json",
  ],
  opencode: [
    ".config/opencode/opencode.json",
  ],
  pi: [
    ".pi/agent/settings.json",
    ".pi/agent/models.json",
  ],
} as const;

const matcher_replaces = Object.entries( argsCollect ).map( ( entry ) => ( {
  checkValue: ( key: string ) => entry[ 0 ] === key,
  setValue: () => entry[ 1 ],
} ) );

const matcher_run = <
  T extends [
    string,
    unknown,
  ],
>(
  config: Record< string, unknown >,
  [ key, value ]: T,
) => {
  if ( typeof value === "object" && value !== null ) {
    return Object.entries( config[ key ] as typeof config )
      .map<boolean>( ( value ) => matcher_run( config[ key ] as typeof config, value ) )
      .some( Boolean );
  }

  let changed = false;
  for ( const { checkValue, setValue } of matcher_replaces ) {
    if ( checkValue( key ) ) {
      const inferType = typeof config[ key ];
      const coerceType = < T >( value: T ) =>
        inferType === "string"
          ? String( value )
          : inferType === "number"
            ? Number( value )
            : value;

      const newValue = coerceType( setValue() );

      if ( config[ key ] !== newValue ) {
        config[ key ] = newValue;
        changed = true;
      }
    }
  }

  return changed;
};

let agent: keyof typeof ai_agent_files;
for ( agent in ai_agent_files ) {
  for ( const file of ai_agent_files[ agent ] ) {
    const config = await Bun.file( file ).json();

    if (
      Object.entries( config )
        .map( ( value ) => matcher_run( config, value ) )
        .some( Boolean )
    ) {
      console.log( "Config updated for: ", file );
      await Bun.file( file ).write( JSON.stringify( config, null, 2 ) );
    }
  }
}
