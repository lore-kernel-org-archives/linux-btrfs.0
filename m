From: Raskin Michael <raskin@mccme.ru>
Subject: Ghost file.
Date: Tue, 07 Jul 2009 23:05:31 +0400
Message-ID: <4A539C7B.7000506@mccme.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I mentioned a ghost file. Here is the dump (less than 65M):
http://dev.mccme.ru/~raskin/btrfs.dump

ghost file is:
885dj1l4788pymp3bk2f3dz52ggcvw4v-empty/garbage-1/mwave.h.tmp-31838-1822528541

It has a name, but stat fails (so no inode, I guess). Also I can create
another file with the same name in the directory. I cannot remove the
file, or containing directory.

fsck output:

root 5 inode 273 errors 0
        unresolved ref dir 270 index 2 namelen 4 name attr filetype 0
error 3
root 5 inode 274 errors 0
        unresolved ref dir 271 index 2 namelen 2 name cs filetype 0 error 3
root 5 inode 275 errors 0
        unresolved ref dir 271 index 3 namelen 2 name de filetype 0 error 3
root 5 inode 276 errors 0
        unresolved ref dir 271 index 4 namelen 2 name es filetype 0 error 3
root 5 inode 277 errors 0
        unresolved ref dir 271 index 5 namelen 2 name fr filetype 0 error 3
root 5 inode 278 errors 0
        unresolved ref dir 271 index 6 namelen 2 name gl filetype 0 error 3
root 5 inode 279 errors 0
        unresolved ref dir 271 index 7 namelen 2 name nl filetype 0 error 3
root 5 inode 280 errors 0
        unresolved ref dir 271 index 8 namelen 2 name pl filetype 0 error 3
root 5 inode 281 errors 0
        unresolved ref dir 271 index 9 namelen 2 name sv filetype 0 error 3
root 5 inode 290 errors 0
        unresolved ref dir 272 index 2 namelen 4 name man1 filetype 0
error 3
root 5 inode 291 errors 0
        unresolved ref dir 272 index 3 namelen 4 name man2 filetype 0
error 3
root 5 inode 292 errors 0
        unresolved ref dir 272 index 4 namelen 4 name man3 filetype 0
error 3
root 5 inode 293 errors 0
        unresolved ref dir 272 index 5 namelen 4 name man5 filetype 0
error 3
root 5 inode 316 errors 2000
        unresolved ref dir 353285 index 1288 namelen 28 name
mwave.h.tmp-31838-1822528541 filetype 1 error 1
root 5 inode 353285 errors 200
found 11118575893 bytes used err is 1
total csum bytes: 10369224
total tree bytes: 433348608
total fs tree bytes: 373395456
btree space waste bytes: 106980960
file data blocks allocated: 10831892480
 referenced 10617970688
Btrfs Btrfs v0.19
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKU5x5AAoJEE6tnN0aWvw3SH4H/i0nQpWWkHL/ZpzgvjvSAjK7
43fkxKTf5VjWB2PJ2H/UTcjp1QIET45HLhH9UN76F9FIYamUOf57bxS5f6XLj8gP
h2WjpIcHkOfmP/+bgge9iUc4zufyHjvPSiwr+ODhWZD0OvOnYww9QxzG6DIctJPF
KwFC8OolWlZt09gSTlkozNLZxJxprKw2g7MrL7j2yKC3fC+MJGfjLMMlzP4ouoPO
8HI/X8I4YLJWyRC4fMCuAVTgMBdV/dZUM3zjp0GNbkavcqWFGTSg3I9H7aqRJvgP
2hSc7PzAPah9kQZUu5fVHhUUOHFK1GJnMuVmDLtbFY70IGCFcvqUoCXJezGQjcA=
=eVog
-----END PGP SIGNATURE-----
