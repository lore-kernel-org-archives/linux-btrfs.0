Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:35331 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751971AbeCMObX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 10:31:23 -0400
Subject: Re: FS unmountable after RAID/LVM problems
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
 <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
 <gho9jsxdii.fsf@lena.gouders.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
Date: Tue, 13 Mar 2018 22:31:02 +0800
MIME-Version: 1.0
In-Reply-To: <gho9jsxdii.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cc6ikP9aj8WWyS7VkjE633lHTel1PpjSu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cc6ikP9aj8WWyS7VkjE633lHTel1PpjSu
Content-Type: multipart/mixed; boundary="XjqKBBBGhjVV5Gg2ZORbqjNXcV6i2TYap";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
Subject: Re: FS unmountable after RAID/LVM problems
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
 <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
 <gho9jsxdii.fsf@lena.gouders.net>
In-Reply-To: <gho9jsxdii.fsf@lena.gouders.net>

--XjqKBBBGhjVV5Gg2ZORbqjNXcV6i2TYap
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 22:21, Dirk Gouders wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 21:29, Dirk Gouders wrote:
>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>
>>>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 21:01, Dirk Gouders wrote:
>>>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>>>
>>>>>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:53, Dirk Gouders wrote:
>>>>>
>>>>> <SNIP>
>>>>>
>>>>>>> find-root:
>>>>>>>
>>>>>>> # btrfs-find-root /dev/loop0p1
>>>>>>> Superblock thinks the generation is 9858294
>>>>>>> Superblock thinks the level is 1
>>>>>>> Found tree root at 848773120 gen 9858294 level 1
>>>>>>
>>>>>> Tree root is found, find-root won't help much here.
>>>>>> And if it's really tree root corruption, we should have some kerne=
l
>>>>>> message for it.
>>>>>>
>>>>>>> Well block 832045056(gen: 9858272 level: 1) seems good, but gener=
ation/level doesn't match, want gen: 9858294 level: 1
>>>>>>
>>>>>> Especially when the next tree block is 22 generation older.
>>>>>>
>>>>>> Would you please try to call "btrfs inspect dump-tree <device>" an=
d
>>>>>> paste the result with *stderr*?
>>>>>>
>>>>>> At least we could know which tree block is corrupted.
>>>>>
>>>>> Here is the result of inspect:
>>>>>
>>>>> # btrfs inspect dump-tree /dev/loop0p1
>>>>> btrfs-progs v4.15
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
>>>>> ERROR: unable to open /dev/loop0p1
>>>>
>>>> OK, one tree block in some important tree is corrupted.
>>>>
>>>> Would you please dump the super block by "btrfs inspect dump-super
>>>> <device>" so that we could have some clue about where the corrupted =
tree
>>>> block belongs?
>>>
>>> Yes, here is the requested output:
>>
>> Sorry, I forgot to add "-f" parameter for dump-super.
>>
>> So what we need is "btrfs inspect dump-super -f /dev/loop0p1".
>>
>>
>> And, what's the version of btrfs-progs?
>> IIRC the latest version of btrfs-progs has loosen the restriction on
>> essential trees for "btrfs inspect dump-tree" if using '-b' option.
>>
>> So along with "dump-super -f" you could also try "btrfs inspect
>> dump-tree -b <number> <device>"
>> Where the number could be any "*_root" value.
>> Like 20971520 (chunk_root) and 848773120 (root) to see if it works.
>=20
> I am a bit lost ;-)  I translated "*_root value" to using both numbers,=

