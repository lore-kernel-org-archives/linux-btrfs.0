Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24990 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaBGJbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 04:31:42 -0500
Message-ID: <52F4A4B9.20506@cn.fujitsu.com>
Date: Fri, 07 Feb 2014 17:17:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] Btrfs: fix use-after-free in the finishing procedure
 of the device replace
References: <1391071615-6729-1-git-send-email-miaox@cn.fujitsu.com> <1391071615-6729-2-git-send-email-miaox@cn.fujitsu.com> <52F495F2.6020606@giantdisaster.de>
In-Reply-To: <52F495F2.6020606@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 07 Feb 2014 09:14:42 +0100, Stefan Behrens wrote:
> On Thu, 30 Jan 2014 16:46:55 +0800, Miao Xie wrote:
>> During device replace test, we hit a null pointer deference (It was very easy
>> to reproduce it by running xfstests' btrfs/011 on the devices with the virtio
>> scsi driver). There were two bugs that caused this problem:
>> - We might allocate new chunks on the replaced device after we updated
>>   the mapping tree. And we forgot to replace the source device in those
>>   mapping of the new chunks.
>> - We might get the mapping information which including the source device
>>   before the mapping information update. And then submit the bio which was
>>   based on that mapping information after we freed the source device.
>>
>> For the first bug, we can fix it by doing mapping tree update and source
>> device remove in the same context of the chunk mutex. The chunk mutex is
>> used to protect the allocable device list, the above method can avoid
>> the new chunk allocation, and after we remove the source device, all
>> the new chunks will be allocated on the new device. So it can fix
>> the first bug.
>>
>> For the second bug, we need make sure all flighting bios are finished and
>> no new bios are produced during we are removing the source device. To fix
>> this problem, we introduced a global @bio_counter, we not only inc/dec
>> @bio_counter outsize of map_blocks, but also inc it before submitting bio
>> and dec @bio_counter when ending bios.
>>
>> Since Raid56 is a little different and device replace dosen't support raid56
>> yet, it is not addressed in the patch and I add comments to make sure we will
>> fix it in the future.
>>
>> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ctree.h       |  9 ++++++
>>  fs/btrfs/dev-replace.c | 74 +++++++++++++++++++++++++++++++++++++++++++++-----
>>  fs/btrfs/disk-io.c     | 12 +++++++-
>>  fs/btrfs/volumes.c     | 30 +++++++++++++++-----
>>  fs/btrfs/volumes.h     |  1 +
>>  5 files changed, 111 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 84d4c05..c39ad06 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -351,6 +351,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>>  #define BTRFS_FS_STATE_ERROR		0
>>  #define BTRFS_FS_STATE_REMOUNTING	1
>>  #define BTRFS_FS_STATE_TRANS_ABORTED	2
>> +#define BTRFS_FS_STATE_DEV_REPLACING	3
>>  
>>  /* Super block flags */
>>  /* Errors detected */
>> @@ -1674,6 +1675,9 @@ struct btrfs_fs_info {
>>  
>>  	atomic_t mutually_exclusive_operation_running;
>>  
>> +	struct percpu_counter bio_counter;
>> +	wait_queue_head_t replace_wait;
>> +
>>  	struct semaphore uuid_tree_rescan_sem;
>>  	unsigned int update_uuid_tree_gen:1;
>>  };
>> @@ -3991,6 +3995,11 @@ int btrfs_scrub_cancel_dev(struct btrfs_fs_info *info,
>>  int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
>>  			 struct btrfs_scrub_progress *progress);
>>  
>> +/* dev-replace.c */
>> +void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info);
>> +void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info);
>> +void btrfs_bio_counter_dec(struct btrfs_fs_info *fs_info);
>> +
>>  /* reada.c */
>>  struct reada_control {
>>  	struct btrfs_root	*root;		/* tree to prefetch */
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index b20d59e..ec1c3f3 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -431,6 +431,35 @@ leave_no_lock:
>>  	return ret;
>>  }
>>  
>> +/*
>> + * blocked until all flighting bios are finished.
>> + */
>> +static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info)
>> +{
>> +	s64 writers;
>> +	DEFINE_WAIT(wait);
>> +
>> +	set_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
>> +	do {
>> +		prepare_to_wait(&fs_info->replace_wait, &wait,
>> +				TASK_UNINTERRUPTIBLE);
>> +		writers = percpu_counter_sum(&fs_info->bio_counter);
>> +		if (writers)
>> +			schedule();
>> +		finish_wait(&fs_info->replace_wait, &wait);
>> +	} while (writers);
>> +}
>> +
>> +/*
>> + * we have removed target device, it is safe to allow new bios request.
>> + */
>> +static void btrfs_rm_dev_replace_unblocked(struct btrfs_fs_info *fs_info)
>> +{
>> +	clear_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
>> +	if (waitqueue_active(&fs_info->replace_wait))
>> +		wake_up(&fs_info->replace_wait);
>> +}
>> +
>>  static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  				       int scrub_ret)
>>  {
>> @@ -458,12 +487,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  	src_device = dev_replace->srcdev;
>>  	btrfs_dev_replace_unlock(dev_replace);
>>  
>> -	/* replace old device with new one in mapping tree */
>> -	if (!scrub_ret)
>> -		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
>> -								src_device,
>> -								tgt_device);
>> -
> 
> Isn't this change the reason that you need to add code to count bios?

