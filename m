Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcEIVbu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 17:31:50 -0400
Date: Mon, 9 May 2016 14:33:37 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/14] Btrfs: fix release reserved extents trace points
Message-ID: <20160509213337.GC4954@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
 <1458926760-17563-13-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458926760-17563-13-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 01:25:58PM -0400, Josef Bacik wrote:
> We were doing trace_btrfs_release_reserved_extent() in pin_down_extent which
> isn't quite right because we will go through and free that extent later when we
> unpin, so it messes up apps that are accounting for the reservation space.  We
> were also unconditionally doing it in __btrfs_free_reserved_extent(), when we
> only actually free the reservation instead of pinning the extent.  Thanks,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0ecceea..273e18d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6253,8 +6253,6 @@ static int pin_down_extent(struct btrfs_root *root,
>  				      cache->space_info->flags, num_bytes, 1);
>  	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
>  			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
> -	if (reserved)
> -		trace_btrfs_reserved_extent_free(root, bytenr, num_bytes);
>  	return 0;
>  }
>  
> @@ -7877,12 +7875,10 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
>  			ret = btrfs_discard_extent(root, start, len, NULL);
>  		btrfs_add_free_space(cache, start, len);
>  		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delalloc);
> +		trace_btrfs_reserved_extent_free(root, start, len);
>  	}
>  
>  	btrfs_put_block_group(cache);
> -
> -	trace_btrfs_reserved_extent_free(root, start, len);
> -
>  	return ret;
>  }
>  
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
