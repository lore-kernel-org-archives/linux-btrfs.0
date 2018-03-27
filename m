Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59717 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbeC0IHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 04:07:31 -0400
Subject: Re: [PATCH 3/8] btrfs: cleanup btrfs_read_disk_super() to return std
 error
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1ed03ce2-9ebd-b126-e7c8-e879bbd15e44@suse.com>
Date: Tue, 27 Mar 2018 11:07:29 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> The only caller btrfs_scan_one_device() sets -EINVAL for error from
> btrfs_read_disk_super(), so this patch returns -EINVAL from the latter
> function.
> 
> A preparatory patch to add csum check in btrfs_read_disk_super().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 87d183accdb2..ed22f0a3d239 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1154,23 +1154,23 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  
>  	/* make sure our super fits in the device */
>  	if (bytenr + PAGE_SIZE >= i_size_read(bdev->bd_inode))
> -		return 1;
> +		return -EINVAL;
>  
>  	/* make sure our super fits in the page */
>  	if (sizeof(**disk_super) > PAGE_SIZE)
> -		return 1;
> +		return -EINVAL;
>  
>  	/* make sure our super doesn't straddle pages on disk */
>  	index = bytenr >> PAGE_SHIFT;
>  	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_SHIFT != index)
> -		return 1;
> +		return -EINVAL;
>  
>  	/* pull in the page with our super */
>  	*page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
>  				   index, GFP_KERNEL);
>  
>  	if (IS_ERR_OR_NULL(*page))
> -		return 1;
> +		return -EINVAL;
>  
>  	p = kmap(*page);
>  
> @@ -1180,7 +1180,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	if (btrfs_super_bytenr(*disk_super) != bytenr ||
>  	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
>  		btrfs_release_disk_super(*page);
> -		return 1;
> +		return -EINVAL;
>  	}
>  
>  	if ((*disk_super)->label[0] &&
> @@ -1218,10 +1218,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	if (IS_ERR(bdev))
>  		return PTR_ERR(bdev);
>  
> -	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> -		ret = -EINVAL;
> +	ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
> +	if (ret)

I'd rather have explicit ret < 0 check.

>  		goto error_bdev_put;
> -	}
>  
>  	mutex_lock(&uuid_mutex);
>  	device = device_list_add(path, disk_super);
> 
