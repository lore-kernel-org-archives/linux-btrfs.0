Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52035 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485Ab3EALmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 07:42:25 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so699718pbb.41
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 04:42:24 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v4 2/3] Btrfs: rescan for qgroups
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5180F66F.900@jan-o-sch.net>
Date: Wed, 1 May 2013 19:42:17 +0800
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-Id: <F7D1DC71-F8C9-41C5-8054-9A05F0179276@gmail.com>
References: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net> <1366905892-7880-3-git-send-email-list.btrfs@jan-o-sch.net> <AF839EC3-B219-4C4A-8CA3-B9634FB3F9BF@gmail.com> <5180F66F.900@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

> Hi Wang,
> 
> On 01.05.2013 09:29, Wang Shilong wrote:
>> Hello Jan,
>> 
>>> If qgroup tracking is out of sync, a rescan operation can be started. It
>>> iterates the complete extent tree and recalculates all qgroup tracking data.
>>> This is an expensive operation and should not be used unless required.
>>> 
>>> A filesystem under rescan can still be umounted. The rescan continues on the
>>> next mount.  Status information is provided with a separate ioctl while a
>>> rescan operation is in progress.
>>> 
>>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>> ---
>>> fs/btrfs/ctree.h           |   17 ++-
>>> fs/btrfs/disk-io.c         |    5 +
>>> fs/btrfs/ioctl.c           |   83 ++++++++++--
>>> fs/btrfs/qgroup.c          |  318 ++++++++++++++++++++++++++++++++++++++++++--
>>> include/uapi/linux/btrfs.h |   12 ++-
>>> 5 files changed, 400 insertions(+), 35 deletions(-)
>>> 
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 412c306..e4f28a6 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -1021,9 +1021,9 @@ struct btrfs_block_group_item {
>>> */
>>> #define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
>>> /*
>>> - * SCANNING is set during the initialization phase
>>> + * RESCAN is set during the initialization phase
>>> */
>>> -#define BTRFS_QGROUP_STATUS_FLAG_SCANNING	(1ULL << 1)
>>> +#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		(1ULL << 1)
>>> /*
>>> * Some qgroup entries are known to be out of date,
>>> * either because the configuration has changed in a way that
>>> @@ -1052,7 +1052,7 @@ struct btrfs_qgroup_status_item {
>>> 	 * only used during scanning to record the progress
>>> 	 * of the scan. It contains a logical address
>>> 	 */
>>> -	__le64 scan;
>>> +	__le64 rescan;
>>> } __attribute__ ((__packed__));
>>> 
>>> struct btrfs_qgroup_info_item {
>>> @@ -1603,6 +1603,11 @@ struct btrfs_fs_info {
>>> 	/* used by btrfs_qgroup_record_ref for an efficient tree traversal */
>>> 	u64 qgroup_seq;
>>> 
>>> +	/* qgroup rescan items */
>>> +	struct mutex qgroup_rescan_lock; /* protects the progress item */
>>> +	struct btrfs_key qgroup_rescan_progress;
>>> +	struct btrfs_workers qgroup_rescan_workers;
>>> +
>>> 	/* filesystem state */
>>> 	unsigned long fs_state;
>>> 
>>> @@ -2888,8 +2893,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
>>> 		   version, 64);
>>> BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
>>> 		   flags, 64);
>>> -BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
>>> -		   scan, 64);
>>> +BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
>>> +		   rescan, 64);
>>> 
>>> /* btrfs_qgroup_info_item */
>>> BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
>>> @@ -3834,7 +3839,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>>> 		       struct btrfs_fs_info *fs_info);
>>> int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>>> 			struct btrfs_fs_info *fs_info);
>>> -int btrfs_quota_rescan(struct btrfs_fs_info *fs_info);
>>> +int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
>>> int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
>>> 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
>>> int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 7717363..63e9348 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2010,6 +2010,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>>> 	btrfs_stop_workers(&fs_info->caching_workers);
>>> 	btrfs_stop_workers(&fs_info->readahead_workers);
>>> 	btrfs_stop_workers(&fs_info->flush_workers);
>>> +	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
>>> }
>>> 
>>> /* helper to cleanup tree roots */
>>> @@ -2301,6 +2302,7 @@ int open_ctree(struct super_block *sb,
>>> 	fs_info->qgroup_seq = 1;
>>> 	fs_info->quota_enabled = 0;
>>> 	fs_info->pending_quota_state = 0;
>>> +	mutex_init(&fs_info->qgroup_rescan_lock);
>>> 
>>> 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
>>> 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
>>> @@ -2529,6 +2531,8 @@ int open_ctree(struct super_block *sb,
>>> 	btrfs_init_workers(&fs_info->readahead_workers, "readahead",
>>> 			   fs_info->thread_pool_size,
>>> 			   &fs_info->generic_worker);
>>> +	btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
>>> +			   &fs_info->generic_worker);
>>> 
>>> 	/*
>>> 	 * endios are largely parallel and should have a very
>>> @@ -2563,6 +2567,7 @@ int open_ctree(struct super_block *sb,
>>> 	ret |= btrfs_start_workers(&fs_info->caching_workers);
>>> 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
>>> 	ret |= btrfs_start_workers(&fs_info->flush_workers);
>>> +	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
>>> 	if (ret) {
>>> 		err = -ENOMEM;
>>> 		goto fail_sb_buffer;
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index d0af96a..5e93bb8 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3701,12 +3701,10 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>>> 	}
>>> 
>>> 	down_write(&root->fs_info->subvol_sem);
>>> -	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
>>> -		trans = btrfs_start_transaction(root->fs_info->tree_root, 2);
>>> -		if (IS_ERR(trans)) {
>>> -			ret = PTR_ERR(trans);
>>> -			goto out;
>>> -		}
>>> +	trans = btrfs_start_transaction(root->fs_info->tree_root, 2);
>>> +	if (IS_ERR(trans)) {
>>> +		ret = PTR_ERR(trans);
>>> +		goto out;
>>> 	}
>>> 
>>> 	switch (sa->cmd) {
>>> @@ -3716,9 +3714,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>>> 	case BTRFS_QUOTA_CTL_DISABLE:
>>> 		ret = btrfs_quota_disable(trans, root->fs_info);
>>> 		break;
>>> -	case BTRFS_QUOTA_CTL_RESCAN:
>>> -		ret = btrfs_quota_rescan(root->fs_info);
>>> -		break;
>>> 	default:
>>> 		ret = -EINVAL;
>>> 		break;
>>> @@ -3727,11 +3722,9 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>>> 	if (copy_to_user(arg, sa, sizeof(*sa)))
>>> 		ret = -EFAULT;
>>> 
>>> -	if (trans) {
>>> -		err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
>>> -		if (err && !ret)
>>> -			ret = err;
>>> -	}
>>> +	err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
>>> +	if (err && !ret)
>>> +		ret = err;
>>> out:
>>> 	kfree(sa);
>>> 	up_write(&root->fs_info->subvol_sem);
>>> @@ -3886,6 +3879,64 @@ drop_write:
>>> 	return ret;
>>> }
>>> 
>>> +static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	struct btrfs_ioctl_quota_rescan_args *qsa;
>>> +	int ret;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EPERM;
>>> +
>>> +	ret = mnt_want_write_file(file);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	qsa = memdup_user(arg, sizeof(*qsa));
>>> +	if (IS_ERR(qsa)) {
>>> +		ret = PTR_ERR(qsa);
>>> +		goto drop_write;
>>> +	}
>>> +
>>> +	if (qsa->flags) {
>>> +		ret = -EINVAL;
>>> +		goto out;
>>> +	}
>>> +
>>> +	ret = btrfs_qgroup_rescan(root->fs_info);
>>> +
>>> +out:
>>> +	kfree(qsa);
>>> +drop_write:
>>> +	mnt_drop_write_file(file);
>>> +	return ret;
>>> +}
>>> +
>>> +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
>>> +{
>>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>>> +	struct btrfs_ioctl_quota_rescan_args *qsa;
>>> +	int ret = 0;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EPERM;
>>> +
>>> +	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
>>> +	if (!qsa)
>>> +		return -ENOMEM;
>>> +
>>> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>>> +		qsa->flags = 1;
>>> +		qsa->progress = root->fs_info->qgroup_rescan_progress.objectid;
>>> +	}
>>> +
>>> +	if (copy_to_user(arg, qsa, sizeof(*qsa)))
>>> +		ret = -EFAULT;
>>> +
>>> +	kfree(qsa);
>>> +	return ret;
>>> +}
>>> +
>>> static long btrfs_ioctl_set_received_subvol(struct file *file,
>>> 					    void __user *arg)
>>> {
>>> @@ -4124,6 +4175,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>>> 		return btrfs_ioctl_qgroup_create(file, argp);
>>> 	case BTRFS_IOC_QGROUP_LIMIT:
>>> 		return btrfs_ioctl_qgroup_limit(file, argp);
>>> +	case BTRFS_IOC_QUOTA_RESCAN:
>>> +		return btrfs_ioctl_quota_rescan(file, argp);
>>> +	case BTRFS_IOC_QUOTA_RESCAN_STATUS:
>>> +		return btrfs_ioctl_quota_rescan_status(file, argp);
>>> 	case BTRFS_IOC_DEV_REPLACE:
>>> 		return btrfs_ioctl_dev_replace(root, argp);
>>> 	case BTRFS_IOC_GET_FSLABEL:
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index c50e5a5..664d457 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -31,13 +31,13 @@
>>> #include "locking.h"
>>> #include "ulist.h"
>>> #include "backref.h"
>>> +#include "extent_io.h"
>>> 
>>> /* TODO XXX FIXME
>>> *  - subvol delete -> delete when ref goes to 0? delete limits also?
>>> *  - reorganize keys
>>> *  - compressed
>>> *  - sync
>>> - *  - rescan
>>> *  - copy also limits on subvol creation
>>> *  - limit
>>> *  - caches fuer ulists
>>> @@ -98,6 +98,14 @@ struct btrfs_qgroup_list {
>>> 	struct btrfs_qgroup *member;
>>> };
>>> 
>>> +struct qgroup_rescan {
>>> +	struct btrfs_work	work;
>>> +	struct btrfs_fs_info	*fs_info;
>>> +};
>>> +
>>> +static void qgroup_rescan_start(struct btrfs_fs_info *fs_info,
>>> +				struct qgroup_rescan *qscan);
>>> +
>>> /* must be called with qgroup_ioctl_lock held */
>>> static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
>>> 					   u64 qgroupid)
>>> @@ -298,7 +306,20 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
>>> 			}
>>> 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
>>> 									  ptr);
>>> -			/* FIXME read scan element */
>>> +			fs_info->qgroup_rescan_progress.objectid =
>>> +					btrfs_qgroup_status_rescan(l, ptr);
>>> +			if (fs_info->qgroup_flags &
>>> +			    BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>>> +				struct qgroup_rescan *qscan =
>>> +					kmalloc(sizeof(*qscan), GFP_NOFS);
>>> +				if (!qscan) {
>>> +					ret = -ENOMEM;
>>> +					goto out;
>>> +				}
>>> +				fs_info->qgroup_rescan_progress.type = 0;
>>> +				fs_info->qgroup_rescan_progress.offset = 0;
>>> +				qgroup_rescan_start(fs_info, qscan);
>>> +			}
>>> 			goto next1;
>>> 		}
>>> 
>>> @@ -719,7 +740,8 @@ static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
>>> 	ptr = btrfs_item_ptr(l, slot, struct btrfs_qgroup_status_item);
>>> 	btrfs_set_qgroup_status_flags(l, ptr, fs_info->qgroup_flags);
>>> 	btrfs_set_qgroup_status_generation(l, ptr, trans->transid);
>>> -	/* XXX scan */
>>> +	btrfs_set_qgroup_status_rescan(l, ptr,
>>> +				fs_info->qgroup_rescan_progress.objectid);
>>> 
>>> 	btrfs_mark_buffer_dirty(l);
>>> 
>>> @@ -830,7 +852,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>>> 	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
>>> 				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>>> 	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
>>> -	btrfs_set_qgroup_status_scan(leaf, ptr, 0);
>>> +	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
>>> 
>>> 	btrfs_mark_buffer_dirty(leaf);
>>> 
>>> @@ -944,10 +966,11 @@ out:
>>> 	return ret;
>>> }
>>> 
>>> -int btrfs_quota_rescan(struct btrfs_fs_info *fs_info)
>>> +static void qgroup_dirty(struct btrfs_fs_info *fs_info,
>>> +			 struct btrfs_qgroup *qgroup)
>>> {
>>> -	/* FIXME */
>>> -	return 0;
>>> +	if (list_empty(&qgroup->dirty))
>>> +		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
>>> }
>>> 
>>> int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
>>> @@ -1155,13 +1178,6 @@ out:
>>> 	return ret;
>>> }
>>> 
>>> -static void qgroup_dirty(struct btrfs_fs_info *fs_info,
>>> -			 struct btrfs_qgroup *qgroup)
>>> -{
>>> -	if (list_empty(&qgroup->dirty))
>>> -		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
>>> -}
>>> -
>>> /*
>>> * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
>>> * the modification into a list that's later used by btrfs_end_transaction to
>>> @@ -1388,6 +1404,15 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>>> 		BUG();
>>> 	}
>>> 
>>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>>> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>>> +		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
>>> +			mutex_unlock(&fs_info->qgroup_rescan_lock);
>>> +			return 0;
>>> +		}
>>> +	}
>>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>>> +
>>> 	/*
>>> 	 * the delayed ref sequence number we pass depends on the direction of
>>> 	 * the operation. for add operations, we pass (node->seq - 1) to skip
>>> @@ -1401,7 +1426,15 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>>> 	if (ret < 0)
>>> 		return ret;
>>> 
>>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>>> 	spin_lock(&fs_info->qgroup_lock);
>>> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>>> +		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
>>> +			ret = 0;
>>> +			goto unlock;
>>> +		}
>>> +	}
>>> +
>>> 	quota_root = fs_info->quota_root;
>>> 	if (!quota_root)
>>> 		goto unlock;
>>> @@ -1443,6 +1476,7 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>>> 
>>> unlock:
>>> 	spin_unlock(&fs_info->qgroup_lock);
>>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> 
>> 
>> Why do you hold qgroup_rescan_lock  when doing qgroup accounting here?
>> I can understand that we hold qgroup_rescan_lock when we update qgroup_flag(at first in qgroup_account_ref()),
>> However, is it necessary that we hold qgroup_rescan_lock when we are doing qgroup
>> accounting step1,2,3??
>> 
>> Or am  i missing something here?
> 
> We need the lock for the check added above. This check needs the mutex
> lock, while the three accounting steps need a spin lock (which was not
> modified by my patch). We cannot call mutex_unlock while holding a spin
> lock, because mutex_unlock might schedule.

Yeah, but do we need check that again? Considering we check:

"fs_info->qgroup_rescan_progress.objectid <= node->bytenr" before find_all_roots()
is called, if we can continue, that means "objected > node->bytenr". The point is that is it
possible that "objected <= node-bytenr" after find_all_roots() when we are doing qgroup
accounting. 

Here i think group_rescan_progress.objectid can only go larger, so it is not necessary to check it
again when we are doing qgroup accounting steps thus we can save  qgroup_rescan_lock usage here.

What do you think of this, please correct me if  i am wrong.

Thanks,
Wang
> 
> Thanks,
> -Jan
> 
>> Thanks,
>> Wang

