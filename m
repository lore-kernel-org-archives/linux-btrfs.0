Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3J2SPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 14:15:30 -0400
Message-ID: <526FFB38.4030008@suse.com>
Date: Tue, 29 Oct 2013 14:15:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: incompatible format change to remove hole extents
 V2
References: <1383054986-21707-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1383054986-21707-1-git-send-email-jbacik@fusionio.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HSWrwwLUDVnvK2Mxpg0r8FNrsC6E51t0M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HSWrwwLUDVnvK2Mxpg0r8FNrsC6E51t0M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/29/13, 9:56 AM, Josef Bacik wrote:
> Btrfs has always had these filler extent data items for holes in inodes=
=2E  This
> has made somethings very easy, like logging hole punches and sending ho=
le
> punches.  However for large holey files these extent data items are pur=
e
> overhead.  So add an incompatible feature to no longer add hole extents=
 to
> reduce the amount of metadata used by these sort of files.  This has a =
few
> changes for logging and send obviously since they will need to detect h=
oles and
> log/send the holes if there are any.  I've tested this thoroughly with =
xfstests
> and it doesn't cause any issues with and without the incompat format se=
t.
> Thanks,

This sounds like it could be a candidate for the online-enable mask in
my feature ioctl patchset.

-Jeff

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: my snapshot exerciser pointed out I don't understand how INLINE=
 extents
