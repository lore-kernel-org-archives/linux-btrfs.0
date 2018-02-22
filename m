Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751760AbeBVWo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 17:44:56 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93E64AF35
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 22:44:55 +0000 (UTC)
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
Date: Thu, 22 Feb 2018 17:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <20171222061847.13158-11-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sVRqnpOVdx3CdpBJgZgVGMtehmjizGaZz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sVRqnpOVdx3CdpBJgZgVGMtehmjizGaZz
Content-Type: multipart/mixed; boundary="d7HS3Wyd5mxCG3nM1y3oxrN1qcqh54ySE";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
In-Reply-To: <20171222061847.13158-11-wqu@suse.com>

--d7HS3Wyd5mxCG3nM1y3oxrN1qcqh54ySE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/22/17 1:18 AM, Qu Wenruo wrote:
> Unlike reservation calculation used in inode rsv for metadata, qgroup
> doesn't really need to care things like csum size or extent usage for
> whole tree COW.
>=20
> Qgroup care more about net change of extent usage.
> That's to say, if we're going to insert one file extent, it will mostly=

> find its place in CoWed tree block, leaving no change in extent usage.
> Or cause leaf split, result one new net extent, increasing qgroup numbe=
r
> by nodesize.
> (Or even more rare case, increase the tree level, increasing qgroup
> number by 2 * nodesize)
>=20
> So here instead of using the way overkilled calculation for extent
> allocator, which cares more about accurate and no error, qgroup doesn't=

> need that over-calculated reservation.
>=20
> This patch will maintain 2 new members in btrfs_block_rsv structure for=

> qgroup, using much smaller calculation for qgroup rsv, reducing false
> EDQUOT.


I think this is the right idea but, rather than being the last step in a
qgroup rework, it should be the first.  Don't qgroup reservation
lifetimes match the block reservation lifetimes?  We wouldn't want a
global reserve and we wouldn't track usage on a per-block basis, but
they should otherwise match.  We already have clear APIs surrounding the
use of block reservations, so it seems to me that it'd make sense to
extend those to cover the qgroup cases as well.  Otherwise, the rest of
your patchset makes a parallel reservation system with a different API.
That keeps the current state of qgroups as a bolt-on that always needs
to be tracked separately (and which developers need to ensure they get
right).