> please let me know if I should also use some other numbers.
>=20
> The version of btrfs-progs is 4.15.
>=20
> And here is more requested information:
>=20
> # btrfs inspect dump-super -f /dev/loop0p1
> superblock: bytenr=3D65536, device=3D/dev/loop0p1
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x31998c61 [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    a6459a90-ebe3-4c75-97f4-5496eadcc96f
> label
> generation              9858294
> root                    848773120
> sys_array_size          226
> chunk_root_generation   18814
> root_level              1
> chunk_root              20971520
> chunk_root_level        0
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             10741612544
> bytes_used              9141452800
> sectorsize              4096
> nodesize                16384
> leafsize (deprecated)           16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x61
>                         ( MIXED_BACKREF |
>                           BIG_METADATA |
>                           EXTENDED_IREF )
> cache_generation        9858294
> uuid_tree_generation    9824396
> dev_item.uuid           b92bd216-a0bb-467d-8f8f-788f845af30c
> dev_item.fsid           a6459a90-ebe3-4c75-97f4-5496eadcc96f [match]
> dev_item.type           0
> dev_item.total_bytes    10741612544
> dev_item.bytes_used     10741612544
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>                 length 4194304 owner 2 stripe_len 65536 type SYSTEM
>                 io_align 4096 io_width 4096 sector_size 4096
>                 num_stripes 1 sub_stripes 0
>                         stripe 0 devid 1 offset 0
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c

An old btrfs made by old mkfs.btrfs.
Which still has the temporary chunk.

>         item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP=

>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 20971520
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>                         stripe 1 devid 1 offset 29360128
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c

With this chunk item, it's clear that corrupted tree block doesn't
belong to chunk tree.

> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       848773120       gen: 9858294   =
 level: 1
>                 backup_chunk_root:      20971520        gen: 18814     =
 level: 0
>                 backup_extent_root:     848789504       gen: 9858294   =
 level: 2
>                 backup_fs_root:         850509824       gen: 9858293   =
 level: 2
>                 backup_dev_root:        30408704        gen: 9855433   =
 level: 0
>                 backup_csum_root:       75300864        gen: 9855436   =
 level: 2
>                 backup_total_bytes:     10741612544
>                 backup_bytes_used:      9141452800
>                 backup_num_devices:     1
>=20
>         backup 1:
>                 backup_tree_root:       848773120       gen: 9858291   =
 level: 1
>                 backup_chunk_root:      20971520        gen: 18814     =
 level: 0
>                 backup_extent_root:     847937536       gen: 9858291   =
 level: 2
>                 backup_fs_root:         845496320       gen: 9858291   =
 level: 2
>                 backup_dev_root:        30408704        gen: 9855433   =
 level: 0
>                 backup_csum_root:       75300864        gen: 9855436   =
 level: 2
>                 backup_total_bytes:     10741612544
>                 backup_bytes_used:      9141436416
>                 backup_num_devices:     1
>=20
>         backup 2:
>                 backup_tree_root:       848871424       gen: 9858292   =
 level: 1
>                 backup_chunk_root:      20971520        gen: 18814     =
 level: 0
>                 backup_extent_root:     847675392       gen: 9858292   =
 level: 2
>                 backup_fs_root:         849068032       gen: 9858293   =
 level: 2
>                 backup_dev_root:        30408704        gen: 9855433   =
 level: 0
>                 backup_csum_root:       75300864        gen: 9855436   =
 level: 2
>                 backup_total_bytes:     10741612544
>                 backup_bytes_used:      9141436416
>                 backup_num_devices:     1
>=20
>         backup 3:
>                 backup_tree_root:       852295680       gen: 9858293   =
 level: 1
>                 backup_chunk_root:      20971520        gen: 18814     =
 level: 0
>                 backup_extent_root:     849887232       gen: 9858293   =
 level: 2
>                 backup_fs_root:         850509824       gen: 9858293   =
 level: 2
>                 backup_dev_root:        30408704        gen: 9855433   =
 level: 0
>                 backup_csum_root:       75300864        gen: 9855436   =
 level: 2
>                 backup_total_bytes:     10741612544
>                 backup_bytes_used:      9141452800
>                 backup_num_devices:     1
>=20
> # btrfs inspect dump-tree -b 20971520 /dev/loop0p1
> btrfs-progs v4.15
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> leaf 20971520 items 14 free space 14731 generation 18814 owner 3
> leaf 20971520 flags 0x1(WRITTEN) backref revision 1
> fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
> chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
>         item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
>                 devid 1 total_bytes 10741612544 bytes_used 10741612544
>                 io_align 4096 io_width 4096 sector_size 4096 type 0
>                 generation 0 start_offset 0 dev_group 0
>                 seek_speed 0 bandwidth 0
>                 uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>                 fsid a6459a90-ebe3-4c75-97f4-5496eadcc96f
>         item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 16105 itemsi=
ze 80
>                 length 4194304 owner 2 stripe_len 65536 type SYSTEM
>                 io_align 4096 io_width 4096 sector_size 4096
>                 num_stripes 1 sub_stripes 0
>                         stripe 0 devid 1 offset 0
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 16025 =
itemsize 80
>                 length 8388608 owner 2 stripe_len 65536 type METADATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 0
>                         stripe 0 devid 1 offset 4194304
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 15945=
 itemsize 80
>                 length 8388608 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 0
>                         stripe 0 devid 1 offset 12582912
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15833=
 itemsize 112
>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP=

>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 20971520
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>                         stripe 1 devid 1 offset 29360128
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15721=
 itemsize 112
>                 length 1073741824 owner 2 stripe_len 65536 type METADAT=
A|DUP
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 37748736
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>                         stripe 1 devid 1 offset 1111490560
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 156=
41 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 2185232384
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 2176843776) itemoff 155=
61 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 3258974208
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 3250585600) itemoff 154=
81 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 4332716032
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 4324327424) itemoff 154=
01 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 5406457856
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 5398069248) itemoff 15=
321 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 6480199680
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 11 key (FIRST_CHUNK_TREE CHUNK_ITEM 6471811072) itemoff 15=
241 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 7553941504
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 12 key (FIRST_CHUNK_TREE CHUNK_ITEM 7545552896) itemoff 15=
161 itemsize 80
>                 length 1073741824 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 8627683328
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>         item 13 key (FIRST_CHUNK_TREE CHUNK_ITEM 8619294720) itemoff 15=
081 itemsize 80
>                 length 1040187392 owner 2 stripe_len 65536 type DATA
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 1 sub_stripes 1
>                         stripe 0 devid 1 offset 9701425152
>                         dev_uuid b92bd216-a0bb-467d-8f8f-788f845af30c
>=20
> # btrfs inspect dump-tree -b 848773120 /dev/loop0p1
> btrfs-progs v4.15
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> node 848773120 level 1 items 2 free 491 generation 9858294 owner 1
> fs uuid a6459a90-ebe3-4c75-97f4-5496eadcc96f
> chunk uuid 6f325a21-ce3e-4994-a638-b88ea82d504c
>         key (EXTENT_TREE ROOT_ITEM 0) block 848986112 (51818) gen 98582=
94
>         key (346 ROOT_ITEM 18671) block 72089600 (4400) gen 9728190

