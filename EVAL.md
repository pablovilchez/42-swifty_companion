Verify .env file is present, but not in repository

Check hash of folders and files (intra and local)
```
Get-ChildItem -Recurse -Path lib | Get-FileHash -Algorithm SHA256 | Out-File hashes.txt