> work, fixed this.
>=20
>  fs/btrfs/ctree.h    |   4 +-
>  fs/btrfs/file.c     |  13 ++++--
>  fs/btrfs/inode.c    |  78 ++++++++++++++++++++-------------
>  fs/btrfs/send.c     | 122 ++++++++++++++++++++++++++++++++++++++++++++=
+-------
>  fs/btrfs/tree-log.c |  56 +++++++++++++++++++++---
>  5 files changed, 217 insertions(+), 56 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9f5e1cf..0a008d8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -521,6 +521,7 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
>  #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
>  #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
> +#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
> =20
>  #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
> @@ -532,7 +533,8 @@ struct btrfs_super_block {
>  	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
>  	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
>  	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
> -	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
> +	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
> +	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
> =20
>  /*
>   * A leaf is full of items. offset and size tell us where to find
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 728f56f..ec0a95a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1963,11 +1963,13 @@ static int fill_holes(struct btrfs_trans_handle=
 *trans, struct inode *inode,
>  	struct btrfs_key key;
>  	int ret;
> =20
> +	if (btrfs_fs_incompat(root->fs_info, NO_HOLES))
> +		goto out;
> +
>  	key.objectid =3D btrfs_ino(inode);
>  	key.type =3D BTRFS_EXTENT_DATA_KEY;
>  	key.offset =3D offset;
> =20
> -
>  	ret =3D btrfs_search_slot(trans, root, &key, path, 0, 1);
>  	if (ret < 0)
>  		return ret;
> @@ -2064,8 +2066,10 @@ static int btrfs_punch_hole(struct inode *inode,=
 loff_t offset, loff_t len)
>  	u64 drop_end;
>  	int ret =3D 0;
>  	int err =3D 0;
> +	int rsv_count;
>  	bool same_page =3D ((offset >> PAGE_CACHE_SHIFT) =3D=3D
>  			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
> +	bool no_holes =3D btrfs_fs_incompat(root->fs_info, NO_HOLES);
> =20
>  	btrfs_wait_ordered_range(inode, offset, len);
> =20
> @@ -2157,9 +2161,10 @@ static int btrfs_punch_hole(struct inode *inode,=
 loff_t offset, loff_t len)
>  	/*
>  	 * 1 - update the inode
>  	 * 1 - removing the extents in the range
> -	 * 1 - adding the hole extent
> +	 * 1 - adding the hole extent if no_holes isn't set
>  	 */
> -	trans =3D btrfs_start_transaction(root, 3);
> +	rsv_count =3D no_holes ? 2 : 3;
> +	trans =3D btrfs_start_transaction(root, rsv_count);
>  	if (IS_ERR(trans)) {
>  		err =3D PTR_ERR(trans);
>  		goto out_free;
> @@ -2196,7 +2201,7 @@ static int btrfs_punch_hole(struct inode *inode, =
loff_t offset, loff_t len)
>  		btrfs_end_transaction(trans, root);
>  		btrfs_btree_balance_dirty(root);
> =20
> -		trans =3D btrfs_start_transaction(root, 3);
> +		trans =3D btrfs_start_transaction(root, rsv_count);
>  		if (IS_ERR(trans)) {
>  			ret =3D PTR_ERR(trans);
>  			trans =3D NULL;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 30bdacd..38fa301 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4204,6 +4204,49 @@ out:
>  	return ret;
>  }
> =20
> +static int maybe_insert_hole(struct btrfs_root *root, struct inode *in=
ode,
> +			     u64 offset, u64 len)
> +{
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	/*
> +	 * Still need to make sure the inode looks like it's been updated so
> +	 * that any holes get logged if we fsync.
> +	 */
> +	if (btrfs_fs_incompat(root->fs_info, NO_HOLES)) {
> +		BTRFS_I(inode)->last_trans =3D root->fs_info->generation;
> +		BTRFS_I(inode)->last_sub_trans =3D root->log_transid;
> +		BTRFS_I(inode)->last_log_commit =3D root->last_log_commit;
> +		return 0;
> +	}
> +
> +	/*
> +	 * 1 - for the one we're dropping
> +	 * 1 - for the one we're adding
> +	 * 1 - for updating the inode.
> +	 */
> +	trans =3D btrfs_start_transaction(root, 3);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	ret =3D btrfs_drop_extents(trans, root, inode, offset, offset + len, =
1);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, root, ret);
> +		btrfs_end_transaction(trans, root);
> +		return ret;
> +	}
> +
> +	ret =3D btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offse=
t,
> +				       0, 0, len, 0, len, 0, 0, 0);
> +	if (ret)
> +		btrfs_abort_transaction(trans, root, ret);
> +	else
> +		btrfs_update_inode(trans, root, inode);
> +	btrfs_end_transaction(trans, root);
> +	return ret;
> +}
> +
>  /*
>   * This function puts in dummy file extents for the area we're creatin=
g a hole
>   * for.  So if we are truncating this file to a larger size we need to=
 insert
> @@ -4212,7 +4255,6 @@ out:
>   */
>  int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size=
)
>  {
> -	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>  	struct extent_io_tree *io_tree =3D &BTRFS_I(inode)->io_tree;
>  	struct extent_map *em =3D NULL;
> @@ -4267,31 +4309,10 @@ int btrfs_cont_expand(struct inode *inode, loff=
_t oldsize, loff_t size)
>  			struct extent_map *hole_em;
>  			hole_size =3D last_byte - cur_offset;
> =20
> -			trans =3D btrfs_start_transaction(root, 3);
> -			if (IS_ERR(trans)) {
> -				err =3D PTR_ERR(trans);
> -				break;
> -			}
> -
> -			err =3D btrfs_drop_extents(trans, root, inode,
> -						 cur_offset,
> -						 cur_offset + hole_size, 1);
> -			if (err) {
> -				btrfs_abort_transaction(trans, root, err);
> -				btrfs_end_transaction(trans, root);
> -				break;
> -			}
> -
> -			err =3D btrfs_insert_file_extent(trans, root,
> -					btrfs_ino(inode), cur_offset, 0,
> -					0, hole_size, 0, hole_size,
> -					0, 0, 0);
> -			if (err) {
> -				btrfs_abort_transaction(trans, root, err);
> -				btrfs_end_transaction(trans, root);
> +			err =3D maybe_insert_hole(root, inode, cur_offset,
> +						hole_size);
> +			if (err)
>  				break;
> -			}
> -
>  			btrfs_drop_extent_cache(inode, cur_offset,
>  						cur_offset + hole_size - 1, 0);
>  			hole_em =3D alloc_extent_map();
> @@ -4310,7 +4331,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t=
 oldsize, loff_t size)
