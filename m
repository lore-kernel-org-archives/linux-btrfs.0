Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37479 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbeH2JXE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 05:23:04 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20180803055022.9816-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
Date: Wed, 29 Aug 2018 13:27:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vx6q0WGsZELlkjueZQqZpjFG3DPHi0IOv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vx6q0WGsZELlkjueZQqZpjFG3DPHi0IOv
Content-Type: multipart/mixed; boundary="LrJfUMEi988F07pspomAi6LNXAnUqSM8P";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Message-ID: <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
References: <20180803055022.9816-1-wqu@suse.com>
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>

--LrJfUMEi988F07pspomAi6LNXAnUqSM8P
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

These fixes are pretty small, I'd like to see them merged before I need
to rebase them again and again.

Thanks,
Qu

On 2018/8/3 =E4=B8=8B=E5=8D=881:50, Qu Wenruo wrote:
> This can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/fixes_for_fuzz_test
>=20
> The base HEAD is:
> commit d7a1b84756157d544a9ddc399ef48c6132eaafcf (david/devel)
> Author: Qu Wenruo <wqu@suse.com>
> Date:   Thu Jul 5 15:37:31 2018 +0800
>=20
>     btrfs-progs: check/original: Don't overwrite return value when we f=
ailed to repair
>=20
>=20
> Thanks for the already merged fixes for fuzz/003, the remaining part is=

> pretty small now, +20/-7.
>=20
> Mostly of the fixes are for fuzz/003, just a small bunch of BUG_ON()
> removal. (Patch 1~3 and 5)
>=20
> There is also a fix for fuzz/003 dead loop. (Patch 4)
>=20
> Finally we have a fix for fuzz/007, the bug is a segfault triggered by
> accessing poisoned list_head, caused by double list freeing. (Patch 6)
>=20
> Now fuzz-test should finally work without problem.
>=20
> Qu Wenruo (6):
>   btrfs-progs: Exit gracefully if we hit ENOSPC when allocating tree
>     block
>   btrfs-progs: Exit gracefully when failed to repair root dir item
>   btrfs-progs: Don't report dirty leaked eb using BUG_ON
>   btrfs-progs: Fix infinite loop when failed to repair bad key order
>   btrfs-progs: Exit gracefull when we failed to alloc dev extent
>   btrfs-progs: rescue-super: Don't double free fs_devices
>=20
>  check/main.c    | 10 +++++++++-
>  extent-tree.c   |  5 ++++-
>  extent_io.c     |  6 +++++-
>  super-recover.c |  3 ---
>  volumes.c       |  3 ++-
>  5 files changed, 20 insertions(+), 7 deletions(-)
>=20


--LrJfUMEi988F07pspomAi6LNXAnUqSM8P--

--vx6q0WGsZELlkjueZQqZpjFG3DPHi0IOv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluGLssACgkQwj2R86El
/qgS4gf/asrR482gR1mc+O1F3JdT7a8tvr30qSAjrWDaX/S3REYOee1lwnoGbUJu
ahVB7pH3V1f///txlh5yP5QOCNTjOGZCphyy2Dn8pUe+Mo627eMrXfMR8mtjtPrW
bTDBU/4/ho58pUFIc0TiLeCoVyLxy2qWOpNyTA++w4yaP33BdnMYEyvEW17T4zPC
4aFn04cKhINRxThFwQ1toUFlRfvCfWnjclC1VQa0fQIXuhz0TDl5Lob9Bhty1biQ
lY8VsbjsBYqPfhsvGaYzVGi7z2jXw9wYThWw83gVqF6Km8uwbe2wt4elTCAr8mDZ
xOw2z5QRuXjRJvg6dQSiyb/HVDlymw==
=clRF
-----END PGP SIGNATURE-----

--vx6q0WGsZELlkjueZQqZpjFG3DPHi0IOv--
