Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32314 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752709AbdG1SfB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 14:35:01 -0400
Date: Fri, 28 Jul 2017 11:33:46 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/2] btrfs: increase ctx->pos for delayed dir index
Message-ID: <20170728173346.GB15815@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1500923666-29670-1-git-send-email-jbacik@fb.com>
 <1500923666-29670-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500923666-29670-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 03:14:26PM -0400, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Our dir_context->pos is supposed to hold the next position we're
> supposed to look.  If we successfully insert a delayed dir index we
> could end up with a duplicate entry because we don't increase ctx->pos
> after doing the dir_emit.
>

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/delayed-inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 8ae409b..19e4ad2 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1727,6 +1727,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  
>  		if (over)
>  			return 1;
> +		ctx->pos++;
>  	}
>  	return 0;
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
