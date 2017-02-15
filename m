Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18812 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdBOVea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:34:30 -0500
Date: Wed, 15 Feb 2017 13:33:34 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 27/29] btrfs: remove unused parameter from
 cleanup_write_cache_enospc
Message-ID: <20170215213334.GM19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <35c2d3f7d37be07da35febae2a1fb71a677348f2.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35c2d3f7d37be07da35febae2a1fb71a677348f2.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:44AM +0100, David Sterba wrote:
> bitmap_list is unused since the io_ctl framework.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/free-space-cache.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 437580e84d9d..0d02599d22bc 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1128,8 +1128,7 @@ cleanup_bitmap_list(struct list_head *bitmap_list)
>  static void noinline_for_stack
>  cleanup_write_cache_enospc(struct inode *inode,
>  			   struct btrfs_io_ctl *io_ctl,
> -			   struct extent_state **cached_state,
> -			   struct list_head *bitmap_list)
> +			   struct extent_state **cached_state)
>  {
>  	io_ctl_drop_pages(io_ctl);
>  	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
> @@ -1365,7 +1364,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  	mutex_unlock(&ctl->cache_writeout_mutex);
>  
>  out_nospc:
> -	cleanup_write_cache_enospc(inode, io_ctl, &cached_state, &bitmap_list);
> +	cleanup_write_cache_enospc(inode, io_ctl, &cached_state);
>  
>  	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
>  		up_write(&block_group->data_rwsem);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
