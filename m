Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29091 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbcLVFrS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 00:47:18 -0500
Date: Wed, 21 Dec 2016 21:46:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] btrfs: fix error handling when
 run_delayed_extent_op fails
Message-ID: <20161222054611.GB11373@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1482258508-7594-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482258508-7594-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 20, 2016 at 01:28:27PM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> In __btrfs_run_delayed_refs, the error path when run_delayed_extent_op
> fails sets locked_ref->processing = 0 but doesn't re-increment
> delayed_refs->num_heads_ready.  As a result, we end up triggering
> the WARN_ON in btrfs_select_ref_head.
> 
> Fixes: d7df2c796d7 (Btrfs: attach delayed ref updates to delayed ref heads)
> Reported-by: Jon Nelson <jnelson-suse@jamponi.net>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index db74889..d74adf1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2576,7 +2576,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  					 */
>  					if (must_insert_reserved)
>  						locked_ref->must_insert_reserved = 1;
> +					spin_lock(&delayed_refs->lock);
>  					locked_ref->processing = 0;
> +					delayed_refs->num_heads_ready++;
> +					spin_unlock(&delayed_refs->lock);

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
>  					btrfs_debug(fs_info,
>  						    "run_delayed_extent_op returned %d",
>  						    ret);
> -- 
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
