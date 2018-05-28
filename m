Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43367 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969091AbeE1Pxz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:53:55 -0400
Date: Mon, 28 May 2018 15:46:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v4 6/6] Btrfs: support swap files
Message-ID: <20180528134657.GY6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527197312.git.osandov@fb.com>
 <cafafebe2e9aa01251e761093199966499127fe0.1527197312.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cafafebe2e9aa01251e761093199966499127fe0.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2018 at 02:41:30PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Implement the swap file a_ops on Btrfs. Activation needs to make sure
> that the file can be used as a swap file, which currently means it must
> be fully allocated as nocow with no compression on one device. It also
> sets up the swap extents directly with add_swap_extent(), so export it.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/inode.c | 220 +++++++++++++++++++++++++++++++++++++++++++++++
>  mm/swapfile.c    |   1 +
>  2 files changed, 221 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9228cb866115..6cca8529e307 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10526,6 +10526,224 @@ void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
>  	}
>  }
>  
> +struct btrfs_swap_info {
> +	u64 start;
> +	u64 block_start;
> +	u64 block_len;
> +	u64 lowest_ppage;
> +	u64 highest_ppage;
> +	unsigned long nr_pages;
> +	int nr_extents;
> +};
> +
> +static int btrfs_add_swap_extent(struct swap_info_struct *sis,
> +				 struct btrfs_swap_info *bsi)
> +{
> +	unsigned long nr_pages;
> +	u64 first_ppage, first_ppage_reported, next_ppage;
> +	int ret;
> +
> +	first_ppage = ALIGN(bsi->block_start, PAGE_SIZE) >> PAGE_SHIFT;
> +	next_ppage = ALIGN_DOWN(bsi->block_start + bsi->block_len,
> +				PAGE_SIZE) >> PAGE_SHIFT;
> +
> +	if (first_ppage >= next_ppage)
> +		return 0;
> +	nr_pages = next_ppage - first_ppage;
> +
> +	first_ppage_reported = first_ppage;
> +	if (bsi->start == 0)
> +		first_ppage_reported++;
> +	if (bsi->lowest_ppage > first_ppage_reported)
> +		bsi->lowest_ppage = first_ppage_reported;
> +	if (bsi->highest_ppage < (next_ppage - 1))
> +		bsi->highest_ppage = next_ppage - 1;
> +
> +	ret = add_swap_extent(sis, bsi->nr_pages, nr_pages, first_ppage);
> +	if (ret < 0)
> +		return ret;
> +	bsi->nr_extents += ret;
> +	bsi->nr_pages += nr_pages;
> +	return 0;
> +}
> +
> +static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
> +			       sector_t *span)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> +	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> +	struct extent_state *cached_state = NULL;
> +	struct extent_map *em = NULL;
> +	struct btrfs_device *device = NULL;
> +	struct btrfs_swap_info bsi = {
> +		.lowest_ppage = (sector_t)-1ULL,
> +	};
> +	int ret = 0;
> +	u64 isize = inode->i_size;
> +	u64 start;
> +
> +	/*
> +	 * The inode is locked, so these flags won't change after we check them.
> +	 */
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS) {
> +		btrfs_err(fs_info, "swapfile is compressed");

I'm not sure this is the right way to phrase the error message. I'd
expect something like "swapfile cannot be compressed", but I also think
I've seen the positive and negative elsewhere so there's no universal
style to follow.

> +		return -EINVAL;
> +	}
> +	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
> +		btrfs_err(fs_info, "swapfile is copy-on-write");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Balance or device remove/replace/resize can move stuff around from
> +	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
> +	 * concurrently while we are mapping the swap extents, and the fs_info
> +	 * nr_swapfiles counter prevents them from running while the swap file
> +	 * is active and moving the extents. Note that this also prevents a
> +	 * concurrent device add which isn't actually necessary, but it's not
> +	 * really worth the trouble to allow it.
> +	 */
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> +		return -EBUSY;
> +	atomic_inc(&fs_info->nr_swapfiles);
> +	/*
> +	 * Snapshots can create extents which require COW even if NODATACOW is
> +	 * set. We use this counter to prevent snapshots. We must increment it
> +	 * before walking the extents because we don't want a concurrent
> +	 * snapshot to run after we've already checked the extents.
> +	 */
> +	atomic_inc(&BTRFS_I(inode)->root->nr_swapfiles);
> +
> +	lock_extent_bits(io_tree, 0, isize - 1, &cached_state);
> +	start = 0;
> +	while (start < isize) {
> +		u64 end, logical_block_start, physical_block_start;
> +		u64 len = isize - start;
> +
> +		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto out;
> +		}
> +		end = extent_map_end(em);
> +
> +		if (em->block_start == EXTENT_MAP_HOLE) {
> +			btrfs_err(fs_info, "swapfile has holes");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		if (em->block_start == EXTENT_MAP_INLINE) {
> +			/*
> +			 * It's unlikely we'll ever actually find ourselves
> +			 * here, as a file small enough to fit inline won't be
> +			 * big enough to store more than the swap header, but in
> +			 * case something changes in the future, let's catch it
> +			 * here rather than later.
> +			 */
> +			btrfs_err(fs_info, "swapfile is inline");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
> +			btrfs_err(fs_info, "swapfile is compressed");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		logical_block_start = em->block_start + (start - em->start);
> +		len = min(len, em->len - (start - em->start));
> +		free_extent_map(em);
> +		em = NULL;
> +
> +		ret = can_nocow_extent(inode, start, &len, NULL, NULL, NULL);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (ret) {
> +			ret = 0;
> +		} else {
> +			btrfs_err(fs_info, "swapfile is copy-on-write");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		em = btrfs_get_chunk_map(fs_info, logical_block_start, len);
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto out;
> +		}
> +
> +		if (em->map_lookup->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +			btrfs_err(fs_info, "swapfile data profile is not single");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (device == NULL) {
> +			device = em->map_lookup->stripes[0].dev;
> +		} else if (device != em->map_lookup->stripes[0].dev) {
> +			btrfs_err(fs_info, "swapfile is on multiple devices");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		physical_block_start = (em->map_lookup->stripes[0].physical +
> +					(logical_block_start - em->start));
> +		len = min(len, em->len - (logical_block_start - em->start));
> +		free_extent_map(em);
> +		em = NULL;
> +
> +		if (bsi.block_len &&
> +		    bsi.block_start + bsi.block_len == physical_block_start) {
> +			bsi.block_len += len;
> +		} else {
> +			if (bsi.block_len) {
> +				ret = btrfs_add_swap_extent(sis, &bsi);
> +				if (ret)
> +					goto out;
> +			}
> +			bsi.start = start;
> +			bsi.block_start = physical_block_start;
> +			bsi.block_len = len;
> +		}
> +
> +		start = end;
> +	}
> +
> +	if (bsi.block_len)
> +		ret = btrfs_add_swap_extent(sis, &bsi);
> +
> +out:
> +	if (!IS_ERR_OR_NULL(em))
> +		free_extent_map(em);
> +
> +	unlock_extent_cached(io_tree, 0, isize - 1, &cached_state);
> +
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> +
> +	if (ret) {
> +		atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
> +		atomic_dec(&fs_info->nr_swapfiles);
> +		return ret;
> +	}

Clearing the EXCL_OP should be done here, so the order of release is
reversed so the contexts are properly nested.

> +
> +	if (device)
> +		sis->bdev = device->bdev;
> +	*span = bsi.highest_ppage - bsi.lowest_ppage + 1;
> +	sis->max = bsi.nr_pages;
> +	sis->pages = bsi.nr_pages - 1;
> +	sis->highest_bit = bsi.nr_pages - 1;
> +	return bsi.nr_extents;
> +}
> +
> +static void btrfs_swap_deactivate(struct file *file)
> +{
> +	struct inode *inode = file_inode(file);
> +
> +	atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
> +	atomic_dec(&BTRFS_I(inode)->root->fs_info->nr_swapfiles);
> +}
> +
>  static const struct inode_operations btrfs_dir_inode_operations = {
>  	.getattr	= btrfs_getattr,
>  	.lookup		= btrfs_lookup,
> @@ -10606,6 +10824,8 @@ static const struct address_space_operations btrfs_aops = {
>  	.releasepage	= btrfs_releasepage,
>  	.set_page_dirty	= btrfs_set_page_dirty,
>  	.error_remove_page = generic_error_remove_page,
> +	.swap_activate	= btrfs_swap_activate,
> +	.swap_deactivate = btrfs_swap_deactivate,
>  };
>  
>  static const struct address_space_operations btrfs_symlink_aops = {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 886c9d89b144..0d934b5be05c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2382,6 +2382,7 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
>  	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
>  	return 1;
>  }
> +EXPORT_SYMBOL_GPL(add_swap_extent);

This maybe needs to go as a separate patch as it's an export in a
different subsystem, unless ou get an ack to do it in the same patch.
