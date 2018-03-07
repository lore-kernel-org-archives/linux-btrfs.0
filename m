Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50161 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbeCGJ1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:27:40 -0500
Subject: Re: [PATCH 0/2] btrfs fiemap related BUG fix.
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <26835a31-1dc4-98f3-f37c-44e8c73d6d67@gmx.com>
Date: Wed, 7 Mar 2018 17:27:21 +0800
MIME-Version: 1.0
In-Reply-To: <1520410819-32405-1-git-send-email-robbieko@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q12bqwdvq8Hym51eGbXQTmYZ6U9WMYoqK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q12bqwdvq8Hym51eGbXQTmYZ6U9WMYoqK
Content-Type: multipart/mixed; boundary="UiHQeRc84OnD4WIVNRqILVy0lvU1R2crG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Message-ID: <26835a31-1dc4-98f3-f37c-44e8c73d6d67@gmx.com>
Subject: Re: [PATCH 0/2] btrfs fiemap related BUG fix.
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1520410819-32405-1-git-send-email-robbieko@synology.com>

--UiHQeRc84OnD4WIVNRqILVy0lvU1R2crG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 16:20, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
>=20
> This patchset intends to fix btrfs fiemap related bug.
>=20
> The fiemap has the following problems:
>=20
> 1) Wrong extent count when fm_extent_count is zero.
>=20
>=20
> 2) SHARED bit is not correct
> I have two ideas, but I do not know which one is the best.
>=20
> Like:
>  # dd if=3D/dev/zero bs=3D16K count=3D2 oflag=3Ddsync of=3D/mnt/btrfs/f=
ile
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..63]:         4241424..4241487    64   0x1
>  # cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone
>=20
> 1. When any extent is shared in extent map, the entire extent map is sh=
ared
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..63]:         4241424..4241487   64  0x2001

I think this is what btrfs is doing right now.
Although I'm not sure if this is the best solution.

BTW, I just did the same operation, and just get the SHARED flag on both
source and destination.

Is there something wrong?

>=20
> 2. Split into different extent
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>      /mnt/btrfs/file:
>      EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>        0: [0..31]:         4241424..4241455   32  0x0
>        1: [32..63]:        4241456..4241487   32  0x2001

This is what XFS does.

Thanks,
Qu

>=20
> Robbie Ko (2):
>   Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
>   Btrfs: fix fiemap extent SHARED flag error with range clone.
>=20
>  fs/btrfs/extent_io.c | 150 +++++++++++++++++++++++++++++++++++++++++++=
+-------
>  1 file changed, 132 insertions(+), 18 deletions(-)
>=20
> --
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--UiHQeRc84OnD4WIVNRqILVy0lvU1R2crG--

--Q12bqwdvq8Hym51eGbXQTmYZ6U9WMYoqK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfsHkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiTEgf/Q9qv1f3uCxmkEMmA4fnW/w/7
9tkYN04NxHVWPNSYPtHHCWW2ma7PEcRDjdjWwP00tH2eQ1tb+icHwDjHHPCsF2vr
ykuy/95HD4E1ZzCZalaNPY38MzL8CBUlh3xyRHe6uoShvZQhbuXtKNvlE1RHZvdR
BWNfp36A+wBkJI6pe8H2FqPp6TMqaYZXTe/iodbVUQfJnPYCuKiLkoA57I9lkKvS
AVdPuHlYNTkaZt7wP86UETzvZiux5P3F1WLEZw7sCnngbTcWbryzTSDwBS4VFxM9
LK07p/xV8gFqbgmIz7ce/29EeCaVShBT7+DbFqtj8dhhbpPaa8LpBUzxbqHY8A==
=Twae
-----END PGP SIGNATURE-----

--Q12bqwdvq8Hym51eGbXQTmYZ6U9WMYoqK--
