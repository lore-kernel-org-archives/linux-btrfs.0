Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22117 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdKHTqT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Nov 2017 14:46:19 -0500
Date: Wed, 8 Nov 2017 11:46:13 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: introduce device flags
Message-ID: <20171108194612.GA14443@dhcp-10-11-181-32.int.fusionio.com>
Reply-To: bo.li.liu@oracle.com
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-2-bo.li.liu@oracle.com>
 <20171106164025.GO28789@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106164025.GO28789@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 05:40:25PM +0100, David Sterba wrote:
> On Wed, Nov 01, 2017 at 06:54:02PM -0600, Liu Bo wrote:
> > Here we have defined two flags,
> > - Fautly
> > - In_sync
> > 
> > Currently only In_sync is in use, it only matters when device serves
> > as part of a raid profile.  The flag In_sync is decided when mounting
> > a btrfs and opening a device, by default every device is set with
> > In_sync, but would not be set if its generation was out of date.
> > 
> > If the device doesn't get resync and to avoid overriding its
> > generation during writing superblock, if the !In_sync device is still
> > writeable, its last valid generation will be recorded in
> > superblock.dev_item.generation instead of superblock.generation, such
> > that the last valid generation can be retained through several reboot,
> > btrfs is able to detect the out-of-sync device.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/disk-io.c | 21 ++++++++++++++++++++-
> >  fs/btrfs/volumes.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
> >  fs/btrfs/volumes.h |  8 ++++++++
> >  3 files changed, 72 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 487bbe4..a080d58 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3640,6 +3640,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >  	int do_barriers;
> >  	int max_errors;
> >  	int total_errors = 0;
> > +	u64 generation;
> >  	u64 flags;
> >  
> >  	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
> > @@ -3671,7 +3672,25 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >  		if (!dev->in_fs_metadata || !dev->writeable)
> >  			continue;
> >  
> > -		btrfs_set_stack_device_generation(dev_item, 0);
> > +		/*
> > +		 * if dev is not in_sync, record the last valid
> > +		 * generation.
> > +		 *
> > +		 * This is used to detect !In_sync device after
> > +		 * reboot, now we check a device's In_sync status by
> > +		 * comparing its superblock->dev_item->generation with
> > +		 * the latest one.
> > +		 *
> > +		 * We don't compare superblock->generation because
> > +		 * after reboot and a successfuly superblock writing,
> > +		 * generation in superblock will be updated.
> > +		 */
> 
> Please format the comments to 80 columns, and use first capital letter
> if it's a stentence.

OK.

> 
> > +		if (!test_bit(In_sync, &dev->flags))
> > +			generation = dev->generation;
> > +		else
> > +			generation = 0;
> > +		btrfs_set_stack_device_generation(dev_item, generation);
> 
> Can generation == 0 possibly confuse older kernels that will not have
> this patch?
>

It is safe, the default value from dev_item.generation is always 0 in
old kernels, and old kernels don't check it at all.

