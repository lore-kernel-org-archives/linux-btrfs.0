Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752584AbdLMSCQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 13:02:16 -0500
Date: Wed, 13 Dec 2017 10:00:09 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix bio leak
Message-ID: <20171213170009.GA26818@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <1513165807-12261-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513165807-12261-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 01:50:07PM +0200, Nikolay Borisov wrote:
> Commit e0ae99941423 ("btrfs: preallocate device flush bio") reworked
> the way the flush bio is allocated and used. Concretely it allocates
> the bio in __alloc_device and then re-uses it multiple times with a
> very simple endio routine that just calls complete() without consuming
> a reference. Allocated bios by default come with a ref count of 1,
> which is then consumed by the endio routine (or not, in which case they
> should be bio_put by the caller). The way the impleementation works now
> is that the flush bio has a refcount of 2 and we only ever bio_put it
> once, leaving it to hang indefinitely. Fix this by removing the extra
> bio_get in __alloc_device.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Fixes: e0ae99941423 ("btrfs: preallocate device flush bio")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 132966950f5f..3690822d469a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -312,7 +312,6 @@ static struct btrfs_device *__alloc_device(void)
>  		kfree(dev);
>  		return ERR_PTR(-ENOMEM);
>  	}
> -	bio_get(dev->flush_bio);
>  
>  	INIT_LIST_HEAD(&dev->dev_list);
>  	INIT_LIST_HEAD(&dev->dev_alloc_list);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
