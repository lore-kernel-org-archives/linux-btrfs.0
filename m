Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbeGRHew (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:34:52 -0400
Subject: Re: [PATCH 13/19] btrfs: qgroup: Drop fs_info parameter from
 btrfs_qgroup_trace_extent
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
 <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
Date: Wed, 18 Jul 2018 14:58:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qlMgcXiv84wr1lAkNSnWfJUA1Be9meUal"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qlMgcXiv84wr1lAkNSnWfJUA1Be9meUal
Content-Type: multipart/mixed; boundary="S4H8K6H83FVeJHyDsUGnVpYzNjwOeKxBn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
Subject: Re: [PATCH 13/19] btrfs: qgroup: Drop fs_info parameter from
 btrfs_qgroup_trace_extent
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
 <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>

--S4H8K6H83FVeJHyDsUGnVpYzNjwOeKxBn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8818=E6=97=A5 14:45, Lu Fengqi wrote:
> It can be fetched from the transaction handle.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c   | 13 ++++++-------
>  fs/btrfs/qgroup.h   |  5 ++---
>  fs/btrfs/tree-log.c |  2 +-
>  3 files changed, 9 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c85c1a0e933a..01add73cb2aa 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1579,10 +1579,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs=
_fs_info *fs_info,
>  	return 0;
>  }
> =20
> -int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
> -		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
> -		gfp_t gfp_flag)
> +int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 by=
tenr,
> +			      u64 num_bytes, gfp_t gfp_flag)
>  {
> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;

Just lines below, we do extra WARN_ON(trans =3D=3D NULL).
So if we really hit some case with NULL trans, this would cause a NULL
pointer dereference.

Although I have to admit, I'm a little paranoid about possible NULL
trans passed in.
So maybe it's a good timing to remove that WARN_ON() too?

Thanks,
Qu

>  	struct btrfs_qgroup_extent_record *record;
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	int ret;
> @@ -1644,8 +1644,8 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_tr=
ans_handle *trans,
> =20
>  		num_bytes =3D btrfs_file_extent_disk_num_bytes(eb, fi);
> =20
> -		ret =3D btrfs_qgroup_trace_extent(trans, fs_info, bytenr,
> -						num_bytes, GFP_NOFS);
> +		ret =3D btrfs_qgroup_trace_extent(trans, bytenr, num_bytes,
> +						GFP_NOFS);
>  		if (ret)
>  			return ret;
>  	}
> @@ -1796,8 +1796,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans=
_handle *trans,
>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>  			path->locks[level] =3D BTRFS_READ_LOCK_BLOCKING;
> =20
> -			ret =3D btrfs_qgroup_trace_extent(trans, fs_info,
> -							child_bytenr,
> +			ret =3D btrfs_qgroup_trace_extent(trans, child_bytenr,
>  							fs_info->nodesize,
>  							GFP_NOFS);
>  			if (ret)
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 385367989ed6..0215dc0b1710 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -212,9 +212,8 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_=
info *fs_info,
>   * Return <0 for error, like memory allocation failure or invalid para=
meter
>   * (NULL trans)
>   */
> -int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
> -		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
> -		gfp_t gfp_flag);
> +int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 by=
tenr,
> +			      u64 num_bytes, gfp_t gfp_flag);
> =20
>  /*
>   * Inform qgroup to trace all leaf items of data
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7b7498f1f641..10f6a4223897 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -685,7 +685,7 @@ static noinline int replay_one_extent(struct btrfs_=
trans_handle *trans,
>  		 * as the owner of the file extent changed from log tree
>  		 * (doesn't affect qgroup) to fs/file tree(affects qgroup)
>  		 */
> -		ret =3D btrfs_qgroup_trace_extent(trans, fs_info,
> +		ret =3D btrfs_qgroup_trace_extent(trans,
>  				btrfs_file_extent_disk_bytenr(eb, item),
>  				btrfs_file_extent_disk_num_bytes(eb, item),
>  				GFP_NOFS);
>=20


--S4H8K6H83FVeJHyDsUGnVpYzNjwOeKxBn--

--qlMgcXiv84wr1lAkNSnWfJUA1Be9meUal
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltO5P4ACgkQwj2R86El
/qh8rggAnxEcAt6Ya16J8QDzPipxN7ZHmSO9iqZtH3as9R6sKW91MAsahp5v1maf
7uMHeBCim+lAF3exLwT5hh7wNd+K1mtNmXtPLdDjeTCRNU8KBUctFTz/thu8ncjO
FKW0zGiRMQw2BjWvuIgpkc8/llIe0lCwKPDkr8A+6kN2P3dNPJ7q7E18BeWAPF5w
Oofv7iM7kCnXod9dw/a8loGQZFE1NOqzX7gFO/azp23c8ycN72Dqn9E1JdXr28Cg
41pKJTG/IDT5HPTUlPyWH5ncZ4Z0zuCmamYnwwt1pkv/iwX0t3v8fwK0HLPcT3FR
0LwjbB+eDT2EHTD60v8SCu9SIu0HMA==
=lmOe
-----END PGP SIGNATURE-----

--qlMgcXiv84wr1lAkNSnWfJUA1Be9meUal--
