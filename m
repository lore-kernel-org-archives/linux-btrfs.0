Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:40525 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbeERFtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:49:17 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
Date: Fri, 18 May 2018 13:49:08 +0800
MIME-Version: 1.0
In-Reply-To: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P1klXWwbZZgxAbwghgpgfV8nniblpiJEE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P1klXWwbZZgxAbwghgpgfV8nniblpiJEE
Content-Type: multipart/mixed; boundary="BuWvWN9aBt9Dx4iJunadxz0nbrmJ0gDyk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
In-Reply-To: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>

--BuWvWN9aBt9Dx4iJunadxz0nbrmJ0gDyk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 13:23, Steve Leung wrote:
> Hi list,
>=20
> I've got 3-device raid1 btrfs filesystem that's throwing up some
> "corrupt leaf" errors in dmesg.=C2=A0 This is a uniquified list I've
> observed lately:
>=20
> =C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D497=
0196795392
> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for uncompre=
ssed
> inline extent, have 3468 expect 3469

Would you please use "btrfs-debug-tree -b 4970196795392 /dev/sda1" to
dump the leaf?

It's caught by tree-checker code which is ensuring all tree blocks are
correct before btrfs can take use of them.

That inline extent size check is tested, so I'm wondering if this
indicates any real corruption.
That btrfs-debug-tree output will definitely help.

BTW, if I didn't miss anything, there should not be any inlined extent
in root tree.

> =C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D497=
0552426496
> slot=3D91 ino=3D209736 file_offset=3D0, invalid ram_bytes for uncompres=
sed
> inline extent, have 3496 expect 3497

Same dump will definitely help.

> =C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D497=
0712399872
> slot=3D221 ino=3D205230 file_offset=3D0, invalid ram_bytes for uncompre=
ssed
> inline extent, have 1790 expect 1791
> =C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D497=
0803920896
> slot=3D368 ino=3D205732 file_offset=3D0, invalid ram_bytes for uncompre=
ssed
> inline extent, have 2475 expect 2476
> =C2=A0 BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D497=
0987945984
> slot=3D236 ino=3D208896 file_offset=3D0, invalid ram_bytes for uncompre=
ssed
> inline extent, have 490 expect 491
>=20
> All of them seem to be 1 short of the expected value.
>=20
> Some files do seem to be inaccessible on the filesystem, and btrfs
> inspect-internal on any of those inode numbers fails with:
>=20
> =C2=A0ERROR: ino paths ioctl: Input/output error
>=20
> and another message for that inode appears.
>=20
> 'btrfs check' (output attached) seems to notice these corruptions (amon=
g
> a few others, some of which seem to be related to a problematic attempt=

> to build Android I posted about some months ago).
>=20
> Other information:
>=20
> Arch Linux x86-64, kernel 4.16.6, btrfs-progs 4.16.=C2=A0 The filesyste=
m has
> about 25 snapshots at the moment, only a handful of compressed files,
> and nothing fancy like qgroups enabled.
>=20
> btrfs fi show:
>=20
> =C2=A0Label: none=C2=A0 uuid: 9d4db9e3-b9c3-4f6d-8cb4-60ff55e96d82
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 4 FS byt=
es used 2.48TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 1 size 1.36TiB used 1.13TiB path /dev/sdd1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 2 size 464.73GiB used 230.00GiB path /dev/sdc1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 3 size 1.36TiB used 1.13TiB path /dev/sdb1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0=
 4 size 3.49TiB used 2.49TiB path /dev/sda1
>=20
> btrfs fi df:
>=20
> =C2=A0Data, RAID1: total=3D2.49TiB, used=3D2.48TiB
> =C2=A0System, RAID1: total=3D32.00MiB, used=3D416.00KiB
> =C2=A0Metadata, RAID1: total=3D7.00GiB, used=3D5.29GiB
> =C2=A0GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> dmesg output attached as well.
>=20
> Thanks in advance for any assistance!=C2=A0 I have backups of all the
> important stuff here but it would be nice to fix the corruptions in pla=
ce.

And btrfs check doesn't report the same problem as the default original
mode doesn't have such check.

Please also post the result of "btrfs check --mode=3Dlowmem /dev/sda1"

Thanks,
Qu

>=20
> Steve


--BuWvWN9aBt9Dx4iJunadxz0nbrmJ0gDyk--

--P1klXWwbZZgxAbwghgpgfV8nniblpiJEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+aVQACgkQwj2R86El
/qjRCQf7BwiG8iSc3xEhkcg5Q5AtvKm2OzMfk4fZTowPp2+DgTEaC4QoHkE/Abkg
witmgrRKUq+kaEey3OWKC0uM/mAlp4mr/BrqrRsR3GJl4WH5wr/pujXWzHFuXshp
4+znJgBOj8tSCUXE6kaD/TK+1VsKmBtgPBxaJKHZlb3PsAbIxP9xchK9nszTHNPv
O3QCLMPvDCqF/ZMgsp/80etLPLT8owvod5bUGE1L7zAPWKgGeq5GIt+tbOWPt1XF
4jDmKeGEIWp31VQxzpKEOqBbsHqQgCWv7ECqxJsEforNrBojSwRA9oVvbA4+/71q
tfk0gR5ChDrsKCzpIskDGpi2ZiTGbw==
=sD8a
-----END PGP SIGNATURE-----

--P1klXWwbZZgxAbwghgpgfV8nniblpiJEE--