> > +
> >  		btrfs_set_stack_device_type(dev_item, dev->type);
> >  		btrfs_set_stack_device_id(dev_item, dev->devid);
> >  		btrfs_set_stack_device_total_bytes(dev_item,
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 0e8f16c..7b29b1a 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -250,6 +250,7 @@ static struct btrfs_device *__alloc_device(void)
> >  	btrfs_device_data_ordered_init(dev);
> >  	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> >  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> > +	ASSERT(dev->flags == 0);
> 
> I think you can drop this,  the whole structure is zeroed a few lines
> above.
>

Make sense.

> >  
> >  	return dev;
> >  }
> > @@ -1003,10 +1004,32 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
> >  			   BTRFS_UUID_SIZE))
> >  			goto error_brelse;
> >  
> > -		device->generation = btrfs_super_generation(disk_super);
> > -		if (!latest_dev ||
> > -		    device->generation > latest_dev->generation)
> > +		if (btrfs_stack_device_generation(&disk_super->dev_item) == 0)
> > +			device->generation = btrfs_super_generation(disk_super);
> > +		else
> > +			device->generation =
> > +				btrfs_stack_device_generation(&disk_super->dev_item);
> > +
> > +		/* no lock is required during the initial stage. */
> > +		if (!latest_dev) {
> > +			set_bit(In_sync, &device->flags);
> >  			latest_dev = device;
> > +		} else {
> > +			if (device->generation > latest_dev->generation) {
> > +				set_bit(In_sync, &device->flags);
> > +				clear_bit(In_sync, &latest_dev->flags);
> > +				latest_dev = device;
> > +			} else if (device->generation == latest_dev->generation) {
> > +				set_bit(In_sync, &device->flags);
> > +			}
> > +			/*
> > +			 * if (device->generation < latest_dev->generation)
> > +			 *	# don't set In_sync
> > +			 */
> > +		}
> > +
> > +		if (!test_bit(In_sync, &device->flags))
> > +			pr_info("dev %s gen %llu is not In_sync\n", device->name->str, device->generation);
> >  
> >  		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
> >  			device->writeable = 0;
> > @@ -2379,6 +2402,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
> >  	q = bdev_get_queue(bdev);
> >  	if (blk_queue_discard(q))
> >  		device->can_discard = 1;
> > +	set_bit(In_sync, &device->flags);
> >  	device->writeable = 1;
> >  	device->generation = trans->transid;
> >  	device->io_width = fs_info->sectorsize;
> > @@ -2599,6 +2623,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
> >  	device->dev_stats_valid = 1;
> >  	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
> >  	device->fs_devices = fs_info->fs_devices;
> > +	set_bit(In_sync, &device->flags);
> >  	list_add(&device->dev_list, &fs_info->fs_devices->devices);
> >  	fs_info->fs_devices->num_devices++;
> >  	fs_info->fs_devices->open_devices++;
> > @@ -6450,6 +6475,14 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
> >  			btrfs_report_missing_device(fs_info, devid, uuid);
> >  			return -EIO;
> >  		}
> > +		if (map->stripes[i].dev &&
> > +		    !test_bit(In_sync, &map->stripes[i].dev->flags) &&
> > +		    !btrfs_test_opt(fs_info, DEGRADED)) {
> > +			btrfs_warn(fs_info, "devid %llu uuid %pU is Not in_sync, but we're not under degraded mode",
> 
> Please move the string to the next line and un-indent until it fits 80
> columns line.

OK.

> 
> > +				   devid, uuid);
> > +			free_extent_map(em);
> > +			return -EIO;
> > +		}
> >  		if (!map->stripes[i].dev) {
> >  			map->stripes[i].dev =
> >  				add_missing_dev(fs_info->fs_devices, devid,
> > @@ -6592,6 +6625,14 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
> >  				return -EIO;
> >  		}
> >  
> > +		if (!test_bit(In_sync, &device->flags) &&
> > +		    !btrfs_test_opt(fs_info, DEGRADED)) {
> > +			btrfs_warn(fs_info,
> > +				   "devid %llu uuid %pU is Not in_sync, but we're not under degraded mode",
> > +				   devid, dev_uuid);
> > +			return -EIO;
> > +		}
> > +
> >  		if(!device->bdev && !device->missing) {
> >  			/*
> >  			 * this happens when a device that was properly setup
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 6108fdf..65b928c 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -69,6 +69,9 @@ struct btrfs_device {
> >  	/* the mode sent to blkdev_get */
> >  	fmode_t mode;
> >  
> > +	/* bit set of 'enum flag_bits' bit  */
> > +	unsigned long flags;
> > +
> >  	int writeable;
> >  	int in_fs_metadata;
> >  	int missing;
> 
> It would be good if you first make a generic member 'flags', and convert
> writeable/in_fs_metadata/missing/... to that and add the sync flags
> later.
>

Sounds good.

> > @@ -261,6 +264,11 @@ struct btrfs_fs_devices {
> >  	struct completion kobj_unregister;
> >  };
> >  
> > +enum flag_bits {
> 
> This name is too generic.

Will add a 'btrfs_device' prefix.

> 
> > +	Faulty,		/* device is known to have a fault */
> > +	In_sync,	/* device is in_sync with rest of array */
> 
> Enums usually are all caps, and with some prefix.
>

Well, copied from md... I'll make it all caps, but no prefix name
seems better to me.

Thanks,

-liubo
