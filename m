Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48224 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3CaBMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Mar 2013 21:12:43 -0400
Received: by mail-pd0-f172.google.com with SMTP id 5so314260pdd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Mar 2013 18:12:42 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V2 1/6] Btrfs: introduce a mutex lock for btrfs quota operations
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5157781A.5000507@gmx.net>
Date: Sun, 31 Mar 2013 09:12:32 +0800
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com,
        wangsl-fnst@cn.fujitsu.com
Message-Id: <ACA06C31-4078-4313-B3F1-1BAFBC22AC83@gmail.com>
References: <1364468024-1636-1-git-send-email-wangshilong1991@gmail.com> <5157781A.5000507@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Arne,

> On 03/28/13 11:53, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> 
>> This patch introduces mutex lock 'quota_lock', and makes
>> all the user change for quota protected by quota_lock.
>> 
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> fs/btrfs/ctree.h   |    3 +++
>> fs/btrfs/disk-io.c |    1 +
>> fs/btrfs/ioctl.c   |   16 ++++++++++++----
>> 3 files changed, 16 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 6e81860..a11a8ed 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1584,6 +1584,9 @@ struct btrfs_fs_info {
>> 	struct rb_root qgroup_tree;
>> 	spinlock_t qgroup_lock;
>> 
>> +	/* protect user change operations for quota */
>> +	struct mutex quota_lock;
>> +
>> 	/* list of dirty qgroups to be written at next commit */
>> 	struct list_head dirty_qgroups;
>> 
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index fe82d08..4552f14 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2250,6 +2250,7 @@ int open_ctree(struct super_block *sb,
>> 	mutex_init(&fs_info->dev_replace.lock);
>> 
>> 	spin_lock_init(&fs_info->qgroup_lock);
>> +	mutex_init(&fs_info->quota_lock);
>> 	fs_info->qgroup_tree = RB_ROOT;
>> 	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
>> 	fs_info->qgroup_seq = 1;
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 222ce84..e2950f1 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -752,7 +752,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
>> 
>> 	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
>> 		goto out_up_read;
>> -
>> +	mutex_lock(&BTRFS_I(dir)->root->fs_info->quota_lock);
>> 	if (snap_src) {
>> 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
>> 					async_transid, readonly, inherit);
>> @@ -762,6 +762,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
>> 	}
>> 	if (!error)
>> 		fsnotify_mkdir(dir, dentry);
>> +	mutex_unlock(&BTRFS_I(dir)->root->fs_info->quota_lock);
> 
> You are completely serializing subvolume operations here. I'd prefer if
> you'd move the lock to a lower level to only protect the quota
> operations. Can't you move the lock completely to qgroup.c?

I have thought about this.
It really should not start a transaction  if the checks fail.So i have all the necessary checks
before a transaction!

For  user quota change operations, i think it is ok to serialize the operations.
The only place may be create_snapshot()/create_subvolume(). Maybe i can move the mutex_lock
to the place where btrfs_qgroup_inherit() is  called.

Thanks,
wang
 
> 
>> out_up_read:
>> 	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
>> out_dput:
>> @@ -3693,6 +3694,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>> 		goto drop_write;
>> 	}
>> 
>> +	mutex_lock(&root->fs_info->quota_lock);
>> 	down_read(&root->fs_info->subvol_sem);
>> 	if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
>> 		trans = btrfs_start_transaction(root, 2);
>> @@ -3728,6 +3730,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>> out:
>> 	kfree(sa);
>> 	up_read(&root->fs_info->subvol_sem);
>> +	mutex_unlock(&root->fs_info->quota_lock);
>> drop_write:
>> 	mnt_drop_write_file(file);
>> 	return ret;
>> @@ -3754,6 +3757,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>> 		goto drop_write;
>> 	}
>> 
>> +	mutex_lock(&root->fs_info->quota_lock);
>> 	trans = btrfs_join_transaction(root);
>> 	if (IS_ERR(trans)) {
>> 		ret = PTR_ERR(trans);
>> @@ -3775,6 +3779,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>> 
>> out:
>> 	kfree(sa);
>> +	mutex_unlock(&root->fs_info->quota_lock);
>> drop_write:
>> 	mnt_drop_write_file(file);
>> 	return ret;
>> @@ -3805,11 +3810,11 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>> 		ret = -EINVAL;
>> 		goto out;
>> 	}
>> -
>> +	mutex_lock(&root->fs_info->quota_lock);
>> 	trans = btrfs_join_transaction(root);
>> 	if (IS_ERR(trans)) {
>> 		ret = PTR_ERR(trans);
>> -		goto out;
>> +		goto out_unlock;
>> 	}
>> 
>> 	/* FIXME: check if the IDs really exist */
>> @@ -3824,6 +3829,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>> 	if (err && !ret)
>> 		ret = err;
>> 
>> +out_unlock:
>> +	mutex_unlock(&root->fs_info->quota_lock);
>> out:
>> 	kfree(sa);
>> drop_write:
>> @@ -3852,7 +3859,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>> 		ret = PTR_ERR(sa);
>> 		goto drop_write;
>> 	}
>> -
>> +	mutex_lock(&root->fs_info->quota_lock);
>> 	trans = btrfs_join_transaction(root);
>> 	if (IS_ERR(trans)) {
>> 		ret = PTR_ERR(trans);
>> @@ -3874,6 +3881,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
>> 
>> out:
>> 	kfree(sa);
>> +	mutex_unlock(&root->fs_info->quota_lock);
>> drop_write:
>> 	mnt_drop_write_file(file);
>> 	return ret;
>> 
> 

