Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeC1HF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:05:58 -0400
Subject: Re: [PATCH v2 3/8] btrfs: cleanup btrfs_read_disk_super() to return
 std error
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180327234000.23656-1-anand.jain@oracle.com>
 <20180327234000.23656-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e402bb73-de66-eda4-ae30-b293d5f31e24@suse.com>
Date: Wed, 28 Mar 2018 10:05:56 +0300
MIME-Version: 1.0
In-Reply-To: <20180327234000.23656-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.03.2018 02:39, Anand Jain wrote:
> The only caller btrfs_scan_one_device() sets -EINVAL for error from
> btrfs_read_disk_super(), so this patch returns -EINVAL from the latter
> function.
> 
> A preparatory patch to add csum check in btrfs_read_disk_super().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v1->v2:
>  Check btrfs_read_disk_super() to be more explicit ret < 0
> 
>  fs/btrfs/volumes.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 87d183accdb2..e63723f23227 100644
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
> +	if (ret < 0)
>  		goto error_bdev_put;
> -	}
>  
>  	mutex_lock(&uuid_mutex);
>  	device = device_list_add(path, disk_super);
> 
