# Adblock filter list Signer #

Signs Adblock `filter list` files.

A typical `filter list` file looks like:

```
[Adblock Plus 2.0]
! Checksum: vNqeap3fcZ7BZI6KZmn4cA
! Version: 201801010000
! Title: Sample
! Last modified: 17 Mar 2018 10:00 UTC
! Expires: 1 days (update frequency)
! Homepage: https://example.com/
!
someRulesHere
```

You can find details on how to write such a file [here](https://adblockplus.org/filters) and [here](https://adblockplus.org/filter-cheatsheet).

In above sample in second line we have:

`! Checksum: vNqeap3fcZ7BZI6KZmn4cA`

Which is the [md5](https://en.wikipedia.org/wiki/MD5) checksum of the `filter list` file without that line!

You can write your rules and leave signing to this script. This script also

* Removes empty lines.
* Converts file encoding to UTF-8.
* Converts line breaks to Unix style.
* Calculates and adds/replaces `Checksum` comment.

## Usage ##

```bash
$ bash adb-sign.sh input.txt output.txt
```

Where `input.txt` is your unsigned `filter list` file and `output.txt` is that file with signature added.