-Jeff

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h       | 18 +++++++++++++++++
>  fs/btrfs/extent-tree.c | 55 ++++++++++++++++++++++++++++++++++++++++--=
--------
>  2 files changed, 62 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0c58f92c2d44..97783ba91e00 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -467,6 +467,24 @@ struct btrfs_block_rsv {
>  	unsigned short full;
>  	unsigned short type;
>  	unsigned short failfast;
> +
> +	/*
> +	 * Qgroup equivalent for @size @reserved
> +	 *
> +	 * Unlike normal normal @size/@reserved for inode rsv,
> +	 * qgroup doesn't care about things like csum size nor how many tree
> +	 * blocks it will need to reserve.
> +	 *
> +	 * Qgroup cares more about *NET* change of extent usage.
> +	 * So for ONE newly inserted file extent, in worst case it will cause=

> +	 * leaf split and level increase, nodesize for each file extent
> +	 * is already way overkilled.
> +	 *
> +	 * In short, qgroup_size/reserved is the up limit of possible needed
> +	 * qgroup metadata reservation.
> +	 */
> +	u64 qgroup_rsv_size;
> +	u64 qgroup_rsv_reserved;
>  };
> =20
>  /*
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 986660f301de..9d579c7bcf7f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5565,14 +5565,18 @@ static void space_info_add_new_bytes(struct btr=
fs_fs_info *fs_info,
> =20
>  static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
>  				    struct btrfs_block_rsv *block_rsv,
> -				    struct btrfs_block_rsv *dest, u64 num_bytes)
> +				    struct btrfs_block_rsv *dest, u64 num_bytes,
> +				    u64 *qgroup_to_release_ret)
>  {
>  	struct btrfs_space_info *space_info =3D block_rsv->space_info;
> +	u64 qgroup_to_release =3D 0;
>  	u64 ret;
> =20
>  	spin_lock(&block_rsv->lock);
> -	if (num_bytes =3D=3D (u64)-1)
> +	if (num_bytes =3D=3D (u64)-1) {
>  		num_bytes =3D block_rsv->size;
> +		qgroup_to_release =3D block_rsv->qgroup_rsv_size;
> +	}
>  	block_rsv->size -=3D num_bytes;
>  	if (block_rsv->reserved >=3D block_rsv->size) {
>  		num_bytes =3D block_rsv->reserved - block_rsv->size;
> @@ -5581,6 +5585,12 @@ static u64 block_rsv_release_bytes(struct btrfs_=
fs_info *fs_info,
>  	} else {
>  		num_bytes =3D 0;
>  	}
> +	if (block_rsv->qgroup_rsv_reserved >=3D block_rsv->qgroup_rsv_size) {=

> +		qgroup_to_release =3D block_rsv->qgroup_rsv_reserved -
> +				    block_rsv->qgroup_rsv_size;
> +		block_rsv->qgroup_rsv_reserved =3D block_rsv->qgroup_rsv_size;
> +	} else
> +		qgroup_to_release =3D 0;
>  	spin_unlock(&block_rsv->lock);
> =20
>  	ret =3D num_bytes;
> @@ -5603,6 +5613,8 @@ static u64 block_rsv_release_bytes(struct btrfs_f=
s_info *fs_info,
>  			space_info_add_old_bytes(fs_info, space_info,
>  						 num_bytes);
>  	}
> +	if (qgroup_to_release_ret)
> +		*qgroup_to_release_ret =3D qgroup_to_release;
>  	return ret;
>  }
> =20
> @@ -5744,17 +5756,21 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *=
inode,
>  	struct btrfs_root *root =3D inode->root;
>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>  	u64 num_bytes =3D 0;
> +	u64 qgroup_num_bytes =3D 0;
>  	int ret =3D -ENOSPC;
> =20
>  	spin_lock(&block_rsv->lock);
>  	if (block_rsv->reserved < block_rsv->size)
>  		num_bytes =3D block_rsv->size - block_rsv->reserved;
> +	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
> +		qgroup_num_bytes =3D block_rsv->qgroup_rsv_size -
> +				   block_rsv->qgroup_rsv_reserved;
>  	spin_unlock(&block_rsv->lock);
> =20
>  	if (num_bytes =3D=3D 0)
>  		return 0;
> =20
> -	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
> +	ret =3D btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, tr=
ue);
>  	if (ret)
>  		return ret;
>  	ret =3D reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> @@ -5762,7 +5778,13 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *i=
node,
>  		block_rsv_add_bytes(block_rsv, num_bytes, 0);
>  		trace_btrfs_space_reservation(root->fs_info, "delalloc",
>  					      btrfs_ino(inode), num_bytes, 1);
> -	}
> +
> +		/* Don't forget to increase qgroup_rsv_reserved */
> +		spin_lock(&block_rsv->lock);
> +		block_rsv->qgroup_rsv_reserved +=3D qgroup_num_bytes;
> +		spin_unlock(&block_rsv->lock);
> +	} else
> +		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
>  	return ret;
>  }
> =20
> @@ -5784,20 +5806,23 @@ void btrfs_inode_rsv_release(struct btrfs_inode=
 *inode, bool qgroup_free)
