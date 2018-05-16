Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33871 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbeEPS7n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 14:59:43 -0400
Received: by mail-pg0-f68.google.com with SMTP id k2-v6so699864pgc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 11:59:42 -0700 (PDT)
Date: Wed, 16 May 2018 11:59:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Howard McLauchlan <linux@hmclauchlan.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: Re: [RFC PATCH 6/6] btrfs: add chattr support for send/receive
Message-ID: <20180516185940.GC29231@vader>
References: <20180509020651.7946-1-linux@hmclauchlan.com>
 <20180509020651.7946-7-linux@hmclauchlan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180509020651.7946-7-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 10:06:51PM -0400, Howard McLauchlan wrote:
> From: Howard McLauchlan <hmclauchlan@fb.com>
> 
> Presently btrfs send/receive does not propagate inode attribute flags;
> all chattr operations are effectively discarded upon transmission.
> 
> This patch adds kernel support for inode attribute flags. Userspace
> support can be found under the commit:
> 
>     btrfs-progs: add chattr support for send/receive
> 
> An associated xfstest can be found at:
> 
>     btrfs: add verify chattr support for send/receive test
> 
> These changes are only enabled for send stream version 2
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> ---
>  fs/btrfs/ctree.h |   2 +
>  fs/btrfs/ioctl.c |   2 +-
>  fs/btrfs/send.c  | 181 ++++++++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/send.h  |   4 +-
>  4 files changed, 159 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2771cc56a622..0a2359144b18 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1461,6 +1461,8 @@ struct btrfs_map_token {
>  	unsigned long offset;
>  };
>  
> +unsigned int btrfs_flags_to_ioctl(unsigned int flags);
> +
>  #define BTRFS_BYTES_TO_BLKS(fs_info, bytes) \
>  				((bytes) >> (fs_info)->sb->s_blocksize_bits)
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 632e26d6f7ce..36ce1e589f9e 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -106,7 +106,7 @@ static unsigned int btrfs_mask_flags(umode_t mode, unsigned int flags)
>  /*
>   * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
>   */
> -static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
> +unsigned int btrfs_flags_to_ioctl(unsigned int flags)
>  {
>  	unsigned int iflags = 0;
>  
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c8ea1ccaa3d8..fa7db1474a7f 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -108,6 +108,13 @@ struct send_ctx {
>  	u64 cur_inode_last_extent;
>  	u64 cur_inode_next_write_offset;
>  
> +	/*
> +	 * state for chattr purposes
> +	 */
> +	u64 cur_inode_flip_flags;
> +	u64 cur_inode_receive_flags;
> +	int receive_flags_valid;

I'd use bool here (and change the places that set it to use true or
false).

> +
>  	u64 send_progress;
>  	u64 total_data_size;
>  
> @@ -815,7 +822,7 @@ static int send_rmdir(struct send_ctx *sctx, struct fs_path *path)
>   */
>  static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>  			  u64 ino, u64 *size, u64 *gen, u64 *mode, u64 *uid,
> -			  u64 *gid, u64 *rdev)
> +			  u64 *gid, u64 *rdev, u64 *flags)
>  {
>  	int ret;
>  	struct btrfs_inode_item *ii;
> @@ -845,6 +852,8 @@ static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>  		*gid = btrfs_inode_gid(path->nodes[0], ii);
>  	if (rdev)
>  		*rdev = btrfs_inode_rdev(path->nodes[0], ii);
> +	if (flags)
> +		*flags = btrfs_inode_flags(path->nodes[0], ii);
>  
>  	return ret;
>  }
> @@ -852,7 +861,7 @@ static int __get_inode_info(struct btrfs_root *root, struct btrfs_path *path,
>  static int get_inode_info(struct btrfs_root *root,
>  			  u64 ino, u64 *size, u64 *gen,
>  			  u64 *mode, u64 *uid, u64 *gid,
> -			  u64 *rdev)
> +			  u64 *rdev, u64 *flags)
>  {
>  	struct btrfs_path *path;
>  	int ret;
> @@ -861,7 +870,7 @@ static int get_inode_info(struct btrfs_root *root,
>  	if (!path)
>  		return -ENOMEM;
>  	ret = __get_inode_info(root, path, ino, size, gen, mode, uid, gid,
> -			       rdev);
> +			       rdev, flags);
>  	btrfs_free_path(path);
>  	return ret;
>  }
> @@ -1250,7 +1259,7 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
>  	 * accept clones from these extents.
>  	 */
>  	ret = __get_inode_info(found->root, bctx->path, ino, &i_size, NULL, NULL,
> -			       NULL, NULL, NULL);
> +			       NULL, NULL, NULL, NULL);
>  	btrfs_release_path(bctx->path);
>  	if (ret < 0)
>  		return ret;
> @@ -1610,7 +1619,7 @@ static int get_cur_inode_state(struct send_ctx *sctx, u64 ino, u64 gen)
>  	u64 right_gen;
>  
>  	ret = get_inode_info(sctx->send_root, ino, NULL, &left_gen, NULL, NULL,
> -			NULL, NULL);
> +			NULL, NULL, NULL);
>  	if (ret < 0 && ret != -ENOENT)
>  		goto out;
>  	left_ret = ret;
> @@ -1619,7 +1628,7 @@ static int get_cur_inode_state(struct send_ctx *sctx, u64 ino, u64 gen)
>  		right_ret = -ENOENT;
>  	} else {
>  		ret = get_inode_info(sctx->parent_root, ino, NULL, &right_gen,
> -				NULL, NULL, NULL, NULL);
> +				NULL, NULL, NULL, NULL, NULL);
>  		if (ret < 0 && ret != -ENOENT)
>  			goto out;
>  		right_ret = ret;
> @@ -1788,7 +1797,7 @@ static int get_first_ref(struct btrfs_root *root, u64 ino,
>  
>  	if (dir_gen) {
>  		ret = get_inode_info(root, parent_dir, NULL, dir_gen, NULL,
> -				     NULL, NULL, NULL);
> +				     NULL, NULL, NULL, NULL);
>  		if (ret < 0)
>  			goto out;
>  	}
> @@ -1861,7 +1870,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>  	 */
>  	if (sctx->parent_root && dir != BTRFS_FIRST_FREE_OBJECTID) {
>  		ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
> -				     NULL, NULL, NULL);
> +				     NULL, NULL, NULL, NULL);
>  		if (ret < 0 && ret != -ENOENT)
>  			goto out;
>  		if (ret) {
> @@ -1889,7 +1898,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>  	if (other_inode > sctx->send_progress ||
>  	    is_waiting_for_move(sctx, other_inode)) {
>  		ret = get_inode_info(sctx->parent_root, other_inode, NULL,
> -				who_gen, who_mode, NULL, NULL, NULL);
> +				who_gen, who_mode, NULL, NULL, NULL, NULL);
>  		if (ret < 0)
>  			goto out;
>  
> @@ -1929,7 +1938,7 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>  
>  	if (dir != BTRFS_FIRST_FREE_OBJECTID) {
>  		ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
> -				     NULL, NULL, NULL);
> +				     NULL, NULL, NULL, NULL);
>  		if (ret < 0 && ret != -ENOENT)
>  			goto out;
>  		if (ret) {
> @@ -1952,7 +1961,7 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>  	}
>  
>  	ret = get_inode_info(sctx->send_root, ow_inode, NULL, &gen, NULL, NULL,
> -			NULL, NULL);
> +			NULL, NULL, NULL);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -2525,6 +2534,42 @@ static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
>  	return ret;
>  }
>  
> +static int send_chattr(struct send_ctx *sctx, u64 ino, u64 gen, u64 flags)
> +{
> +	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
> +	int ret = 0;
> +	int __flags;
> +	struct fs_path *p;
> +
> +	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
> +		return 0;

The other send_foo() commands have
ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) instead, why is this
one different? You'll want to enable CONFIG_BTRFS_ASSERT when you test,
otherwise ASSERT() is a noop.

