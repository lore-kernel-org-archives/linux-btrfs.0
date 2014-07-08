Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29559 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHEIa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 00:08:30 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6848TEB009279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jul 2014 04:08:29 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6848S50007425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jul 2014 04:08:28 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s6848RkC025019
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jul 2014 04:08:27 GMT
Date: Tue, 8 Jul 2014 12:08:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: code optimize use btrfs_get_bdev_and_sb() at
 btrfs_scan_one_device
Message-ID: <20140708040818.GA20810@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 08, 2014 at 02:38:37AM +0800, Anand Jain wrote:
> (for review comments pls).
> 
> btrfs_scan_one_device() needs SB, instead of doing it from scratch could
> use btrfs_get_bdev_and_sb()
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 51 ++++++---------------------------------------------
>  1 file changed, 6 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c166355..94e6131 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1053,14 +1053,11 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  {
>  	struct btrfs_super_block *disk_super;
>  	struct block_device *bdev;
> -	struct page *page;
> -	void *p;
>  	int ret = -EINVAL;
>  	u64 devid;
>  	u64 transid;
>  	u64 total_devices;
> -	u64 bytenr;
> -	pgoff_t index;
> +	struct buffer_head *bh;
>  
>  	/*
>  	 * we would like to check all the supers, but that would make
> @@ -1068,44 +1065,12 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	 * So, we need to add a special mount option to scan for
>  	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>  	 */
> -	bytenr = btrfs_sb_offset(0);
>  	mutex_lock(&uuid_mutex);
>  
> -	bdev = blkdev_get_by_path(path, flags, holder);
> -
> -	if (IS_ERR(bdev)) {
> -		ret = PTR_ERR(bdev);
> +	ret = btrfs_get_bdev_and_sb(path, flags, holder, 0, &bdev, &bh);
> +	if (ret)
>  		goto error;
> -	}
> -
> -	/* make sure our super fits in the device */
> -	if (bytenr + PAGE_CACHE_SIZE >= i_size_read(bdev->bd_inode))
> -		goto error_bdev_put;
> -
> -	/* make sure our super fits in the page */
> -	if (sizeof(*disk_super) > PAGE_CACHE_SIZE)
> -		goto error_bdev_put;
> -
> -	/* make sure our super doesn't straddle pages on disk */
> -	index = bytenr >> PAGE_CACHE_SHIFT;
> -	if ((bytenr + sizeof(*disk_super) - 1) >> PAGE_CACHE_SHIFT != index)
> -		goto error_bdev_put;

Apparently btrfs_get_bdev_and_sb() lacks the above two checks, otherwise looks good.

thanks,
-liubo

> -
> -	/* pull in the page with our super */
> -	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
> -				   index, GFP_NOFS);
> -
> -	if (IS_ERR_OR_NULL(page))
> -		goto error_bdev_put;
> -
> -	p = kmap(page);
> -
> -	/* align our pointer to the offset of the super block */
> -	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
> -
> -	if (btrfs_super_bytenr(disk_super) != bytenr ||
> -	    btrfs_super_magic(disk_super) != BTRFS_MAGIC)
> -		goto error_unmap;
> +	disk_super = (struct btrfs_super_block *) bh->b_data;
>  
>  	devid = btrfs_stack_device_id(&disk_super->dev_item);
>  	transid = btrfs_super_generation(disk_super);
> @@ -1125,13 +1090,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
>  	}
>  
> -
> -error_unmap:
> -	kunmap(page);
> -	page_cache_release(page);
> -
> -error_bdev_put:
> +	brelse(bh);
>  	blkdev_put(bdev, flags);
> +
>  error:
>  	mutex_unlock(&uuid_mutex);
>  	return ret;
> -- 
> 2.0.0.257.g75cc6c6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
