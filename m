Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35377 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbdC2SBf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 14:01:35 -0400
Date: Wed, 29 Mar 2017 11:00:35 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 3/5] btrfs: scrub: Don't append on-disk pages for
 raid56 scrub
Message-ID: <20170329180035.GB8328@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-4-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329013322.1323-4-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 09:33:20AM +0800, Qu Wenruo wrote:
> In the following situation, scrub will calculate wrong parity to
> overwrite correct one:
> 
> RAID5 full stripe:
> 
> Before
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0x0000 (Bad)   |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
> 
> After scrubbing dev3 only:
> 
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0xcdcd (Good)  |     0xcdcd     | 0xcdcd (Bad)  |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
> 
> The reason is after raid56 read rebuild rbio->stripe_pages are all
> correct recovered (0xcd for data stripes).
> 
> However when we check and repair parity, in
> scrub_parity_check_and_repair(), we will appending pages in
> sparity->spages list to rbio->bio_pages[], which contains old on-disk
> data.
>

s/appending/append/

> And when we submit parity data to disk, we calculate parity using
> rbio->bio_pages[] first, if rbio->bio_pages[] not found, then fallback
> to rbio->stripe_pages[].
>

*is not found

> The patch fix it by not appending pages from sparity->spages.
> So finish_parity_scrub() will use rbio->stripe_pages[] which is correct.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index f92d2512f4f3..2fd259dbf4db 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2991,7 +2991,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
>  	struct btrfs_fs_info *fs_info = sctx->fs_info;
>  	struct bio *bio;
>  	struct btrfs_raid_bio *rbio;
> -	struct scrub_page *spage;
>  	struct btrfs_bio *bbio = NULL;
>  	u64 length;
>  	int ret;
> @@ -3021,9 +3020,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
>  	if (!rbio)
>  		goto rbio_out;
>  
> -	list_for_each_entry(spage, &sparity->spages, list)
> -		raid56_add_scrub_pages(rbio, spage->page, spage->logical);
> -
>  	scrub_pending_bio_inc(sctx);
>  	raid56_parity_submit_scrub_rbio(rbio);
>  	return;
> -- 
> 2.12.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
