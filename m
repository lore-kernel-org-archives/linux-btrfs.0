Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60143 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751702AbdBOWGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 17:06:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B65AACD8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 22:06:22 +0000 (UTC)
Subject: Re: [PATCH 4/8] btrfs: free-space-cache, clean up unnecessary root
 arguments
To: linux-btrfs@vger.kernel.org
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
 <1487194114-12786-5-git-send-email-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a10e9596-5675-af76-b923-d7ca8b3bca60@suse.com>
Date: Wed, 15 Feb 2017 17:06:20 -0500
MIME-Version: 1.0
In-Reply-To: <1487194114-12786-5-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FxIhC9aXVLPGTwL095cXnDeTQVG2ocmsW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FxIhC9aXVLPGTwL095cXnDeTQVG2ocmsW
Content-Type: multipart/mixed; boundary="NFS9D1NTl6f7n7Tba4k42NL4AjBgNx88t";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <a10e9596-5675-af76-b923-d7ca8b3bca60@suse.com>
Subject: Re: [PATCH 4/8] btrfs: free-space-cache, clean up unnecessary root
 arguments
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
 <1487194114-12786-5-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-5-git-send-email-jeffm@suse.com>

--NFS9D1NTl6f7n7Tba4k42NL4AjBgNx88t
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/15/17 4:28 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> The free space cache APIs accept a root but always use the tree root.
>=20
> Also, btrfs_truncate_free_space_cache accepts a root AND an inode but
> the inode always points to the root anyway, so let's just pass the inod=
e.

This one has minor conflicts with Dave's patchset that removes path and
objectid.

