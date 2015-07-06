Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbbGFDSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jul 2015 23:18:47 -0400
Date: Mon, 6 Jul 2015 11:18:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 11/21] Btrfs: subpagesize-blocksize:
 btrfs_page_mkwrite: Reserve space in sectorsized units.
Message-ID: <20150706031828.GB6105@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-12-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-12-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:46PM +0530, Chandan Rajendra wrote:
> In subpagesize-blocksize scenario, if i_size occurs in a block which is not
> the last block in the page, then the space to be reserved should be calculated
> appropriately.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/inode.c | 36 +++++++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9486e61..e9bab73 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8601,11 +8601,24 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	loff_t size;
>  	int ret;
>  	int reserved = 0;
> +	u64 reserved_space;
>  	u64 page_start;
>  	u64 page_end;
> +	u64 end;
> +
> +	reserved_space = PAGE_CACHE_SIZE;
>  
>  	sb_start_pagefault(inode->i_sb);
> -	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
> +
> +	/*
> +	  Reserving delalloc space after obtaining the page lock can lead to
> +	  deadlock. For example, if a dirty page is locked by this function
> +	  and the call to btrfs_delalloc_reserve_space() ends up triggering
> +	  dirty page write out, then the btrfs_writepage() function could
> +	  end up waiting indefinitely to get a lock on the page currently
> +	  being processed by btrfs_page_mkwrite() function.
> +	 */
> +	ret  = btrfs_delalloc_reserve_space(inode, reserved_space);
>  	if (!ret) {
>  		ret = file_update_time(vma->vm_file);
>  		reserved = 1;
> @@ -8626,6 +8639,7 @@ again:
>  	size = i_size_read(inode);
>  	page_start = page_offset(page);
>  	page_end = page_start + PAGE_CACHE_SIZE - 1;
> +	end = page_end;
>  
>  	if ((page->mapping != inode->i_mapping) ||
>  	    (page_start >= size)) {
> @@ -8641,7 +8655,7 @@ again:
>  	 * we can't set the delalloc bits if there are pending ordered
>  	 * extents.  Drop our locks and wait for them to finish
>  	 */
> -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> +	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
>  	if (ordered) {
>  		unlock_extent_cached(io_tree, page_start, page_end,
>  				     &cached_state, GFP_NOFS);
> @@ -8651,6 +8665,18 @@ again:
>  		goto again;
>  	}
>  
> +	if (page->index == ((size - 1) >> PAGE_CACHE_SHIFT)) {
> +		reserved_space = round_up(size - page_start, root->sectorsize);
> +		if (reserved_space < PAGE_CACHE_SIZE) {
> +			end = page_start + reserved_space - 1;
> +			spin_lock(&BTRFS_I(inode)->lock);
> +			BTRFS_I(inode)->outstanding_extents++;
> +			spin_unlock(&BTRFS_I(inode)->lock);
> +			btrfs_delalloc_release_space(inode,
> +						PAGE_CACHE_SIZE - reserved_space);
> +		}
> +	}
> +
>  	/*
>  	 * XXX - page_mkwrite gets called every time the page is dirtied, even
>  	 * if it was already dirty, so for space accounting reasons we need to
> @@ -8658,12 +8684,12 @@ again:
>  	 * is probably a better way to do this, but for now keep consistent with
>  	 * prepare_pages in the normal write path.
>  	 */
> -	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
> +	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, end,
>  			  EXTENT_DIRTY | EXTENT_DELALLOC |
>  			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
>  			  0, 0, &cached_state, GFP_NOFS);
>  
> -	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
> +	ret = btrfs_set_extent_delalloc(inode, page_start, end,
>  					&cached_state);
>  	if (ret) {
>  		unlock_extent_cached(io_tree, page_start, page_end,
> @@ -8706,7 +8732,7 @@ out_unlock:
>  	}
>  	unlock_page(page);
>  out:
> -	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
> +	btrfs_delalloc_release_space(inode, reserved_space);
>  out_noreserve:
>  	sb_end_pagefault(inode->i_sb);
>  	return ret;
> -- 
> 2.1.0
> 