>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>  	u64 released =3D 0;
> +	u64 qgroup_to_release =3D 0;
> =20
>  	/*
>  	 * Since we statically set the block_rsv->size we just want to say we=

>  	 * are releasing 0 bytes, and then we'll just get the reservation ove=
r
>  	 * the size free'd.
>  	 */
> -	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_rsv, =
0);
> +	released =3D block_rsv_release_bytes(fs_info, block_rsv, global_rsv, =
0,
> +					   &qgroup_to_release);
>  	if (released > 0)
>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>  					      btrfs_ino(inode), released, 0);
>  	if (qgroup_free)
> -		btrfs_qgroup_free_meta_prealloc(inode->root, released);
> +		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
>  	else
> -		btrfs_qgroup_convert_reserved_meta(inode->root, released);
> +		btrfs_qgroup_convert_reserved_meta(inode->root,
> +						   qgroup_to_release);
>  }
> =20
>  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> @@ -5809,7 +5834,7 @@ void btrfs_block_rsv_release(struct btrfs_fs_info=
 *fs_info,
>  	if (global_rsv =3D=3D block_rsv ||
>  	    block_rsv->space_info !=3D global_rsv->space_info)
>  		global_rsv =3D NULL;
> -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes);
> +	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NU=
LL);
>  }
> =20
>  static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
> @@ -5889,7 +5914,7 @@ static void init_global_block_rsv(struct btrfs_fs=
_info *fs_info)
>  static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
>  {
>  	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
> -				(u64)-1);
> +				(u64)-1, NULL);
>  	WARN_ON(fs_info->trans_block_rsv.size > 0);
>  	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
>  	WARN_ON(fs_info->chunk_block_rsv.size > 0);
> @@ -5931,7 +5956,7 @@ void btrfs_trans_release_chunk_metadata(struct bt=
rfs_trans_handle *trans)
>  	WARN_ON_ONCE(!list_empty(&trans->new_bgs));
> =20
>  	block_rsv_release_bytes(fs_info, &fs_info->chunk_block_rsv, NULL,
> -				trans->chunk_bytes_reserved);
> +				trans->chunk_bytes_reserved, NULL);
>  	trans->chunk_bytes_reserved =3D 0;
>  }
> =20
> @@ -6036,6 +6061,7 @@ static void btrfs_calculate_inode_block_rsv_size(=
struct btrfs_fs_info *fs_info,
>  {
>  	struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>  	u64 reserve_size =3D 0;
> +	u64 qgroup_rsv_size =3D 0;
>  	u64 csum_leaves;
>  	unsigned outstanding_extents;
> =20
> @@ -6048,9 +6074,16 @@ static void btrfs_calculate_inode_block_rsv_size=
(struct btrfs_fs_info *fs_info,
>  						 inode->csum_bytes);
>  	reserve_size +=3D btrfs_calc_trans_metadata_size(fs_info,
>  						       csum_leaves);
> +	/*
> +	 * For qgroup rsv, the calculation is very simple:
> +	 * nodesize for each outstanding extent.
> +	 * This is already overkilled under most case.
> +	 */
> +	qgroup_rsv_size =3D outstanding_extents * fs_info->nodesize;
> =20
>  	spin_lock(&block_rsv->lock);
>  	block_rsv->size =3D reserve_size;
> +	block_rsv->qgroup_rsv_size =3D qgroup_rsv_size;
>  	spin_unlock(&block_rsv->lock);
>  }
> =20
> @@ -8405,7 +8438,7 @@ static void unuse_block_rsv(struct btrfs_fs_info =
*fs_info,
>  			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
>  {
>  	block_rsv_add_bytes(block_rsv, blocksize, 0);
> -	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
> +	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
>  }
> =20
>  /*
>=20


--=20
Jeff Mahoney
SUSE Labs


--d7HS3Wyd5mxCG3nM1y3oxrN1qcqh54ySE--

--sVRqnpOVdx3CdpBJgZgVGMtehmjizGaZz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqPR+QACgkQHntLYyF5
5bIiYhAAtAD6peqTkrEs4HH+QSf4jAukuN50G0CQOFKNdYVKsUsn0hFufI1advRf
CBp+ItO/43RWh1CXQOUNK/XOmAUWNhNNaKc5/StTllN1wTQh4EZd7PCU4o/tWexM
KWaRSWUstKrJ+p0seW2pKEa/yRfmJKgkEWPqbSpO9Vctfl/bo7DnvdM+WAwvLj0/
sLaEqMO6X+hi5cx0+eP4kUM7NeBTtzsXDonvL181/9enrzXz+3K2KqhZDjrLkURT
u6ywS5Cnn7CkQzfuNG6EUlE/9JFqP4sQPYub2zRSxVFSw+JTR4pGNMl/3+gMqXJc
tTIoZsGuwwoSQEsSAAdldUQRkhU/5HgYsTMKKAlxTjQvUQaW8dkS1uvsYq5MvssU
07MHl4B0S7f786JS7rm8WJKrv5VTiX3BVSeYkT0a45uOVHa8e1F3uGrx/XcU60mb
Ru5YxO5uaJzzVMkPLHQHRiCVHFzZUtRpDQ6ffZp7Iqrsj+P2lVadVrV/xIJbG1gt
u89DCUNNcAoRLVFThd+lfW039OCWD2Lp9pAuercneqm6vrLpCsrv0Yww3BxHsgdZ
OWaLotoUUJsUgHCJ+aIwLRp0DrxOUu8K294yHqYcqlK1FejkRUTXGdZZHryVuPNu
8fX/UW7/TYiwprRHoF10UccTfyCLJOeCw2HH4Bp6THVWDTfY1dA=
=+vOt
-----END PGP SIGNATURE-----

--sVRqnpOVdx3CdpBJgZgVGMtehmjizGaZz--
