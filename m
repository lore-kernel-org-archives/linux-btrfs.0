Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:51891 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2KHRYj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 12:24:39 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (josoe mo17) (RZmta 31.2 AUTH)
	with ESMTPA id w05958oA8GZxW9 for <linux-btrfs@vger.kernel.org>;
	Thu, 8 Nov 2012 18:24:37 +0100 (CET)
Message-ID: <509BEAD4.8070309@giantdisaster.de>
Date: Thu, 08 Nov 2012 18:24:36 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/26] Btrfs: add a new source file with device replace
 code
References: <cover.1352217243.git.sbehrens@giantdisaster.de> <4520a248e2bcf0493b35673ea4cac2d4e0757e08.1352217243.git.sbehrens@giantdisaster.de> <20121108145038.GB3034@gmail.com>
In-Reply-To: <20121108145038.GB3034@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Nov 2012 22:50:47 +0800, Liu Bo wrote:
> On Tue, Nov 06, 2012 at 05:38:33PM +0100, Stefan Behrens wrote:

>> +out:
>> +	if (path) {
>> +		btrfs_release_path(path);
>> +		btrfs_free_path(path);
> 
> btrfs_free_path(path) will do release for you :)
> 

Right :) Thanks.


>> +int btrfs_dev_replace_start(struct btrfs_root *root,
>> +			    struct btrfs_ioctl_dev_replace_args *args)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>> +	int ret;
>> +	struct btrfs_device *tgt_device = NULL;
>> +	struct btrfs_device *src_device = NULL;
>> +
>> +	switch (args->start.cont_reading_from_srcdev_mode) {
>> +	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS:
>> +	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	if ((args->start.srcdevid == 0 && args->start.srcdev_name[0] == '\0') ||
>> +	    args->start.tgtdev_name[0] == '\0')
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&fs_info->volume_mutex);
>> +	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
>> +					    &tgt_device);
>> +	if (ret) {
>> +		pr_err("btrfs: target device %s is invalid!\n",
>> +		       args->start.tgtdev_name);
>> +		mutex_unlock(&fs_info->volume_mutex);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
>> +					    args->start.srcdev_name,
>> +					    &src_device);
>> +	mutex_unlock(&fs_info->volume_mutex);
>> +	if (ret) {
>> +		ret = -EINVAL;
>> +		goto leave_no_lock;
>> +	}
>> +
>> +	if (tgt_device->total_bytes < src_device->total_bytes) {
>> +		pr_err("btrfs: target device is smaller than source device!\n");
>> +		ret = -EINVAL;
>> +		goto leave_no_lock;
>> +	}
>> +
>> +	btrfs_dev_replace_lock(dev_replace);
>> +	switch (dev_replace->replace_state) {
>> +	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
>> +	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
>> +	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
>> +		break;
>> +	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
>> +	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>> +		args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED;
>> +		goto leave;
>> +	}
>> +
>> +	dev_replace->cont_reading_from_srcdev_mode =
>> +		args->start.cont_reading_from_srcdev_mode;
>> +	WARN_ON(!src_device);
>> +	dev_replace->srcdev = src_device;
>> +	WARN_ON(!tgt_device);
>> +	dev_replace->tgtdev = tgt_device;
>> +
>> +	tgt_device->total_bytes = src_device->total_bytes;
>> +	tgt_device->disk_total_bytes = src_device->disk_total_bytes;
>> +	tgt_device->bytes_used = src_device->bytes_used;
>> +
>> +	/*
>> +	 * from now on, the writes to the srcdev are all duplicated to
>> +	 * go to the tgtdev as well (refer to btrfs_map_block()).
>> +	 */
>> +	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED;
>> +	dev_replace->time_started = btrfs_get_seconds_since_1970();
>> +	dev_replace->cursor_left = 0;
>> +	dev_replace->committed_cursor_left = 0;
>> +	dev_replace->cursor_left_last_write_of_item = 0;
>> +	dev_replace->cursor_right = 0;
>> +	dev_replace->is_valid = 1;
>> +	dev_replace->item_needs_writeback = 1;
>> +	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>> +	btrfs_dev_replace_unlock(dev_replace);
>> +
>> +	btrfs_wait_ordered_extents(root, 0);
>> +
>> +	/* force writing the updated state information to disk */
>> +	trans = btrfs_start_transaction(root, 0);
> 
> why a start_transaction here?  Any reasons?
> (same question also for some other places)
> 

Without this transaction, there is outstanding I/O which is not flushed.
Pending writes that go only to the old disk need to be flushed before
the mode is switched to write all live data to the source disk and to
the target disk as well. The copy operation that is part of the scrub
code works on the commit root for performance reasons. Every write
request that is performed after the commit root is established needs to
go to both disks. Those requests that already have the bdev assigned
(i.e., btrfs_map_bio() was already called) cannot be duplicated anymore
to write to the new disk as well.

btrfs_dev_replace_finishing() looks similar and goes through a
transaction commit between the steps where the bdev in the mapping tree
is swapped and the step when the old bdev is freed. Otherwise the bdev
would be accessed after being freed.