-Jeff

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c      |  9 +++++----
>  fs/btrfs/free-space-cache.c | 25 +++++++++++--------------
>  fs/btrfs/free-space-cache.h |  7 +++----
>  fs/btrfs/inode-map.c        |  2 +-
>  fs/btrfs/relocation.c       |  5 ++---
>  5 files changed, 22 insertions(+), 26 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 20bedc7..a557249 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3372,7 +3372,7 @@ static int cache_save_setup(struct btrfs_block_gr=
oup_cache *block_group,
>  	if (trans->aborted)
>  		return 0;
>  again:
> -	inode =3D lookup_free_space_inode(root, block_group, path);
> +	inode =3D lookup_free_space_inode(fs_info, block_group, path);
>  	if (IS_ERR(inode) && PTR_ERR(inode) !=3D -ENOENT) {
>  		ret =3D PTR_ERR(inode);
>  		btrfs_release_path(path);
> @@ -3386,7 +3386,8 @@ static int cache_save_setup(struct btrfs_block_gr=
oup_cache *block_group,
>  		if (block_group->ro)
>  			goto out_free;
> =20
> -		ret =3D create_free_space_inode(root, trans, block_group, path);
> +		ret =3D create_free_space_inode(fs_info, trans, block_group,
> +					      path);
>  		if (ret)
>  			goto out_free;
>  		goto again;
> @@ -3428,7 +3429,7 @@ static int cache_save_setup(struct btrfs_block_gr=
oup_cache *block_group,
>  		if (ret)
>  			goto out_put;
> =20
> -		ret =3D btrfs_truncate_free_space_cache(root, trans, NULL, inode);
> +		ret =3D btrfs_truncate_free_space_cache(trans, NULL, inode);
>  		if (ret)
>  			goto out_put;
>  	}
> @@ -10319,7 +10320,7 @@ int btrfs_remove_block_group(struct btrfs_trans=
_handle *trans,
>  	 * get the inode first so any iput calls done for the io_list
>  	 * aren't the final iput (no unlinks allowed now)
>  	 */
> -	inode =3D lookup_free_space_inode(tree_root, block_group, path);
> +	inode =3D lookup_free_space_inode(fs_info, block_group, path);
> =20
>  	mutex_lock(&trans->transaction->cache_write_mutex);
>  	/*
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 7015892..61a72fb 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -94,12 +94,11 @@ static struct inode *__lookup_free_space_inode(stru=
ct btrfs_root *root,
>  	return inode;
>  }
> =20
> -struct inode *lookup_free_space_inode(struct btrfs_root *root,
> +struct inode *lookup_free_space_inode(struct btrfs_fs_info *fs_info,
>  				      struct btrfs_block_group_cache
>  				      *block_group, struct btrfs_path *path)
>  {
>  	struct inode *inode =3D NULL;
> -	struct btrfs_fs_info *fs_info =3D root->fs_info;
>  	u32 flags =3D BTRFS_INODE_NODATASUM | BTRFS_INODE_NODATACOW;
> =20
>  	spin_lock(&block_group->lock);
> @@ -109,7 +108,7 @@ struct inode *lookup_free_space_inode(struct btrfs_=
root *root,
>  	if (inode)
>  		return inode;
> =20
> -	inode =3D __lookup_free_space_inode(root, path,
> +	inode =3D __lookup_free_space_inode(fs_info->tree_root, path,
>  					  block_group->key.objectid);
>  	if (IS_ERR(inode))
>  		return inode;
> @@ -192,7 +191,7 @@ static int __create_free_space_inode(struct btrfs_r=
oot *root,
>  	return 0;
>  }
> =20
> -int create_free_space_inode(struct btrfs_root *root,
> +int create_free_space_inode(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_trans_handle *trans,
>  			    struct btrfs_block_group_cache *block_group,
>  			    struct btrfs_path *path)
> @@ -200,11 +199,11 @@ int create_free_space_inode(struct btrfs_root *ro=
ot,
>  	int ret;
>  	u64 ino;
> =20
> -	ret =3D btrfs_find_free_objectid(root, &ino);
> +	ret =3D btrfs_find_free_objectid(fs_info->tree_root, &ino);
>  	if (ret < 0)
>  		return ret;
> =20
> -	return __create_free_space_inode(root, trans, path, ino,
> +	return __create_free_space_inode(fs_info->tree_root, trans, path, ino=
,
>  					 block_group->key.objectid);
>  }
> =20
> @@ -227,11 +226,11 @@ int btrfs_check_trunc_cache_free_space(struct btr=
fs_fs_info *fs_info,
>  	return ret;
>  }
> =20
> -int btrfs_truncate_free_space_cache(struct btrfs_root *root,
> -				    struct btrfs_trans_handle *trans,
> +int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
>  				    struct btrfs_block_group_cache *block_group,
>  				    struct inode *inode)
>  {
> +	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>  	int ret =3D 0;
>  	struct btrfs_path *path =3D btrfs_alloc_path();
>  	bool locked =3D false;
> @@ -828,7 +827,6 @@ int load_free_space_cache(struct btrfs_fs_info *fs_=
info,
>  			  struct btrfs_block_group_cache *block_group)
>  {
>  	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
> -	struct btrfs_root *root =3D fs_info->tree_root;
>  	struct inode *inode;
>  	struct btrfs_path *path;
>  	int ret =3D 0;
> @@ -852,7 +850,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_=
info,
>  	path->search_commit_root =3D 1;
>  	path->skip_locking =3D 1;
> =20
> -	inode =3D lookup_free_space_inode(root, block_group, path);
> +	inode =3D lookup_free_space_inode(fs_info, block_group, path);
>  	if (IS_ERR(inode)) {
>  		btrfs_free_path(path);
>  		return 0;
> @@ -1378,7 +1376,6 @@ int btrfs_write_out_cache(struct btrfs_fs_info *f=
s_info,
>  			  struct btrfs_block_group_cache *block_group,
>  			  struct btrfs_path *path)
>  {
> -	struct btrfs_root *root =3D fs_info->tree_root;
>  	struct btrfs_free_space_ctl *ctl =3D block_group->free_space_ctl;
>  	struct inode *inode;
>  	int ret =3D 0;
> @@ -1390,12 +1387,12 @@ int btrfs_write_out_cache(struct btrfs_fs_info =
*fs_info,
>  	}
>  	spin_unlock(&block_group->lock);
> =20
> -	inode =3D lookup_free_space_inode(root, block_group, path);
> +	inode =3D lookup_free_space_inode(fs_info, block_group, path);
>  	if (IS_ERR(inode))
>  		return 0;
> =20
> -	ret =3D __btrfs_write_out_cache(root, inode, ctl, block_group,
> -				      &block_group->io_ctl, trans,
> +	ret =3D __btrfs_write_out_cache(fs_info->tree_root, inode, ctl,
> +				      block_group, &block_group->io_ctl, trans,
>  				      path, block_group->key.objectid);
>  	if (ret) {
>  #ifdef DEBUG
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index 6f3c025..79eca4c 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -51,18 +51,17 @@ struct btrfs_free_space_op {
> =20
>  struct btrfs_io_ctl;
> =20
> -struct inode *lookup_free_space_inode(struct btrfs_root *root,
> +struct inode *lookup_free_space_inode(struct btrfs_fs_info *fs_info,
>  				      struct btrfs_block_group_cache
>  				      *block_group, struct btrfs_path *path);
> -int create_free_space_inode(struct btrfs_root *root,
> +int create_free_space_inode(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_trans_handle *trans,
>  			    struct btrfs_block_group_cache *block_group,
>  			    struct btrfs_path *path);
> =20
>  int btrfs_check_trunc_cache_free_space(struct btrfs_fs_info *fs_info,
>  				       struct btrfs_block_rsv *rsv);
> -int btrfs_truncate_free_space_cache(struct btrfs_root *root,
> -				    struct btrfs_trans_handle *trans,
> +int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
>  				    struct btrfs_block_group_cache *block_group,
>  				    struct inode *inode);
>  int load_free_space_cache(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index 144b119..3bbb8f0 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -467,7 +467,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
>  	}
> =20
>  	if (i_size_read(inode) > 0) {
> -		ret =3D btrfs_truncate_free_space_cache(root, trans, NULL, inode);
> +		ret =3D btrfs_truncate_free_space_cache(trans, NULL, inode);
>  		if (ret) {
>  			if (ret !=3D -ENOSPC)
>  				btrfs_abort_transaction(trans, ret);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 2e9deb9..bee4b5b 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3543,7 +3543,7 @@ static int delete_block_group_cache(struct btrfs_=
fs_info *fs_info,
>  		goto out;
>  	}
> =20
> -	ret =3D btrfs_truncate_free_space_cache(root, trans, block_group, ino=
de);
> +	ret =3D btrfs_truncate_free_space_cache(trans, block_group, inode);
> =20
>  	btrfs_end_transaction(trans);
>  	btrfs_btree_balance_dirty(fs_info);
> @@ -4347,8 +4347,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_in=
fo *fs_info, u64 group_start)
>  		goto out;
>  	}
> =20
> -	inode =3D lookup_free_space_inode(fs_info->tree_root, rc->block_group=
,
> -					path);
> +	inode =3D lookup_free_space_inode(fs_info, rc->block_group, path);
>  	btrfs_free_path(path);
> =20
>  	if (!IS_ERR(inode))
>=20


--=20
Jeff Mahoney
SUSE Labs


--NFS9D1NTl6f7n7Tba4k42NL4AjBgNx88t--

--FxIhC9aXVLPGTwL095cXnDeTQVG2ocmsW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWKTQ3B57S2MheeWyAQj7jA//R+Kiik349eybwMcSfTht7nE2PO7VzEyU
MD9b6n64HJGhU2SE8bHpAhzpsiQn4tof4nK9o9cnBCqvokca/gWvMoreRRY5XFfU
xM22/uKTpw8JK8CRv0BV10AO8LydkUE+z0On07Krxz5RxtR59kFTFTzGdf9pZ25S
MoaswdBERKPMhfkaMH2l6veTOLzX6IhQ/AXwmqv+Dfj3XjVXJNyrQl6E762+aTBe
+3HCiH1BMp/pQMmja/gE969d/ikymiC7ZiBEHqtt0SCo5ll2mQMu5FUUjTBBdmGj
dj0XUf+d9k/2njEN6fZDz0H+HqCEaft7tg35eKLFhuXjHfC1rvLVirHftoXKBg4w
tKb3izW2ocIWxwrYCnDggYPyjE8uAqV87G+GtdMe2+BeIBFLQEs0nYjkaNhp3nTn
PTinZfd46huHra//bClqgl1ntsA0QN4wx4iJARCK1rkL6JFmI2ASlwnIw+Ia4D3I
58QFt67qD8n4eKMxLqA8pvri5zBHmakHtzVs/bW3MFVlbIwbpPKNtj3YuFeSSFGu
BYzL05Xl0EXHs3T0sb4c/hO+Ni5QIHwVNRWJgHo9qfHhszNwDo/oRJWEXvexyjLb
ZodKmN1ckGIfQVxDnKEtzbhSghLEZektOhFaXCsBK9QCtCrox3Nhe8FSMcz2Hfua
i/psvvgSpVo=
=r6d3
-----END PGP SIGNATURE-----

--FxIhC9aXVLPGTwL095cXnDeTQVG2ocmsW--
