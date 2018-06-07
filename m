Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbeFGF4u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 01:56:50 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Steve Leung <sjleung@shaw.ca>
References: <20180606072717.28854-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5cd8fd98-c361-8018-1a69-6e5dbdec535e@gmx.com>
Date: Thu, 7 Jun 2018 13:56:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="18fAFRKo8AdxImjl94Sd6qxVwAn4LdnCs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--18fAFRKo8AdxImjl94Sd6qxVwAn4LdnCs
Content-Type: multipart/mixed; boundary="251yVBCDELAxdiPD8ndu6PpnaxwQuGM5a";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Steve Leung <sjleung@shaw.ca>
Message-ID: <5cd8fd98-c361-8018-1a69-6e5dbdec535e@gmx.com>
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
References: <20180606072717.28854-1-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>

--251yVBCDELAxdiPD8ndu6PpnaxwQuGM5a
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

To Steve,

This patchset should fix your problem.

Would you please have a try?

Thanks,
Qu

On 2018=E5=B9=B406=E6=9C=8806=E6=97=A5 15:27, Qu Wenruo wrote:
> The patchset can be fetched from github (*):
> https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes
>=20
> It's based on David's devel branch, whose HEAD is:
> commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
> Author: Matthias Benkard <matthias.benkard@egym.de>
> Date:   Wed Apr 25 16:34:54 2018 +0200
>=20
>     btrfs-progs: mkfs: traverse_directory: Reset error code on continue=

>=20
> Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
> offending inodes are from 2014) has inline uncompressed extent, while
> its ram_bytes mismatch with item size.
>=20
> Latest kernel tree check catches this bug, while we failed to detect by=

> dump-tree.
>=20
> It turns out that btrfs-progs is doing something evil to avoid reading
> ram_bytes from inline uncompressed extent.
>=20
>=20
> So this patchset will address all such ram_bytes related problems.
>=20
> The 1st patch is a not-so-relative fix for restore, which is using
> ram_bytes for decompress. Although thanks to the compression header, we=

> won't read out-of-boundary, but fixing it is never a bad thing.
>=20
> The 2nd patch will get rid of the evil btrfs_file_extent_inline_len()
> which hides raw ram_bytes from us, and fooling us for a long long time.=

>=20
> The 3rd~5th patches introduce check/repair function for both original
> and lowmem mode (although lowmem mode can detect it even before this pa=
tch).
>=20
> The last one is the test case for it as usual.
>=20
> *: Or should I just migrate to gitlab after M$ acquired github?
>=20
> Qu Wenruo (6):
>   btrfs-progs: restore: Fix wrong compressed item size for decompress()=

>   btrfs-progs: Get rid of the confusing btrfs_file_extent_inline_len()
>   btrfs-progs: check/original: Detect and repair wrong inline ram_bytes=

>   btrfs-progs: check/lowmem: Prepare check_file_extent() to handle
>     repair
>   btrfs-progs: check/lowmem: Repair wrong inlien ram_bytes for
>     uncompressed extent
>   btrfs-progs: fsck-tests: Add test case for corrupted inline ram_bytes=

>=20
>  check/main.c                                  |  46 ++++++-
>  check/mode-lowmem.c                           | 120 ++++++++++++++----=

>  check/mode-original.h                         |   1 +
>  cmds-restore.c                                |   5 +-
>  ctree.h                                       |  22 ----
>  file.c                                        |   3 +-
>  print-tree.c                                  |   4 +-
>  .../offset_by_one.img                         | Bin 0 -> 3072 bytes
>  .../035-inline-bad-ram-bytes/test.sh          |  11 ++
>  9 files changed, 157 insertions(+), 55 deletions(-)
>  create mode 100644 tests/fsck-tests/035-inline-bad-ram-bytes/offset_by=
_one.img
>  create mode 100755 tests/fsck-tests/035-inline-bad-ram-bytes/test.sh
>=20


--251yVBCDELAxdiPD8ndu6PpnaxwQuGM5a--

--18fAFRKo8AdxImjl94Sd6qxVwAn4LdnCs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsYyQ0ACgkQwj2R86El
/qjqKggAj961Y8sF6qfJEnBeo6mEO25DWOq/BtomFiAsvqckRP5H6DvFFM6dypbr
u07Z2FtrUwiNuymLSGUFap2rcNi7CCRsKw2ekFn15NeCrvE7hmCnsEksVmfIvg0a
Z2//lud0gBQCxuyHt9zQzPMjFNrVOhFRodAdufdl5MsrhhE5NMXJTWlDtKCUDJmD
OI5avMrKoQgOmTcWLxXkegwbYJq2l4LonL9IBbDYDLmGDj1l4FuPAWx9YXK0aj4V
7ylFwIEamnRS8TYc2DOhyugi65mdFrs5+IQ+RZDJPmc4y4mzcjs+a1g9C68rkaph
90Dg1CrPdUTFGWjXrfjinh7gXOmX4w==
=jjIm
-----END PGP SIGNATURE-----

--18fAFRKo8AdxImjl94Sd6qxVwAn4LdnCs--