And also not a tree block of root tree.

It may be extent tree, and if that's the case, we may enhance
btrfs-restore to handle it.
Please dump the following info.

# btrfs inspect dump-tree -b 848986112 /dev/loop0p1
# btrfs inspect dump-tree -b 72089600 /dev/loop0p1

Thanks,
Qu

>=20
> Thanks,
>=20
> Dirk
>=20


--XjqKBBBGhjVV5Gg2ZORbqjNXcV6i2TYap--

--cc6ikP9aj8WWyS7VkjE633lHTel1PpjSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqn4KYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg8EQf7B5UHZZH/YekFcTwNxl9IApXb
dGst7xCjeJSjbWm1Y5c7QDaGvo8Tp+CB6MCQ9wJkUVHeA4f9w575CrxxjWSWpPnO
ZSXz7bhV94Y43nNMFZkfd1NgHRgLJkK4J7ErufnJpm+6CymMdnW8J9+5nTrFWiXC
SWnfu0So6KTJGBNBC0Wb5FqBbbWpqEw8vSBA7yWhxcEykwNjvb6XV4q0xT906tdI
V4JSottBa8bpddtXXlp4GhDdaKQGby4/NVg1l+oEv/Yhnqtum+E24EbjM/FkEuOF
GDJO3cMiu2Cj1rbwZC5HpKm3UOjLOU9JVHRtvgG1PAGr55KLQBp97fC13bsWfw==
=sxVt
-----END PGP SIGNATURE-----

--cc6ikP9aj8WWyS7VkjE633lHTel1PpjSu--
