Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57318 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbeAVBLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 20:11:07 -0500
Subject: Re: Damaged Root Tree(s)
To: Liwei <xieliwei@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3c1e8a86-0f2a-2f54-723e-5dd3fbe4ba23@gmx.com>
Date: Mon, 22 Jan 2018 09:11:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="h4nCqUp4PJK5fXsLN9Dss8mWkFt6sXPvE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h4nCqUp4PJK5fXsLN9Dss8mWkFt6sXPvE
Content-Type: multipart/mixed; boundary="ishvLmXQA6pMbvYz2F5dwqP0xQsz2dmn2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liwei <xieliwei@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <3c1e8a86-0f2a-2f54-723e-5dd3fbe4ba23@gmx.com>
Subject: Re: Damaged Root Tree(s)
References: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
In-Reply-To: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>

--ishvLmXQA6pMbvYz2F5dwqP0xQsz2dmn2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8822=E6=97=A5 03:16, Liwei wrote:
> Hi list,
>=20
> =3D=3D=3D=3DTLDR=3D=3D=3D=3D
> 1. Can I mount a filesystem using one of the roots found with btrfs-fin=
d-root?

Depends on the tree.

If it's root tree, it's possible.

Otherwise those found trees don't help much.


> 2. Can btrfs check just fix the damaged root without attempting any
> other repairs?

No.
But under most case, it's not a single corrupted tree but normally multip=
le.

> 3. If the above is not possible, how should I proceed given that I
> seem to have lost both the main and backup roots?

In theory, it's possible to use specified fs tree root to salvage a
filesystem.

But under most case, metadata is protected by safer profile.
So it's not implemented in btrfs-progs.

Your current best try would be manually scanning through all tree backups=
=2E
Which need extra info.

Please provide the following info:

# btrfs inspect dump-super -FfA <device> | grep backup_tree_root | sort
| uniq

And try them one by one:

# btrfs check --tree-root <number from above output> <device>

If any one can proceed, then use it to repair:

# btrfs check --tree-root <number> <device>

And good luck.

Thanks,
Qu

>=20
> =3D=3D=3D=3DBackground Information=3D=3D=3D=3D
>     I have a 2x10TB raid0 (20TB, raid0 provided by md) volume that (my
> theory is) experienced a headcrash while updating the root tree, or
> maybe while it was carrying out background defragmentation.>
>     This occurred while I was setting up redundancy by using LVM
> mirroring, so in the logs you'll see some dm errors. Unfortunately the
> lost data has not been mirrored yet (what are the chances, given that
> the mirror was 97% complete when this happened).
>=20
>     Running a scrub on the raid shows that I have 1000+ unreadable
> sectors, amounting to about 800kB of data. So I've got spare drives
> and imaged the offending drive. Currently ddrescue is still trying to
> read those sectors, but it seems unlikely that they'll ever succeed.
>=20
> =3D=3D=3D=3DProblem=3D=3D=3D=3D
>     So with an imaged copy of the array, I tried remounting the
> filesystem, but it refuses to mount even using 'usebackuproot':
>=20
> With usebackuproot:
> [ 1610.788527] device-mapper: raid1: Mirror read failed.
> [ 1610.788799] device-mapper: raid1: Mirror read failed.
> [ 1610.788939] Buffer I/O error on dev dm-15, logical block
> 5371800560, async page read
> [ 1610.823141] BTRFS: device label edata devid 1 transid 318593
> /dev/mapper/datavol-edata
> [ 1616.778563] BTRFS info (device dm-15): trying to use backup root at
> mount time
> [ 1616.778758] BTRFS info (device dm-15): disk space caching is enabled=

