Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54671 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751683AbdJTP3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:29:06 -0400
Date: Fri, 20 Oct 2017 17:27:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: clean up btrfs_dev_stat_inc() usage
Message-ID: <20171020152717.GR3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020095059.3730-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020095059.3730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 05:50:59PM +0800, Anand Jain wrote:
> btrfs_end_bio() is using btrfs_dev_stat_inc() and then
> btrfs_dev_stat_print_on_error() separately instead
> use btrfs_dev_stat_inc_and_print() directly.
> 
> No need to worry about print lines one for read/write
> and another if the source of IO request is flush, since
> as mentioned in this patch
>  [patch] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback

I don't see such patch merged, I've only found
https://patchwork.kernel.org/patch/9619949/
so the remark in the changelog is insufficient to understand what you're
referring to.

This patch itself looks good but the changelog should be improved.

> there isn't any IO which is doing that.
> 
> This consolidation is a preparatory patch to add device
> critical error handling in btrfs_dev_stat_inc_and_print()
> and can be renamed as needed.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index efaf85dd91b0..d1d8aa226bff 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6004,15 +6004,14 @@ static void btrfs_end_bio(struct bio *bio)
>  			dev = bbio->stripes[stripe_index].dev;
>  			if (dev->bdev) {
>  				if (bio_op(bio) == REQ_OP_WRITE)
> -					btrfs_dev_stat_inc(dev,
> +					btrfs_dev_stat_inc_and_print(dev,
>  						BTRFS_DEV_STAT_WRITE_ERRS);
>  				else
> -					btrfs_dev_stat_inc(dev,
> +					btrfs_dev_stat_inc_and_print(dev,
>  						BTRFS_DEV_STAT_READ_ERRS);
>  				if (bio->bi_opf & REQ_PREFLUSH)
> -					btrfs_dev_stat_inc(dev,
> +					btrfs_dev_stat_inc_and_print(dev,
>  						BTRFS_DEV_STAT_FLUSH_ERRS);
> -				btrfs_dev_stat_print_on_error(dev);
>  			}
>  		}
>  	}
> -- 
> 2.13.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