No, the change is not the reason to introduce a bio counter.

The above two bugs are independent, the second bug can happen even the first one
doesn't exist, for example:
	Task1			Task2
				btrfs_readpages()
				  btrfs_map_bio()
				    __btrfs_map_block()
				    <be blocked for a long time>
	device replace start
	device replace finish
	  release source device
				    bio_size_ok()
				      bdev_get_queue()
					oops

> I mean, code is there to flush everything to disk. It's needed for sync,
> too. When btrfs_dev_replace_finishing() is called, the copy operation is
> finished and the replaced and the replacement drive are logically
> identical except that data is not yet forced to be flushed to disk. The
> only difference between both disks is the bdev block device pointer and
> the btrfs device pointer.
> 
> I think this is the correct and lightweight procedure:
> 
> 1. After the copy operation finished, from now on, always use the new
> btrfs device and the new block device.
> 2. Flush all outstanding bios and wait for them.
> 3. Close the block dev and free the btrfs device.
> 
> You said that the problem was that we might allocate new chunks on the
> replaced device after we updated the mapping tree. Well, can't we just
> make sure the new chunks are allocated using the new device pointers
> after step 1 and all issues are resolved? I think that the first change
> is not a good idea and causes the other issues that you fix with a lot
> of code.

Step1 can fix the first problem, but need more code to recover the mapping
tree when the flush fails.

And as I said above, the second bug is not introduced by the fix of the first
bug, we have to add a bio counter. Any good idea?

BTW, the reason why I mixed two fixes into one patch is that we could not fix
the oops by any one of them. I can split it into two patches if need. 

