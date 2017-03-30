Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37877 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932971AbdC3AwP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 20:52:15 -0400
Date: Wed, 29 Mar 2017 17:51:18 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 2/5] btrfs: scrub: Fix RAID56 recovery race condition
Message-ID: <20170330005117.GB15452@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170329013322.1323-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 09:33:19AM +0800, Qu Wenruo wrote:
[...]
> 
> Reported-by: Goffredo Baroncelli <kreijack@libero.it>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ab33b9a8aac2..f92d2512f4f3 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1129,6 +1129,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  	have_csum = sblock_to_check->pagev[0]->have_csum;
>  	dev = sblock_to_check->pagev[0]->dev;
>  
> +	/*
> +	 * For RAID5/6 race can happen for different dev scrub thread.
> +	 * For data corruption, Parity and Data thread will both try
> +	 * to recovery the data.
> +	 * Race can lead to double added csum error, or even unrecoverable
> +	 * error.
> +	 */
> +	ret = lock_full_stripe(fs_info, logical);
> +	if (ret < 0)
> +		return ret;
> +

Firstly, sctx->stat needs to be set with errors before returning errors.

Secondly, I think the critical section starts right before re-checking the
failed mirror, doesn't it?  If so, we could get the benefit from
sblock_bad->page since the page->recover can tell if this is a raid56 profile so
that we may save a searching for block group.

>  	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
>  		sblocks_for_recheck = NULL;
>  		goto nodatasum_case;
> @@ -1463,6 +1474,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  		kfree(sblocks_for_recheck);
>  	}
>  
> +	ret = unlock_full_stripe(fs_info, logical);
> +	if (ret < 0)
> +		return ret;

Seems that the callers of scrub_handle_errored_block doesn't care about @ret.

And could you please put a 'locked' flag after taking the lock succesfully?
Otherwise every raid profile has to check block group for raid flag.

Thanks,

-liubo
>  	return 0;
>  }
>  
> -- 
> 2.12.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
