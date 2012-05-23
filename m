Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab2EWBYf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 21:24:35 -0400
Message-ID: <4FBC3D68.4020400@cn.fujitsu.com>
Date: Wed, 23 May 2012 09:29:12 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] Btrfs: read device stats on mount, write modified
 ones during commit
References: <cover.1337682115.git.sbehrens@giantdisaster.de> <1b233fadc62813d5f9498d87e59a95559add4bf7.1337682115.git.sbehrens@giantdisaster.de>
In-Reply-To: <1b233fadc62813d5f9498d87e59a95559add4bf7.1337682115.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/22/2012 06:53 PM, Stefan Behrens wrote:

> The device statistics are written into the device tree with each
> transaction commit. Only modified statistics are written.
> When a filesystem is mounted, the device statistics for each involved
> device are read from the device tree and used to initialize the
> counters.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/ctree.h       |   51 ++++++++++++
>  fs/btrfs/disk-io.c     |    7 ++
>  fs/btrfs/print-tree.c  |    3 +
>  fs/btrfs/transaction.c |    4 +
>  fs/btrfs/volumes.c     |  205 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h     |    9 +++
>  6 files changed, 279 insertions(+)
> 
[...]
> +static int update_device_stat_item(struct btrfs_trans_handle *trans,
> +				   struct btrfs_root *dev_root,
> +				   struct btrfs_device *device)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct extent_buffer *eb;
> +	struct btrfs_device_stats_item *ptr;
> +	int ret;
> +
> +	key.objectid = 0;
> +	key.type = BTRFS_DEVICE_STATS_KEY;
> +	key.offset = device->devid;
> +
> +	path = btrfs_alloc_path();
> +	BUG_ON(!path);
> +	ret = btrfs_search_slot(trans, dev_root, &key, path, 0, 1);


Since we may delete this item, I prefer cow: -1,

btrfs_search_slot(trans, dev_root, &key, path, 0, -1);

thanks,
liubo

