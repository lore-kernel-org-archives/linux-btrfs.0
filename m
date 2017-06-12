Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32273 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752074AbdFLRj4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 13:39:56 -0400
Date: Mon, 12 Jun 2017 10:37:48 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 3/7] Btrfs: update total_bytes_pinned when pinning down
 extents
Message-ID: <20170612173748.GC18452@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1496792333.git.osandov@fb.com>
 <ff9e2944872bc1bdabb682daf1eac4c3e05cc041.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff9e2944872bc1bdabb682daf1eac4c3e05cc041.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:28PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The extents marked in pin_down_extent() will be unpinned later in
> unpin_extent_range(), which decrements total_bytes_pinned.
> pin_down_extent() must increment the counter to avoid underflowing it.
> Also adjust btrfs_free_tree_block() to avoid accounting for the same
> extent twice.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6032e9a635f2..9cff937415cb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6343,6 +6343,7 @@ static int pin_down_extent(struct btrfs_fs_info *fs_info,
>  
>  	trace_btrfs_space_reservation(fs_info, "pinned",
>  				      cache->space_info->flags, num_bytes, 1);
> +	percpu_counter_add(&cache->space_info->total_bytes_pinned, num_bytes);
>  	set_extent_dirty(fs_info->pinned_extents, bytenr,
>  			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
>  	return 0;
> @@ -7189,6 +7190,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  				goto out;
>  		}
>  
> +		pin = 0;
>  		cache = btrfs_lookup_block_group(fs_info, buf->start);
>  
>  		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
> @@ -7204,7 +7206,6 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  		btrfs_free_reserved_bytes(cache, buf->len, 0);
>  		btrfs_put_block_group(cache);
>  		trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
> -		pin = 0;
>  	}
>  out:
>  	if (pin)
> -- 
> 2.13.0
> 
