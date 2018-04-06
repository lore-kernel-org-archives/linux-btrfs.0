Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47501 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755768AbeDFOsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 10:48:32 -0400
Date: Fri, 6 Apr 2018 16:46:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] btrfs: Allow rmdir(2) to delete a subvolume
Message-ID: <20180406144602.GF8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1c798713-c896-f20c-5551-b8480ca74b72@jp.fujitsu.com>
 <47eb3e91-8059-e273-b2f1-c648f94a3a3b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47eb3e91-8059-e273-b2f1-c648f94a3a3b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 03:16:47PM +0900, Misono Tomohiro wrote:
> This patch changes the behavior of rmdir(2) to allow it to delete
> an empty subvolume by default, unless it is not a default subvolume
> and send is not in progress.
> 
> New function btrfs_delete_subvolume() is almost equal to the second half
> of btrfs_ioctl_snap_destroy(). This function requires inode_lock for both
> @dir and inode of @dentry. For rmdir(2) it is already acquired in vfs
> layer before calling btrfs_rmdir().
> 
> Note that while a non-privileged user cannot delete a read-only subvolume
> by "btrfs subvolume delete" when user_subvol_rm_allowd mount option is
> enabled, rmdir(2) can delete an empty read-only subvolume.
> 
> Tested-by: Goffredo Baroncelli <kreijack@inwind.it>
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 140 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index db66fa4fede6..84dbb9cafd6b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4387,6 +4387,145 @@ noinline int may_destroy_subvol(struct btrfs_root *root)
>  	return ret;
>  }
>  
> +static int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
> +	struct btrfs_root *root = BTRFS_I(dir)->root;
> +	struct inode *inode = d_inode(dentry);
> +	struct btrfs_root *dest = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_block_rsv block_rsv;
> +	u64 root_flags;
> +	u64 qgroup_reserved;
> +	int ret;
> +	int err;
> +
> +	/*
> +	 * Don't allow to delete a subvolume with send in progress. This is
> +	 * inside the i_mutex so the error handling that has to drop the bit
> +	 * again is not run concurrently.
> +	 */
> +	spin_lock(&dest->root_item_lock);
> +	root_flags = btrfs_root_flags(&dest->root_item);
> +	if (dest->send_in_progress == 0) {
> +		btrfs_set_root_flags(&dest->root_item,
> +				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
> +		spin_unlock(&dest->root_item_lock);
> +	} else {
> +		spin_unlock(&dest->root_item_lock);
> +		btrfs_warn(fs_info,
> +			   "Attempt to delete subvolume %llu during send",
> +			   dest->root_key.objectid);
> +		err = -EPERM;
> +		return err;
> +	}
> +
> +	down_write(&fs_info->subvol_sem);
> +
> +	err = may_destroy_subvol(dest);
> +	if (err)
> +		goto out_up_write;
> +
> +	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
> +	/*
> +	 * One for dir inode, two for dir entries, two for root
> +	 * ref/backref.
> +	 */
> +	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
> +					       5, &qgroup_reserved, true);
> +	if (err)
> +		goto out_up_write;
> +
> +	trans = btrfs_start_transaction(root, 0);
> +	if (IS_ERR(trans)) {
> +		err = PTR_ERR(trans);
> +		goto out_release;
> +	}
> +	trans->block_rsv = &block_rsv;
> +	trans->bytes_reserved = block_rsv.size;
> +
> +	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
> +
> +	ret = btrfs_unlink_subvol(trans, root, dir,
> +				dest->root_key.objectid,
> +				dentry->d_name.name,
> +				dentry->d_name.len);
> +	if (ret) {
> +		err = ret;
> +		btrfs_abort_transaction(trans, ret);
> +		goto out_end_trans;
> +	}
> +
> +	btrfs_record_root_in_trans(trans, dest);
> +
> +	memset(&dest->root_item.drop_progress, 0,
> +		sizeof(dest->root_item.drop_progress));
> +	dest->root_item.drop_level = 0;
> +	btrfs_set_root_refs(&dest->root_item, 0);
> +
> +	if (!test_and_set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &dest->state)) {
> +		ret = btrfs_insert_orphan_item(trans,
> +					fs_info->tree_root,
> +					dest->root_key.objectid);
> +		if (ret) {
> +			btrfs_abort_transaction(trans, ret);
> +			err = ret;
> +			goto out_end_trans;
> +		}
> +	}
> +
> +	ret = btrfs_uuid_tree_rem(trans, fs_info, dest->root_item.uuid,
> +				  BTRFS_UUID_KEY_SUBVOL,
> +				  dest->root_key.objectid);
> +	if (ret && ret != -ENOENT) {
> +		btrfs_abort_transaction(trans, ret);
> +		err = ret;
> +		goto out_end_trans;
> +	}
> +	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
> +		ret = btrfs_uuid_tree_rem(trans, fs_info,
> +					  dest->root_item.received_uuid,
> +					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
> +					  dest->root_key.objectid);
> +		if (ret && ret != -ENOENT) {
> +			btrfs_abort_transaction(trans, ret);
> +			err = ret;
> +			goto out_end_trans;
> +		}
> +	}
> +
> +out_end_trans:
> +	trans->block_rsv = NULL;
> +	trans->bytes_reserved = 0;
> +	ret = btrfs_end_transaction(trans);
> +	if (ret && !err)
> +		err = ret;
> +	inode->i_flags |= S_DEAD;
> +out_release:
> +	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
> +out_up_write:
> +	up_write(&fs_info->subvol_sem);
> +	if (err) {
> +		spin_lock(&dest->root_item_lock);
> +		root_flags = btrfs_root_flags(&dest->root_item);
> +		btrfs_set_root_flags(&dest->root_item,
> +				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
> +		spin_unlock(&dest->root_item_lock);
> +	} else {
> +		d_invalidate(dentry);
> +		btrfs_invalidate_inodes(dest);
> +		ASSERT(dest->send_in_progress == 0);
> +
> +		/* the last ref */
> +		if (dest->ino_cache_inode) {
> +			iput(dest->ino_cache_inode);
> +			dest->ino_cache_inode = NULL;
> +		}
> +	}
> +
> +	return err;
> +}

The change separation is still not right. Patch 2+3 should factor out
btrfs_delete_subvolume and do not any changes to rmdir behaviour. The
following patch will do what's in the hunk below, with enough reasonging
why it is so.

> +
>  static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -4398,7 +4537,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>  	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
>  		return -ENOTEMPTY;
>  	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID)
> -		return -EPERM;
> +		return btrfs_delete_subvolume(dir, dentry);
>  
>  	trans = __unlink_start_trans(dir);
>  	if (IS_ERR(trans))
