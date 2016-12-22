Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47980 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938498AbcLVFml (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 00:42:41 -0500
Date: Wed, 21 Dec 2016 21:42:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix locking when we put back a delayed ref
 that's too new
Message-ID: <20161222054232.GA11373@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1482258508-7594-1-git-send-email-jeffm@suse.com>
 <1482258508-7594-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482258508-7594-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 20, 2016 at 01:28:28PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> In __btrfs_run_delayed_refs, when we put back a delayed ref that's too
> new, we have already dropped the lock on locked_ref when we set
> ->processing = 0.
> 
> This patch keeps the lock to cover that assignment.
> 
> Fixes: d7df2c796d7 (Btrfs: attach delayed ref updates to delayed ref heads)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d74adf1..930ac8e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2526,11 +2526,11 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  		if (ref && ref->seq &&
>  		    btrfs_check_delayed_seq(fs_info, delayed_refs, ref->seq)) {
>  			spin_unlock(&locked_ref->lock);
> -			btrfs_delayed_ref_unlock(locked_ref);
>  			spin_lock(&delayed_refs->lock);
>  			locked_ref->processing = 0;
>  			delayed_refs->num_heads_ready++;
>  			spin_unlock(&delayed_refs->lock);
> +			btrfs_delayed_ref_unlock(locked_ref);

I don't think that this would end up a deadlock as we use mutex_try_lock
for head->mutex everywhere, but I'd rather have it cleaned up.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
>  			locked_ref = NULL;
>  			cond_resched();
>  			count++;
> -- 
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
