Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51757 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdBOVaB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:30:01 -0500
Date: Wed, 15 Feb 2017 13:29:07 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 22/29] btrfs: remove unused parameters from
 scrub_setup_wr_ctx
Message-ID: <20170215212906.GJ19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <035062e9f1048e95e2d605e070d5c08ee18e1895.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <035062e9f1048e95e2d605e070d5c08ee18e1895.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:29AM +0100, David Sterba wrote:
> Never used.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/scrub.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 9a94670536a6..f7dffacf61fa 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -282,9 +282,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
>  			       u64 *extent_physical,
>  			       struct btrfs_device **extent_dev,
>  			       int *extent_mirror_num);
> -static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
> -			      struct scrub_wr_ctx *wr_ctx,
> -			      struct btrfs_fs_info *fs_info,
> +static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
>  			      struct btrfs_device *dev,
>  			      int is_dev_replace);
>  static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
> @@ -501,7 +499,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
>  	spin_lock_init(&sctx->stat_lock);
>  	init_waitqueue_head(&sctx->list_wait);
>  
> -	ret = scrub_setup_wr_ctx(sctx, &sctx->wr_ctx, fs_info,
> +	ret = scrub_setup_wr_ctx(&sctx->wr_ctx,
>  				 fs_info->dev_replace.tgtdev, is_dev_replace);
>  	if (ret) {
>  		scrub_free_ctx(sctx);
> @@ -4084,9 +4082,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
>  	btrfs_put_bbio(bbio);
>  }
>  
> -static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
> -			      struct scrub_wr_ctx *wr_ctx,
> -			      struct btrfs_fs_info *fs_info,
> +static int scrub_setup_wr_ctx(struct scrub_wr_ctx *wr_ctx,
>  			      struct btrfs_device *dev,
>  			      int is_dev_replace)
>  {
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
