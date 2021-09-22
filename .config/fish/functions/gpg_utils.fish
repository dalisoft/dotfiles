function gpg_rem_keys --argument name
    gpg --delete-secret-key $name
    gpg --delete-key $name
end
