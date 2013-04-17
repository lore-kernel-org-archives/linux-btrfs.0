Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:65488 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3DQPU2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 11:20:28 -0400
Message-ID: <516EBDB8.8050603@jan-o-sch.net>
Date: Wed, 17 Apr 2013 17:20:24 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Btrfs: rescan for qgroups
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net> <B9EA5CB8-2AD5-4939-8290-4043F6ED9664@gmail.com>
In-Reply-To: <B9EA5CB8-2AD5-4939-8290-4043F6ED9664@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 16, 2013 at 14:22 (+0200), Wang Shilong wrote:
> 
> Hello Jan, more comments below..
> 
> [...snip..]
> 
>>  
>> +
>> +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
>> +{
>> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
>> +	struct btrfs_ioctl_quota_rescan_args *qsa;
>> +	int ret = 0;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
>> +	if (!qsa)
>> +		return -ENOMEM;
>> +
> 
> 	Here, i think we should hold qgroup_rescan_lock and group_lock:
> 
> 	1> qgroup_rescan protect BTRFS_QGROUP_STATUS_RESCAN  
> 	2>quota disabling may happen this time..so group_lock should also be held here.

It's just a status call for user space, I don't really care about exact
synchronization here. *If* we wanted to do that, I would have moved the code
into qgroup.c, because all the code that requires any qgroup locks is there. But
I'd really want to keep it simple. You cannot get completely garbage information
that way, you only could race with someone just starting off or finishing a
rescan operation. I don't think that really matters in the end.

> 
> 
>> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>> +		qsa->flags = 1;
>> +		qsa->progress = root->fs_info->qgroup_rescan_progress.objectid;
>> +	}
>> +
>> +	if (copy_to_user(arg, qsa, sizeof(*qsa)))
>> +		ret = -EFAULT;
>> +
>> +	kfree(qsa);
>> +	return ret;
>> +}
>> +
>>  
> [бн.snip...]
>>
>> +
>> +/*
>> + * returns < 0 on error, 0 when more leafs are to be scanned.
>> + * returns 1 when done, 2 when done and FLAG_INCONSISTENT was cleared.
>> + */
>> +static int
>> +qgroup_rescan_leaf(struct qgroup_rescan *qscan, struct btrfs_path *path,
>> +		   struct btrfs_trans_handle *trans, struct ulist *tmp,
>> +		   struct extent_buffer *scratch_leaf)
>> +{
>> +	struct btrfs_key found;
>> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
>> +	struct ulist *roots = NULL;
>> +	struct ulist_node *unode;
>> +	struct ulist_iterator uiter;
>> +	struct seq_list tree_mod_seq_elem = {};
>> +	u64 seq;
>> +	int slot;
>> +	int ret;
>> +
>> +	path->leave_spinning = 1;
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> 
> Here in qgroup_rescan_leaf(), we don't need hold group_rescan_lock.
> Because qgroup_rescan_lock is used to protect qgroup_flag, in group_rescan_leaf().
> we don't change qgroup_flag.. So we don't need hold the group_rescan_lock.
> 
> Maybe we can just remove the lock qgroup_rescan_lock,  and i think what qgroup_rscan_lock
> does that qgroup_lock can replace.

No, we cannot. We need the mutex for the following tree search and tie it to the
following update of the qgroup_rescan_progress. In fact, that's the only reason
I introduced it, but I don't want to hold a spin lock for a whole tree search.
If we do not make sure the search operation and the progress update happen under
the same lock, we can end up with a tree block being found by thread A, then
thread B checks the rescan_progress, then thread A updates the rescan_progress
according to the found block and doing the rescan. That would result in wrong
tracking information.

> 
> 
>> +	ret = btrfs_search_slot_for_read(fs_info->extent_root,
>> +					 &fs_info->qgroup_rescan_progress,
>> +					 path, 1, 0);
>> +
>> +	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
>> +		 (unsigned long long)fs_info->qgroup_rescan_progress.objectid,
>> +		 fs_info->qgroup_rescan_progress.type,
>> +		 (unsigned long long)fs_info->qgroup_rescan_progress.offset,
>> +		 ret);
>> +
>> +	if (ret) {
>> +		/*
>> +		 * The rescan is about to end, we will not be scanning any
>> +		 * further blocks. We cannot unset the RESCAN flag here, because
>> +		 * we want to commit the transaction if everything went well.
>> +		 * To make the live accounting work in this phase, we set our
>> +		 * scan progress pointer such that every real extent objectid
>> +		 * will be smaller.
>> +		 */
>> +		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
>> +		btrfs_release_path(path);
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		return ret;
>> +	}
>> +
>> +	btrfs_item_key_to_cpu(path->nodes[0], &found,
>> +			      btrfs_header_nritems(path->nodes[0]) - 1);
>> +	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
>> +
>> +	btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>> +	memcpy(scratch_leaf, path->nodes[0], sizeof(*scratch_leaf));
>> +	slot = path->slots[0];
>> +	btrfs_release_path(path);
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>> +	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
>> +		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
>> +		if (found.type != BTRFS_EXTENT_ITEM_KEY)
>> +			continue;
>> +		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
>> +					   tree_mod_seq_elem.seq, &roots);
>> +		if (ret < 0)
>> +			break;
>> +		spin_lock(&fs_info->qgroup_lock);
> 
> Quota may has been disabled now, so please adds the check, otherwise
> we may get a NULL pointer panic here.

Quota cannot be disabled without a transaction commit, and we're holding a
transaction open here.

What is in fact missing is stopping the rescan worker thread when quota is
disabled, though. I'll put that into v3.

Thanks,
-Jan