> +	__flags = btrfs_flags_to_ioctl(flags);
> +
> +	btrfs_debug(fs_info, "send_chattr %llu flags=%llu", ino, flags);
> +
> +	p = fs_path_alloc();
> +	if (!p)
> +		return -ENOMEM;
> +
> +	ret = begin_cmd(sctx, BTRFS_SEND_C_CHATTR);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = get_cur_path(sctx, ino, gen, p);
> +	if (ret < 0)
> +		goto out;
> +	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> +	TLV_PUT_U64(sctx, BTRFS_SEND_A_CHATTR, __flags);
> +
> +	ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +	fs_path_free(p);
> +	return ret;
> +}
> +
>  static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
>  {
>  	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
> @@ -2610,7 +2655,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
>  
>  	if (ino != sctx->cur_ino) {
>  		ret = get_inode_info(sctx->send_root, ino, NULL, &gen, &mode,
> -				     NULL, NULL, &rdev);
> +				     NULL, NULL, &rdev, NULL);
>  		if (ret < 0)
>  			goto out;
>  	} else {
> @@ -3332,7 +3377,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>  		 * The parent inode might have been deleted in the send snapshot
>  		 */
>  		ret = get_inode_info(sctx->send_root, cur->dir, NULL,
> -				     NULL, NULL, NULL, NULL, NULL);
> +				     NULL, NULL, NULL, NULL, NULL, NULL);
>  		if (ret == -ENOENT) {
>  			ret = 0;
>  			continue;
> @@ -3502,11 +3547,11 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>  	}
>  
>  	ret = get_inode_info(sctx->parent_root, di_key.objectid, NULL,
> -			     &left_gen, NULL, NULL, NULL, NULL);
> +			     &left_gen, NULL, NULL, NULL, NULL, NULL);
>  	if (ret < 0)
>  		goto out;
>  	ret = get_inode_info(sctx->send_root, di_key.objectid, NULL,
> -			     &right_gen, NULL, NULL, NULL, NULL);
> +			     &right_gen, NULL, NULL, NULL, NULL, NULL);
>  	if (ret < 0) {
>  		if (ret == -ENOENT)
>  			ret = 0;
> @@ -3650,7 +3695,7 @@ static int is_ancestor(struct btrfs_root *root,
>  			}
>  
>  			ret = get_inode_info(root, parent, NULL, &parent_gen,
> -					     NULL, NULL, NULL, NULL);
> +					     NULL, NULL, NULL, NULL, NULL);
>  			if (ret < 0)
>  				goto out;
>  			ret = check_ino_in_path(root, ino1, ino1_gen,
> @@ -3740,7 +3785,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
>  
>  			ret = get_inode_info(sctx->parent_root, ino, NULL,
>  					     &parent_ino_gen, NULL, NULL, NULL,
> -					     NULL);
> +					     NULL, NULL);
>  			if (ret < 0)
>  				goto out;
>  			if (ino_gen == parent_ino_gen) {
> @@ -4220,7 +4265,7 @@ static int record_ref(struct btrfs_root *root, u64 dir, struct fs_path *name,
>  		return -ENOMEM;
>  
>  	ret = get_inode_info(root, dir, NULL, &gen, NULL, NULL,
> -			NULL, NULL);
> +			NULL, NULL, NULL);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -4308,7 +4353,7 @@ static int __find_iref(int num, u64 dir, int index,
>  		 * else matches.
>  		 */
>  		ret = get_inode_info(ctx->root, dir, NULL, &dir_gen, NULL,
> -				     NULL, NULL, NULL);
> +				     NULL, NULL, NULL, NULL);
>  		if (ret)
>  			return ret;
>  		if (dir_gen != ctx->dir_gen)
> @@ -4352,7 +4397,7 @@ static int __record_changed_new_ref(int num, u64 dir, int index,
>  	struct send_ctx *sctx = ctx;
>  
>  	ret = get_inode_info(sctx->send_root, dir, NULL, &dir_gen, NULL,
> -			     NULL, NULL, NULL);
> +			     NULL, NULL, NULL, NULL);
>  	if (ret)
>  		return ret;
>  
> @@ -4375,7 +4420,7 @@ static int __record_changed_deleted_ref(int num, u64 dir, int index,
>  	struct send_ctx *sctx = ctx;
>  
>  	ret = get_inode_info(sctx->parent_root, dir, NULL, &dir_gen, NULL,
> -			     NULL, NULL, NULL);
> +			     NULL, NULL, NULL, NULL);
>  	if (ret)
>  		return ret;
>  
> @@ -4975,7 +5020,7 @@ static int send_clone(struct send_ctx *sctx,
>  
>  	if (clone_root->root == sctx->send_root) {
>  		ret = get_inode_info(sctx->send_root, clone_root->ino, NULL,
> -				&gen, NULL, NULL, NULL, NULL);
> +				&gen, NULL, NULL, NULL, NULL, NULL);
>  		if (ret < 0)
>  			goto out;
>  		ret = get_cur_path(sctx, clone_root->ino, gen, p);
> @@ -5934,9 +5979,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  	u64 right_mode;
>  	u64 right_uid;
>  	u64 right_gid;
> +	u64 left_flags;
>  	int need_chmod = 0;
>  	int need_chown = 0;
>  	int need_truncate = 1;
> +	int need_chattr = 0;

Sigh, I was going to say to use bool here, but the other ones are int,
so it's better to be consistent.

>  	int pending_move = 0;
>  	int refs_processed = 0;
>  
> @@ -5944,7 +5991,6 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  					      &refs_processed);
>  	if (ret < 0)
>  		goto out;
> -
>  	/*
>  	 * We have processed the refs and thus need to advance send_progress.
>  	 * Now, calls to get_cur_xxx will take the updated refs of the current
> @@ -5962,6 +6008,64 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  
>  	if (sctx->cur_ino == 0 || sctx->cur_inode_deleted)
>  		goto out;
> +
> +	/*
> +	 * If possible, we want to know what flags are set for this inode on the
> +	 * receiving end.
> +	 */
> +	if (sctx->parent_root && !sctx->receive_flags_valid && sctx->flags &
> +	    BTRFS_SEND_FLAG_STREAM_V2) {

Wrap this after the && instead of breaking up the operands to &. I also
had to look up the operator precedence of && vs & here, which probably
means this should just have parentheses :) So like so:

	if (sctx->parent_root && !sctx->receive_flags_valid &&
	    (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)) {

> +		ret = get_inode_info(sctx->parent_root, sctx->cur_ino, NULL,
> +				     NULL, NULL, NULL, NULL, NULL,
> +				     &sctx->cur_inode_receive_flags);
> +		if (ret < 0)
> +			goto out;
> +		sctx->receive_flags_valid = 1;
> +	}
> +
> +	/*
> +	 * The change is going to modify data and the inode already exists
> +	 * !at_end prevents unnecessary chattr.
> +	 */
> +	if (!at_end && sctx->parent_root && !sctx->cur_inode_new &&
> +	    (sctx->cmp_key->type == BTRFS_EXTENT_DATA_KEY ||
> +	    sctx->cmp_key->type == BTRFS_XATTR_ITEM_KEY) &&
> +	    sctx->flags & BTRFS_SEND_FLAG_STREAM_V2) {

Same comment about parentheses around sctx->flags & BTRFS_SEND_FLAG_STREAM_V2.

> +
> +		ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
> +				NULL, NULL, NULL, NULL, &left_flags);
> +		if (ret < 0)
> +			goto out;
> +		/*
> +		 * We check against the receive flags first; then check against
> +		 * the left flags to see if we can save a chattr later on
> +		 */
> +		if (sctx->cur_inode_receive_flags & BTRFS_INODE_IMMUTABLE) {
> +			sctx->cur_inode_flip_flags |= (left_flags &
> +						       BTRFS_INODE_IMMUTABLE);
> +			left_flags &= ~BTRFS_INODE_IMMUTABLE;
> +			need_chattr = 1;
> +		}
> +		if (sctx->cur_inode_receive_flags & BTRFS_INODE_APPEND) {
> +			sctx->cur_inode_flip_flags |= (left_flags &
> +						       BTRFS_INODE_APPEND);
> +			left_flags &= ~BTRFS_INODE_APPEND;
> +			need_chattr = 1;
> +		}
> +		if (need_chattr) {
> +			need_chattr = 0;
> +			ret = send_chattr(sctx, sctx->cur_ino,
> +					  sctx->cur_inode_gen, left_flags);
> +			if (ret < 0)
> +				goto out;
> +			/*
> +			 * left_flags is now an accurate rep of what the
> +			 * receiving inode's flags are
> +			 */
> +			sctx->cur_inode_receive_flags = left_flags;
> +		}
> +	}
> +
>  	if (!at_end && sctx->cmp_key->objectid == sctx->cur_ino)
>  		goto out;
>  
> @@ -5969,7 +6073,7 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  		goto truncate_inode;
>  
>  	ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
> -			&left_mode, &left_uid, &left_gid, NULL);
> +			&left_mode, &left_uid, &left_gid, NULL, &left_flags);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -5979,12 +6083,14 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  			need_chmod = 1;
>  		if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
>  			need_truncate = 0;
> +		if (left_flags)
> +			need_chattr = 1;

