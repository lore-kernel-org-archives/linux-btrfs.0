Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2HKL6O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Aug 2012 07:58:14 -0400
Message-ID: <502648CA.2080008@oracle.com>
Date: Sat, 11 Aug 2012 19:58:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs: make filesystem read-only when submitting barrier
 fails
References: <1344605915-22526-1-git-send-email-sbehrens@giantdisaster.de> <5025C521.2010707@oracle.com>
In-Reply-To: <5025C521.2010707@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

)sorry, forgot to CC btrfs Maillist)

On 08/11/2012 10:36 AM, Liu Bo wrote:
> On 08/10/2012 09:38 PM, Stefan Behrens wrote:
>> So far the return code of barrier_all_devices() is ignored, which
>> means that errors are ignored. The result can be a corrupt
>> filesystem which is not consistent.
>> This commit adds code to evaluate the return code of
>> barrier_all_devices(). The normal btrfs_error() mechanism is used to
>> switch the filesystem into read-only mode when errors are detected.
>>
>> In order to decide whether barrier_all_devices() should return
>> error or success, the number of disks that are allowed to fail the
>> barrier submission is calculated. This calculation accounts for the
>> worst RAID level of metadata, system and data. If single, dup or
>> RAID0 is in use, a single disk error is already considered to be
>> fatal. Otherwise a single disk error is tolerated.
>>
>> The calculation of the number of disks that are tolerated to fail
>> the barrier operation is performed when the filesystem gets mounted,
>> when a balance operation is started and finished, and when devices
>> are added or removed.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  fs/btrfs/ctree.h    |   5 +++
>>  fs/btrfs/disk-io.c  | 109 +++++++++++++++++++++++++++++++++++++++++++++-------
>>  fs/btrfs/disk-io.h  |   2 +
>>  fs/btrfs/ioctl.c    |   8 ++--
>>  fs/btrfs/tree-log.c |   7 +++-
>>  fs/btrfs/volumes.c  |  30 +++++++++++++++
>>  6 files changed, 142 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index adb1cd7..af38d6d 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1442,6 +1442,8 @@ struct btrfs_fs_info {
>>  
>>  	/* next backup root to be overwritten */
>>  	int backup_root_index;
>> +
>> +	int num_tolerated_disk_barrier_failures;
> [...]  
>> +int btrfs_calc_num_tolerated_disk_barrier_failures(
>> +	struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_ioctl_space_info space;
>> +	struct btrfs_space_info *sinfo;
>> +	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
>> +		       BTRFS_BLOCK_GROUP_SYSTEM,
>> +		       BTRFS_BLOCK_GROUP_METADATA,
>> +		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
>> +	int num_types = 4;
>> +	int i;
>> +	int c;
>> +	int num_tolerated_disk_barrier_failures =
>> +		(int)fs_info->fs_devices->num_devices;
>> +
>> +	for (i = 0; i < num_types; i++) {
>> +		struct btrfs_space_info *tmp;
>> +
>> +		sinfo = NULL;
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(tmp, &fs_info->space_info, list) {
>> +			if (tmp->flags == types[i]) {
>> +				sinfo = tmp;
>> +				break;
>> +			}
>> +		}
>> +		rcu_read_unlock();
>> +
>> +		if (!sinfo)
>> +			continue;
>> +
>> +		down_read(&sinfo->groups_sem);
>> +		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
>> +			if (!list_empty(&sinfo->block_groups[c])) {
>> +				u64 flags;
>> +
>> +				btrfs_get_block_group_info(
>> +					&sinfo->block_groups[c], &space);
>> +				if (space.total_bytes == 0 ||
>> +				    space.used_bytes == 0)
>> +					continue;
>> +				flags = space.flags;
>> +				/*
>> +				 * return
>> +				 * 0: if dup, single or RAID0 is configured for
>> +				 *    any of metadata, system or data, else
>> +				 * 1: if RAID5 is configured, or if RAID1 or
>> +				 *    RAID10 is configured and only two mirrors
>> +				 *    are used, else
>> +				 * 2: if RAID6 is configured, else
>> +				 * num_mirrors - 1: if RAID1 or RAID10 is
>> +				 *                  configured and more than
>> +				 *                  2 mirrors are used.
>> +				 */
>> +				if (num_tolerated_disk_barrier_failures > 0 &&
>> +				    ((flags & (BTRFS_BLOCK_GROUP_DUP |
>> +					       BTRFS_BLOCK_GROUP_RAID0)) ||
>> +				     ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK)
>> +				      == 0)))
> 
> Good work.
> 
> We already have __get_block_group_index(), for dup, single, raid0 we can do the same thing like
> this:
> __get_block_group_index(flags) > 1
> 
> the only problem is to make the function public :)
> 
> 
>> +					num_tolerated_disk_barrier_failures = 0;
>> +				else if (num_tolerated_disk_barrier_failures > 1
>> +					 &&
>> +					 (flags & (BTRFS_BLOCK_GROUP_RAID1 |
>> +						   BTRFS_BLOCK_GROUP_RAID10)))
>> +					num_tolerated_disk_barrier_failures = 1;
>> +			}
>> +		}
>> +		up_read(&sinfo->groups_sem);
>> +	}
>> +
>> +	return num_tolerated_disk_barrier_failures;
>> +}
>> +
>>  int write_all_supers(struct btrfs_root *root, int max_mirrors)
>>  {
>>  	struct list_head *head;
>> @@ -2979,8 +3054,16 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
>>  	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
>>  	head = &root->fs_info->fs_devices->devices;
>>  
>> -	if (do_barriers)
>> -		barrier_all_devices(root->fs_info);
>> +	if (do_barriers) {
>> +		ret = barrier_all_devices(root->fs_info);
>> +		if (ret) {
>> +			mutex_unlock(
>> +				&root->fs_info->fs_devices->device_list_mutex);
>> +			btrfs_error(root->fs_info, ret,
>> +				    "errors while submitting device barriers.");
>> +			return ret;
>> +		}
>> +	}
>>  
>>  	list_for_each_entry_rcu(dev, head, dev_list) {
>>  		if (!dev->bdev) {
>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>> index c5b00a7..2025a91 100644
>> --- a/fs/btrfs/disk-io.h
>> +++ b/fs/btrfs/disk-io.h
>> @@ -95,6 +95,8 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>>  				     u64 objectid);
>>  int btree_lock_page_hook(struct page *page, void *data,
>>  				void (*flush_fn)(void *));
>> +int btrfs_calc_num_tolerated_disk_barrier_failures(
>> +	struct btrfs_fs_info *fs_info);
>>  
>>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>>  void btrfs_init_lockdep(void);
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 43f0012..6cd4125 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2852,8 +2852,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
>>  	return 0;
>>  }
>>  
>> -static void get_block_group_info(struct list_head *groups_list,
>> -				 struct btrfs_ioctl_space_info *space)
>> +void btrfs_get_block_group_info(struct list_head *groups_list,
>> +				struct btrfs_ioctl_space_info *space)
>>  {
>>  	struct btrfs_block_group_cache *block_group;
>>  
>> @@ -2961,8 +2961,8 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
>>  		down_read(&info->groups_sem);
>>  		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
>>  			if (!list_empty(&info->block_groups[c])) {
>> -				get_block_group_info(&info->block_groups[c],
>> -						     &space);
>> +				btrfs_get_block_group_info(
>> +					&info->block_groups[c], &space);
>>  				memcpy(dest, &space, sizeof(space));
>>  				dest++;
>>  				space_args.total_spaces++;
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index c86670f..c30e1c0 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -2171,9 +2171,12 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>>  	 * in and cause problems either.
>>  	 */
>>  	btrfs_scrub_pause_super(root);
>> -	write_ctree_super(trans, root->fs_info->tree_root, 1);
>> +	ret = write_ctree_super(trans, root->fs_info->tree_root, 1);
>>  	btrfs_scrub_continue_super(root);
>> -	ret = 0;
>> +	if (ret) {
>> +		btrfs_abort_transaction(trans, root, ret);
>> +		goto out_wake_log_root;
>> +	}
>>  
>>  	mutex_lock(&root->log_mutex);
>>  	if (root->last_log_commit < log_transid)
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index b8708f9..48ccaa4 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1474,6 +1474,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>>  		free_fs_devices(cur_devices);
>>  	}
>>  
>> +	root->fs_info->num_tolerated_disk_barrier_failures =
>> +		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
>> +
>>  	/*
>>  	 * at this point, the device is zero sized.  We want to
>>  	 * remove it from the devices list and zero out the old super
>> @@ -1796,6 +1799,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>  	btrfs_clear_space_info_full(root->fs_info);
>>  
>>  	unlock_chunks(root);
>> +	root->fs_info->num_tolerated_disk_barrier_failures =
>> +		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
>>  	ret = btrfs_commit_transaction(trans, root);
>>  
>>  	if (seeding_dev) {
>> @@ -2807,6 +2812,26 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>>  		}
>>  	}
>>  
>> +	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int num_tolerated_disk_barrier_failures;
>> +		u64 target = bctl->sys.target;
>> +
>> +		num_tolerated_disk_barrier_failures =
>> +			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>> +		if (num_tolerated_disk_barrier_failures > 0 &&
>> +		    (target &
>> +		     (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
>> +		      BTRFS_AVAIL_ALLOC_BIT_SINGLE)))
> 
> ditto.
> 
> thanks,
> liubo
> 
>> +			num_tolerated_disk_barrier_failures = 0;
>> +		else if (num_tolerated_disk_barrier_failures > 1 &&
>> +			 (target &
>> +			  (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)))
>> +			num_tolerated_disk_barrier_failures = 1;
>> +
>> +		fs_info->num_tolerated_disk_barrier_failures =
>> +			num_tolerated_disk_barrier_failures;
>> +	}
>> +
>>  	ret = insert_balance_item(fs_info->tree_root, bctl);
>>  	if (ret && ret != -EEXIST)
>>  		goto out;
>> @@ -2839,6 +2864,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>>  		__cancel_balance(fs_info);
>>  	}
>>  
>> +	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		fs_info->num_tolerated_disk_barrier_failures =
>> +			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>> +	}
>> +
>>  	wake_up(&fs_info->balance_wait_q);
>>  
>>  	return ret;
>>
> 

