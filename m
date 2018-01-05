Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751809AbeAEOLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 09:11:23 -0500
Date: Fri, 5 Jan 2018 15:09:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: make code easy to read in
 btrfs_open_one_device()
Message-ID: <20180105140915.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171215074016.26461-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171215074016.26461-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 03:40:14PM +0800, Anand Jain wrote:
> No functional change. First set the usual case, writeable then check
> for any special config.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5a4c30451c7f..a81574dba124 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -676,14 +676,12 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>  
>  	device->generation = btrfs_super_generation(disk_super);
>  
> +	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);

I would not say there's no functional change. This line will
unconditionally set the writeable flag, but this was not the case
before.

Sure it's dropped a few lines below, but this would need some checking
that it's not a problem. btrfs_open_one_device is indirectly called from
mount so it should be safe (we can't use one device twice), but this
needs to be documented.

>  	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
>  		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  		fs_devices->seeding = 1;
> -	} else {
> -		if (bdev_read_only(bdev))
> -			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
> -		else
> -			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
> +	} else if (bdev_read_only(bdev)) {
> +		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  	}
>  
>  	q = bdev_get_queue(bdev);
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