Why is need_chattr necessary? Will this not be covered by the
sctx->cur_inode_receive_flags != left_flags check?

>  	} else {
>  		u64 old_size;
>  
>  		ret = get_inode_info(sctx->parent_root, sctx->cur_ino,
>  				&old_size, NULL, &right_mode, &right_uid,
> -				&right_gid, NULL);
> +				&right_gid, NULL, NULL);
>  		if (ret < 0)
>  			goto out;
>  
> @@ -6060,6 +6166,27 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>  			goto out;
>  	}
>  
> +	/*
> +	 * At this point, if we toggled stuff earlier, untoggle it
> +	 * force a chattr and fix the flags
> +	 */
> +	if (sctx->cur_inode_flip_flags)
> +		left_flags |= sctx->cur_inode_flip_flags;
> +
> +	/*
> +	 * We either need a chattr because this inode is new, or we need to make
> +	 * a change due to a discrepancy between left_flags and receive_flags
> +	 */
> +	if ((need_chattr || (sctx->cur_inode_receive_flags != left_flags)) &&
> +	    sctx->flags & BTRFS_SEND_FLAG_STREAM_V2) {

Same parentheses thing.

> +		ret = send_chattr(sctx, sctx->cur_ino, sctx->cur_inode_gen,
> +				  left_flags);
> +		if (ret < 0)
> +			goto out;
> +	}
> +	sctx->cur_inode_flip_flags = 0;
> +	sctx->cur_inode_receive_flags = 0;
> +	sctx->receive_flags_valid = 0;
>  out:
>  	return ret;
>  }
> @@ -6380,12 +6507,12 @@ static int dir_changed(struct send_ctx *sctx, u64 dir)
>  	int ret;
>  
>  	ret = get_inode_info(sctx->send_root, dir, NULL, &new_gen, NULL, NULL,
> -			     NULL, NULL);
> +			     NULL, NULL, NULL);
>  	if (ret)
>  		return ret;
>  
>  	ret = get_inode_info(sctx->parent_root, dir, NULL, &orig_gen, NULL,
> -			     NULL, NULL, NULL);
> +			     NULL, NULL, NULL, NULL);
>  	if (ret)
>  		return ret;
>  
> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> index 2f5e25e03def..664272ced1af 100644
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -85,8 +85,8 @@ enum btrfs_send_cmd {
>  	 */
>  	BTRFS_SEND_C_TOTAL_DATA_SIZE,
>  	BTRFS_SEND_C_FALLOCATE,
> -	BTRFS_SEND_C_INODE_SET_FLAGS,
>  	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */
> +	BTRFS_SEND_C_CHATTR,

I don't care too much about the naming, but whichever one you do should
be there from patch 1 and not get renamed or renumbered.

>  	__BTRFS_SEND_C_MAX,
>  };
> @@ -130,7 +130,7 @@ enum {
>  	 * The following attributes were added in stream version 2.
>  	 */
>  	BTRFS_SEND_A_FALLOCATE_FLAGS,
> -	BTRFS_SEND_A_INODE_FLAGS,
> +	BTRFS_SEND_A_CHATTR,

Same comment here re: naming.

>  
>  	__BTRFS_SEND_A_MAX,
>  };
> -- 
> 2.17.0
> 
