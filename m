Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49385 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3ENKo3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:44:29 -0400
Date: Tue, 14 May 2013 18:44:11 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/8] Btrfs: maintain subvolume items in the UUID tree
Message-ID: <20130514104410.GB15127@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
 <c68d2db7aa4ed6455645cf788e305b1a9ebb88bc.1368523154.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68d2db7aa4ed6455645cf788e305b1a9ebb88bc.1368523154.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 11:36:56AM +0200, Stefan Behrens wrote:
> When a new subvolume or snapshot is created, a new UUID item is added
> to the UUID tree. Such items are removed when the subvolume is deleted.
> The ioctl to set the received subvolume UUID is also touched and will
> now also add this received UUID into the UUID tree together with the
> ID of the subvolume. The latter is also done when read-only snapshots
> are created which inherit all the send/receive information from the
> parent subvolume.
> 
> User mode programs use the BTRFS_IOC_TREE_SEARCH ioctl to search and
> read in the UUID tree.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/ctree.h       |  1 +
>  fs/btrfs/ioctl.c       | 74 +++++++++++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/transaction.c | 19 ++++++++++++-
>  3 files changed, 83 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6f9d760..73d797c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3634,6 +3634,7 @@ extern const struct dentry_operations btrfs_dentry_operations;
>  long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  void btrfs_update_iflags(struct inode *inode);
>  void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
> +int btrfs_is_empty_uuid(u8 *uuid);
>  int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		      struct btrfs_ioctl_defrag_range_args *range,
>  		      u64 newer_than, unsigned long max_pages);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b2537c7..47bef5a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -363,6 +363,13 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
>  	return 0;
>  }
>  
> +int btrfs_is_empty_uuid(u8 *uuid)
> +{
> +	static char empty_uuid[BTRFS_UUID_SIZE] = {0};
> +
> +	return !memcmp(uuid, empty_uuid, BTRFS_UUID_SIZE);
> +}
> +
>  static noinline int create_subvol(struct inode *dir,
>  				  struct dentry *dentry,
>  				  char *name, int namelen,
> @@ -396,7 +403,7 @@ static noinline int create_subvol(struct inode *dir,
>  	 * of create_snapshot().
>  	 */
>  	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
> -					       7, &qgroup_reserved);
> +					       8, &qgroup_reserved);
>  	if (ret)
>  		return ret;
>  
> @@ -518,9 +525,13 @@ static noinline int create_subvol(struct inode *dir,
>  	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
>  				 objectid, root->root_key.objectid,
>  				 btrfs_ino(dir), index, name, namelen);
> -
>  	BUG_ON(ret);
>  

This uuid_root will not use trans->block_rsv but empty_rsv since it does not set
ref_cow, so you don't need to add one more to block_rsv, and same for
the below cases.

thanks,
liubo

