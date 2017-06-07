Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50805 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdFGUW2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 16:22:28 -0400
Date: Wed, 7 Jun 2017 13:20:24 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 4/7] Btrfs: always account pinned bytes when dropping a
 tree block ref
Message-ID: <20170607202024.GC16793@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1496792333.git.osandov@fb.com>
 <6e19647f2f3fb86f042e43162d55ceefe7c85d3e.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6e19647f2f3fb86f042e43162d55ceefe7c85d3e.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:29PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we only increment total_bytes_pinned in
> btrfs_free_tree_block() when dropping the last reference on the block.
> However, when the delayed ref is run later, we will decrement
> total_bytes_pinned regardless of whether it was the last reference or
> not. This causes the counter to underflow when the reference we dropped
> was not the last reference. Fix it by incrementing the counter
> unconditionally, which is what btrfs_free_extent() does. This makes
> total_bytes_pinned an overestimate when references to shared extents are
> dropped, but in the worst case this will just make us try to commit the
> transaction to try to free up space and find we didn't free enough.
>

I recognize the same problem, the patch looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9cff937415cb..52f3a0486e64 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7178,10 +7178,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  		BUG_ON(ret); /* -ENOMEM */
>  	}
>  
> -	if (!last_ref)
> -		return;
> -
> -	if (btrfs_header_generation(buf) == trans->transid) {
> +	if (last_ref && btrfs_header_generation(buf) == trans->transid) {
>  		struct btrfs_block_group_cache *cache;
>  
>  		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
> @@ -7212,11 +7209,13 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  		add_pinned_bytes(fs_info, buf->len, btrfs_header_level(buf),
>  				 root->root_key.objectid);
>  
> -	/*
> -	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
> -	 * anymore.
> -	 */
> -	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
> +	if (last_ref) {
> +		/*
> +		 * Deleting the buffer, clear the corrupt flag since it doesn't
> +		 * matter anymore.
> +		 */
> +		clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
> +	}
>  }
>  
>  /* Can return -ENOMEM */
> -- 
> 2.13.0
> 
