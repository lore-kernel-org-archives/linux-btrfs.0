Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62606 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbeAVOiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 09:38:51 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
Date: Mon, 22 Jan 2018 22:38:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t2MgURmlJUUdO6WzdXxxO0VAVVlLrNvSI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t2MgURmlJUUdO6WzdXxxO0VAVVlLrNvSI
Content-Type: multipart/mixed; boundary="j9HljG6wvtentkGRjeqkPNs1cjrQD0ydX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
In-Reply-To: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>

--j9HljG6wvtentkGRjeqkPNs1cjrQD0ydX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8822=E6=97=A5 22:11, ^m'e wrote:
> Hi there,
>=20
> After resuming from hibernation, my system shows weirdness; the
> following dmesg line alerted me:
>=20
>   Jan 22 08:10:33 [kernel] BTRFS critical (device sdb3): invalid dir
> item name + data len: 3 + 32907

This is true problem.

No dir item should have such large size, so it's definitely a corruption.=


But until you ls the dir containing the offending dir item, it shouldn't
cause problem.

>=20
> Although I can boot (root is BTRFS), (re-)mount the concerned FS,
> succesfully scrub it (no error reported), I'm unable to repair... More
> info (using a sysrescue with static a btrfs-progs build -- the same
> installed on the main Funtoo system):
>=20
>   # uname -a
>   Linux sysresccd 4.9.60-std512-amd64 #2 SMP Thu Nov 2 17:43:13 UTC
> 2017 x86_64 Intel(R) Core(TM) i7-4702MQ CPU @ 2.20GHz GenuineIntel
> GNU/Linux
>=20
>   # ./btrfs.static --version
>   btrfs-progs v4.14.1
>=20
>   # ./btrfs.static fi show
>    Label: 'BTR-POOL'  uuid: de1723e2-150c-4448-bb36-be14d7d96093
>     Total devices 1 FS bytes used 97.73GiB
>     devid    1 size 230.35GiB used 173.04GiB path /dev/sdb3
>=20
>   # ./btrfs.static fi df /mnt/gentoo/
>   Data, single: total=3D167.00GiB, used=3D95.64GiB
>   System, single: total=3D32.00MiB, used=3D48.00KiB
>   Metadata, single: total=3D6.01GiB, used=3D2.09GiB
>   GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
>   # dmesg | grep BTRFS
>  [14963.234135] BTRFS info (device sdb3): disk space caching is enabled=

>  [14963.234138] BTRFS info (device sdb3): has skinny extents
>  [14963.261054] BTRFS info (device sdb3): detected SSD devices,
> enabling SSD mode
>  [14963.261485] BTRFS info (device sdb3): checking UUID tree
>=20
>=20
> As for check and repair attempts:
>=20
> ------------------------------------------8<---------------------------=
-----------
> # ./btrfs.static check -p --mode=3Dlowmem --check-data-csum /dev/sdb3
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> ERROR: data extent[1862352896 425984] backref lost
> ERROR: data extent[1886453760 479232] backref lost
> ERROR: data extent[1902219264 524288] backref lost
> ERROR: data extent[1817378816 151552] backref lost
> ERROR: data extent[1799688192 57344] backref lost
> ERROR: data extent[1830277120 258048] backref lost
> ERROR: data extent[2558107648 1368064] backref lost

Not the best way to verify "backref lost" error.

Current lowmem mode is not 100% proven for such error detection, so it
may be false alerts, until original (no --repair) mode also reports such
problem.

But considering your later original mode repair is trying to insert
extent items for them, it's good to know they are not false alerts.

And for these errors, btrfs-progs repair should handle them well, so
they are not the main concern.

> ERROR: errors found in extent allocation tree or chunk allocation
> cache and super generation don't match, space cache will be invalidated=

> ERROR: root 257 DIR_ITEM[30039322 4007295565] name  namelen 0 filetype
> 0 mismatch with its hash, wanted 4007295565 have 4294967294

And such error is what lowmem mode better at.

One dir item has mismatch hash with its data, either the data len is
corrupted or the hash.

> ERROR: root 257 INODE_ITEM[0] index 18446744073709551615 name
> filetype 0 missing
> ERROR: root 257 DIR_ITEM[30039322 4007295565] data_len shouldn't be 329=
07

Paired with the first error, it's obvious the namelen is corrupted.

> ERROR: root 257 DIR_ITEM[30039322 4007295565] name  namelen 3 filetype
> 0 mismatch with its hash, wanted 4007295565 have 987418363
> ERROR: root 257 INODE_ITEM[0] index 18446744073709551615 name
> filetype 0 missing

And some obvious index key corruption in INODE_REF.
The index is way too large for any sane fs.

So clearly a leaf (maybe more leaves) corruption.

And that's why btrfs uses DUP for its metadata as default.
(You just need to pay that cost since you choose to use single meta profi=
le)

