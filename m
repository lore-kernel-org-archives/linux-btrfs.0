Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32467 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2KAIPU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 04:15:20 -0400
Date: Thu, 1 Nov 2012 16:14:17 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/5] Btrfs: fix unprotected extent map operation when
 logging file extents
Message-ID: <20121101081416.GC2554@liubo.cn.oracle.com>
References: <5092261E.2020702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5092261E.2020702@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 03:34:54PM +0800, Miao Xie wrote:
> We forget to protect the modified_extents list, fix it.
> 

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-log.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index cbb544e..f7e9387 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3525,8 +3525,10 @@ next_slot:
>  		struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
>  		struct extent_map *em, *n;
>  
> +		write_lock(&tree->lock);
>  		list_for_each_entry_safe(em, n, &tree->modified_extents, list)
>  			list_del_init(&em->list);
> +		write_unlock(&tree->lock);
>  	}
>  
>  	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
> -- 
> 1.7.6.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
