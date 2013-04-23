Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab3DWLik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 07:38:40 -0400
Message-ID: <517673E1.8050400@cn.fujitsu.com>
Date: Tue, 23 Apr 2013 19:43:29 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> If qgroup tracking is out of sync, a rescan operation can be started. It
> iterates the complete extent tree and recalculates all qgroup tracking data.
> This is an expensive operation and should not be used unless required.
> 
> A filesystem under rescan can still be umounted. The rescan continues on the
> next mount.  Status information is provided with a separate ioctl while a
> rescan operation is in progress.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.h           |   17 ++-
>  fs/btrfs/disk-io.c         |    5 +
>  fs/btrfs/ioctl.c           |   83 ++++++++++--
>  fs/btrfs/qgroup.c          |  312 ++++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/btrfs.h |   12 ++-
>  5 files changed, 394 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 412c306..e4f28a6 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1021,9 +1021,9 @@ struct btrfs_block_group_item {
>   */
>  #define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
>  /*
> - * SCANNING is set during the initialization phase
> + * RESCAN is set during the initialization phase
>   */
> -#define BTRFS_QGROUP_STATUS_FLAG_SCANNING	(1ULL << 1)
> +#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		(1ULL << 1)
>  /*
>   * Some qgroup entries are known to be out of date,
>   * either because the configuration has changed in a way that
> @@ -1052,7 +1052,7 @@ struct btrfs_qgroup_status_item {
>  	 * only used during scanning to record the progress
>  	 * of the scan. It contains a logical address
>  	 */
> -	__le64 scan;
> +	__le64 rescan;
>  } __attribute__ ((__packed__));
>  
>  struct btrfs_qgroup_info_item {
> @@ -1603,6 +1603,11 @@ struct btrfs_fs_info {
>  	/* used by btrfs_qgroup_record_ref for an efficient tree traversal */
>  	u64 qgroup_seq;
>  
> +	/* qgroup rescan items */
> +	struct mutex qgroup_rescan_lock; /* protects the progress item */
> +	struct btrfs_key qgroup_rescan_progress;
> +	struct btrfs_workers qgroup_rescan_workers;
> +
>  	/* filesystem state */
>  	unsigned long fs_state;
>  
> @@ -2888,8 +2893,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
>  		   version, 64);
>  BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
>  		   flags, 64);
> -BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
> -		   scan, 64);
> +BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
> +		   rescan, 64);
>  
>  /* btrfs_qgroup_info_item */
>  BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
> @@ -3834,7 +3839,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  		       struct btrfs_fs_info *fs_info);
>  int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>  			struct btrfs_fs_info *fs_info);
> -int btrfs_quota_rescan(struct btrfs_fs_info *fs_info);
> +int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
>  int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
>  			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
>  int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f4628c7..f80383e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1996,6 +1996,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>  	btrfs_stop_workers(&fs_info->caching_workers);
>  	btrfs_stop_workers(&fs_info->readahead_workers);
>  	btrfs_stop_workers(&fs_info->flush_workers);
> +	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
>  }
>  
>  /* helper to cleanup tree roots */
> @@ -2257,6 +2258,7 @@ int open_ctree(struct super_block *sb,
>  	fs_info->qgroup_seq = 1;
>  	fs_info->quota_enabled = 0;
>  	fs_info->pending_quota_state = 0;
> +	mutex_init(&fs_info->qgroup_rescan_lock);
>  
>  	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
>  	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
> @@ -2485,6 +2487,8 @@ int open_ctree(struct super_block *sb,
>  	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
>  			   fs_info->thread_pool_size,
>  			   &fs_info->generic_worker);
> +	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
> +			   &fs_info->generic_worker);
>  
>  	/*
>  	 * endios are largely parallel and should have a very
> @@ -2519,6 +2523,7 @@ int open_ctree(struct super_block *sb,
>  	ret |= btrfs_start_workers(&fs_info->caching_workers);
>  	ret |= btrfs_start_workers(&fs_info->readahead_workers);
>  	ret |= btrfs_start_workers(&fs_info->flush_workers);
> +	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
>  	if (ret) {
>  		err = -ENOMEM;
>  		goto fail_sb_buffer;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d0af96a..5e93bb8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3701,12 +3701,10 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>  	}
>  
>  	down_write(&root->fs_info->subvol_sem);
> -	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
> -		trans = btrfs_start_transaction(root->fs_info->tree_root, 2);
> -		if (IS_ERR(trans)) {
> -			ret = PTR_ERR(trans);
> -			goto out;
> -		}
> +	trans = btrfs_start_transaction(root->fs_info->tree_root, 2);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
>  	}
>  
>  	switch (sa->cmd) {
> @@ -3716,9 +3714,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>  	case BTRFS_QUOTA_CTL_DISABLE:
>  		ret = btrfs_quota_disable(trans, root->fs_info);
>  		break;
> -	case BTRFS_QUOTA_CTL_RESCAN:
> -		ret = btrfs_quota_rescan(root->fs_info);
> -		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -3727,11 +3722,9 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>  	if (copy_to_user(arg, sa, sizeof(*sa)))
>  		ret = -EFAULT;
>  
> -	if (trans) {
> -		err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
> -		if (err && !ret)
> -			ret = err;
> -	}
> +	err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
> +	if (err && !ret)
> +		ret = err;
>  out:
>  	kfree(sa);
>  	up_write(&root->fs_info->subvol_sem);
> @@ -3886,6 +3879,64 @@ drop_write:
>  	return ret;
>  }
>  
> +static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct btrfs_ioctl_quota_rescan_args *qsa;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	qsa = memdup_user(arg, sizeof(*qsa));
> +	if (IS_ERR(qsa)) {
> +		ret = PTR_ERR(qsa);
> +		goto drop_write;
> +	}
> +
> +	if (qsa->flags) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = btrfs_qgroup_rescan(root->fs_info);
> +
> +out:
> +	kfree(qsa);
> +drop_write:
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
> +
> +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct btrfs_ioctl_quota_rescan_args *qsa;
> +	int ret = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
> +	if (!qsa)
> +		return -ENOMEM;
> +
> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> +		qsa->flags = 1;
> +		qsa->progress = root->fs_info->qgroup_rescan_progress.objectid;
> +	}
> +
> +	if (copy_to_user(arg, qsa, sizeof(*qsa)))
> +		ret = -EFAULT;
> +
> +	kfree(qsa);
> +	return ret;
> +}
> +
>  static long btrfs_ioctl_set_received_subvol(struct file *file,
>  					    void __user *arg)
>  {
> @@ -4124,6 +4175,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_create(file, argp);
>  	case BTRFS_IOC_QGROUP_LIMIT:
>  		return btrfs_ioctl_qgroup_limit(file, argp);
> +	case BTRFS_IOC_QUOTA_RESCAN:
> +		return btrfs_ioctl_quota_rescan(file, argp);
> +	case BTRFS_IOC_QUOTA_RESCAN_STATUS:
> +		return btrfs_ioctl_quota_rescan_status(file, argp);
>  	case BTRFS_IOC_DEV_REPLACE:
>  		return btrfs_ioctl_dev_replace(root, argp);
>  	case BTRFS_IOC_GET_FSLABEL:
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c50e5a5..249dd64 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -31,13 +31,13 @@
>  #include "locking.h"
>  #include "ulist.h"
>  #include "backref.h"
> +#include "extent_io.h"
>  
>  /* TODO XXX FIXME
>   *  - subvol delete -> delete when ref goes to 0? delete limits also?
>   *  - reorganize keys
>   *  - compressed
>   *  - sync
> - *  - rescan
>   *  - copy also limits on subvol creation
>   *  - limit
>   *  - caches fuer ulists
> @@ -98,6 +98,14 @@ struct btrfs_qgroup_list {
>  	struct btrfs_qgroup *member;
>  };
>  
> +struct qgroup_rescan {
> +	struct btrfs_work	work;
> +	struct btrfs_fs_info	*fs_info;
> +};
> +
> +static void qgroup_rescan_start(struct btrfs_fs_info *fs_info,
> +				struct qgroup_rescan *qscan);
> +
>  /* must be called with qgroup_ioctl_lock held */
>  static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
>  					   u64 qgroupid)
> @@ -298,7 +306,20 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
>  			}
>  			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
>  									  ptr);
> -			/* FIXME read scan element */
> +			fs_info->qgroup_rescan_progress.objectid =
> +					btrfs_qgroup_status_rescan(l, ptr);
> +			if (fs_info->qgroup_flags &
> +			    BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> +				struct qgroup_rescan *qscan =
> +					kmalloc(sizeof(*qscan), GFP_NOFS);
> +				if (!qscan) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +				fs_info->qgroup_rescan_progress.type = 0;
> +				fs_info->qgroup_rescan_progress.offset = 0;
> +				qgroup_rescan_start(fs_info, qscan);
> +			}
>  			goto next1;
>  		}
>  
> @@ -717,9 +738,12 @@ static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
>  	l = path->nodes[0];
>  	slot = path->slots[0];
>  	ptr = btrfs_item_ptr(l, slot, struct btrfs_qgroup_status_item);
> +	spin_lock(&fs_info->qgroup_lock);
>  	btrfs_set_qgroup_status_flags(l, ptr, fs_info->qgroup_flags);
>  	btrfs_set_qgroup_status_generation(l, ptr, trans->transid);
> -	/* XXX scan */
> +	btrfs_set_qgroup_status_rescan(l, ptr,
> +				fs_info->qgroup_rescan_progress.objectid);
> +	spin_unlock(&fs_info->qgroup_lock);


Did you forget to remove spin lock 'qgroup_lock' here?...

Thanks,
Wang

[snip]
...


