Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54807 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbeAHFJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 00:09:20 -0500
Subject: Re: [PATCH v2 1/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-2-anand.jain@oracle.com>
 <20180108050409.727-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dffaa3c8-30d9-2ec0-4fac-3bb6457c7136@gmx.com>
Date: Mon, 8 Jan 2018 13:08:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180108050409.727-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rMOPASHf5ZullUG6aPFiEeO7VqAGXJrbr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rMOPASHf5ZullUG6aPFiEeO7VqAGXJrbr
Content-Type: multipart/mixed; boundary="k7qUh8VnG9dWrcB23wZTOf59rAKGy1o2d";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <dffaa3c8-30d9-2ec0-4fac-3bb6457c7136@gmx.com>
Subject: Re: [PATCH v2 1/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
References: <20180108030512.22344-2-anand.jain@oracle.com>
 <20180108050409.727-1-anand.jain@oracle.com>
In-Reply-To: <20180108050409.727-1-anand.jain@oracle.com>

--k7qUh8VnG9dWrcB23wZTOf59rAKGy1o2d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 13:04, Anand Jain wrote:
> Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changing=

> fsid is complete. Its not a good idea to mount the device anything in
> between, so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID
> is set.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>   cc: wqu@suse.com
> ---
> v1->v2: Oops. Fix cut and paste error, remove ~. My bad.
>=20
>  fs/btrfs/disk-io.c              | 7 ++++++-
>  include/uapi/linux/btrfs_tree.h | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a69e5944dc08..0dd215258ff9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -61,7 +61,8 @@
>  				 BTRFS_HEADER_FLAG_RELOC |\
>  				 BTRFS_SUPER_FLAG_ERROR |\
>  				 BTRFS_SUPER_FLAG_SEEDING |\
> -				 BTRFS_SUPER_FLAG_METADUMP)
> +				 BTRFS_SUPER_FLAG_METADUMP |\
> +				 BTRFS_SUPER_FLAG_CHANGING_FSID)

Still the same problem here.

Since that super flag is excluded in btrfs_check_super_valid(), I didn't
see any meaning including it into BTRFS_SUPER_FLAG_SUPP, and it will
confuse later BTRFS_SUPER_FLAG_SUPP users.

Thanks,
Qu

> =20
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
> @@ -3906,6 +3907,10 @@ static int btrfs_check_super_valid(struct btrfs_=
fs_info *fs_info)
>  		btrfs_err(fs_info, "no valid FS found");
>  		ret =3D -EINVAL;
>  	}
> +	if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_CHANGING_FSID) {
> +		btrfs_err(fs_info, "SUPER_FLAG_CHANGING_FSID is set");
> +		ret =3D -EINVAL;
> +	}
>  	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)
>  		btrfs_warn(fs_info, "unrecognized super flag: %llu",
>  				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs=
_tree.h
> index 38ab0e06259a..aff1356c2bb8 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -457,6 +457,7 @@ struct btrfs_free_space_header {
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
>  #define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
> +#define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
> =20
> =20
>  /*
>=20


--k7qUh8VnG9dWrcB23wZTOf59rAKGy1o2d--

--rMOPASHf5ZullUG6aPFiEeO7VqAGXJrbr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpS/NEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgyeAf9F4zcIYsp/htupmuQSlTk4iVi
zqD+q6nh6GFLguqTc0RLU7/mrGAFkgsinrjtpbypWcjnkK7ubBjlnfvhS/6HVoHk
qT9fIQp43jv8y4it2fMjqLVAwLo1GGmCit/apr3YtrjEMm707D5uo0lBeoCqLpZe
kc9BiUgI0+6Cp2mtNp4Mz2vTKcE0vakPzA+syCk130ZVphIf6CF9XBy8s6v7PgYx
lWd6wksLRNZT8AEezT8yFG+JGcvJk/YRoPd92/2bz+T3jsVyHAiDsDNYcLflsrCn
3e4vVls02BwJdMSJk52ik+7D0judlvGBFPrlfh7TYRlcmXMyEHObsHUb/MDitg==
=Hv1R
-----END PGP SIGNATURE-----

--rMOPASHf5ZullUG6aPFiEeO7VqAGXJrbr--
