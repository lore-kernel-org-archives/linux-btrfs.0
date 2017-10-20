Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753132AbdJTLtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:49:01 -0400
Subject: Re: [PATCH] btrfs: clean up btrfs_dev_stat_inc() usage
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171020095059.3730-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <98a2136c-1335-d0b9-fb77-bd87d0c1eeb0@suse.com>
Date: Fri, 20 Oct 2017 14:48:58 +0300
MIME-Version: 1.0
In-Reply-To: <20171020095059.3730-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.10.2017 12:50, Anand Jain wrote:
> btrfs_end_bio() is using btrfs_dev_stat_inc() and then
> btrfs_dev_stat_print_on_error() separately instead
> use btrfs_dev_stat_inc_and_print() directly.
> 
> No need to worry about print lines one for read/write
> and another if the source of IO request is flush, since
> as mentioned in this patch
>  [patch] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
> there isn't any IO which is doing that.
> 
> This consolidation is a preparatory patch to add device
> critical error handling in btrfs_dev_stat_inc_and_print()
> and can be renamed as needed.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

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
> 