>  			hole_em->ram_bytes =3D hole_size;
>  			hole_em->bdev =3D root->fs_info->fs_devices->latest_bdev;
>  			hole_em->compress_type =3D BTRFS_COMPRESS_NONE;
> -			hole_em->generation =3D trans->transid;
> +			hole_em->generation =3D root->fs_info->generation;
> =20
>  			while (1) {
>  				write_lock(&em_tree->lock);
> @@ -4323,17 +4344,14 @@ int btrfs_cont_expand(struct inode *inode, loff=
_t oldsize, loff_t size)
>  							hole_size - 1, 0);
>  			}
>  			free_extent_map(hole_em);
> -next:
> -			btrfs_update_inode(trans, root, inode);
> -			btrfs_end_transaction(trans, root);
>  		}
> +next:
>  		free_extent_map(em);
>  		em =3D NULL;
>  		cur_offset =3D last_byte;
>  		if (cur_offset >=3D block_end)
>  			break;
>  	}
> -
>  	free_extent_map(em);
>  	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_stat=
e,
>  			     GFP_NOFS);
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5a3874c..2a2677b 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -111,6 +111,7 @@ struct send_ctx {
>  	int cur_inode_deleted;
>  	u64 cur_inode_size;
>  	u64 cur_inode_mode;
> +	u64 cur_inode_last_extent;
> =20
>  	u64 send_progress;
> =20
> @@ -146,6 +147,13 @@ struct name_cache_entry {
>  	char name[];
>  };
> =20
> +static int need_send_hole(struct send_ctx *sctx)
> +{
> +	return (sctx->parent_root && !sctx->cur_inode_new &&
> +		!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted &&
> +		S_ISREG(sctx->cur_inode_mode));
> +}
> +
>  static void fs_path_reset(struct fs_path *p)
>  {
>  	if (p->reversed) {
> @@ -3776,6 +3784,43 @@ out:
>  	return ret;
>  }
> =20
> +static int send_hole(struct send_ctx *sctx, u64 end)
> +{
> +	struct fs_path *p =3D NULL;
> +	u64 offset =3D sctx->cur_inode_last_extent;
> +	u64 len;
> +	int ret;
> +
> +	p =3D fs_path_alloc();
> +	if (!p)
> +		return -ENOMEM;
> +	ret =3D open_cur_inode_file(sctx);
> +	if (ret < 0)
> +		goto out;
> +	memset(sctx->read_buf, 0, BTRFS_SEND_READ_SIZE);
> +	while (offset < end) {
> +		len =3D min_t(u64, end - offset, BTRFS_SEND_READ_SIZE);
> +
> +		ret =3D begin_cmd(sctx, BTRFS_SEND_C_WRITE);
> +		if (ret < 0)
> +			break;
> +		ret =3D get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +		if (ret < 0)
> +			break;
> +		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> +		TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> +		TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, len);
> +		ret =3D send_cmd(sctx);
> +		if (ret < 0)
> +			break;
> +		offset +=3D len;
> +	}
> +tlv_put_failure:
> +out:
> +	fs_path_free(p);
> +	return ret;
> +}
> +
>  static int send_write_or_clone(struct send_ctx *sctx,
>  			       struct btrfs_path *path,
>  			       struct btrfs_key *key,
> @@ -4008,26 +4053,32 @@ static int process_extent(struct send_ctx *sctx=
,
>  			  struct btrfs_key *key)
>  {
>  	struct clone_root *found_clone =3D NULL;
> +	struct btrfs_file_extent_item *ei;
> +	u64 len;
> +	u8 type;
>  	int ret =3D 0;
> =20
>  	if (S_ISLNK(sctx->cur_inode_mode))
>  		return 0;
> =20
> +	ei =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			    struct btrfs_file_extent_item);
> +	type =3D btrfs_file_extent_type(path->nodes[0], ei);
> +	if (type =3D=3D BTRFS_FILE_EXTENT_INLINE)
> +		len =3D ALIGN(btrfs_file_extent_inline_len(path->nodes[0], ei),
> +			    sctx->send_root->sectorsize);
> +	else
> +		len =3D btrfs_file_extent_num_bytes(path->nodes[0], ei);
> +
>  	if (sctx->parent_root && !sctx->cur_inode_new) {
>  		ret =3D is_extent_unchanged(sctx, path, key);
>  		if (ret < 0)
>  			goto out;
>  		if (ret) {
>  			ret =3D 0;
> -			goto out;
> +			goto out_hole;
>  		}
>  	} else {
> -		struct btrfs_file_extent_item *ei;
> -		u8 type;
> -
> -		ei =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> -				    struct btrfs_file_extent_item);
> -		type =3D btrfs_file_extent_type(path->nodes[0], ei);
>  		if (type =3D=3D BTRFS_FILE_EXTENT_PREALLOC ||
>  		    type =3D=3D BTRFS_FILE_EXTENT_REG) {
>  			/*
> @@ -4055,7 +4106,12 @@ static int process_extent(struct send_ctx *sctx,=

>  		goto out;
> =20
>  	ret =3D send_write_or_clone(sctx, path, key, found_clone);
> -
> +	if (ret)
> +		goto out;
> +out_hole:
> +	if (need_send_hole(sctx) && sctx->cur_inode_last_extent !=3D key->off=
set)
> +		ret =3D send_hole(sctx, key->offset);
> +	sctx->cur_inode_last_extent =3D key->offset + len;
>  out:
>  	return ret;
>  }
> @@ -4181,6 +4237,12 @@ static int finish_inode_if_needed(struct send_ct=
x *sctx, int at_end)
>  	}
> =20
>  	if (S_ISREG(sctx->cur_inode_mode)) {
> +		if (need_send_hole(sctx) &&
> +		    sctx->cur_inode_last_extent < sctx->cur_inode_size) {
> +			ret =3D send_hole(sctx, sctx->cur_inode_size);
> +			if (ret)
> +				goto out;
> +		}
>  		ret =3D send_truncate(sctx, sctx->cur_ino, sctx->cur_inode_gen,
>  				sctx->cur_inode_size);
>  		if (ret < 0)
> @@ -4228,6 +4290,7 @@ static int changed_inode(struct send_ctx *sctx,
> =20
>  	sctx->cur_ino =3D key->objectid;
>  	sctx->cur_inode_new_gen =3D 0;
> +	sctx->cur_inode_last_extent =3D 0;
> =20
>  	/*
>  	 * Set send_progress to current inode. This will tell all get_cur_xxx=

> @@ -4492,6 +4555,31 @@ out:
>  	return ret;
>  }
> =20
> +static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *p=
ath,
> +			   struct btrfs_key *key)
> +{
> +	struct btrfs_file_extent_item *fi;
> +	u64 len;
> +	u8 type;
> +	int ret =3D 0;
> +
> +	if (sctx->cur_ino !=3D key->objectid || !need_send_hole(sctx))
> +		return 0;
> +
> +	fi =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			    struct btrfs_file_extent_item);
> +	type =3D btrfs_file_extent_type(path->nodes[0], fi);
> +	if (type =3D=3D BTRFS_FILE_EXTENT_INLINE)
> +		len =3D ALIGN(btrfs_file_extent_inline_len(path->nodes[0], fi),
> +			    sctx->send_root->sectorsize);
> +	else
> +		len =3D btrfs_file_extent_num_bytes(path->nodes[0], fi);
> +	if (sctx->cur_inode_last_extent !=3D key->offset)
> +		ret =3D send_hole(sctx, key->offset);
> +	sctx->cur_inode_last_extent =3D key->offset + len;
> +	return ret;
> +}
> +
>  /*
>   * Updates compare related fields in sctx and simply forwards to the a=
ctual
>   * changed_xxx functions.
> @@ -4508,14 +4596,18 @@ static int changed_cb(struct btrfs_root *left_r=
oot,
>  	struct send_ctx *sctx =3D ctx;
> =20
>  	if (result =3D=3D BTRFS_COMPARE_TREE_SAME) {
> -		if (key->type !=3D BTRFS_INODE_REF_KEY &&
> -		    key->type !=3D BTRFS_INODE_EXTREF_KEY)
> -			return 0;
> -		ret =3D compare_refs(sctx, left_path, key);
> -		if (!ret)
> +		if (key->type =3D=3D BTRFS_INODE_REF_KEY ||
> +		    key->type =3D=3D BTRFS_INODE_EXTREF_KEY) {
> +			ret =3D compare_refs(sctx, left_path, key);
> +			if (!ret)
> +				return 0;
> +			if (ret < 0)
> +				return ret;
> +		} else if (key->type =3D=3D BTRFS_EXTENT_DATA_KEY) {
> +			return maybe_send_hole(sctx, left_path, key);
> +		} else {
>  			return 0;
> -		if (ret < 0)
> -			return ret;
> +		}
>  		result =3D BTRFS_COMPARE_TREE_CHANGED;
>  		ret =3D 0;
>  	}
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1134aa4..3c8564a 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3188,7 +3188,7 @@ static int log_inode_item(struct btrfs_trans_hand=
le *trans,
>  static noinline int copy_items(struct btrfs_trans_handle *trans,
>  			       struct inode *inode,
>  			       struct btrfs_path *dst_path,
> -			       struct extent_buffer *src,
> +			       struct extent_buffer *src, u64 *last_extent,
>  			       int start_slot, int nr, int inode_only)
>  {
>  	unsigned long src_offset;
> @@ -3203,6 +3203,7 @@ static noinline int copy_items(struct btrfs_trans=
_handle *trans,
>  	int i;
>  	struct list_head ordered_sums;
>  	int skip_csum =3D BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
> +	bool has_extents =3D false;
> =20
>  	INIT_LIST_HEAD(&ordered_sums);
> =20
> @@ -3242,6 +3243,8 @@ static noinline int copy_items(struct btrfs_trans=
_handle *trans,
>  					   src_offset, ins_sizes[i]);
>  		}
> =20
> +		if (ins_keys[i].type =3D=3D BTRFS_EXTENT_DATA_KEY)
> +			has_extents =3D true;
>  		/* take a reference on file data extents so that truncates
>  		 * or deletes of this inode don't have to relog the inode
>  		 * again
> @@ -3306,6 +3309,46 @@ static noinline int copy_items(struct btrfs_tran=
s_handle *trans,
>  		list_del(&sums->list);
>  		kfree(sums);
>  	}
> +
> +	if (!has_extents)
> +		return ret;
> +
> +	/*
> +	 * Ok so here we need to go through and fill in any holes we may have=

> +	 * to make sure that holes are punched for those areas in case they h=
ad
> +	 * extents previously.
> +	 */
> +	for (i =3D start_slot; i < start_slot + nr; i++) {
> +		struct btrfs_key key;
> +		u64 offset, len;
> +		u64 extent_end;
> +
> +		btrfs_item_key_to_cpu(src, &key, i);
> +		if (key.type !=3D BTRFS_EXTENT_DATA_KEY)
> +			continue;
> +		extent =3D btrfs_item_ptr(src, i, struct btrfs_file_extent_item);
> +		if (btrfs_file_extent_type(src, extent) =3D=3D
> +		    BTRFS_FILE_EXTENT_INLINE) {
> +			len =3D btrfs_file_extent_inline_len(src, extent);
> +			extent_end =3D ALIGN(key.offset + len, log->sectorsize);
> +		} else {
> +			len =3D btrfs_file_extent_num_bytes(src, extent);
> +			extent_end =3D key.offset + len;
> +		}
> +
> +		if (*last_extent =3D=3D key.offset) {
> +			*last_extent =3D extent_end;
> +			continue;
> +		}
> +		offset =3D *last_extent;
> +		len =3D key.offset - *last_extent;
> +		ret =3D btrfs_insert_file_extent(trans, log, btrfs_ino(inode),
> +					       offset, 0, 0, len, 0, len, 0,
> +					       0, 0);
> +		if (ret)
> +			break;
> +		*last_extent =3D extent_end;
> +	}
>  	return ret;
>  }
> =20
> @@ -3624,6 +3667,7 @@ static int btrfs_log_inode(struct btrfs_trans_han=
dle *trans,
>  	struct btrfs_key max_key;
>  	struct btrfs_root *log =3D root->log_root;
>  	struct extent_buffer *src =3D NULL;
> +	u64 last_extent =3D 0;
>  	int err =3D 0;
>  	int ret;
>  	int nritems;
> @@ -3738,8 +3782,8 @@ again:
>  			goto next_slot;
>  		}
> =20
> -		ret =3D copy_items(trans, inode, dst_path, src, ins_start_slot,
> -				 ins_nr, inode_only);
> +		ret =3D copy_items(trans, inode, dst_path, src, &last_extent,
> +				 ins_start_slot, ins_nr, inode_only);
>  		if (ret) {
>  			err =3D ret;
>  			goto out_unlock;
> @@ -3757,7 +3801,7 @@ next_slot:
>  		}
>  		if (ins_nr) {
>  			ret =3D copy_items(trans, inode, dst_path, src,
> -					 ins_start_slot,
> +					 &last_extent, ins_start_slot,
>  					 ins_nr, inode_only);
>  			if (ret) {
>  				err =3D ret;
> @@ -3777,8 +3821,8 @@ next_slot:
>  		}
>  	}
>  	if (ins_nr) {
> -		ret =3D copy_items(trans, inode, dst_path, src, ins_start_slot,
> -				 ins_nr, inode_only);
> +		ret =3D copy_items(trans, inode, dst_path, src, &last_extent,
> +				 ins_start_slot, ins_nr, inode_only);
>  		if (ret) {
>  			err =3D ret;
>  			goto out_unlock;
>=20


--=20
Jeff Mahoney
SUSE Labs


--HSWrwwLUDVnvK2Mxpg0r8FNrsC6E51t0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSb/s8AAoJEB57S2MheeWyH/gP+wZEmiNijTT6NHkLJQL+XBv/
HGUpEoVStgoi427mDzgOmTqSaxQCGvvVwq4UsLz8sc89kLsDycm+S/AI6xnaXuNg
mtmQhvjhgNVdYxuZ9XsjQGS+9hiC80J2rszXFSlLyl7z/4NFYKWofPKZum5pBBcL
Fl/ZWxrKG48FeWbrGeoEeWOsynLVzJpPyMGKFFQ+mptxK+QVXkPDt7xZ9chsiYBY
5zUinsrxjpDjFmabS9vFE5Dz4gGdzh+Cn6InYPIqp2UZIaAsjj906CLi9hNK/t3l
v/r/j5W1QyDKdnpGyFeTtB9DZ4gi+ALsNW/OJ8fmoel32ZSeGwN0TMei90AgBQBE
ELkC1RwWMqAV4/J3UGisxEjNLTTb2rP2K6q6DdfcmOA9BBKs3zTj+qGaekmDOcIe
QxXkNNKMSEaqNM+vrx5cV9tskcZsqJWwjFDg7DKrD+Juq3CfpuUdbZI4xgRZCc9J
Qea79J7r1nz3r9ZTV8AQDtb/FHIHg1SuUP0UCQSwnSu8xc027Kl/DupocQPX1xvt
ifAkt+JDfloUzt6qo5pnjI8TCAiTbSgh6L8r1R4y0w0c+cYVY7bDPXiZ5k6jABpQ
hDalb9pPJP/7PRyWQOW46ERnIkhP6d18nqXBOmx1MhWT8VV/QQdiIfVz6n+mydWm
1UrNZC8NcMNXKdJCRdAY
=RqVH
-----END PGP SIGNATURE-----

--HSWrwwLUDVnvK2Mxpg0r8FNrsC6E51t0M--
