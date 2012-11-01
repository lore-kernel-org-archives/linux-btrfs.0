Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18502 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2KAJWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 05:22:18 -0400
Date: Thu, 1 Nov 2012 17:21:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix missing log when
 BTRFS_INODE_NEEDS_FULL_SYNC is set
Message-ID: <20121101092111.GE2554@liubo.cn.oracle.com>
References: <5092263B.7070500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5092263B.7070500@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 03:35:23PM +0800, Miao Xie wrote:
> If we set BTRFS_INODE_NEEDS_FULL_SYNC, we should log all the extent,
> but now we forget to take it into account, and set a wrong max key,
> if so, we will skip the file extent metadata when doing logging. Fix it.
> 

But it's along with LOG_INODE_EXISTS, which is set by rename and link
and means we need to log just enough to rebuild the inode during log replay.

On the other side, if we do log all the extents because of having set
BTRFS_INODE_NEEDS_FULL_SYNC, we don't know if we actually get what we
want because rename and link do not wait for dirty pages as fsync does.

thanks,
liubo

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-log.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f7e9387..c495b47 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3394,7 +3394,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>  
>  
>  	/* today the code can only do partial logging of directories */
> -	if (inode_only == LOG_INODE_EXISTS || S_ISDIR(inode->i_mode))
> +	if (S_ISDIR(inode->i_mode) ||
> +	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> +		       &BTRFS_I(inode)->runtime_flags) &&
> +	     inode_only == LOG_INODE_EXISTS))
>  		max_key.type = BTRFS_XATTR_ITEM_KEY;
>  	else
>  		max_key.type = (u8)-1;
> -- 
> 1.7.6.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
