Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50597 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755245AbeAHEwT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Jan 2018 23:52:19 -0500
Subject: Re: [PATCH 1/2] btrfs: add missing BTRFS_SUPER_FLAG define
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <348a9814-5ed7-bf49-704a-d24e70f89bdd@gmx.com>
Date: Mon, 8 Jan 2018 12:52:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180108030512.22344-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zGskRo3Vz1156SpSrBytTCg5BEplwhGcZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zGskRo3Vz1156SpSrBytTCg5BEplwhGcZ
Content-Type: multipart/mixed; boundary="l7fo0M7X9DyJXUiAYg1Lc2zXZYLEzeXUb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <348a9814-5ed7-bf49-704a-d24e70f89bdd@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: add missing BTRFS_SUPER_FLAG define
References: <20180108030512.22344-1-anand.jain@oracle.com>
In-Reply-To: <20180108030512.22344-1-anand.jain@oracle.com>

--l7fo0M7X9DyJXUiAYg1Lc2zXZYLEzeXUb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 11:05, Anand Jain wrote:
> btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 3=
4).
> So just define that in kernel so that we know its been used. This patch=

> does not add it to BTRFS_SUPER_FLAG_SUPP yet, and will continue to warn=

> about unsupported flag.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  include/uapi/linux/btrfs_tree.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs=
_tree.h
> index 6d6e5da51527..38ab0e06259a 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
> =20
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
> =20
> =20
>  /*
>=20


--l7fo0M7X9DyJXUiAYg1Lc2zXZYLEzeXUb--

--zGskRo3Vz1156SpSrBytTCg5BEplwhGcZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpS+PEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiPRQf/eAbfy6HPdIVzkRX9Sq4AkyJz
O8NFDnH1EJicWMm2uGNZQOXtl/APqAv2Ou5lelf2MA2WO4SnnoAFYUqwWZXW2XtT
fhNm8hO5eoXboapDWHn8jAdqWHZ/dkmUD46raP7gJlVZSv40+l30fo/rcwfId9te
Cv+h+DEBnvTCLriaueqjdKfc2ukL46uFrG2lLj7TwKJFGi1I0IibM/ryKxEoPwRO
yyqvIYt0oLzeXFRGvUWSzohiMyAiMEq+eQwyorBLc9wGpxMFoCwatZgkl16qHwQs
E+qE0kDPz3D43M1Isulewj8hWfonflv/ouDhN/L5iSFhEbHmq3jiF1sjCjd+Aw==
=yDvA
-----END PGP SIGNATURE-----

--zGskRo3Vz1156SpSrBytTCg5BEplwhGcZ--