> ERROR: root 1385 INODE_ITEM[0] index 18446744073709551615 name
> metadata.xml filetype 1 missing
> ERROR: root 1385 DIR_ITEM[30039322 4007295565] name  namelen 0
> filetype 0 mismatch with its hash, wanted 4007295565 have 4294967294
> ERROR: root 1385 INODE_ITEM[0] index 18446744073709551615 name
> filetype 0 missing
> ERROR: root 1385 DIR_ITEM[30039322 4007295565] data_len shouldn't be 32=
907
> ERROR: root 1385 DIR_ITEM[30039322 4007295565] name  namelen 3
> filetype 0 mismatch with its hash, wanted 4007295565 have 987418363
> ERROR: root 1385 INODE_ITEM[0] index 18446744073709551615 name
> filetype 0 missing
> ERROR: root 1385 DIR ITEM[30039322 2] name  filetype 1 missing
> ERROR: root 1385 INODE REF[30039323, 30039322] name  filetype 1 missing=

> ERROR: root 1385 DIR ITEM[30039322 3] name metadata.xml filetype 1 mism=
ath
> ERROR: root 1385 DIR ITEM[30039322 5] name Manifest filetype 1 mismath
> ERROR: root 1385 INODE_ITEM[47302014] index 6 name metadata.xml
> filetype 1 missing
> ERROR: root 1385 INODE_ITEM[47302015] index 7 name metadata.xml
> filetype 1 missing
> ERROR: root 1385 DIR INODE [30039322] size 152 not equal to 163

The good news is, the corruption seems to be all in one leaf, or at
least for one subvolume.


> ERROR: errors found in fs roots
> found 104939749376 bytes used, error(s) found
> total csum bytes: 100264520
> total tree bytes: 15521644544
> total fs tree bytes: 15299624960
> total extent tree bytes: 88293376
> btree space waste bytes: 3468278611
> file data blocks allocated: 373752188928
>  referenced 322517573632
> ------------------------------------------8<---------------------------=
-----------
>=20
>=20
> ------------------------------------------8<---------------------------=
-----------
> # ./btrfs.static check -p  --repair /dev/sdb3
> Fixed 0 roots.
> enabling repair mode
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> ref mismatch on [1799688192 57344] extent item 2, found 1
> Incorrect local backref count on 1799688192 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xde7d020
> Backref disk bytenr does not match extent record, bytenr=3D1799688192,
> ref bytenr=3D0
> backpointer mismatch on [1799688192 57344]
> repair deleting extent record: key 1799688192 168 57344
> adding new data backref on 1799688192 root 257 owner 47301992 offset 0 =
found 1
> Repaired extent references for 1799688192
> ref mismatch on [1817378816 151552] extent item 2, found 1
> Incorrect local backref count on 1817378816 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xde78200
> Backref disk bytenr does not match extent record, bytenr=3D1817378816,
> ref bytenr=3D0
> backpointer mismatch on [1817378816 151552]
> repair deleting extent record: key 1817378816 168 151552
> adding new data backref on 1817378816 root 257 owner 47301982 offset 0 =
found 1
> Repaired extent references for 1817378816
> ref mismatch on [1830277120 258048] extent item 2, found 1
> Incorrect local backref count on 1830277120 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xde98c00
> Backref disk bytenr does not match extent record, bytenr=3D1830277120,
> ref bytenr=3D0
> backpointer mismatch on [1830277120 258048]
> repair deleting extent record: key 1830277120 168 258048
> adding new data backref on 1830277120 root 257 owner 47302002 offset 0 =
found 1
> Repaired extent references for 1830277120
> ref mismatch on [1862352896 425984] extent item 2, found 1
> Incorrect local backref count on 1862352896 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xddedd30
> Backref disk bytenr does not match extent record, bytenr=3D1862352896,
> ref bytenr=3D0
> backpointer mismatch on [1862352896 425984]
> repair deleting extent record: key 1862352896 168 425984
> adding new data backref on 1862352896 root 257 owner 47301952 offset 0 =
found 1
> Repaired extent references for 1862352896
> ref mismatch on [1886453760 479232] extent item 2, found 1
> Incorrect local backref count on 1886453760 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xde45b10
> Backref disk bytenr does not match extent record, bytenr=3D1886453760,
> ref bytenr=3D0
> backpointer mismatch on [1886453760 479232]
> repair deleting extent record: key 1886453760 168 479232
> adding new data backref on 1886453760 root 257 owner 47301962 offset 0 =
found 1
> Repaired extent references for 1886453760
> ref mismatch on [1902219264 524288] extent item 2, found 1
> Incorrect local backref count on 1902219264 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xde54c50
> Backref disk bytenr does not match extent record, bytenr=3D1902219264,
> ref bytenr=3D0
> backpointer mismatch on [1902219264 524288]
> repair deleting extent record: key 1902219264 168 524288
> adding new data backref on 1902219264 root 257 owner 47301972 offset 0 =
found 1
> Repaired extent references for 1902219264
> ref mismatch on [2558107648 1368064] extent item 2, found 1
> Incorrect local backref count on 2558107648 parent 186517012480 owner
> 0 offset 0 found 0 wanted 1 back 0xdefd520
> Backref disk bytenr does not match extent record, bytenr=3D2558107648,
> ref bytenr=3D0
> backpointer mismatch on [2558107648 1368064]
> repair deleting extent record: key 2558107648 168 1368064
> adding new data backref on 2558107648 root 257 owner 47302009 offset 0 =
found 1
> Repaired extent references for 2558107648
> owner ref check failed [186517012480 16384]
> repair deleting extent record: key 186517012480 168 16384
> adding new tree backref on start 186517012480 len 16384 parent 0 root 1=
385
> Repaired extent references for 186517012480
>=20
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated=

