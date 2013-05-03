Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079Ab3ECP2l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 11:28:41 -0400
Date: Fri, 3 May 2013 23:28:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: increase the max global reserve size to 1gig
Message-ID: <20130503152834.GE16411@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 08:56:54AM -0400, Josef Bacik wrote:
> Apparently 512mb was too small, with a fs_mark command we could get so much
> delayed work built up that we'd never trip the "lets commit the transaction"
> logic until we'd gotten too much delayed refs built up.  Increasing this to 1
> gig makes us much safer and we no longer abort with Dave's fs_mark tester.
> Thanks,

I remember that last time I made a similar commit, but users complains that
they cannot boot their system on root btrfs partition due to lacking space and
Chris eventually got to revert that one...

thanks,
liubo

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 7049bbc..f10ac46 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4516,7 +4516,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
>  	spin_lock(&sinfo->lock);
>  	spin_lock(&block_rsv->lock);
>  
> -	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
> +	block_rsv->size = min_t(u64, num_bytes, 1024 * 1024 * 1024);
>  
>  	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
>  		    sinfo->bytes_reserved + sinfo->bytes_readonly +
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
