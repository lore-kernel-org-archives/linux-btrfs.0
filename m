Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56210 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755566AbeAHE4a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Jan 2018 23:56:30 -0500
Subject: Re: [PATCH 2/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-1-anand.jain@oracle.com>
 <20180108030512.22344-2-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <83756e06-446f-2807-8c9a-b918f609b741@gmx.com>
Date: Mon, 8 Jan 2018 12:55:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180108030512.22344-2-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9uMl0yUdO4GHkTnNPo5wZxxbPQqm2asBK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9uMl0yUdO4GHkTnNPo5wZxxbPQqm2asBK
Content-Type: multipart/mixed; boundary="5HfpdU7y3ZX75SfTSlHtnlsW00uQ6OnvU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <83756e06-446f-2807-8c9a-b918f609b741@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
References: <20180108030512.22344-1-anand.jain@oracle.com>
 <20180108030512.22344-2-anand.jain@oracle.com>
In-Reply-To: <20180108030512.22344-2-anand.jain@oracle.com>

--5HfpdU7y3ZX75SfTSlHtnlsW00uQ6OnvU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 11:05, Anand Jain wrote:
> Userland uses this flag and resets it only when changing the fsid is
> complete. Its not a good idea to mount the device anything in between,
> so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID is set.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>   cc: wqu@suse.com
> ---
>  fs/btrfs/disk-io.c              | 7 ++++++-
>  include/uapi/linux/btrfs_tree.h | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a69e5944dc08..8b76faa77235 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -61,7 +61,8 @@
>  				 BTRFS_HEADER_FLAG_RELOC |\
>  				 BTRFS_SUPER_FLAG_ERROR |\
>  				 BTRFS_SUPER_FLAG_SEEDING |\
> -				 BTRFS_SUPER_FLAG_METADUMP)
> +				 BTRFS_SUPER_FLAG_METADUMP |\
> +				 BTRFS_SUPER_FLAG_CHANGING_FSID)

If we don't want the half changed fs to be mounted, it's better not to
include FLAG_CHANGING_FSID into BTRFS_SUPER_FLAG_SUPP.

> =20
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
> @@ -3906,6 +3907,10 @@ static int btrfs_check_super_valid(struct btrfs_=
fs_info *fs_info)
>  		btrfs_err(fs_info, "no valid FS found");
>  		ret =3D -EINVAL;
>  	}
> +	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_CHANGING_FSID) {

This doesn't seems right.

Shouldn't it be "btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_CHANING_FSID"?

Thanks,
Qu

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


--5HfpdU7y3ZX75SfTSlHtnlsW00uQ6OnvU--

--9uMl0yUdO4GHkTnNPo5wZxxbPQqm2asBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpS+c8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qilngf/Swferc2RgL9RobnFaKWYJHoT
zNigpG2MpcEUtx+8/EzPog+Iei6BKr7DuulZof/jl7DIuO5EBUw4txlezgxGTCcZ
a//9oHBwxfhe/5wfwv4wwbNjVnwWc0sCiTqlmsfDKVfFWSPqwDs/qRLCTU9OhGvF
F7lVtFWH13ifQp/CkwYQId5gw/hhtL6Y9HdeH7Aw/5Aki4TnWhuNuddFuCpw5bdI
0JbC96bGGOmP/Somapwg25VvHYKb81AnwJcZr3eY4UeWuiDDU5vxX7TOyeUuqJI4
Wx4R4voNGpWs0p+ODqRbjWrtpcrfnevLziclYLNa0wEKUza8h5U+gtHqdUTEuw==
=On4q
-----END PGP SIGNATURE-----

--9uMl0yUdO4GHkTnNPo5wZxxbPQqm2asBK--
