---
title: Fetch missing GnuPG key IDs
---

I just had a look at the signatures in my keyring and noticed alot of missing key IDs. 

I had a look for some sort of automation for fetching missing keys, but realised, that it would not make much sense to make this easily available, as this would very probably fetch the whole [strong set of the Web of Trust](), containing several thousend keys, if applied repeatedly. 

For one- or two-time-use I made this little hack.

```
gpg2 --list-sigs | grep -Pho '([A-Z0-9]{16}).*\[User ID not found' | grep -Eo '[A-Z0-9]{16} | sort -u > missing-ids'
while read x; do gpg2 --recv-keys $x ; done < missing-ids

rm missing-ids
``` 

It goes through the list of all signatures and greps for missing IDs. Please note, that the string `User ID not found` may differ, depending on your system language.

Please also note, that the latter command fetches the key from the configured keyserver. This potentially leaks information about your contacts out of your local system. 
