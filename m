From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 7 Apr 2011 10:28:40 +0200
Message-ID: <201104071028.40666.johannes.hirte@fem.tu-ilmenau.de>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de> <201104061310.38951.johannes.hirte@fem.tu-ilmenau.de> <20110406171541.GA5574@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110406171541.GA5574@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 06 April 2011 19:15:41 Josef Bacik wrote:
> On Wed, Apr 06, 2011 at 01:10:38PM +0200, Johannes Hirte wrote:
> > On Tuesday 05 April 2011 23:57:53 Josef Bacik wrote:
> > > > Now it hit
> > > 
> > > Man I cannot catch a break.  I hope this is the last one.  Thanks,
> 
> Ok I give up, I just cleaned it all up and don't mark the pages as dirty
> unless we're actually going to succeed at writing them.  This should fix
> everything
> 
> ---
>  fs/btrfs/ctree.h            |    5 ++
>  fs/btrfs/file.c             |   21 +++----
>  fs/btrfs/free-space-cache.c |  117
> ++++++++++++++++++++----------------------- 3 files changed, 69
> insertions(+), 74 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3458b57..0d00a07 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2576,6 +2576,11 @@ int btrfs_drop_extents(struct btrfs_trans_handle
> *trans, struct inode *inode, int btrfs_mark_extent_written(struct
> btrfs_trans_handle *trans,
>  			      struct inode *inode, u64 start, u64 end);
>  int btrfs_release_file(struct inode *inode, struct file *file);
> +void btrfs_drop_pages(struct page **pages, size_t num_pages);
> +int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
> +		      struct page **pages, size_t num_pages,
> +		      loff_t pos, size_t write_bytes,
> +		      struct extent_state **cached);
> 
>  /* tree-defrag.c */
>  int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e621ea5..75899a0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -104,7 +104,7 @@ static noinline int btrfs_copy_from_user(loff_t pos,
> int num_pages, /*
>   * unlocks pages after btrfs_file_write is done with them
>   */
> -static noinline void btrfs_drop_pages(struct page **pages, size_t
> num_pages) +void btrfs_drop_pages(struct page **pages, size_t num_pages)
>  {
>  	size_t i;
>  	for (i = 0; i < num_pages; i++) {
> @@ -127,16 +127,13 @@ static noinline void btrfs_drop_pages(struct page
> **pages, size_t num_pages) * this also makes the decision about creating
> an inline extent vs * doing real data extents, marking pages dirty and
> delalloc as required. */
> -static noinline int dirty_and_release_pages(struct btrfs_root *root,
> -					    struct file *file,
> -					    struct page **pages,
> -					    size_t num_pages,
> -					    loff_t pos,
> -					    size_t write_bytes)
> +int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
> +		      struct page **pages, size_t num_pages,
> +		      loff_t pos, size_t write_bytes,
> +		      struct extent_state **cached)
>  {
>  	int err = 0;
>  	int i;
> -	struct inode *inode = fdentry(file)->d_inode;
>  	u64 num_bytes;
>  	u64 start_pos;
>  	u64 end_of_last_block;
> @@ -149,7 +146,7 @@ static noinline int dirty_and_release_pages(struct
> btrfs_root *root,
> 
>  	end_of_last_block = start_pos + num_bytes - 1;
>  	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
> -					NULL);
> +					cached);
>  	if (err)
>  		return err;
> 
> @@ -992,9 +989,9 @@ static noinline ssize_t __btrfs_buffered_write(struct
> file *file, }
> 
>  		if (copied > 0) {
> -			ret = dirty_and_release_pages(root, file, pages,
> -						      dirty_pages, pos,
> -						      copied);
> +			ret = btrfs_dirty_pages(root, inode, pages,
> +						dirty_pages, pos, copied,
> +						NULL);
>  			if (ret) {
>  				btrfs_delalloc_release_space(inode,
>  					dirty_pages << PAGE_CACHE_SHIFT);
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index f561c95..a3f420d 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -508,6 +508,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  	struct inode *inode;
>  	struct rb_node *node;
>  	struct list_head *pos, *n;
> +	struct page **pages;
>  	struct page *page;
>  	struct extent_state *cached_state = NULL;
>  	struct btrfs_free_cluster *cluster = NULL;
> @@ -517,13 +518,13 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  	u64 start, end, len;
>  	u64 bytes = 0;
>  	u32 *crc, *checksums;
> -	pgoff_t index = 0, last_index = 0;
>  	unsigned long first_page_offset;
> -	int num_checksums;
> +	int index = 0, num_pages = 0;
>  	int entries = 0;
>  	int bitmaps = 0;
>  	int ret = 0;
>  	bool next_page = false;
> +	bool out_of_space = false;
> 
>  	root = root->fs_info->tree_root;
> 
> @@ -551,24 +552,31 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		return 0;
>  	}
> 
> -	last_index = (i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT;
> +	num_pages = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
> +		PAGE_CACHE_SHIFT;
>  	filemap_write_and_wait(inode->i_mapping);
>  	btrfs_wait_ordered_range(inode, inode->i_size &
>  				 ~(root->sectorsize - 1), (u64)-1);
> 
>  	/* We need a checksum per page. */
> -	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
> -	crc = checksums  = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
> +	crc = checksums = kzalloc(sizeof(u32) * num_pages, GFP_NOFS);
>  	if (!crc) {
>  		iput(inode);
>  		return 0;
>  	}
> 
> +	pages = kzalloc(sizeof(struct page *) * num_pages, GFP_NOFS);
> +	if (!pages) {
> +		kfree(crc);
> +		iput(inode);
> +		return 0;
> +	}
> +
>  	/* Since the first page has all of our checksums and our generation we
>  	 * need to calculate the offset into the page that we can start writing
>  	 * our entries.
>  	 */
> -	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
> +	first_page_offset = (sizeof(u32) * num_pages) + sizeof(u64);
> 
>  	/* Get the cluster for this block_group if it exists */
>  	if (!list_empty(&block_group->cluster_list))
> @@ -590,20 +598,18 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  	 * after find_get_page at this point.  Just putting this here so people
>  	 * know and don't freak out.
>  	 */
> -	while (index <= last_index) {
> +	while (index < num_pages) {
>  		page = grab_cache_page(inode->i_mapping, index);
>  		if (!page) {
> -			pgoff_t i = 0;
> +			int i;
> 
> -			while (i < index) {
> -				page = find_get_page(inode->i_mapping, i);
> -				unlock_page(page);
> -				page_cache_release(page);
> -				page_cache_release(page);
> -				i++;
> +			for (i = 0; i < num_pages; i++) {
> +				unlock_page(pages[i]);
> +				page_cache_release(pages[i]);
>  			}
>  			goto out_free;
>  		}
> +		pages[index] = page;
>  		index++;
>  	}
> 
> @@ -631,7 +637,12 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  			offset = start_offset;
>  		}
> 
> -		page = find_get_page(inode->i_mapping, index);
> +		if (index >= num_pages) {
> +			out_of_space = true;
> +			break;
> +		}
> +
> +		page = pages[index];
> 
>  		addr = kmap(page);
>  		entry = addr + start_offset;
> @@ -708,23 +719,6 @@ int btrfs_write_out_cache(struct btrfs_root *root,
> 
>  		bytes += PAGE_CACHE_SIZE;
> 
> -		ClearPageChecked(page);
> -		set_page_extent_mapped(page);
> -		SetPageUptodate(page);
> -		set_page_dirty(page);
> -
> -		/*
> -		 * We need to release our reference we got for grab_cache_page,
> -		 * except for the first page which will hold our checksums, we
> -		 * do that below.
> -		 */
> -		if (index != 0) {
> -			unlock_page(page);
> -			page_cache_release(page);
> -		}
> -
> -		page_cache_release(page);
> -
>  		index++;
>  	} while (node || next_page);
> 
> @@ -734,6 +728,10 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		struct btrfs_free_space *entry =
>  			list_entry(pos, struct btrfs_free_space, list);
> 
> +		if (index >= num_pages) {
> +			out_of_space = true;
> +			break;
> +		}
>  		page = find_get_page(inode->i_mapping, index);
> 
>  		addr = kmap(page);
> @@ -745,64 +743,58 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		crc++;
>  		bytes += PAGE_CACHE_SIZE;
> 
> -		ClearPageChecked(page);
> -		set_page_extent_mapped(page);
> -		SetPageUptodate(page);
> -		set_page_dirty(page);
> -		unlock_page(page);
> -		page_cache_release(page);
> -		page_cache_release(page);
>  		list_del_init(&entry->list);
>  		index++;
>  	}
> 
> +	if (out_of_space) {
> +		btrfs_drop_pages(pages, num_pages);
> +		unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
> +				     i_size_read(inode) - 1, &cached_state,
> +				     GFP_NOFS);
> +		ret = 0;
> +		goto out_free;
> +	}
> +
>  	/* Zero out the rest of the pages just to make sure */
> -	while (index <= last_index) {
> +	while (index < num_pages) {
>  		void *addr;
> 
> -		page = find_get_page(inode->i_mapping, index);
> -
> +		page = pages[index];
>  		addr = kmap(page);
>  		memset(addr, 0, PAGE_CACHE_SIZE);
>  		kunmap(page);
> -		ClearPageChecked(page);
> -		set_page_extent_mapped(page);
> -		SetPageUptodate(page);
> -		set_page_dirty(page);
> -		unlock_page(page);
> -		page_cache_release(page);
> -		page_cache_release(page);
>  		bytes += PAGE_CACHE_SIZE;
>  		index++;
>  	}
> 
> -	btrfs_set_extent_delalloc(inode, 0, bytes - 1, &cached_state);
> -
>  	/* Write the checksums and trans id to the first page */
>  	{
>  		void *addr;
>  		u64 *gen;
> 
> -		page = find_get_page(inode->i_mapping, 0);
> +		page = pages[0];
> 
>  		addr = kmap(page);
> -		memcpy(addr, checksums, sizeof(u32) * num_checksums);
> -		gen = addr + (sizeof(u32) * num_checksums);
> +		memcpy(addr, checksums, sizeof(u32) * num_pages);
> +		gen = addr + (sizeof(u32) * num_pages);
>  		*gen = trans->transid;
>  		kunmap(page);
> -		ClearPageChecked(page);
> -		set_page_extent_mapped(page);
> -		SetPageUptodate(page);
> -		set_page_dirty(page);
> -		unlock_page(page);
> -		page_cache_release(page);
> -		page_cache_release(page);
>  	}
> -	BTRFS_I(inode)->generation = trans->transid;
> 
> +	ret = btrfs_dirty_pages(root, inode, pages, num_pages, 0,
> +					    bytes, &cached_state);
> +	btrfs_drop_pages(pages, num_pages);
>  	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
>  			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
> 
> +	if (ret) {
> +		ret = 0;
> +		goto out_free;
> +	}
> +
> +	BTRFS_I(inode)->generation = trans->transid;
> +
>  	filemap_write_and_wait(inode->i_mapping);
> 
>  	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
> @@ -853,6 +845,7 @@ out_free:
>  		BTRFS_I(inode)->generation = 0;
>  	}
>  	kfree(checksums);
> +	kfree(pages);
>  	btrfs_update_inode(trans, root, inode);
>  	iput(inode);
>  	return ret;

After testing the last hours without any oops; i think it's really fixed now. 
It also seems to fix the ENOSPC-bug I've reported some time ago:
http://marc.info/?l=linux-btrfs&m=129120932813085&w=2
Feel free to add my:
Tested-by Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>

regards,
  Johannes
