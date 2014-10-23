Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63119 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651AbaJWInR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 04:43:17 -0400
Message-ID: <5448C006.1070808@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 16:44:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't do async reclaim during log replay V2
References: <1411054037-20136-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1411054037-20136-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 18 Sep 2014 11:27:17 -0400, Josef Bacik wrote:
> Trying to reproduce a log enospc bug I hit a panic in the async reclaim code
> during log replay.  This is because we use fs_info->fs_root as our root for
> shrinking and such.  Technically we can use whatever root we want, but let's
> just not allow async reclaim while we're doing log replay.  Thanks,

Why not move the code of fs_root initialization to the front of log replay?
I think it is better than the fix way in this patch because the async reclaimer
can help us do some work.

Thanks
Miao

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V1->V2: use fs_info->log_root_recovering instead, didn't notice this existed
> before.
> 
>  fs/btrfs/extent-tree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 28a27d5..44d0497 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4513,7 +4513,13 @@ again:
>  		space_info->flush = 1;
>  	} else if (!ret && space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
>  		used += orig_bytes;
> -		if (need_do_async_reclaim(space_info, root->fs_info, used) &&
> +		/*
> +		 * We will do the space reservation dance during log replay,
> +		 * which means we won't have fs_info->fs_root set, so don't do
> +		 * the async reclaim as we will panic.
> +		 */
> +		if (!root->fs_info->log_root_recovering &&
> +		    need_do_async_reclaim(space_info, root->fs_info, used) &&
>  		    !work_busy(&root->fs_info->async_reclaim_work))
>  			queue_work(system_unbound_wq,
>  				   &root->fs_info->async_reclaim_work);
> 

