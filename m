Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27595 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbbGFKHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 06:07:20 -0400
Date: Mon, 6 Jul 2015 18:06:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 13/21] Btrfs: subpagesize-blocksize: Deal with
 partial ordered extent allocations.
Message-ID: <20150706100631.GC6105@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-14-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-14-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:48PM +0530, Chandan Rajendra wrote:
> In subpagesize-blocksize scenario, extent allocations for only some of the
> dirty blocks of a page can succeed, while allocation for rest of the blocks
> can fail. This patch allows I/O against such partially allocated ordered
> extents to be submitted.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/extent_io.c | 27 ++++++++++++++-------------
>  fs/btrfs/inode.c     | 35 ++++++++++++++++++++++-------------
>  2 files changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0b017e1..0110abc 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1850,17 +1850,23 @@ int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
>  			if (page_ops & PAGE_SET_PRIVATE2)
>  				SetPagePrivate2(pages[i]);
>  
> +			if (page_ops & PAGE_SET_ERROR)
> +				SetPageError(pages[i]);
> +
>  			if (pages[i] == locked_page) {
>  				page_cache_release(pages[i]);
>  				continue;
>  			}
> -			if (page_ops & PAGE_CLEAR_DIRTY)
> +
> +			if ((page_ops & PAGE_CLEAR_DIRTY)
> +				&& !PagePrivate2(pages[i]))
>  				clear_page_dirty_for_io(pages[i]);
> -			if (page_ops & PAGE_SET_WRITEBACK)
> +			if ((page_ops & PAGE_SET_WRITEBACK)
> +				&& !PagePrivate2(pages[i]))
>  				set_page_writeback(pages[i]);
> -			if (page_ops & PAGE_SET_ERROR)
> -				SetPageError(pages[i]);
> -			if (page_ops & PAGE_END_WRITEBACK)
> +
> +			if ((page_ops & PAGE_END_WRITEBACK)
> +				&& !PagePrivate2(pages[i]))
>  				end_page_writeback(pages[i]);
>  			if (page_ops & PAGE_UNLOCK)
>  				unlock_page(pages[i]);
> @@ -2550,7 +2556,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>  			uptodate = 0;
>  	}
>  
> -	if (!uptodate) {
> +	if (!uptodate || PageError(page)) {
>  		ClearPageUptodate(page);
>  		SetPageError(page);
>  		ret = ret < 0 ? ret : -EIO;
> @@ -3340,7 +3346,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  					       nr_written);
>  		/* File system has been set read-only */
>  		if (ret) {
> -			SetPageError(page);
>  			/* fill_delalloc should be return < 0 for error
>  			 * but just in case, we use > 0 here meaning the
>  			 * IO is started, so we don't want to return > 0
> @@ -3561,7 +3566,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  	struct inode *inode = page->mapping->host;
>  	struct extent_page_data *epd = data;
>  	u64 start = page_offset(page);
> -	u64 page_end = start + PAGE_CACHE_SIZE - 1;
>  	int ret;
>  	int nr = 0;
>  	size_t pg_offset = 0;
> @@ -3606,7 +3610,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
>  	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
>  	if (ret == 1)
>  		goto done_unlocked;
> -	if (ret)
> +	if (ret && !PagePrivate2(page))
>  		goto done;
>  
>  	ret = __extent_writepage_io(inode, page, wbc, epd,
> @@ -3620,10 +3624,7 @@ done:
>  		set_page_writeback(page);
>  		end_page_writeback(page);
>  	}
> -	if (PageError(page)) {
> -		ret = ret < 0 ? ret : -EIO;
> -		end_extent_writepage(page, ret, start, page_end);
> -	}
> +
>  	unlock_page(page);
>  	return ret;
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8b4aaed..bff60c6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -925,6 +925,8 @@ static noinline int cow_file_range(struct inode *inode,
>  	struct btrfs_key ins;
>  	struct extent_map *em;
>  	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
> +	struct btrfs_ordered_extent *ordered;
> +	unsigned long page_ops, extent_ops;
>  	int ret = 0;
>  
>  	if (btrfs_is_free_space_inode(inode)) {
> @@ -969,8 +971,6 @@ static noinline int cow_file_range(struct inode *inode,
>  	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
>  
>  	while (disk_num_bytes > 0) {
> -		unsigned long op;
> -
>  		cur_alloc_size = disk_num_bytes;
>  		ret = btrfs_reserve_extent(root, cur_alloc_size,
>  					   root->sectorsize, 0, alloc_hint,
> @@ -1023,7 +1023,7 @@ static noinline int cow_file_range(struct inode *inode,
>  			ret = btrfs_reloc_clone_csums(inode, start,
>  						      cur_alloc_size);
>  			if (ret)
> -				goto out_drop_extent_cache;
> +				goto out_remove_ordered_extent;
>  		}
>  
>  		if (disk_num_bytes < cur_alloc_size)
> @@ -1036,13 +1036,12 @@ static noinline int cow_file_range(struct inode *inode,
>  		 * Do set the Private2 bit so we know this page was properly
>  		 * setup for writepage
>  		 */
> -		op = unlock ? PAGE_UNLOCK : 0;
> -		op |= PAGE_SET_PRIVATE2;
> -
> +		page_ops = unlock ? PAGE_UNLOCK : 0;
> +		page_ops |= PAGE_SET_PRIVATE2;
> +		extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC;
>  		extent_clear_unlock_delalloc(inode, start,
> -					     start + ram_size - 1, locked_page,
> -					     EXTENT_LOCKED | EXTENT_DELALLOC,
> -					     op);
> +					start + ram_size - 1, locked_page,
> +					extent_ops, page_ops);
>  		disk_num_bytes -= cur_alloc_size;
>  		num_bytes -= cur_alloc_size;
>  		alloc_hint = ins.objectid + ins.offset;
> @@ -1051,16 +1050,26 @@ static noinline int cow_file_range(struct inode *inode,
>  out:
>  	return ret;
>  
> +out_remove_ordered_extent:
> +	ordered = btrfs_lookup_ordered_extent(inode, ins.objectid);
> +	BUG_ON(!ordered);
> +	btrfs_remove_ordered_extent(inode, ordered);
> +

Two problems here,

1. ins.objectid refers to block address while
btrfs_lookup_ordered_extent() expects a file offset.

2. Removing ordered extent is not enough for cleaning it up, not only
this ordered extent remains in memory, but our reserved space number
needs to be cleaned up.

If we have to do it this way, I'd copy what btrfs_finish_ordered_io()
does the cleanup job, however, I hope to call end_extent_writepage()
directly here to keep it simple as much as possible.

Thanks,

-liubo

>  out_drop_extent_cache:
>  	btrfs_drop_extent_cache(inode, start, start + ram_size - 1, 0);
> +
>  out_reserve:
>  	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
> +
>  out_unlock:
> +	page_ops = unlock ? PAGE_UNLOCK : 0;
> +	page_ops |= PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK
> +		| PAGE_SET_ERROR;
> +	extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING
> +		| EXTENT_DEFRAG;
> +
>  	extent_clear_unlock_delalloc(inode, start, end, locked_page,
> -				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
> -				     EXTENT_DELALLOC | EXTENT_DEFRAG,
> -				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
> -				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
> +				extent_ops, page_ops);
>  	goto out;
>  }
>  
> -- 
> 2.1.0
> 
