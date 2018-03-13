Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:48871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932094AbeCMNot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:44:49 -0400
Subject: Re: FS unmountable after RAID/LVM problems
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
Date: Tue, 13 Mar 2018 21:44:28 +0800
MIME-Version: 1.0
In-Reply-To: <ghsh94xfx9.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JgffNbH6rGhOnLTeGhSvAGJYmhzR3Nqfj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JgffNbH6rGhOnLTeGhSvAGJYmhzR3Nqfj
Content-Type: multipart/mixed; boundary="GpibOOUFprB1El91Zvc4uvDaAhIM9LtaZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
Subject: Re: FS unmountable after RAID/LVM problems
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
In-Reply-To: <ghsh94xfx9.fsf@lena.gouders.net>

--GpibOOUFprB1El91Zvc4uvDaAhIM9LtaZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 21:29, Dirk Gouders wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 21:01, Dirk Gouders wrote:
>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>
>>>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:53, Dirk Gouders wrote:
>>>
>>> <SNIP>
>>>
>>>>> find-root:
>>>>>
>>>>> # btrfs-find-root /dev/loop0p1
>>>>> Superblock thinks the generation is 9858294
>>>>> Superblock thinks the level is 1
>>>>> Found tree root at 848773120 gen 9858294 level 1
>>>>
>>>> Tree root is found, find-root won't help much here.
>>>> And if it's really tree root corruption, we should have some kernel
>>>> message for it.
>>>>
>>>>> Well block 832045056(gen: 9858272 level: 1) seems good, but generat=
ion/level doesn't match, want gen: 9858294 level: 1
>>>>
>>>> Especially when the next tree block is 22 generation older.
>>>>
>>>> Would you please try to call "btrfs inspect dump-tree <device>" and
>>>> paste the result with *stderr*?
>>>>
>>>> At least we could know which tree block is corrupted.
>>>
>>> Here is the result of inspect:
>>>
>>> # btrfs inspect dump-tree /dev/loop0p1
>>> btrfs-progs v4.15
>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
>>> ERROR: unable to open /dev/loop0p1
>>
>> OK, one tree block in some important tree is corrupted.
>>
>> Would you please dump the super block by "btrfs inspect dump-super
>> <device>" so that we could have some clue about where the corrupted tr=
ee
>> block belongs?
>=20
> Yes, here is the requested output:

Sorry, I forgot to add "-f" parameter for dump-super.

So what we need is "btrfs inspect dump-super -f /dev/loop0p1".


And, what's the version of btrfs-progs?
IIRC the latest version of btrfs-progs has loosen the restriction on
essential trees for "btrfs inspect dump-tree" if using '-b' option.

So along with "dump-super -f" you could also try "btrfs inspect
dump-tree -b <number> <device>"
Where the number could be any "*_root" value.
Like 20971520 (chunk_root) and 848773120 (root) to see if it works.

Thanks,
Qu

>=20
> # btrfs inspect dump-super /dev/loop0p1=20
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
>=20
>=20
> Thanks,
>=20
> Dirk
>=20


--GpibOOUFprB1El91Zvc4uvDaAhIM9LtaZ--

--JgffNbH6rGhOnLTeGhSvAGJYmhzR3Nqfj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqn1b0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi++wf9H1dmiKuethnNKVcpNHt+4tPa
LDczy9SlxEX7IntKzjvO4mTuGSelGjTZqWXe6nRceZboNNPnrrmL3Vuh3KByYoy0
INRW7QlgJP7cTbc4LekNNyTi9up7ou/8q8SlBSJ3rlIeAt30daRFjim9oCDEmAq2
Xzelc7RjImQbdt9YOuqjZpDIInmHWBogGNUyfC3uyteBelGbDyMsX5QNLdDMQpjq
gZdRJTsALNqV5lYOYMWxAtvcpfHUUu36JB9vTL7W+Icoa5pbM3aXPRpnydTC6bvz
YUsWHxjRL2mjvXUlK24yaPqhq2dXuS1FxvjRIOezQuMOmPHSjpdvMoqfy0+asw==
=VFL3
-----END PGP SIGNATURE-----

--JgffNbH6rGhOnLTeGhSvAGJYmhzR3Nqfj--