Thanks
Miao
> 
>>  	/*
>>  	 * flush all outstanding I/O and inode extent mappings before the
>>  	 * copy operation is declared as being finished
>> @@ -495,7 +518,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  	dev_replace->time_stopped = get_seconds();
>>  	dev_replace->item_needs_writeback = 1;
>>  
>> -	if (scrub_ret) {
>> +	/* replace old device with new one in mapping tree */
>> +	if (!scrub_ret) {
>> +		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
>> +								src_device,
>> +								tgt_device);
>> +	} else {
>>  		printk_in_rcu(KERN_ERR
>>  			      "BTRFS: btrfs_scrub_dev(%s, %llu, %s) failed %d\n",
>>  			      src_device->missing ? "<missing disk>" :
>> @@ -534,8 +562,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>>  	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>>  
>> +	btrfs_rm_dev_replace_blocked(fs_info);
>> +
>>  	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
>>  
>> +	btrfs_rm_dev_replace_unblocked(fs_info);
>> +
>>  	/*
>>  	 * this is again a consistent state where no dev_replace procedure
>>  	 * is running, the target device is part of the filesystem, the
>> @@ -865,3 +897,31 @@ void btrfs_dev_replace_unlock(struct btrfs_dev_replace *dev_replace)
>>  		mutex_unlock(&dev_replace->lock_management_lock);
>>  	}
>>  }
>> +
>> +void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
>> +{
>> +	percpu_counter_inc(&fs_info->bio_counter);
>> +}
>> +
>> +void btrfs_bio_counter_dec(struct btrfs_fs_info *fs_info)
>> +{
>> +	percpu_counter_dec(&fs_info->bio_counter);
>> +
>> +	if (waitqueue_active(&fs_info->replace_wait))
>> +		wake_up(&fs_info->replace_wait);
>> +}
>> +
>> +void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
>> +{
>> +	DEFINE_WAIT(wait);
>> +again:
>> +	percpu_counter_inc(&fs_info->bio_counter);
>> +	if (test_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state)) {
>> +		btrfs_bio_counter_dec(fs_info);
>> +		wait_event(fs_info->replace_wait,
>> +			   !test_bit(BTRFS_FS_STATE_DEV_REPLACING,
>> +				     &fs_info->fs_state));
>> +		goto again;
>> +	}
>> +
>> +}
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7619147..4d6f36c 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2136,10 +2136,16 @@ int open_ctree(struct super_block *sb,
>>  		goto fail_dirty_metadata_bytes;
>>  	}
>>  
>> +	ret = percpu_counter_init(&fs_info->bio_counter, 0);
>> +	if (ret) {
>> +		err = ret;
>> +		goto fail_delalloc_bytes;
>> +	}
>> +
>>  	fs_info->btree_inode = new_inode(sb);
>>  	if (!fs_info->btree_inode) {
>>  		err = -ENOMEM;
>> -		goto fail_delalloc_bytes;
>> +		goto fail_bio_counter;
>>  	}
>>  
>>  	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
>> @@ -2214,6 +2220,7 @@ int open_ctree(struct super_block *sb,
>>  	atomic_set(&fs_info->scrub_pause_req, 0);
>>  	atomic_set(&fs_info->scrubs_paused, 0);
>>  	atomic_set(&fs_info->scrub_cancel_req, 0);
>> +	init_waitqueue_head(&fs_info->replace_wait);
>>  	init_waitqueue_head(&fs_info->scrub_pause_wait);
>>  	fs_info->scrub_workers_refcnt = 0;
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>> @@ -2966,6 +2973,8 @@ fail_iput:
>>  	btrfs_mapping_tree_free(&fs_info->mapping_tree);
>>  
>>  	iput(fs_info->btree_inode);
>> +fail_bio_counter:
>> +	percpu_counter_destroy(&fs_info->bio_counter);
>>  fail_delalloc_bytes:
>>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>>  fail_dirty_metadata_bytes:
>> @@ -3613,6 +3622,7 @@ int close_ctree(struct btrfs_root *root)
>>  
>>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
>>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>> +	percpu_counter_destroy(&fs_info->bio_counter);
>>  	bdi_destroy(&fs_info->bdi);
>>  	cleanup_srcu_struct(&fs_info->subvol_srcu);
>>  
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index b68afe32..07629e9 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5263,6 +5263,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
>>  static void btrfs_end_bio(struct bio *bio, int err)
>>  {
>>  	struct btrfs_bio *bbio = bio->bi_private;
>> +	struct btrfs_device *dev = bbio->stripes[0].dev;
>>  	int is_orig_bio = 0;
>>  
>>  	if (err) {
>> @@ -5270,7 +5271,6 @@ static void btrfs_end_bio(struct bio *bio, int err)
>>  		if (err == -EIO || err == -EREMOTEIO) {
>>  			unsigned int stripe_index =
>>  				btrfs_io_bio(bio)->stripe_index;
>> -			struct btrfs_device *dev;
>>  
>>  			BUG_ON(stripe_index >= bbio->num_stripes);
>>  			dev = bbio->stripes[stripe_index].dev;
>> @@ -5292,6 +5292,8 @@ static void btrfs_end_bio(struct bio *bio, int err)
>>  	if (bio == bbio->orig_bio)
>>  		is_orig_bio = 1;
>>  
>> +	btrfs_bio_counter_dec(bbio->fs_info);
>> +
>>  	if (atomic_dec_and_test(&bbio->stripes_pending)) {
>>  		if (!is_orig_bio) {
>>  			bio_put(bio);
>> @@ -5440,6 +5442,9 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
>>  	}
>>  #endif
>>  	bio->bi_bdev = dev->bdev;
>> +
>> +	btrfs_bio_counter_inc_noblocked(root->fs_info);
>> +
>>  	if (async)
>>  		btrfs_schedule_bio(root, dev, rw, bio);
>>  	else
>> @@ -5508,28 +5513,38 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
>>  	length = bio->bi_size;
>>  	map_length = length;
>>  
>> +	btrfs_bio_counter_inc_blocked(root->fs_info);
>>  	ret = __btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
>>  			      mirror_num, &raid_map);
>> -	if (ret) /* -ENOMEM */
>> +	if (ret) {
>> +		btrfs_bio_counter_dec(root->fs_info);
>>  		return ret;
>> +	}
>>  
>>  	total_devs = bbio->num_stripes;
>>  	bbio->orig_bio = first_bio;
>>  	bbio->private = first_bio->bi_private;
>>  	bbio->end_io = first_bio->bi_end_io;
>> +	bbio->fs_info = root->fs_info;
>>  	atomic_set(&bbio->stripes_pending, bbio->num_stripes);
>>  
>>  	if (raid_map) {
>>  		/* In this case, map_length has been set to the length of
>>  		   a single stripe; not the whole write */
>>  		if (rw & WRITE) {
>> -			return raid56_parity_write(root, bio, bbio,
>> -						   raid_map, map_length);
>> +			ret = raid56_parity_write(root, bio, bbio,
>> +						  raid_map, map_length);
>>  		} else {
>> -			return raid56_parity_recover(root, bio, bbio,
>> -						     raid_map, map_length,
>> -						     mirror_num);
>> +			ret = raid56_parity_recover(root, bio, bbio,
>> +						    raid_map, map_length,
>> +						    mirror_num);
>>  		}
>> +		/*
>> +		 * FIXME, replace dosen't support raid56 yet, please fix
>> +		 * it in the future.
>> +		 */
>> +		btrfs_bio_counter_dec(root->fs_info);
>> +		return ret;
>>  	}
>>  
>>  	if (map_length < length) {
>> @@ -5571,6 +5586,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
>>  				  async_submit);
>>  		dev_nr++;
>>  	}
>> +	btrfs_bio_counter_dec(root->fs_info);
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 8b3cd14..80754f9 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -192,6 +192,7 @@ typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
>>  
>>  struct btrfs_bio {
>>  	atomic_t stripes_pending;
>> +	struct btrfs_fs_info *fs_info;
>>  	bio_end_io_t *end_io;
>>  	struct bio *orig_bio;
>>  	void *private;
>>
> 
> 
> 