>> +	if (IS_ERR(trans)) {
>> +		ret = PTR_ERR(trans);
>> +		btrfs_dev_replace_lock(dev_replace);
>> +		goto leave;
>> +	}
>> +
>> +	ret = btrfs_commit_transaction(trans, root);
>> +	WARN_ON(ret);
>> +
>> +	/* the disk copy procedure reuses the scrub code */
>> +	ret = btrfs_scrub_dev(fs_info, src_device->devid, 0,
>> +			      src_device->total_bytes,
>> +			      &dev_replace->scrub_progress, 0, 1);
>> +
>> +	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
>> +	WARN_ON(ret);
>> +
>> +	return 0;
>> +
>> +leave:
>> +	dev_replace->srcdev = NULL;
>> +	dev_replace->tgtdev = NULL;
>> +	btrfs_dev_replace_unlock(dev_replace);
>> +leave_no_lock:
>> +	if (tgt_device)
>> +		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
>> +	return ret;
>> +}
>> +
>> +static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>> +				       int scrub_ret)
>> +{
>> +	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>> +	struct btrfs_device *tgt_device;
>> +	struct btrfs_device *src_device;
>> +	struct btrfs_root *root = fs_info->tree_root;
>> +	u8 uuid_tmp[BTRFS_UUID_SIZE];
>> +	struct btrfs_trans_handle *trans;
>> +	int ret = 0;
>> +
>> +	/* don't allow cancel or unmount to disturb the finishing procedure */
>> +	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
>> +
>> +	btrfs_dev_replace_lock(dev_replace);
>> +	/* was the operation canceled, or is it finished? */
>> +	if (dev_replace->replace_state !=
>> +	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
>> +		btrfs_dev_replace_unlock(dev_replace);
>> +		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>> +		return 0;
>> +	}
>> +
>> +	tgt_device = dev_replace->tgtdev;
>> +	src_device = dev_replace->srcdev;
>> +	btrfs_dev_replace_unlock(dev_replace);
>> +
>> +	/* replace old device with new one in mapping tree */
>> +	if (!scrub_ret)
>> +		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
>> +								src_device,
>> +								tgt_device);
>> +
>> +	/*
>> +	 * flush all outstanding I/O and inode extent mappings before the
>> +	 * copy operation is declared as being finished
>> +	 */
>> +	btrfs_start_delalloc_inodes(root, 0);
>> +	btrfs_wait_ordered_extents(root, 0);
>> +
>> +	trans = btrfs_start_transaction(root, 0);
>> +	if (IS_ERR(trans)) {
>> +		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>> +		return PTR_ERR(trans);
>> +	}
>> +	ret = btrfs_commit_transaction(trans, root);
>> +	WARN_ON(ret);
>> +
>> +	/* keep away write_all_supers() during the finishing procedure */
>> +	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
>> +	btrfs_dev_replace_lock(dev_replace);
>> +	dev_replace->replace_state =
>> +		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
>> +			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
>> +	dev_replace->tgtdev = NULL;
>> +	dev_replace->srcdev = NULL;
>> +	dev_replace->time_stopped = btrfs_get_seconds_since_1970();
>> +	dev_replace->item_needs_writeback = 1;
>> +
>> +	if (scrub_ret) {
>> +		printk_in_rcu(KERN_ERR
>> +			      "btrfs: btrfs_scrub_dev(%s, %llu, %s) failed %d\n",
>> +			      rcu_str_deref(src_device->name),
>> +			      src_device->devid,
>> +			      rcu_str_deref(tgt_device->name), scrub_ret);
>> +		btrfs_dev_replace_unlock(dev_replace);
>> +		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>> +		if (tgt_device)
>> +			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
>> +		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>> +
>> +		return 0;
>> +	}
>> +
>> +	tgt_device->is_tgtdev_for_dev_replace = 0;
>> +	tgt_device->devid = src_device->devid;
>> +	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
>> +	tgt_device->bytes_used = src_device->bytes_used;
>> +	memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
>> +	memcpy(tgt_device->uuid, src_device->uuid, sizeof(tgt_device->uuid));
>> +	memcpy(src_device->uuid, uuid_tmp, sizeof(src_device->uuid));
>> +	tgt_device->total_bytes = src_device->total_bytes;
>> +	tgt_device->disk_total_bytes = src_device->disk_total_bytes;
>> +	tgt_device->bytes_used = src_device->bytes_used;
>> +	if (fs_info->sb->s_bdev == src_device->bdev)
>> +		fs_info->sb->s_bdev = tgt_device->bdev;
>> +	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
>> +		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>> +	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>> +
>> +	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
>> +	if (src_device->bdev) {
>> +		/* zero out the old super */
>> +		btrfs_scratch_superblock(src_device);
>> +	}
>> +	/*
>> +	 * this is again a consistent state where no dev_replace procedure
>> +	 * is running, the target device is part of the filesystem, the
>> +	 * source device is not part of the filesystem anymore and its 1st
>> +	 * superblock is scratched out so that it is no longer marked to
>> +	 * belong to this filesystem.
>> +	 */
>> +	btrfs_dev_replace_unlock(dev_replace);
>> +	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>> +
>> +	/* write back the superblocks */
>> +	trans = btrfs_start_transaction(root, 0);
>> +	if (!IS_ERR(trans))
>> +		btrfs_commit_transaction(trans, root);
>> +
>> +	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>> +
>> +	return 0;
>> +}

