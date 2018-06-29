Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932676AbeF2Mlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 08:41:52 -0400
Subject: Re: btrfs suddenly think's it's raid6
To: marble <marble@hamburg.ccc.de>, linux-btrfs@vger.kernel.org
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com>
Date: Fri, 29 Jun 2018 20:41:42 +0800
MIME-Version: 1.0
In-Reply-To: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uTERpPbkC4KQOvChfUQPMlDdUFNeNfE7N"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uTERpPbkC4KQOvChfUQPMlDdUFNeNfE7N
Content-Type: multipart/mixed; boundary="cazHdDNPGIdjlUSX59IAUQSFwFJdyd017";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: marble <marble@hamburg.ccc.de>, linux-btrfs@vger.kernel.org
Message-ID: <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com>
Subject: Re: btrfs suddenly think's it's raid6
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
In-Reply-To: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>

--cazHdDNPGIdjlUSX59IAUQSFwFJdyd017
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 19:04, marble wrote:
> Hello,
> I have an external HDD. The HDD contains no partition.
> I use the whole HDD as a LUKS container. Inside that LUKS is a btrfs.
> It's used to store some media files.
> The HDD was hooked up to a Raspberry Pi running up-to-date Arch Linux
> to play music from the drive.
>=20
> After disconnecting the drive from the Pi and connecting it to my lapto=
p
> again, I couldn't mount it anymore. If I read the dmesg right, it now
> thinks that it's part of a raid6.

Don't panic, the raid6 module is always loaded by btrfs, no matter if
btrfs uses or not.

>=20
> btrfs check --repair also didn't help.

Normally you shouldn't try it anyway.

>=20
> ```
> marble@archlinux ~ % uname -a
> Linux archlinux 4.17.2-1-ARCH #1 SMP PREEMPT Sat Jun 16 11:08:59 UTC
> 2018 x86_64 GNU/Linux
>=20
> marble@archlinux ~ % btrfs --version
> btrfs-progs v4.16.1
>=20
> marble@archlinux ~ % sudo cryptsetup open /dev/sda black
> [sudo] password for marble:
> Enter passphrase for /dev/sda:
>=20
> marble@archlinux ~ % mkdir /tmp/black
> marble@archlinux ~ % sudo mount /dev/mapper/black /tmp/black
> mount: /tmp/black: can't read superblock on /dev/mapper/black.
>=20
> marble@archlinux ~ % sudo btrfs fi show
> Label: 'black'  uuid: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
>         Total devices 1 FS bytes used 143.38GiB
>         devid    1 size 465.76GiB used 172.02GiB path /dev/mapper/black=

>=20
> marble@archlinux ~ % sudo btrfs check --repair /dev/mapper/black
> enabling repair mode
> Checking filesystem on /dev/mapper/black
> UUID: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
> Fixed 0 roots.
> checking extents
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3

This means, both copies for logical bytenr 1082114048 are corrupted.

> bytenr mismatch, want=3D1082114048, have=3D9385453728028469028
> owner ref check failed [1082114048 16384]
> repair deleting extent record: key [1082114048,168,16384]

You shouldn't really use --repair here.
Your extent tree is corrupted, --repair could make things worse here.

> adding new tree backref on start 1082114048 len 16384 parent 0 root 5
> Repaired extent references for 1082114048
> ref mismatch on [59038556160 4096] extent item 1, found 0
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> bytenr mismatch, want=3D1082114048, have=3D9385453728028469028
> incorrect local backref count on 59038556160 root 5 owner 334393 offset=

> 0 found 0 wanted 1 back 0x56348aee5de0
> backref disk bytenr does not match extent record, bytenr=3D59038556160,=

> ref bytenr=3D0
> backpointer mismatch on [59038556160 4096]
> owner ref check failed [59038556160 4096]
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> bytenr mismatch, want=3D1082114048, have=3D9385453728028469028
> failed to repair damaged filesystem, aborting
>=20
> marble@archlinux ~ % dmesg > /tmp/dmesg.log

This is the root cause:
[  124.544439] BTRFS error (device dm-1): bad tree block start
9385453728028469028 1082114048
[  124.555229] BTRFS error (device dm-1): bad tree block start
2365503423870651471 1082114048
[  124.555275] BTRFS warning (device dm-1): failed to read fs tree: -5

Your fs tree is corrupted.
I'm not sure how it's corrupted, but corruption to fs tree is a little ra=
re.

Is there anything like unexpected power loss happens?
And would you provide the following data for debugging?

# btrfs ins dump-super -fFa /dev/mapper/black

And further more, what's the device mapper setup for /dev/mapper/black?
Is there anything like RAID here?

Thanks,
Qu


> ```
>=20
> Any clues?
>=20
> Best regards,
> marble
>=20


--cazHdDNPGIdjlUSX59IAUQSFwFJdyd017--

--uTERpPbkC4KQOvChfUQPMlDdUFNeNfE7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls2KQYACgkQwj2R86El
/qj1HQgAi2SdhU3ejYI4LHzNJyqWFec4Yh/P+Q0ymYZaO41rJrqvym2uJr2BedcP
bQcy3eOeJH0x5Reh5P8zfP6yyittqMAEYQlusawMRGaNHiafWG1xNZ3DzT9ik8kQ
UtLR+j+nzq3Sv3QKrl/RdPtjqrUfAQzQO1Hpzm06bvxV2n8kQhpwcYqn7nSlW+R+
WcQOOWvHRcauu+1+Y3DoYbV95VcXeAfUwrIVD5l39WZ+uekRHaq7i2568ukUGRNY
w15P4TFEW0e8IBUA8yKMv+iATvo8yhHXSqqmXKjBmcndzGMJRem584F7oaGHMFOc
lYtoadZzN8bRxYfixAwrOkc4NdAiGw==
=D6if
-----END PGP SIGNATURE-----

--uTERpPbkC4KQOvChfUQPMlDdUFNeNfE7N--
