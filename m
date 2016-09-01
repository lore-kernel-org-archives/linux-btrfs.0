Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755859AbcIAPhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 11:37:53 -0400
Date: Thu, 1 Sep 2016 17:36:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs: do not decrease bytes_may_use when replaying
 extents
Message-ID: <20160901153629.GT16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472182394-7785-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472182394-7785-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC Josef. It's a followup of patch that went to 4.8-rc4 so we'd better
get it to 4.8.

On Fri, Aug 26, 2016 at 11:33:14AM +0800, Wang Xiaoguang wrote:
> When replaying extents, there is no need to update bytes_may_use
> in btrfs_alloc_logged_file_extent(), otherwise it'll trigger a
> WARN_ON about bytes_may_use.
> 
> Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ae8f9aa..7a15990 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8242,6 +8242,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  {
>  	int ret;
>  	struct btrfs_block_group_cache *block_group;
> +	struct btrfs_space_info *space_info;
>  
>  	/*
>  	 * Mixed block groups will exclude before processing the log so we only
> @@ -8257,9 +8258,14 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  	if (!block_group)
>  		return -EINVAL;
>  
> -	ret = btrfs_add_reserved_bytes(block_group, ins->offset,
> -				       ins->offset, 0);
> -	BUG_ON(ret); /* logic error */
> +	space_info = block_group->space_info;
> +	spin_lock(&space_info->lock);
> +	spin_lock(&block_group->lock);
> +	space_info->bytes_reserved += ins->offset;
> +	block_group->reserved += ins->offset;
> +	spin_unlock(&block_group->lock);
> +	spin_unlock(&space_info->lock);
> +
>  	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
>  					 0, owner, offset, ins, 1);
>  	btrfs_put_block_group(block_group);
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
