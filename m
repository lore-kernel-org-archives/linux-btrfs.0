Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:42643 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbeITO2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 10:28:04 -0400
Subject: Re: Punch hole on full fs
To: anand.jain@oracle.com, linux-btrfs@vger.kernel.org
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
Date: Thu, 20 Sep 2018 16:45:32 +0800
MIME-Version: 1.0
In-Reply-To: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RDBI6Gn4KowgArpi5Y9ZMecDeiE5u5G2d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RDBI6Gn4KowgArpi5Y9ZMecDeiE5u5G2d
Content-Type: multipart/mixed; boundary="KcPNQzvwKQDbR1JQZs1OsLpg6fmSzOQBS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: anand.jain@oracle.com, linux-btrfs@vger.kernel.org
Message-ID: <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
Subject: Re: Punch hole on full fs
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
In-Reply-To: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>

--KcPNQzvwKQDbR1JQZs1OsLpg6fmSzOQBS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/20 =E4=B8=8B=E5=8D=881:26, anand.jain@oracle.com wrote:
>=20
>=20
> Test script [1] tries to punch hole on a full FS and it works fine as
> long as the hole size and the offset is aligned with the sectorsize and=

> the extent, so that it could just drop the relevant extent to create th=
e
> hole.
>=20
> The reason why this test fails for non aligned hole size and offset is
> because, as it rightfully tries to truncate the non aligned extent at
> the front and back of the hole, it tries to create new extent which end=
s
> up with ENOSPC.

This is what btrfs should do, I don't see any problem though.

>=20
> Any idea, how do we solve this?

I don't really think this is a problem though.

As long as we need to do data COW, such ENOSPC would happen.

>=20
> xfs is fine.

Of course xfs is fine, XFS defaults to do NODATACOW, in contrast to
btrfs' default DATACOW.

Have you tried to do the same when the file is reflinked?

Thanks,
Qu

>=20
> [1]
> cat ./punch-hole-on-full-fs
> ------------------------
> cleanup()
> {
> =C2=A0=C2=A0=C2=A0=C2=A0umount /dev/sdb > /dev/null 2>&1
> =C2=A0=C2=A0=C2=A0=C2=A0btrfs_reload
> }
>=20
> full_fs_setup()
> {
> =C2=A0=C2=A0=C2=A0=C2=A0btrfs-dyndbg disable
> =C2=A0=C2=A0=C2=A0=C2=A0mkfs.$fs -b 200M -fq $mkfs_options /dev/sdb || =
exit
> =C2=A0=C2=A0=C2=A0=C2=A0mount $mount_options /dev/sdb /mnt/scratch || e=
xit
> =C2=A0=C2=A0=C2=A0=C2=A0dd status=3Dnone if=3D/dev/zero of=3D/mnt/scrat=
ch/filler bs=3D512 >
> /dev/null 2>&1
> }
>=20
> test()
> {
> =C2=A0=C2=A0=C2=A0=C2=A0cleanup
> =C2=A0=C2=A0=C2=A0=C2=A0full_fs_setup
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0btrfs-dyndbg enable
> =C2=A0=C2=A0=C2=A0=C2=A0echo "---- fallocate -p -o 0 -l $punch_hole_siz=
e /mnt/scratch/filler
> ----"
> =C2=A0=C2=A0=C2=A0=C2=A0fallocate -p -o 0 -l $punch_hole_size /mnt/scra=
tch/filler
> }
>=20
> fs=3Dbtrfs; mkfs_options=3D""; mount_options=3D"";
> [[ $1 ]] || { echo "usage: $0 <hole-len>"; exit; }
> punch_hole_size=3D$1 && test
> ------------------------
>=20
> ./punch-hole-on-full-fs 512
> -- fallocate -p -o 0 -l 512 /mnt/scratch/filler --
> fallocate: /mnt/scratch/filler: fallocate failed: No space left on devi=
ce
>=20
> ./punch-hole-on-full-fs 8000
> -- fallocate -p -o 0 -l 8000 /mnt/scratch/filler --
> fallocate: /mnt/scratch/filler: fallocate failed: No space left on devi=
ce
>=20
>=20
> Thanks, Anand


--KcPNQzvwKQDbR1JQZs1OsLpg6fmSzOQBS--

--RDBI6Gn4KowgArpi5Y9ZMecDeiE5u5G2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlujXiwACgkQwj2R86El
/qgjVwf+Ni6JcRj8w10O8dk4AMZrR+fipMpTY26zOa16mJYi3iPb1hCnhSNF0cAq
1oX0dZPbI2XFFgzmCfOUnylidgAfxb0D4InCjjx3Mo95AuQ5sFHKgJfKssWumqkC
vBDQYvZzdcKzWQOxewh04iJFQuJ2ZVTyLwDUAqH9g6hUtifenkqRxPr5WA61XtBn
Dtv/mGyQk9m+l6oApR3LHNoUPH7zEtUV3DY/O4E1VbySgXQPEahs/zWBSOuSQ3qB
+iQIqQvoMJE1Vb7qbeuDn2Tf89ApHsykysgDxh9jquC4hkq3/zaGcFYVfu6k6fz8
QsJ2AXdn9b5gyWCAVzJmiY4XuQcTdw==
=l4t8
-----END PGP SIGNATURE-----

--RDBI6Gn4KowgArpi5Y9ZMecDeiE5u5G2d--
