Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdLRMwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:52:39 -0500
Subject: Re: [PATCH RESEND 1/2] btrfs: handle volume split brain scenario
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171217135247.1838-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <91c1bbc1-f543-b1e6-d9e4-4243db066bcc@suse.com>
Date: Mon, 18 Dec 2017 14:52:37 +0200
MIME-Version: 1.0
In-Reply-To: <20171217135247.1838-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.12.2017 15:52, Anand Jain wrote:
> In two device configs of RAID1/RAID5 where one device can be missing
> in the degraded mount, or in the configs such as four devices RAID6
> where two devices can be missing, in these type of configs it can form
> two separate set of devices where each of the set can be mounted without
> the other set. And if user does that and writes the data, one set would
> have to loose the data. As of now we just loose the data without the
> user consent depending on the SB generation number which user won't have
> any meaningful interpretations.

This is rather hard to parse something like:

In raid configs RAID1/RAID5/RAID6 it's possible to have some devices
missing which would render btrfs to be mounted in degraded state but
still be operational. In those cases it's possible (albeit highly
undesirable) that the degraded and missing parts of the filesystem are
mounted independently. When writes occur such split-brain scenarios
(caused by intentional user action) then one of the sides of the RAID
config will have to be blown away when bringing it back to the
consistent state.

> 
> This patch introduces a new SB flag BTRFS_SUPER_FLAG_VOL_MOVED_ON which
MOVED_ON sounds way too colloquial. something like VOL_FORCED_MOUNT,
VOL_PARTIAL_MOUNT.

Another thing which comes to mind is why not piggyback on the degraded
mount capabilities of the filesystem - is it just a mount option or do
we have a flag which indicates this volume was mounted in degraded mode?
If there is not flag perhaps name the flag VOL_DEGRADED_MOUNT?

> will be set when RAID group is mounted with missing device, so when RAID
> is mounted with no missing device and if all the devices contains this
> flag then we know that each of these set are mounted without the other
> set. In this scenario this patch will fail the mount so that user can
> decide which set would they prefer to keep the data.

This is also hard to parse

> 
> Now the procedure to assemble the disks would be to continue to mount
> the good set first without the device set on which new data can be
> ignored, and later run btrfs device scan to bring in the missing device
> and complete the RAID group which then shall reset the flag
> BTRFS_SUPER_FLAG_VOL_MOVED_ON.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> On top of kdave misc-next.
> 
>  fs/btrfs/disk-io.c              | 56 ++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.c              | 14 +++++++++--
>  include/uapi/linux/btrfs_tree.h |  1 +
>  3 files changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a3e9b74f6006..55bc6c846671 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -61,7 +61,8 @@
>  				 BTRFS_HEADER_FLAG_RELOC |\
>  				 BTRFS_SUPER_FLAG_ERROR |\
>  				 BTRFS_SUPER_FLAG_SEEDING |\
> -				 BTRFS_SUPER_FLAG_METADUMP)
> +				 BTRFS_SUPER_FLAG_METADUMP|\
> +				 BTRFS_SUPER_FLAG_VOL_MOVED_ON)
>  
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
> @@ -2383,6 +2384,43 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
>  	return 0;
>  }
>  
> +bool volume_has_split_brain(struct btrfs_fs_info *fs_info)
> +{
> +	unsigned long devs_moved_on = 0;
> +	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;

almost every other instance of the which iterates fs_devices uses the
full name of the temp variable fs_devices, let's do that here as well
for the sake of grep

> +	struct list_head *head = &fs_devs->devices;
> +	struct btrfs_device *dev;
> +
> +again:
> +	list_for_each_entry(dev, head, dev_list) {
> +		struct buffer_head *bh;
> +		struct btrfs_super_block *sb;
> +
> +		if (!dev->devid)
> +			continue;
> +
> +		bh = btrfs_read_dev_super(dev->bdev);
> +		if (IS_ERR(bh))
> +			continue;
> +
> +		sb = (struct btrfs_super_block *)bh->b_data;
> +		if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_VOL_MOVED_ON)
> +			devs_moved_on++;
> +		brelse(bh);
> +	}
> +
> +	fs_devs = fs_devs->seed;
> +	if (fs_devs) {
> +		head = &fs_devs->devices;
> +		goto again;
> +	}
> +
> +	if (devs_moved_on == fs_info->fs_devices->total_devices)
> +		return true;
> +	else
> +		return false;
> +}
> +
>  int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options)
> @@ -2872,6 +2910,22 @@ int open_ctree(struct super_block *sb,
>  		goto fail_sysfs;
>  	}
>  
> +	if (fs_info->fs_devices->missing_devices) {
> +		btrfs_set_super_flags(fs_info->super_copy,
> +			fs_info->super_copy->flags |
> +			BTRFS_SUPER_FLAG_VOL_MOVED_ON);
> +	} else if (fs_info->super_copy->flags &
> +			BTRFS_SUPER_FLAG_VOL_MOVED_ON) {
> +		if (volume_has_split_brain(fs_info)) {
> +			btrfs_err(fs_info,
> +				"Detected 'moved_on' flag on all device");
> +			goto fail_sysfs;
> +		}
> +		btrfs_set_super_flags(fs_info->super_copy,
> +			fs_info->super_copy->flags &
> +			~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
> +	}

Is there any specific reason why you place this check right before the
cleaner_kthread? If not I think it makes sense to be as close as
possible to btrfs_read_chunk_tree, since the information it uses is
populated by that function.

> +
>  	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>  					       "btrfs-cleaner");
>  	if (IS_ERR(fs_info->cleaner_kthread))
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 33e814ef992f..c08b9b89e285 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2057,8 +2057,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>  	device->fs_devices->num_devices--;
>  	device->fs_devices->total_devices--;
>  
> -	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
> +	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
>  		device->fs_devices->missing_devices--;
> +		if (!device->fs_devices->missing_devices)
> +			btrfs_set_super_flags(fs_info->super_copy,
> +				fs_info->super_copy->flags &
> +				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
> +	}
>  
>  	btrfs_assign_next_active_device(fs_info, device, NULL);
>  
> @@ -2132,8 +2137,13 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
>  	list_del_rcu(&srcdev->dev_list);
>  	list_del(&srcdev->dev_alloc_list);
>  	fs_devices->num_devices--;
> -	if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state))
> +	if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state)) {
>  		fs_devices->missing_devices--;
> +		if (!fs_devices->missing_devices)
> +			btrfs_set_super_flags(fs_info->super_copy,
> +				fs_info->super_copy->flags &
> +				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
> +	}
>  
>  	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
>  		fs_devices->rw_devices--;
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index 6d6e5da51527..a9f625be0589 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
>  
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_VOL_MOVED_ON	(1ULL << 36)
>  
>  
>  /*
> 
