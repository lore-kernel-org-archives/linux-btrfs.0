Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60273 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbeH0EBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 00:01:30 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
Date: Mon, 27 Aug 2018 08:16:58 +0800
MIME-Version: 1.0
In-Reply-To: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2a4nCgLvWmuFdgYHtKMJ1aAUcJirRRgtg"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2a4nCgLvWmuFdgYHtKMJ1aAUcJirRRgtg
Content-Type: multipart/mixed; boundary="2BJw1NWTDz1lwI2NOzUfGzqbXSp3KU223";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
Message-ID: <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
In-Reply-To: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>

--2BJw1NWTDz1lwI2NOzUfGzqbXSp3KU223
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/27 =E4=B8=8A=E5=8D=884:45, Larkin Lowrey wrote:
> When I do a scrub it aborts about 10% of the way in due to:
>=20
> corrupt leaf: root=3D7 block=3D7687860535296 slot=3D0, invalid key obje=
ctid
> for csum item, have 18446744073650847734 expect 18446744073709551606

This error message explains itself.

Key objectid is not valid.

>=20
> The filesystem in question stores my backups and I have verified all of=

> the backups so I know all files that are supposed to be there are there=

> and their hashes match. Backups run normally and everything seems to
> work fine, it's just the scrub that doesn't.

No, scrub works as expected, during its csum fetching, it detects bad
csum tree block.
This means your csum tree is corrupted.

>=20
> I tried:
>=20
> # btrfs check --repair /dev/Cached/Backups
> enabling repair mode
> Checking filesystem on /dev/Cached/Backups
> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
> Fixed 0 roots.
> checking extents
> leaf free space ret -2002721201, leaf data size 16283, used 2002737484
> nritems 319
> leaf free space ret -2002721201, leaf data size 16283, used 2002737484
> nritems 319

--repair doesn't support to repair such corruption, yet.

> leaf free space incorrect 7687860535296 -2002721201
> bad block 7687860535296

Corrupted tree block bytenr matches with the number reported by kernel.

You could provide the tree block dump for bytenr 7687860535296, and
maybe we could find out what's going wrong and fix it manually.

# btrfs ins dump-tree -b 7687860535296 <device>

Please note that this corruption could be caused by bad ram or some old
kernel bug.
It's recommend to run a memtest if possible.

> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> block group 34028518375424 has wrong amount of free space
> failed to load free space cache for block group 34028518375424
> checking fs roots
> root 5 inode 6784890 errors 1000, some csum missing
> checking csums
> there are no extents for csum range 6447630387207159216-644763039011586=
8080
> csum exists for 6447630387207159216-6447630390115868080 but there is no=

> extent record
> there are no extents for csum range 763548178418734000-7635481814286509=
28
> csum exists for 763548178418734000-763548181428650928 but there is no
> extent record
> there are no extents for csum range
> 10574442573086800664-10574442573732416280
> csum exists for 10574442573086800664-10574442573732416280 but there is
> no extent record
> ERROR: errors found in csum tree
> found 73238589853696 bytes used, error(s) found
> total csum bytes: 8117840900
> total tree bytes: 34106834944
> total fs tree bytes: 23289413632
> total extent tree bytes: 1659682816
> btree space waste bytes: 6020692848
> file data blocks allocated: 73136347418624
> =C2=A0referenced 73135917441024
>=20
> Nothing changes because when I run the above command again the output i=
s
> identical.
>=20
> I had been using space_cache v2 but reverted to nospace_cache to run th=
e
> above.

The corrupted tree block is csum tree thus space_cache is not related.

>=20
> Is there any way to clean this up?

Only manually patching is possible.
As the corruption looks pretty like a memory corruption.

Thanks,
Qu

>=20
> kernel 4.17.14-202.fc28.x86_64
> btrfs-progs v4.15.1
>=20
> Label: none=C2=A0 uuid: acff5096-1128-4b24-a15e-4ba04261edc3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 66.61TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 72.77TiB used 68.03TiB path
> /dev/mapper/Cached-Backups
>=20
> Data, single: total=3D67.80TiB, used=3D66.52TiB
> System, DUP: total=3D40.00MiB, used=3D7.41MiB
> Metadata, DUP: total=3D98.50GiB, used=3D95.21GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> BTRFS info (device dm-3): disk space caching is enabled
> BTRFS info (device dm-3): has skinny extents
> BTRFS info (device dm-3): bdev /dev/mapper/Cached-Backups errs: wr 0, r=
d
> 0, flush 0, corrupt 666, gen 25
> BTRFS info (device dm-3): enabling ssd optimizations
>=20
>=20
>=20


--2BJw1NWTDz1lwI2NOzUfGzqbXSp3KU223--

--2a4nCgLvWmuFdgYHtKMJ1aAUcJirRRgtg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluDQvoACgkQwj2R86El
/qjzvgf/YFuLvgYnps6zMXyv0finpqdjOtR0XoGP8C7e4/N5iP/rVuJcsNDZ//Om
ofG9MIV5Ta6pwb+bvIicg3Rj8KJii4lzhLiTRjBAPkwNl937Zrd2e19SjfiL+4PW
v6lhH7CTJhhMTcghEP1tcCrTE5nF3dlge5rQ4U9hJA4Hi7sV7sFpedzIDU978dYd
3dQbXLx+N9W1SMrdAnQXjZLdGMg0mTxTao3bZX7DBEgDDbl5ZU4d4JOQUgeQGfep
m46QvoqAQRa/BoLpQSfKUIup6nGi51sjwRdLL56SMiM4iib7bYAlLfgBZyrsH/sK
ScAya0MQ0leui7YpoehOL+VLp7xE0A==
=ts9C
-----END PGP SIGNATURE-----

--2a4nCgLvWmuFdgYHtKMJ1aAUcJirRRgtg--
