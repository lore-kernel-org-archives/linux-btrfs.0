Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40975 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbeHJPpy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 11:45:54 -0400
Date: Fri, 10 Aug 2018 22:15:58 +0900
From: Naohiro Aota <naota@elisp.net>
To: Hannes Reinecke <hare@suse.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>
Subject: Re: [RFC PATCH 03/17] btrfs: Check and enable HMZONED mode
Message-ID: <20180810131558.gadsij5g7tshfg5u@zazie>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809180450.5091-4-naota@elisp.net>
 <51ed0d0b-7574-b9a9-bae5-2cc8042913e6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51ed0d0b-7574-b9a9-bae5-2cc8042913e6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 02:25:33PM +0200, Hannes Reinecke wrote:
> On 08/09/2018 08:04 PM, Naohiro Aota wrote:
> > HMZONED mode cannot be used together with the RAID5/6 profile. Introduce
> > the function btrfs_check_hmzoned_mode() to check this. This function will
> > also check if HMZONED flag is enabled on the file system and if the file
> > system consists of zoned devices with equal zone size.
> > 
> > Additionally, as updates to the space cache are in-place, the space cache
> > cannot be located over sequential zones and there is no guarantees that the
> > device will have enough conventional zones to store this cache. Resolve
> > this problem by disabling completely the space cache.  This does not
> > introduces any problems with sequential block groups: all the free space is
> > located after the allocation pointer and no free space before the pointer.
> > There is no need to have such cache.
> > 
> > Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> > Signed-off-by: Naohiro Aota <naota@elisp.net>
> > ---
> >  fs/btrfs/ctree.h       |  3 ++
> >  fs/btrfs/dev-replace.c |  7 ++++
> >  fs/btrfs/disk-io.c     |  7 ++++
> >  fs/btrfs/super.c       | 12 +++---
> >  fs/btrfs/volumes.c     | 87 ++++++++++++++++++++++++++++++++++++++++++
> >  fs/btrfs/volumes.h     |  1 +
> >  6 files changed, 112 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 66f1d3895bca..14f880126532 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -763,6 +763,9 @@ struct btrfs_fs_info {
> >  	struct btrfs_root *uuid_root;
> >  	struct btrfs_root *free_space_root;
> >  
> > +	/* Zone size when in HMZONED mode */
> > +	u64 zone_size;
> > +
> >  	/* the log root tree is a directory of all the other log roots */
> >  	struct btrfs_root *log_root_tree;
> >  
> > diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> > index dec01970d8c5..839a35008fd8 100644
> > --- a/fs/btrfs/dev-replace.c
> > +++ b/fs/btrfs/dev-replace.c
> > @@ -202,6 +202,13 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
> >  		return PTR_ERR(bdev);
> >  	}
> >  
> > +	if ((bdev_zoned_model(bdev) == BLK_ZONED_HM &&
> > +	     !btrfs_fs_incompat(fs_info, HMZONED)) ||
> > +	    (!bdev_is_zoned(bdev) && btrfs_fs_incompat(fs_info, HMZONED))) {
> > +		ret = -EINVAL;
> > +		goto error;
> > +	}
> > +
> >  	filemap_write_and_wait(bdev->bd_inode->i_mapping);
> >  
> >  	devices = &fs_info->fs_devices->devices;
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 5124c15705ce..14f284382ba7 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3057,6 +3057,13 @@ int open_ctree(struct super_block *sb,
> >  
> >  	btrfs_free_extra_devids(fs_devices, 1);
> >  
> > +	ret = btrfs_check_hmzoned_mode(fs_info);
> > +	if (ret) {
> > +		btrfs_err(fs_info, "failed to init hmzoned mode: %d",
> > +				ret);
> > +		goto fail_block_groups;
> > +	}
> > +
> >  	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
> >  	if (ret) {
> >  		btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 5fdd95e3de05..cc812e459197 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -435,11 +435,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >  	bool saved_compress_force;
> >  	int no_compress = 0;
> >  
> > -	cache_gen = btrfs_super_cache_generation(info->super_copy);
> > -	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
> > -		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
> > -	else if (cache_gen)
> > -		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> > +	if (!btrfs_fs_incompat(info, HMZONED)) {
> > +		cache_gen = btrfs_super_cache_generation(info->super_copy);
> > +		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
> > +			btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
> > +		else if (cache_gen)
> > +			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
> > +	}
> >  
> >  	/*
> >  	 * Even the options are empty, we still need to do extra check
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 35b3a2187653..ba7ebb80de4d 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1293,6 +1293,80 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
> >  	return ret;
> >  }
> >  
> > +int btrfs_check_hmzoned_mode(struct btrfs_fs_info *fs_info)
> > +{
> > +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> > +	struct btrfs_device *device;
> > +	u64 hmzoned_devices = 0;
> > +	u64 nr_devices = 0;
> > +	u64 zone_size = 0;
> > +	int incompat_hmzoned = btrfs_fs_incompat(fs_info, HMZONED);
> > +	int ret = 0;
> > +
> > +	/* Count zoned devices */
> > +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> > +		if (!device->bdev)
> > +			continue;
> > +		if (bdev_zoned_model(device->bdev) == BLK_ZONED_HM ||
> > +		    (bdev_zoned_model(device->bdev) == BLK_ZONED_HA &&
> > +		     incompat_hmzoned)) {
> > +			hmzoned_devices++;
> > +			if (!zone_size) {
> > +				zone_size = device->zone_size;
> > +			} else if (device->zone_size != zone_size) {
> > +				btrfs_err(fs_info,
> > +					  "Zoned block devices must have equal zone sizes");
> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +		}
> > +		nr_devices++;
> > +	}
> > +
> > +	if (!hmzoned_devices && incompat_hmzoned) {
> > +		/* No zoned block device, disable HMZONED */
> > +		btrfs_err(fs_info, "HMZONED enabled file system should have zoned devices");
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	fs_info->zone_size = zone_size;
> > +
> > +	if (hmzoned_devices != nr_devices) {
> > +		btrfs_err(fs_info,
> > +			  "zoned devices mixed with regular devices");
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> This breaks existing setups; as we're not checking if the device
> specified by fs_info is a zoned device we'll fail here for normal devices.

Ah, I forgot to deel with the normal devices when I convert HMZONED
mount flag to incompat flag.

> You need this patch to fix it:

Thank you for fixing this. It's exactly what I wanted to do. I'll fix
in the next version.

Regards,
Naohiro

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 43eaf0142062..8609776c9a9e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1314,6 +1314,9 @@ int btrfs_check_hmzoned_mode(struct btrfs_fs_info
> *fs_info)
>         int incompat_hmzoned = btrfs_fs_incompat(fs_info, HMZONED);
>         int ret = 0;
> 
> +       if (!incompat_hmzoned)
> +               return 0;
> +
>         /* Count zoned devices */
>         list_for_each_entry(device, &fs_devices->devices, dev_list) {
>                 if (!device->bdev)
> 
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.com			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)