> ERROR: DIR_ITEM[30039322 4007295565] name  ]=EF=BF=BD  namelen 0 filety=
pe 0
> mismatch with its hash, wanted 4007295565 have 4294967294
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
> mismatch with its hash, wanted 4007295565 have 987418363
> invalid location in dir item 125
> root 257 inode 30039322 errors 10, odd dir item
> Failed to reset nlink for inode 18446744073709551361: No such file or d=
irectory
>     unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>     unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
> errors 6, no dir index, no inode ref
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  ]=EF=BF=BD  namelen 0 filety=
pe 0
> mismatch with its hash, wanted 4007295565 have 4294967294
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
> mismatch with its hash, wanted 4007295565 have 987418363
> invalid location in dir item 125
> Deleting bad dir index [30039322,96,2] root 1385
> Deleting bad dir index [30039322,96,6] root 1385
> Deleting bad dir index [30039322,96,7] root 1385
> invalid dir item size
> adding missing dir index/item pair for inode 30039323
> invalid dir item size
> ERROR: DIR_ITEM[30039322 4007295565] name  ]=EF=BF=BD  namelen 0 filety=
pe 0
> mismatch with its hash, wanted 4007295565 have 4294967294
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
> mismatch with its hash, wanted 4007295565 have 987418363
> invalid location in dir item 125
> root 257 inode 30039322 errors 10, odd dir item
> Failed to reset nlink for inode 18446744073709551361: No such file or d=
irectory
>     unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>     unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
> errors 6, no dir index, no inode ref
> ERROR: DIR_ITEM[30039322 4007295565] name  ]=EF=BF=BD  namelen 0 filety=
pe 0
> mismatch with its hash, wanted 4007295565 have 4294967294
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
> mismatch with its hash, wanted 4007295565 have 987418363
> invalid location in dir item 125
> root 257 inode 30039322 errors 10, odd dir item
> Failed to reset nlink for inode 18446744073709551361: No such file or d=
irectory
>     unresolved ref dir 30039322 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>     unresolved ref dir 30039322 index 0 namelen 3 name  filetype 0
> errors 6, no dir index, no inode ref
> ERROR: DIR_ITEM[30039322 4007295565] name  ]=EF=BF=BD  namelen 0 filety=
pe 0
> mismatch with its hash, wanted 4007295565 have 4294967294
> invalid location in dir item 0
> ERROR: DIR_ITEM[30039322 4007295565] name  namelen 3 filetype 0
> mismatch with its hash, wanted 4007295565 have 987418363
> invalid location in dir item 125
> root 257 inode 30039322 errors 10, odd dir item
> ....
> ------------------------------------------8<---------------------------=
-----------
>=20
> Note that the repair run seems stuck * looping* on the same inode
> 18446744073709551361, it doesn't progress (though I stopped it after
> half an hour).

We could enhance the repair, but considering how many problem we have in
a single leaf, the fix won't come any time soon.

>=20
> Please, help!

If you really need quick and dirty (maybe sometimes deadly) fix, I could
hand craft some small fixes, but no warranty to work.

Please provide the following data:
(Unfortunately, to really make it work, we need the exact length of each
filename, so censoring your filename is not a good idea, and may leak
your confidential info. And none ASCII chars in filename may make the
case even worse)

# btrfs-debug-tree -t 1385 <device> | grep -C 20 30039322

And later work may need extra info too, depending on the corruption type.=


Thanks,
Qu

>=20
> Cheers,
>=20
>    Marco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--j9HljG6wvtentkGRjeqkPNs1cjrQD0ydX--

--t2MgURmlJUUdO6WzdXxxO0VAVVlLrNvSI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpl93QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgQowf/VJD2kCGfc+iBAZYT68jY+zMJ
p/bnEFkPFaqw9a5XvRm+K4SUHfaUcjDf+KPpMDYWaTisROVKW6MMqQ+lXQsRTbs1
V2tX95G5PuBY3F0iO9+o1cB/lsvCItVtHK/bwZCAN+e5Lxrsw8tAYsaurzvyLlv4
26HWFB1YVyoJPRnPSN+qlF8A7oTLHxz1cwsz+93y08UwLM41c67PasMyY6+/qa1S
oxdiWnot45jLPsSfv0WIXzSdTir7cQSIyiYyXYe4f969sgSHKgIqLFbkj5HPRhc4
zFCfX3y1jjrE2XgODSiisnttsxFtZW8mdfCLMwcB7PBv6SM813N3IiEMAhhmGQ==
=EZd7
-----END PGP SIGNATURE-----

--t2MgURmlJUUdO6WzdXxxO0VAVVlLrNvSI--
