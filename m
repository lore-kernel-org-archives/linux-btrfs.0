Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752188AbeETBC0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 May 2018 21:02:26 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
Date: Sun, 20 May 2018 09:02:15 +0800
MIME-Version: 1.0
In-Reply-To: <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IOCMdU1rVOb5NAVoSZeYBUC2YagjDyfaf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IOCMdU1rVOb5NAVoSZeYBUC2YagjDyfaf
Content-Type: multipart/mixed; boundary="JplMPiEBaDpj7G4oTTPfpERkrrMmDjtfK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
In-Reply-To: <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>

--JplMPiEBaDpj7G4oTTPfpERkrrMmDjtfK
Content-Type: multipart/mixed;
 boundary="------------D5E593CF25963C84BF1C1069"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D5E593CF25963C84BF1C1069
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8820=E6=97=A5 07:40, Steve Leung wrote:
> On 05/17/2018 11:49 PM, Qu Wenruo wrote:
>> On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 13:23, Steve Leung wrote:
>>> Hi list,
>>>
>>> I've got 3-device raid1 btrfs filesystem that's throwing up some
>>> "corrupt leaf" errors in dmesg.=C2=A0 This is a uniquified list I've
>>> observed lately:
>=20
> Evidently I forgot that I added a fourth device to this system, from th=
e
> info below, but I don't think it matters.=C2=A0 :)
>=20
>>> =C2=A0=C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1
>>> block=3D4970196795392
>>> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for uncomp=
ressed
>>> inline extent, have 3468 expect 3469
>>
>> Would you please use "btrfs-debug-tree -b 4970196795392 /dev/sda1" to
>> dump the leaf?
>=20
> Attached btrfs-debug-tree dumps for all of the blocks that I saw
> messages for.
>=20
>> It's caught by tree-checker code which is ensuring all tree blocks are=

>> correct before btrfs can take use of them.
>>
>> That inline extent size check is tested, so I'm wondering if this
>> indicates any real corruption.
>> That btrfs-debug-tree output will definitely help.
>>
>> BTW, if I didn't miss anything, there should not be any inlined extent=

>> in root tree.
>>
>>> =C2=A0=C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1
>>> block=3D4970552426496
>>> slot=3D91 ino=3D209736 file_offset=3D0, invalid ram_bytes for uncompr=
essed
>>> inline extent, have 3496 expect 3497
>>
>> Same dump will definitely help.
>>
>>> =C2=A0=C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1
>>> block=3D4970712399872
>>> slot=3D221 ino=3D205230 file_offset=3D0, invalid ram_bytes for uncomp=
ressed
>>> inline extent, have 1790 expect 1791
>>> =C2=A0=C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1
>>> block=3D4970803920896
>>> slot=3D368 ino=3D205732 file_offset=3D0, invalid ram_bytes for uncomp=
ressed
>>> inline extent, have 2475 expect 2476
>>> =C2=A0=C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1
>>> block=3D4970987945984
>>> slot=3D236 ino=3D208896 file_offset=3D0, invalid ram_bytes for uncomp=
ressed
>>> inline extent, have 490 expect 491
>>>
>>> All of them seem to be 1 short of the expected value.
>>>
>>> Some files do seem to be inaccessible on the filesystem, and btrfs
>>> inspect-internal on any of those inode numbers fails with:
>>>
>>> =C2=A0=C2=A0ERROR: ino paths ioctl: Input/output error
>>>
>>> and another message for that inode appears.
>>>
>>> 'btrfs check' (output attached) seems to notice these corruptions (am=
ong
>>> a few others, some of which seem to be related to a problematic attem=
pt
>>> to build Android I posted about some months ago).
>>>
>>> Other information:
>>>
>>> Arch Linux x86-64, kernel 4.16.6, btrfs-progs 4.16.=C2=A0 The filesys=
tem has
>>> about 25 snapshots at the moment, only a handful of compressed files,=

