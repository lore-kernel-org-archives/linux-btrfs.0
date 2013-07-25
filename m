Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3GYISw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 04:18:52 -0400
Date: Thu, 25 Jul 2013 16:18:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Andi Shyti <andi@etezian.org>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: avoid double allocation
Message-ID: <20130725081840.GB5202@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1374710980-5707-1-git-send-email-andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374710980-5707-1-git-send-email-andi@etezian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 25, 2013 at 02:09:40AM +0200, Andi Shyti wrote:
> alloc_rbio frees already bbio and raid_map, therefore they don't
> need to be freed in case it fails
> 

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  fs/btrfs/raid56.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 0525e13..35fe775 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1687,11 +1687,9 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
>  	struct blk_plug_cb *cb;
>  
>  	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
> -	if (IS_ERR(rbio)) {
> -		kfree(raid_map);
> -		kfree(bbio);
> +	if (IS_ERR(rbio))
>  		return PTR_ERR(rbio);
> -	}
> +
>  	bio_list_add(&rbio->bio_list, bio);
>  	rbio->bio_list_bytes = bio->bi_size;
>  
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-liubo