> +	ret = btrfs_insert_uuid_subvol_item(trans, root->fs_info->uuid_root,
> +					    root_item.uuid, objectid);
> +	if (ret)
> +		btrfs_abort_transaction(trans, root, ret);
> +
>  fail:
>  	trans->block_rsv = NULL;
>  	trans->bytes_reserved = 0;
> @@ -567,9 +578,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	 * 1 - root item
>  	 * 2 - root ref/backref
>  	 * 1 - root of snapshot
> +	 * 1 - UUID item
>  	 */
>  	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
> -					&pending_snapshot->block_rsv, 7,
> +					&pending_snapshot->block_rsv, 8,
>  					&pending_snapshot->qgroup_reserved);
>  	if (ret)
>  		goto out;
> @@ -2207,6 +2219,27 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  			goto out_end_trans;
>  		}
>  	}
> +
> +	ret = btrfs_del_uuid_subvol_item(trans, root->fs_info->uuid_root,
> +					 dest->root_item.uuid,
> +					 dest->root_key.objectid);
> +	if (ret && ret != -ENOENT) {
> +		btrfs_abort_transaction(trans, root, ret);
> +		err = ret;
> +		goto out_end_trans;
> +	}
> +	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
> +		ret = btrfs_del_uuid_received_subvol_item(trans,
> +				root->fs_info->uuid_root,
> +				dest->root_item.received_uuid,
> +				dest->root_key.objectid);
> +		if (ret && ret != -ENOENT) {
> +			btrfs_abort_transaction(trans, root, ret);
> +			err = ret;
> +			goto out_end_trans;
> +		}
> +	}
> +
>  out_end_trans:
>  	trans->block_rsv = NULL;
>  	trans->bytes_reserved = 0;
> @@ -2418,7 +2451,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>  	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>  	int ret = 0;
>  	char *s_uuid = NULL;
> -	char empty_uuid[BTRFS_UUID_SIZE] = {0};
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -2427,7 +2459,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>  	if (IS_ERR(di_args))
>  		return PTR_ERR(di_args);
>  
> -	if (memcmp(empty_uuid, di_args->uuid, BTRFS_UUID_SIZE) != 0)
> +	if (!btrfs_is_empty_uuid(di_args->uuid))
>  		s_uuid = di_args->uuid;
>  
>  	mutex_lock(&fs_devices->device_list_mutex);
> @@ -3952,6 +3984,7 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
>  	struct btrfs_trans_handle *trans;
>  	struct timespec ct = CURRENT_TIME;
>  	int ret = 0;
> +	int received_uuid_changed;
>  
>  	ret = mnt_want_write_file(file);
>  	if (ret < 0)
> @@ -3981,7 +4014,11 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
>  		goto out;
>  	}
>  
> -	trans = btrfs_start_transaction(root, 1);
> +	/*
> +	 * 1 - root item
> +	 * 2 - uuid items (received uuid + subvol uuid)
> +	 */
> +	trans = btrfs_start_transaction(root, 3);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
>  		trans = NULL;
> @@ -3992,6 +4029,14 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
>  	sa->rtime.sec = ct.tv_sec;
>  	sa->rtime.nsec = ct.tv_nsec;
>  
> +	received_uuid_changed = memcmp(root_item->received_uuid, sa->uuid,
> +				       BTRFS_UUID_SIZE);
> +	if (received_uuid_changed &&
> +	    !btrfs_is_empty_uuid(root_item->received_uuid))
> +		btrfs_del_uuid_received_subvol_item(trans,
> +						    root->fs_info->uuid_root,
> +						    root_item->received_uuid,
> +						    root->root_key.objectid);
>  	memcpy(root_item->received_uuid, sa->uuid, BTRFS_UUID_SIZE);
>  	btrfs_set_root_stransid(root_item, sa->stransid);
>  	btrfs_set_root_rtransid(root_item, sa->rtransid);
> @@ -4004,12 +4049,21 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
>  				&root->root_key, &root->root_item);
>  	if (ret < 0) {
>  		btrfs_end_transaction(trans, root);
> -		trans = NULL;
>  		goto out;
> -	} else {
> -		ret = btrfs_commit_transaction(trans, root);
> -		if (ret < 0)
> +	}
> +	if (received_uuid_changed && !btrfs_is_empty_uuid(sa->uuid)) {
> +		ret = btrfs_insert_uuid_received_subvol_item(
> +			trans, root->fs_info->uuid_root, sa->uuid,
> +			root->root_key.objectid);
> +		if (ret < 0 && ret != -EEXIST) {
> +			btrfs_abort_transaction(trans, root, ret);
>  			goto out;
> +		}
> +	}
> +	ret = btrfs_commit_transaction(trans, root);
> +	if (ret < 0) {
> +		btrfs_abort_transaction(trans, root, ret);
> +		goto out;
>  	}
>  
>  	ret = copy_to_user(arg, sa, sizeof(*sa));
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 0544587..a3d92b3 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1263,8 +1263,25 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  					 dentry->d_name.len * 2);
>  	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
>  	ret = btrfs_update_inode_fallback(trans, parent_root, parent_inode);
> -	if (ret)
> +	if (ret) {
> +		btrfs_abort_transaction(trans, root, ret);
> +		goto fail;
> +	}
> +	ret = btrfs_insert_uuid_subvol_item(trans, fs_info->uuid_root,
> +					    new_uuid.b, objectid);
> +	if (ret) {
>  		btrfs_abort_transaction(trans, root, ret);
> +		goto fail;
> +	}
> +	if (!btrfs_is_empty_uuid(new_root_item->received_uuid)) {
> +		ret = btrfs_insert_uuid_received_subvol_item(
> +			trans, fs_info->uuid_root, new_root_item->received_uuid,
> +			objectid);
> +		if (ret && ret != -EEXIST) {
> +			btrfs_abort_transaction(trans, root, ret);
> +			goto fail;
> +		}
> +	}
>  fail:
>  	pending->error = ret;
>  dir_item_existed:
> -- 
> 1.8.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
