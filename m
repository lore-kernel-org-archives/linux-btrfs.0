Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbcEBP0f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 11:26:35 -0400
Date: Mon, 2 May 2016 17:26:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: cleanup assigning next active device with a
 check
Message-ID: <20160502152618.GK29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 07:02:08AM +0800, Anand Jain wrote:
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -569,11 +569,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	ASSERT(list_empty(&src_device->resized_list));
>  	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
>  	tgt_device->commit_bytes_used = src_device->bytes_used;
> -	if (fs_info->sb->s_bdev &&
> -		(fs_info->sb->s_bdev == src_device->bdev))
> -		fs_info->sb->s_bdev = tgt_device->bdev;

What's the base of this patch? The above code is not in my for-next so
I could be missing some important bits.

> -	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
> -		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
> +
> +	btrfs_assign_next_active_device(fs_info, src_device, tgt_device);
> +
>  	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>  	fs_info->fs_devices->rw_devices++;
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5f70c1235466..0bb15da2da40 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1742,10 +1742,49 @@ out:
>  	return ret;
>  }
>  
> +struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
> +					struct btrfs_device *device)
> +{
> +	struct btrfs_device *next_device;
> +
> +	list_for_each_entry(next_device, &fs_devs->devices, dev_list) {
> +		if (next_device != device &&
> +			!next_device->missing && next_device->bdev)
> +			return next_device;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Helper function to check if the given device is part of
> + * s_bdev / latest_bdev and replace it with the provided or
> + * the next active device, in the context where this function
> + * called, there should be always be another device which is
> + * active.
> + */
> +void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> +		struct btrfs_device *device, struct btrfs_device *this_dev)
> +{
> +	struct btrfs_device *next_device;
> +
> +	if (this_dev)
> +		next_device = this_dev;
> +	else
> +		next_device = btrfs_find_next_active_device(fs_info->fs_devices,
> +								device);
> +	BUG_ON(!next_device); /* Logic error */

Please make it an ASSERT.
