Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3A2CeK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 21:34:10 -0500
Date: Tue, 29 Jan 2013 10:31:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not merge logged extents if we've removed them
 from the tree
Message-ID: <20130129023131.GC15654@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 09:52:56AM -0500, Josef Bacik wrote:
> You can run into this problem where if somebody is fsyncing and writing out
> the existing extents you will have removed the extent map from the em tree,
> but it's still valid for the current fsync so we go ahead and write it.  The
> problem is we unconditionally try to merge it back into the em tree, but if
> we've removed it from the em tree that will cause problems.  So fix this by
> only trying to merge it in if it is still a part of the tree.  Thanks,
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent_map.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index ed88f5e..9759911 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -289,7 +289,8 @@ out:
>  void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em)
>  {
>  	clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
> -	try_merge_map(tree, em);
> +	if (em->in_tree)
> +		try_merge_map(tree, em);
>  }
>  
>  /**
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