>>> and nothing fancy like qgroups enabled.
>>>
>>> btrfs fi show:
>>>
>>> =C2=A0=C2=A0Label: none=C2=A0 uuid: 9d4db9e3-b9c3-4f6d-8cb4-60ff55e96=
d82
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices =
4 FS bytes used 2.48TiB
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=
=A0=C2=A0 1 size 1.36TiB used 1.13TiB path /dev/sdd1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=
=A0=C2=A0 2 size 464.73GiB used 230.00GiB path /dev/sdc1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=
=A0=C2=A0 3 size 1.36TiB used 1.13TiB path /dev/sdb1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=
=A0=C2=A0 4 size 3.49TiB used 2.49TiB path /dev/sda1
>>>
>>> btrfs fi df:
>>>
>>> =C2=A0=C2=A0Data, RAID1: total=3D2.49TiB, used=3D2.48TiB
>>> =C2=A0=C2=A0System, RAID1: total=3D32.00MiB, used=3D416.00KiB
>>> =C2=A0=C2=A0Metadata, RAID1: total=3D7.00GiB, used=3D5.29GiB
>>> =C2=A0=C2=A0GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>>>
>>> dmesg output attached as well.
>>>
>>> Thanks in advance for any assistance!=C2=A0 I have backups of all the=

>>> important stuff here but it would be nice to fix the corruptions in
>>> place.
>>
>> And btrfs check doesn't report the same problem as the default origina=
l
>> mode doesn't have such check.
>>
>> Please also post the result of "btrfs check --mode=3Dlowmem /dev/sda1"=

>=20
> Also, attached.=C2=A0 It seems to notice the same off-by-one problems, =
though
> there also seem to be a couple of examples of being off by more than on=
e.

Unfortunately, it doesn't detect, as there is no off-by-one error at all.=


The problem is, kernel is reporting error on completely fine leaf.

Further more, even in the same leaf, there are more inlined extents, and
they are all valid.

So the kernel reports the error out of nowhere.

More problems happens for extent_size where a lot of them is offset by on=
e.

Moreover, the root owner is not printed correctly, thus I'm wondering if
the memory is corrupted.

Please try memtest+ to verify all your memory is correct, and if so,
please try the attached patch and to see if it provides extra info.


>=20
> Thanks for looking at this!=C2=A0 I'll get my backups ready, just in ca=
se.
>=20
> Steve

--------------D5E593CF25963C84BF1C1069
Content-Type: text/x-patch;
 name="0001-btrfs-tree-checker-Add-extra-inline-extent-ram_bytes.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-btrfs-tree-checker-Add-extra-inline-extent-ram_bytes.pa";
 filename*1="tch"

=46rom 3540534d0ff8b6e9dc200f9dff92b8a5afa7d384 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Sun, 20 May 2018 09:01:43 +0800
Subject: [PATCH] btrfs: tree-checker: Add extra inline extent ram_bytes d=
ebug
 info

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 8d40e7dd8c30..3a4534e7068e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -163,8 +163,10 @@ static int check_extent_data_item(struct btrfs_fs_in=
fo *fs_info,
 		if (item_size !=3D BTRFS_FILE_EXTENT_INLINE_DATA_START +
 		    btrfs_file_extent_ram_bytes(leaf, fi)) {
 			file_extent_err(fs_info, leaf, slot,
-	"invalid ram_bytes for uncompressed inline extent, have %u expect %llu"=
,
+	"invalid ram_bytes for uncompressed inline extent, have %u expect %llu =
(%lu + %llu)",
 				item_size, BTRFS_FILE_EXTENT_INLINE_DATA_START +
+				btrfs_file_extent_ram_bytes(leaf, fi),
+				BTRFS_FILE_EXTENT_INLINE_DATA_START,
 				btrfs_file_extent_ram_bytes(leaf, fi));
 			return -EUCLEAN;
 		}
--=20
2.17.0


--------------D5E593CF25963C84BF1C1069--

--JplMPiEBaDpj7G4oTTPfpERkrrMmDjtfK--

--IOCMdU1rVOb5NAVoSZeYBUC2YagjDyfaf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsAyRcACgkQwj2R86El
/qjq4AgAjIkq5blFjZWogHOFWQPmYuhFh4r4d618zy0wCJOVI8mt2uhF3evOtBZ+
bgfGVf3CFWZRGhjr382oKyVN+MBSwEpoNMWmDlZFywtnA7jbm3mDrR8rRVtd3LD9
MajqYFGot78bjihJWiRm8SwaQskj1JJ47HqCvgO2jzJcQpIVUp4coANmhuyuPJ+9
uvmCt3GLgWisU0HVJXDEIxwBXQDlxoNHjtojgIWHTjOkWsvkDkVn6wLPNFhGTpU1
DyGbcdUglEHp5odcxwS6KTUL+ZL/CRyEv51wavT+vM9XfASapCUMMAwHzuvr9Jty
pA3mOvCYS3JUpTpRHEZpx+pYXXOUZw==
=K9zL
-----END PGP SIGNATURE-----

--IOCMdU1rVOb5NAVoSZeYBUC2YagjDyfaf--
