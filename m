From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH/RFC] Btrfs: Add conditional ENOSPC debugging.
Date: Fri, 10 Feb 2012 10:33:31 +0100
Message-ID: <4F34E46B.8030109@jan-o-sch.net>
References: <1328823521-8487-1-git-send-email-mitch.harder@sabayonlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328823521-8487-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mitch,

having this patch on the list is a good idea. I've two remarks, just in
case it will be included sometimes:

On 09.02.2012 22:38, Mitch Harder wrote:
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index fe4cd0f..31b717f 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -656,8 +656,18 @@ static int btrfs_delayed_inode_reserve_metadata(
>  		 * EAGAIN to make us stop the transaction we have, so return
>  		 * ENOSPC instead so that btrfs_dirty_inode knows what to do.
>  		 */
> +#ifdef BTRFS_DEBUG_ENOSPC
> +		if (unlikely(ret == -EAGAIN)) {
> +			ret = -ENOSPC;
> +			if (printk_ratelimit())

>From linux/printk.h:
/*
 * Please don't use printk_ratelimit(), because it shares ratelimiting state
 * with all other unrelated printk_ratelimit() callsites.  Instead use
 * printk_ratelimited() or plain old __ratelimit().
 */

printk_ratelimited() seems the right choice, here.

> +				printk(KERN_WARNING
> +				       "btrfs: ENOSPC set in "
> +				       "btrfs_delayed_inode_reserve_metadata\n");
> +		}
> +#else
>  		if (ret == -EAGAIN)
>  			ret = -ENOSPC;
> +#endif

I don't like the #if placements throughout the patch. Copying all the
conditions is error prone (especially when changes are made later on).

I'd rather leave all the conditions as they stand (possibly adding the
unlikely() macro if you wish). Same for the following return statement
or assignment. Simply put printk_ratelimited() into the #if ... #endif.

-Jan
