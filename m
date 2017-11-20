Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60833 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750795AbdKTHNx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 02:13:53 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LrNoG-1fJYSQ2jcK-0134wG for
 <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:13:51 +0100
Subject: Re: Issues while doing btrfs delete missing in raid6
To: linux-btrfs@vger.kernel.org
References: <20171120014344.7a5d8bd2@Vantage.cJ>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3bc72dbb-7d3d-fa1c-8302-f789c41ea1a4@gmx.com>
Date: Mon, 20 Nov 2017 15:13:48 +0800
MIME-Version: 1.0
In-Reply-To: <20171120014344.7a5d8bd2@Vantage.cJ>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vviWWGpl0lpEAPlxmhrF8Et6O8KrD9PJ1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vviWWGpl0lpEAPlxmhrF8Et6O8KrD9PJ1
Content-Type: multipart/mixed; boundary="02r8XH7sV6OxUGLptrkIRfUfLBvVaahMo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <3bc72dbb-7d3d-fa1c-8302-f789c41ea1a4@gmx.com>
Subject: Re: Issues while doing btrfs delete missing in raid6
References: <20171120014344.7a5d8bd2@Vantage.cJ>
In-Reply-To: <20171120014344.7a5d8bd2@Vantage.cJ>

--02r8XH7sV6OxUGLptrkIRfUfLBvVaahMo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8820=E6=97=A5 14:43, J=C3=A9r=C3=B4me Carretero =
wrote:
> Hi,
>=20
>=20
> While doing a test (to evaluate drives), where I'm filling a bunch of
> drives in RAID6, one of the disks failed in the process.
> (System with v4.14 / ECC).
> I remounted the array in degraded, launched a "btrfs delete missing"
> as I have no replacement device.
>=20
> The command (takes ages and) fails with:
>  ERROR: error removing device 'missing': Input/output error
>=20
> and klog says:
>=20
>  [631517.263313] BTRFS info (device dm-18): relocating block group 1411=
883335680 flags data|raid6
>  [631547.556527] btrfs_print_data_csum_error: 151 callbacks suppressed
>  [631547.556530] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559653376 csum 0x2e827bb4 expected csum 0xda9c34d6 mirror 2

Root -9 means it's a data reloc tree. So its ino number is not real
inode number.

To delete it, you need to  calculate the offset into bytenr, then find
the owner.

>  [631547.562727] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559657472 csum 0x6722cd32 expected csum 0x3ca2ce6f mirror 2
>  [631547.562730] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559661568 csum 0x90368636 expected csum 0xf55a0410 mirror 2
>  [631547.562732] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559665664 csum 0x3e38aeb2 expected csum 0x6c80a970 mirror 2
>  [631547.562746] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559669760 csum 0x77d73f2d expected csum 0xe62cfbe8 mirror 2
>  [631547.562747] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559673856 csum 0xb03d1632 expected csum 0xe9a3f0e6 mirror 2
>  [631547.562756] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559677952 csum 0xeea04377 expected csum 0x8819aaf7 mirror 2
>  [631547.562758] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559682048 csum 0xe46ab546 expected csum 0xacc16686 mirror 2
>  [631547.562775] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559690240 csum 0x956a74d7 expected csum 0x99e29858 mirror 2
>  [631547.562788] BTRFS warning (device dm-18): csum failed root -9 ino =
1177 off 3559686144 csum 0xb09a35ae expected csum 0x5f61fa99 mirror 2
>=20
> Since this is RAID6, I wasn't expecting to not be able to recover
> from a checksum issue,

Currently btrfs RAID6 can't ensure recovered data to match its csum.

That's to say, if some other error, like real data corruption in another
disk, in theory RAID6 could still recover it, but the truth is, it may
use the corrupted disk to recover, resulting back checksum.

Thanks,
Qu

> also it's not very practical to bail out on the first
> error of this kind during a delete... the offending blocks could be
> left as is.
>=20
> I then try to work around the issue by removing the offending file
> (yes it's a test, but filling the drives takes a lot of time),
> finding it with "btrfs inspect-internal inode-resolve 1177", and someho=
w:
>  ERROR: ino paths ioctl: No such file or directory
>=20
>=20
> Regards,
>=20


--02r8XH7sV6OxUGLptrkIRfUfLBvVaahMo--

--vviWWGpl0lpEAPlxmhrF8Et6O8KrD9PJ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloSgKwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhfmwf8C5mtOTBGV4EOIPU5bp+ifjJQ
np+6qHvyitNAtWA9AR8aDgjkem2eFuJnUFsau6CqeYmOMAKGzayBfRiE88eRXxY2
i4BUya+Rw7JbU1w0P2Ww84+YT+D6/jLqn9v5rXgAAHAXUqilRejS58rGTcLLFXly
ewwnc/G64oJCYrOhk5L+jDLPUI54lh8xzByIakffxh74B+LRTCwzHaJrbewHBKN3
WPJzINE7lsw7aTZsR1uUTzLfovM1/SrcUrY13cDwf7X+3K6JR/JxjGf4p7HOwXuL
8PfXCGnMkS1fTBnlLsDQEALx+ENTSVlep3zjvAggr/25m9EJwFIyIny3OhBMyg==
=kE+G
-----END PGP SIGNATURE-----

--vviWWGpl0lpEAPlxmhrF8Et6O8KrD9PJ1--