> [ 1617.961152] device-mapper: raid1: Mirror read failed.
> [ 1618.238198] device-mapper: raid1: Mirror read failed.
> [ 1618.238498] BTRFS warning (device dm-15): failed to read tree root
> [ 1618.238700] device-mapper: raid1: Mirror read failed.
> [ 1618.238878] device-mapper: raid1: Mirror read failed.
> [ 1618.239050] BTRFS warning (device dm-15): failed to read tree root
> [ 1618.239207] device-mapper: raid1: Mirror read failed.
> [ 1618.239372] device-mapper: raid1: Mirror read failed.
> [ 1618.239590] BTRFS warning (device dm-15): failed to read tree root
> [ 1618.239775] device-mapper: raid1: Mirror read failed.
> [ 1618.240055] device-mapper: raid1: Mirror read failed.
> [ 1618.240298] BTRFS warning (device dm-15): failed to read tree root
> [ 1618.240492] device-mapper: raid1: Mirror read failed.
> [ 1618.240744] device-mapper: raid1: Mirror read failed.
> [ 1618.240989] BTRFS warning (device dm-15): failed to read tree root
> [ 1618.363234] BTRFS error (device dm-15): open_ctree failed
>=20
> Without usebackuproot:
> [ 2149.015427] device-mapper: raid1: Mirror read failed.
> [ 2149.015700] device-mapper: raid1: Mirror read failed.
> [ 2149.015840] Buffer I/O error on dev dm-15, logical block
> 5371800560, async page read
> [ 2154.172102] BTRFS info (device dm-15): disk space caching is enabled=

> [ 2155.325134] device-mapper: raid1: Mirror read failed.
> [ 2155.715439] device-mapper: raid1: Mirror read failed.
> [ 2155.715795] BTRFS warning (device dm-15): failed to read tree root
> [ 2155.851599] BTRFS error (device dm-15): open_ctree failed
>=20
>     It appears that the damaged data has affected both the main and
> backup roots.
>=20
>     Next I ran btrfs-find-root, which gave me the following:
> Superblock thinks the generation is 318593
> Superblock thinks the level is 1
> Well block 25826479144960(gen: 318346 level: 1) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826450505728(gen: 318345 level: 1) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826461237248(gen: 318344 level: 1) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826479669248(gen: 318342 level: 0) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826479603712(gen: 318342 level: 0) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826468495360(gen: 318342 level: 0) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826465923072(gen: 318342 level: 0) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> Well block 25826477654016(gen: 318341 level: 0) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1
> ...[truncated]
>=20
>     I tried running btrfs check with the top 5 roots, but only the
> first 3 seems to be usable. However, even with the first 3, btrfs
> check gives me a lot of:
> bytenr mismatch, want=3D26008292753408, have=3D0
> bytenr mismatch, want=3D26353175658496, have=3D0
> bytenr mismatch, want=3D26353188618240, have=3D0
> bytenr mismatch, want=3D26353513299968, have=3D0
>     and thousands of extent errors, etc. I do see references to
> directories within the filesystem though, so I'd think the tree root
> is at least pretty good.
>=20
>     Just to see if btrfs check can reach a usable state, I made a COW
> snapshot of the imaged drive, and ran btrfs check --repair. However,
> it eventually gives up, and seemed to have wrecked the FS.
>=20
>     Is there a way to mount/repair the filesystem with the found root
> instead? I'd like to copy the files off the image, but prefer not to
> use btrfs restore. Can btrfs check just copy the alternative root and
> not try to repair anything else?
>=20
> =3D=3D=3D=3DMisc info=3D=3D=3D=3D
> # uname -a
> Linux tvm 4.14.0-3-amd64 #1 SMP Debian 4.14.13-1 (2018-01-14) x86_64 GN=
U/Linux
> # btrfs --version
> btrfs-progs v4.13.3
>=20
> Thanks for the help!
> Liwei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ishvLmXQA6pMbvYz2F5dwqP0xQsz2dmn2--

--h4nCqUp4PJK5fXsLN9Dss8mWkFt6sXPvE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlplOiUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjbLwgArCRRKYoH0m/uzKbpl5K2hLfX
6iWKcYPJsxdaExj0c2Z07uwPjXSVqqbU9LYzG8pibHWjqk/nZ6XS3yXejxPklhws
4o6r6AAGvgN5QVzeTCPP8ElSsH4tE4Qvxg8oxLjfN22tJ9HeVMvYD//TTnf7Bi+j
btdZofj0Zk6SzTc8UcX3SUa4b2JSoJPuEHytv2Lxzt/DqEstuOAWwy14rl84foF4
CyYHaVxlw/+KmZtp+bSA5KPDkIEmrWlCIiEuMaksOn+88y5H59v42d1Y5iFDuicw
xv04h+0cuxtnvYlSQmWr40OFiO+2e5NIV82VVwR2tpy6J9ro1T7Hmeq/889Hrw==
=A48u
-----END PGP SIGNATURE-----

--h4nCqUp4PJK5fXsLN9Dss8mWkFt6sXPvE--
