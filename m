Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51761 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbbFJNqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 09:46:22 -0400
Date: Wed, 10 Jun 2015 21:46:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix a comment in
 inode.c:evict_inode_truncate_pages()
Message-ID: <20150610134606.GI3561@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433937732-7355-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433937732-7355-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 01:02:12PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The comment was not correct about the part where it says the endio
> callback of the bio might have not yet been called - update it
> to mention that by that time the endio callback execution might
> still be in progress only.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 855935f..a21ad34 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4989,8 +4989,9 @@ static void evict_inode_truncate_pages(struct inode *inode)
>  	/*
>  	 * Keep looping until we have no more ranges in the io tree.
>  	 * We can have ongoing bios started by readpages (called from readahead)
> -	 * that didn't get their end io callbacks called yet or they are still
> -	 * in progress ((extent_io.c:end_bio_extent_readpage()). This means some
> +	 * that have their endio callback (extent_io.c:end_bio_extent_readpage)
> +	 * still in progress (unlocked the pages in the bio but did not yet
> +	 * unlocked the ranges in the io tree). Therefore this means some
>  	 * ranges can still be locked and eviction started because before
>  	 * submitting those bios, which are executed by a separate task (work
>  	 * queue kthread), inode references (inode->i_count) were not taken
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
