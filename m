Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830AbaGXNpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:45:51 -0400
Date: Thu, 24 Jul 2014 15:45:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] Btrfs: Fix the problem that the dirty flag of dev
 stats is cleared
Message-ID: <20140724134549.GD1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
 <1406173035-29478-6-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406173035-29478-6-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:37:11AM +0800, Miao Xie wrote:
> The io error might happen during writing out the device stats, and the
> device stats information and dirty flag would be update at that time,
> but the current code didn't consider this case, just clear the dirty
> flag, it would cause that we forgot to write out the new device stats
> information. Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c |  7 +++++--
>  fs/btrfs/volumes.h | 19 +++++++++++++++----
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 19188df..0d37746 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -159,6 +159,7 @@ static struct btrfs_device *__alloc_device(void)
>  
>  	spin_lock_init(&dev->reada_lock);
>  	atomic_set(&dev->reada_in_flight, 0);
> +	atomic_set(&dev->dev_stats_ccnt, 0);
>  	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_WAIT);
>  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_WAIT);
>  
> @@ -6398,16 +6399,18 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *dev_root = fs_info->dev_root;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>  	struct btrfs_device *device;
> +	int stats_cnt;
>  	int ret = 0;
>  
>  	mutex_lock(&fs_devices->device_list_mutex);
>  	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> -		if (!device->dev_stats_valid || !device->dev_stats_dirty)
> +		if (!device->dev_stats_valid || !btrfs_dev_stats_dirty(device))

The helper btrfs_dev_stats_dirty is used only once and IMHO not
necessary.
>  			continue;
>  
> +		stats_cnt = atomic_read(&device->dev_stats_ccnt);

Here it is opencoded anyway.

>  		ret = update_dev_stat_item(trans, dev_root, device);
>  		if (!ret)
> -			device->dev_stats_dirty = 0;
> +			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6fcc8ea..0defd23 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -110,7 +110,9 @@ struct btrfs_device {
>  	/* disk I/O failure stats. For detailed description refer to
>  	 * enum btrfs_dev_stat_values in ioctl.h */
>  	int dev_stats_valid;
> -	int dev_stats_dirty; /* counters need to be written to disk */
> +
> +	/* Counter to record the change of device stats */
> +	atomic_t dev_stats_ccnt;

dev_stats_dirty is more descriptive, please keep it. The counter
semantics can be documented here.

>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
>  };
>  
> @@ -359,11 +361,18 @@ unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
>  int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *extent_root,
>  				u64 chunk_offset, u64 chunk_size);
> +
> +static inline int btrfs_dev_stats_dirty(struct btrfs_device *dev)
> +{
> +	return atomic_read(&dev->dev_stats_ccnt);

IMHO too trivial, not necessary.

> +}
> +
>  static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
>  				      int index)
>  {
>  	atomic_inc(dev->dev_stat_values + index);
> -	dev->dev_stats_dirty = 1;

> +	smp_mb__before_atomic();
> +	atomic_inc(&dev->dev_stats_ccnt);

Please put the two lines into a wrapper, 3 times repeating the same is
worth it.

> @@ -378,7 +387,8 @@ static inline int btrfs_dev_stat_read_and_reset(struct btrfs_device *dev,
>  	int ret;
>  
>  	ret = atomic_xchg(dev->dev_stat_values + index, 0);
> -	dev->dev_stats_dirty = 1;
> +	smp_mb__before_atomic();
> +	atomic_inc(&dev->dev_stats_ccnt);

> @@ -386,7 +396,8 @@ static inline void btrfs_dev_stat_set(struct btrfs_device *dev,
>  				      int index, unsigned long val)
>  {
>  	atomic_set(dev->dev_stat_values + index, val);
> -	dev->dev_stats_dirty = 1;
> +	smp_mb__before_atomic();
> +	atomic_inc(&dev->dev_stats_ccnt);