> +	if (ret < 0) {
> +		printk(KERN_WARNING "btrfs: error %d while searching for device_stats item for device %s!\n",
> +		       ret, device->name);
> +		goto out;
> +	}
> +
> +	if (ret == 0 &&
> +	    btrfs_item_size_nr(path->nodes[0], path->slots[0]) < sizeof(*ptr)) {
> +		/* need to delete old one and insert a new one */
> +		ret = btrfs_del_item(trans, dev_root, path);
> +		if (ret != 0) {
> +			printk(KERN_WARNING "btrfs: delete too small device_stats item for device %s failed %d!\n",
> +			       device->name, ret);
> +			goto out;
> +		}
> +		ret = 1;
> +	}
> +
> +	if (ret == 1) {
> +		/* need to insert a new item */
> +		btrfs_release_path(path);
> +		ret = btrfs_insert_empty_item(trans, dev_root, path,
> +					      &key, sizeof(*ptr));
> +		if (ret < 0) {
> +			printk(KERN_WARNING "btrfs: insert device_stats item for device %s failed %d!\n",
> +			       device->name, ret);
> +			goto out;
> +		}
> +	}
> +
> +	eb = path->nodes[0];
> +	ptr = btrfs_item_ptr(eb, path->slots[0],
> +			     struct btrfs_device_stats_item);
> +	btrfs_set_device_stats_cnt_write_io_errs(eb, ptr,
> +		btrfs_device_stat_read(&device->cnt_write_io_errs));
> +	btrfs_set_device_stats_cnt_read_io_errs(eb, ptr,
> +		btrfs_device_stat_read(&device->cnt_read_io_errs));
> +	btrfs_set_device_stats_cnt_flush_io_errs(eb, ptr,
> +		btrfs_device_stat_read(&device->cnt_flush_io_errs));
> +	btrfs_set_device_stats_cnt_corruption_errs(eb, ptr,
> +		btrfs_device_stat_read(&device->cnt_corruption_errs));
> +	btrfs_set_device_stats_cnt_generation_errs(eb, ptr,
> +		btrfs_device_stat_read(&device->cnt_generation_errs));
> +	btrfs_mark_buffer_dirty(eb);
> +
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +/*
> + * called from commit_transaction. Writes all changed device stats to disk.
> + */
> +int btrfs_run_device_stats(struct btrfs_trans_handle *trans,
> +			   struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_root *dev_root = fs_info->dev_root;
> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	struct btrfs_device *device;
> +	int ret = 0;
> +
> +	mutex_lock(&fs_devices->device_list_mutex);
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +		if (!device->device_stats_valid || !device->device_stats_dirty)
> +			continue;
> +
> +		ret = update_device_stat_item(trans, dev_root, device);
> +		if (!ret)
> +			device->device_stats_dirty = 0;
> +	}
> +	mutex_unlock(&fs_devices->device_list_mutex);
> +
> +	return ret;
> +}
> +
>  void btrfs_device_stat_print_on_error(struct btrfs_device *device)
>  {
> +	if (!device->device_stats_valid)
> +		return;
>  	printk_ratelimited(KERN_ERR
>  			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
>  			   device->name,
> @@ -4639,6 +4828,18 @@ void btrfs_device_stat_print_on_error(struct btrfs_device *device)
>  				&device->cnt_generation_errs));
>  }
>  
> +static void btrfs_device_stat_print_on_load(struct btrfs_device *device)
> +{
> +	printk(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u,"
> +	       " corrupt %u, gen %u\n",
> +	       device->name,
> +	       btrfs_device_stat_read(&device->cnt_write_io_errs),
> +	       btrfs_device_stat_read(&device->cnt_read_io_errs),
> +	       btrfs_device_stat_read(&device->cnt_flush_io_errs),
> +	       btrfs_device_stat_read(&device->cnt_corruption_errs),
> +	       btrfs_device_stat_read(&device->cnt_generation_errs));
> +}
> +
>  int btrfs_get_device_stats(struct btrfs_root *root,
>  			   struct btrfs_ioctl_get_device_stats *stats,
>  			   int reset_after_read)
> @@ -4654,6 +4855,10 @@ int btrfs_get_device_stats(struct btrfs_root *root,
>  		printk(KERN_WARNING
>  		       "btrfs: get device_stats failed, device not found\n");
>  		return -ENODEV;
> +	} else if (!dev->device_stats_valid) {
> +		printk(KERN_WARNING
> +		       "btrfs: get device_stats failed, not yet valid\n");
> +		return -ENODEV;
>  	} else if (reset_after_read) {
>  		if (stats->nr_items >= 1)
>  			stats->cnt_write_io_errs =
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index e0b31f1..3134662 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -108,6 +108,7 @@ struct btrfs_device {
>  
>  	/* disk I/O failure stats. For detailed description refer to
>  	 * struct btrfs_device_stats_item in ctree.h */
> +	int device_stats_valid;
>  	int device_stats_dirty; /* counters need to be written to disk */
>  	atomic_t cnt_write_io_errs;
>  	atomic_t cnt_read_io_errs;
> @@ -291,6 +292,9 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
>  			 u64 *start, u64 *max_avail);
>  struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
>  						   u64 logical, int mirror_num);
> +int btrfs_init_device_stats(struct btrfs_fs_info *fs_info);
> +int btrfs_run_device_stats(struct btrfs_trans_handle *trans,
> +			   struct btrfs_fs_info *fs_info);
>  void btrfs_device_stat_print_on_error(struct btrfs_device *device);
>  int btrfs_get_device_stats(struct btrfs_root *root,
>  			   struct btrfs_ioctl_get_device_stats *stats,
> @@ -315,4 +319,9 @@ static inline void btrfs_device_stat_reset(atomic_t *cnt)
>  {
>  	atomic_set(cnt, 0);
>  }
> +
> +static inline void btrfs_device_stat_set(atomic_t *cnt, unsigned long val)
> +{
> +	atomic_set(cnt, val);
> +}
>  #endif


