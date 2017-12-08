Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52929 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdLIAMn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 19:12:43 -0500
Date: Fri, 8 Dec 2017 16:05:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [PATCH] Btrfs: raid56: fix race between merge_bio and
 rbio_orig_end_io
Message-ID: <20171208230539.GA30998@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171208230235.30636-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20171208230235.30636-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Add Jérôme Carretero.)

Thanks,

-liubo

On Fri, Dec 08, 2017 at 04:02:35PM -0700, Liu Bo wrote:
> We're not allowed to take any new bios to rbio->bio_list in
> rbio_orig_end_io(), otherwise we may get merged with more bios and
> rbio->bio_list is not empty.
> 
> This should only happens in error-out cases, the normal path of
> recover and full stripe write have already set RBIO_RMW_LOCKED_BIT to
> disable merge before doing IO.
> 
> Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 5aa9d22..127c782 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -859,12 +859,23 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
>   */
>  static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
>  {
> -	struct bio *cur = bio_list_get(&rbio->bio_list);
> +	struct bio *cur;
>  	struct bio *next;
>  
> +	/*
> +	 * We're not allowed to take any new bios to rbio->bio_list
> +	 * from now on, otherwise we may get merged with more bios and
> +	 * rbio->bio_list is not empty.
> +	 */
> +	spin_lock(&rbio->bio_list_lock);
> +	set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
> +	spin_unlock(&rbio->bio_list_lock);
> +
>  	if (rbio->generic_bio_cnt)
>  		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
>  
> +	cur = bio_list_get(&rbio->bio_list);
> +
>  	free_raid_bio(rbio);
>  
>  	while (cur) {
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
