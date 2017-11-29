Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdK2JjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 04:39:21 -0500
Subject: Re: [PATCH 4/4] btrfs: cleanup device states define
 BTRFS_DEV_STATE_CAN_DISCARD
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
References: <20171129044536.16260-1-anand.jain@oracle.com>
 <20171129044536.16260-5-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5a15e05f-c3f3-2602-fe22-c2c86d5423c2@suse.com>
Date: Wed, 29 Nov 2017 11:39:18 +0200
MIME-Version: 1.0
In-Reply-To: <20171129044536.16260-5-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.11.2017 06:45, Anand Jain wrote:
> Currently device state is being managed by each individual int
> variable such as struct btrfs_device::can_discard. Instead of that
> declare btrfs_device::dev_state BTRFS_DEV_STATE_CAN_DISCARD and use
> the bit operations.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  fs/btrfs/volumes.c     | 6 +++---
>  fs/btrfs/volumes.h     | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f81d928754e1..ee79f7cdc543 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2155,7 +2155,8 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>  
>  		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
>  			u64 bytes;
> -			if (!stripe->dev->can_discard)
> +			if (!test_bit(BTRFS_DEV_STATE_CAN_DISCARD,
> +						&stripe->dev->dev_state))
>  				continue;

Given that we only check for discard support here I can't help but think
do we really need to duplicate the information. We already have struct
block_device in struct btrfs_device, why don't we query for discard
support directly the underlying device, rather than duplicating
information?

>  
>  			ret = btrfs_issue_discard(stripe->dev->bdev,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 75839e07ce10..a9c6486f06f4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -647,7 +647,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>  
>  	q = bdev_get_queue(bdev);
>  	if (blk_queue_discard(q))
> -		device->can_discard = 1;
> +		set_bit(BTRFS_DEV_STATE_CAN_DISCARD, &device->dev_state);
>  	if (!blk_queue_nonrot(q))
>  		fs_devices->rotating = 1;
>  
> @@ -2401,7 +2401,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  
>  	q = bdev_get_queue(bdev);
>  	if (blk_queue_discard(q))
> -		device->can_discard = 1;
> +		set_bit(BTRFS_DEV_STATE_CAN_DISCARD, &device->dev_state);
>  	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  	device->generation = trans->transid;
>  	device->io_width = fs_info->sectorsize;
> @@ -2601,7 +2601,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  
>  	q = bdev_get_queue(bdev);
>  	if (blk_queue_discard(q))
> -		device->can_discard = 1;
> +		set_bit(BTRFS_DEV_STATE_CAN_DISCARD, &device->dev_state);
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
>  	device->generation = 0;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 2fbff6902c8d..85e4b2dcc071 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -50,6 +50,7 @@ struct btrfs_pending_bios {
>  #define BTRFS_DEV_STATE_WRITEABLE	(1UL << 1)
>  #define BTRFS_DEV_STATE_IN_FS_METADATA	(1UL << 2)
>  #define BTRFS_DEV_STATE_MISSING		(1UL << 3)
> +#define BTRFS_DEV_STATE_CAN_DISCARD	(1UL << 4)
>  
>  struct btrfs_device {
>  	struct list_head dev_list;
> @@ -74,7 +75,6 @@ struct btrfs_device {
>  	fmode_t mode;
>  
>  	unsigned long dev_state;
> -	int can_discard;
>  	int is_tgtdev_for_dev_replace;
>  	blk_status_t last_flush_error;
>  	int flush_bio_sent;
> 
