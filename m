Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbbGAOfe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 10:35:34 -0400
Date: Wed, 1 Jul 2015 22:33:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 04/21] Btrfs: subpagesize-blocksize: Define
 extent_buffer_head.
Message-ID: <20150701143319.GA7847@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-5-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-5-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:39PM +0530, Chandan Rajendra wrote:
> In order to handle multiple extent buffers per page, first we need to create a
> way to handle all the extent buffers that are attached to a page.
> 
> This patch creates a new data structure 'struct extent_buffer_head', and moves
> fields that are common to all extent buffers in a page from 'struct extent
> buffer' to 'struct extent_buffer_head'

This makes that extent buffers in a page share @ref on ebh and may
cause much memory pressure as they may not be freed even with
setting EXTENT_BUFFER_STALE, but I guess that's the penaty we have to
pay in such ways.

Others look good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
> EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
> extent_buffer_head->bflags.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/backref.c           |   2 +-
>  fs/btrfs/ctree.c             |   2 +-
>  fs/btrfs/ctree.h             |   6 +-
>  fs/btrfs/disk-io.c           |  73 ++++---
>  fs/btrfs/extent-tree.c       |   6 +-
>  fs/btrfs/extent_io.c         | 469 ++++++++++++++++++++++++++++---------------
>  fs/btrfs/extent_io.h         |  39 +++-
>  fs/btrfs/volumes.c           |   2 +-
>  include/trace/events/btrfs.h |   2 +-
>  9 files changed, 392 insertions(+), 209 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 9de772e..b4d911c 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1372,7 +1372,7 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>  		eb = path->nodes[0];
>  		/* make sure we can use eb after releasing the path */
>  		if (eb != eb_in) {
> -			atomic_inc(&eb->refs);
> +			atomic_inc(&eb_head(eb)->refs);
>  			btrfs_tree_read_lock(eb);
>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>  		}
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 0f11ebc..b28f14d 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -159,7 +159,7 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
>  		 * the inc_not_zero dance and if it doesn't work then
>  		 * synchronize_rcu and try again.
>  		 */
> -		if (atomic_inc_not_zero(&eb->refs)) {
> +		if (atomic_inc_not_zero(&eb_head(eb)->refs)) {
>  			rcu_read_unlock();
>  			break;
>  		}
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6f364e1..2bc3e0e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2320,14 +2320,16 @@ static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
>  #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
>  static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
>  {									\
> -	type *p = page_address(eb->pages[0]);				\
> +	type *p = page_address(eb_head(eb)->pages[0]) +			\
> +				(eb->start & (PAGE_CACHE_SIZE -1));	\
>  	u##bits res = le##bits##_to_cpu(p->member);			\
>  	return res;							\
>  }									\
>  static inline void btrfs_set_##name(struct extent_buffer *eb,		\
>  				    u##bits val)			\
>  {									\
> -	type *p = page_address(eb->pages[0]);				\
> +	type *p = page_address(eb_head(eb)->pages[0]) +			\
> +				(eb->start & (PAGE_CACHE_SIZE -1));	\
>  	p->member = cpu_to_le##bits(val);				\
>  }
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2ef9a4b..51fe2ec 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -368,9 +368,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>  		ret = 0;
>  		goto out;
>  	}
> +
>  	printk_ratelimited(KERN_ERR
>  	    "BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",
> -			eb->fs_info->sb->s_id, eb->start,
> +			eb_head(eb)->fs_info->sb->s_id, eb->start,
>  			parent_transid, btrfs_header_generation(eb));
>  	ret = 1;
>  
> @@ -445,7 +446,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  	int mirror_num = 0;
>  	int failed_mirror = 0;
>  
> -	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
> +	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
>  	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
>  	while (1) {
>  		ret = read_extent_buffer_pages(io_tree, eb, start,
> @@ -464,7 +465,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  		 * there is no reason to read the other copies, they won't be
>  		 * any less wrong.
>  		 */
> -		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
> +		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags))
>  			break;
>  
>  		num_copies = btrfs_num_copies(root->fs_info,
> @@ -622,7 +623,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  		goto err;
>  
>  	eb->read_mirror = mirror;
> -	if (test_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags)) {
> +	if (test_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags)) {
>  		ret = -EIO;
>  		goto err;
>  	}
> @@ -631,13 +632,14 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	if (found_start != eb->start) {
>  		printk_ratelimited(KERN_ERR "BTRFS (device %s): bad tree block start "
>  			       "%llu %llu\n",
> -			       eb->fs_info->sb->s_id, found_start, eb->start);
> +				eb_head(eb)->fs_info->sb->s_id, found_start,
> +				eb->start);
>  		ret = -EIO;
>  		goto err;
>  	}
>  	if (check_tree_block_fsid(root->fs_info, eb)) {
>  		printk_ratelimited(KERN_ERR "BTRFS (device %s): bad fsid on block %llu\n",
> -			       eb->fs_info->sb->s_id, eb->start);
> +			       eb_head(eb)->fs_info->sb->s_id, eb->start);
>  		ret = -EIO;
>  		goto err;
>  	}
> @@ -664,7 +666,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	 * return -EIO.
>  	 */
>  	if (found_level == 0 && check_leaf(root, eb)) {
> -		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
> +		set_bit(EXTENT_BUFFER_CORRUPT, &eb->ebflags);
>  		ret = -EIO;
>  	}
>  
> @@ -672,7 +674,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  		set_extent_buffer_uptodate(eb);
>  err:
>  	if (reads_done &&
> -	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
> +	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
>  		btree_readahead_hook(root, eb, eb->start, ret);
>  
>  	if (ret) {
> @@ -695,10 +697,10 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
>  	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
>  
>  	eb = (struct extent_buffer *)page->private;
> -	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
> +	set_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
>  	eb->read_mirror = failed_mirror;
>  	atomic_dec(&eb->io_pages);
> -	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
> +	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->ebflags))
>  		btree_readahead_hook(root, eb, eb->start, -EIO);
>  	return -EIO;	/* we fixed nothing */
>  }
> @@ -1047,13 +1049,24 @@ static int btree_set_page_dirty(struct page *page)
>  {
>  #ifdef DEBUG
>  	struct extent_buffer *eb;
> +	int i, dirty = 0;
>  
>  	BUG_ON(!PagePrivate(page));
>  	eb = (struct extent_buffer *)page->private;
>  	BUG_ON(!eb);
> -	BUG_ON(!test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -	BUG_ON(!atomic_read(&eb->refs));
> -	btrfs_assert_tree_locked(eb);
> +
> +	do {
> +		dirty = test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
> +		if (dirty)
> +			break;
> +	} while ((eb = eb->eb_next) != NULL);
> +
> +	BUG_ON(!dirty);
> +
> +	eb = (struct extent_buffer *)page->private;
> +	BUG_ON(!atomic_read(&(eb_head(eb)->refs)));
> +
> +	btrfs_assert_tree_locked(&ebh->eb);
>  #endif
>  	return __set_page_dirty_nobuffers(page);
>  }
> @@ -1094,7 +1107,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>  	if (!buf)
>  		return 0;
>  
> -	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
> +	set_bit(EXTENT_BUFFER_READAHEAD, &buf->ebflags);
>  
>  	ret = read_extent_buffer_pages(io_tree, buf, 0, WAIT_PAGE_LOCK,
>  				       btree_get_extent, mirror_num);
> @@ -1103,7 +1116,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
>  		return ret;
>  	}
>  
> -	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
> +	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags)) {
>  		free_extent_buffer(buf);
>  		return -EIO;
>  	} else if (extent_buffer_uptodate(buf)) {
> @@ -1131,14 +1144,16 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
>  
>  int btrfs_write_tree_block(struct extent_buffer *buf)
>  {
> -	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
> +	return filemap_fdatawrite_range(eb_head(buf)->pages[0]->mapping,
> +					buf->start,
>  					buf->start + buf->len - 1);
>  }
>  
>  int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
>  {
> -	return filemap_fdatawait_range(buf->pages[0]->mapping,
> -				       buf->start, buf->start + buf->len - 1);
> +	return filemap_fdatawait_range(eb_head(buf)->pages[0]->mapping,
> +					buf->start,
> +					buf->start + buf->len - 1);
>  }
>  
>  struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
> @@ -1168,7 +1183,8 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
>  	    fs_info->running_transaction->transid) {
>  		btrfs_assert_tree_locked(buf);
>  
> -		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
> +		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
> +						&buf->ebflags)) {
>  			__percpu_counter_add(&fs_info->dirty_metadata_bytes,
>  					     -buf->len,
>  					     fs_info->dirty_metadata_batch);
> @@ -2798,9 +2814,10 @@ int open_ctree(struct super_block *sb,
>  					   btrfs_super_chunk_root(disk_super),
>  					   generation);
>  	if (!chunk_root->node ||
> -	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
> +		!test_bit(EXTENT_BUFFER_UPTODATE,
> +			&chunk_root->node->ebflags)) {
>  		printk(KERN_ERR "BTRFS: failed to read chunk root on %s\n",
> -		       sb->s_id);
> +			sb->s_id);
>  		goto fail_tree_roots;
>  	}
>  	btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
> @@ -2835,7 +2852,8 @@ retry_root_backup:
>  					  btrfs_super_root(disk_super),
>  					  generation);
>  	if (!tree_root->node ||
> -	    !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
> +		!test_bit(EXTENT_BUFFER_UPTODATE,
> +			&tree_root->node->ebflags)) {
>  		printk(KERN_WARNING "BTRFS: failed to read tree root on %s\n",
>  		       sb->s_id);
>  
> @@ -3786,7 +3804,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
>  			  int atomic)
>  {
>  	int ret;
> -	struct inode *btree_inode = buf->pages[0]->mapping->host;
> +	struct inode *btree_inode = eb_head(buf)->pages[0]->mapping->host;
>  
>  	ret = extent_buffer_uptodate(buf);
>  	if (!ret)
> @@ -3816,10 +3834,10 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>  	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
>  	 * outside of the sanity tests.
>  	 */
> -	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
> +	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb_head(buf)->bflags)))
>  		return;
>  #endif
> -	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
> +	root = BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
>  	btrfs_assert_tree_locked(buf);
>  	if (transid != root->fs_info->generation)
>  		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
> @@ -3874,7 +3892,8 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
>  
>  int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
>  {
> -	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
> +	struct btrfs_root *root =
> +			BTRFS_I(eb_head(buf)->pages[0]->mapping->host)->root;
>  	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
>  }
>  
> @@ -4185,7 +4204,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
>  			wait_on_extent_buffer_writeback(eb);
>  
>  			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
> -					       &eb->bflags))
> +					       &eb->ebflags))
>  				clear_extent_buffer_dirty(eb);
>  			free_extent_buffer_stale(eb);
>  		}
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1eef4ee..b93a922 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6450,7 +6450,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  			goto out;
>  		}
>  
> -		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
> +		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->ebflags));
>  
>  		btrfs_add_free_space(cache, buf->start, buf->len);
>  		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
> @@ -6468,7 +6468,7 @@ out:
>  	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
>  	 * anymore.
>  	 */
> -	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
> +	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->ebflags);
>  }
>  
>  /* Can return -ENOMEM */
> @@ -7444,7 +7444,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
>  	btrfs_tree_lock(buf);
>  	clean_tree_block(trans, root->fs_info, buf);
> -	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
> +	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
>  
>  	btrfs_set_lock_blocking(buf);
>  	btrfs_set_buffer_uptodate(buf);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 3736ab5..a7e715a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -61,6 +61,7 @@ void btrfs_leak_debug_check(void)
>  {
>  	struct extent_state *state;
>  	struct extent_buffer *eb;
> +	struct extent_buffer_head *ebh;
>  
>  	while (!list_empty(&states)) {
>  		state = list_entry(states.next, struct extent_state, leak_list);
> @@ -73,12 +74,17 @@ void btrfs_leak_debug_check(void)
>  	}
>  
>  	while (!list_empty(&buffers)) {
> -		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
> -		printk(KERN_ERR "BTRFS: buffer leak start %llu len %lu "
> -		       "refs %d\n",
> -		       eb->start, eb->len, atomic_read(&eb->refs));
> -		list_del(&eb->leak_list);
> -		kmem_cache_free(extent_buffer_cache, eb);
> +		ebh = list_entry(buffers.next, struct extent_buffer_head, leak_list);
> +		printk(KERN_ERR "btrfs buffer leak ");
> +
> +		eb = &ebh->eb;
> +		do {
> +			printk(KERN_ERR "eb %p %llu:%lu ", eb, eb->start, eb->len);
> +		} while ((eb = eb->eb_next) != NULL);
> +
> +		printk(KERN_ERR "refs %d\n", atomic_read(&ebh->refs));
> +		list_del(&ebh->leak_list);
> +		kmem_cache_free(extent_buffer_cache, ebh);
>  	}
>  }
>  
> @@ -149,7 +155,7 @@ int __init extent_io_init(void)
>  		return -ENOMEM;
>  
>  	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
> -			sizeof(struct extent_buffer), 0,
> +			sizeof(struct extent_buffer_head), 0,
>  			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
>  	if (!extent_buffer_cache)
>  		goto free_state_cache;
> @@ -2170,7 +2176,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
>  		return -EROFS;
>  
>  	for (i = 0; i < num_pages; i++) {
> -		struct page *p = eb->pages[i];
> +		struct page *p = eb_head(eb)->pages[i];
>  
>  		ret = repair_io_failure(root->fs_info->btree_inode, start,
>  					PAGE_CACHE_SIZE, start, p,
> @@ -3625,8 +3631,8 @@ done_unlocked:
>  
>  void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
>  {
> -	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_WRITEBACK,
> -		       TASK_UNINTERRUPTIBLE);
> +	wait_on_bit_io(&eb->ebflags, EXTENT_BUFFER_WRITEBACK,
> +		    TASK_UNINTERRUPTIBLE);
>  }
>  
>  static noinline_for_stack int
> @@ -3644,7 +3650,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>  		btrfs_tree_lock(eb);
>  	}
>  
> -	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
> +	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)) {
>  		btrfs_tree_unlock(eb);
>  		if (!epd->sync_io)
>  			return 0;
> @@ -3655,7 +3661,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>  		while (1) {
>  			wait_on_extent_buffer_writeback(eb);
>  			btrfs_tree_lock(eb);
> -			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
> +			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags))
>  				break;
>  			btrfs_tree_unlock(eb);
>  		}
> @@ -3666,17 +3672,17 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>  	 * under IO since we can end up having no IO bits set for a short period
>  	 * of time.
>  	 */
> -	spin_lock(&eb->refs_lock);
> -	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
> -		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
> -		spin_unlock(&eb->refs_lock);
> +	spin_lock(&eb_head(eb)->refs_lock);
> +	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags)) {
> +		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
> +		spin_unlock(&eb_head(eb)->refs_lock);
>  		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
>  		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
>  				     -eb->len,
>  				     fs_info->dirty_metadata_batch);
>  		ret = 1;
>  	} else {
> -		spin_unlock(&eb->refs_lock);
> +		spin_unlock(&eb_head(eb)->refs_lock);
>  	}
>  
>  	btrfs_tree_unlock(eb);
> @@ -3686,7 +3692,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>  
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	for (i = 0; i < num_pages; i++) {
> -		struct page *p = eb->pages[i];
> +		struct page *p = eb_head(eb)->pages[i];
>  
>  		if (!trylock_page(p)) {
>  			if (!flush) {
> @@ -3702,18 +3708,19 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
>  
>  static void end_extent_buffer_writeback(struct extent_buffer *eb)
>  {
> -	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
> +	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
>  	smp_mb__after_atomic();
> -	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
> +	wake_up_bit(&eb->ebflags, EXTENT_BUFFER_WRITEBACK);
>  }
>  
>  static void set_btree_ioerr(struct page *page)
>  {
>  	struct extent_buffer *eb = (struct extent_buffer *)page->private;
> -	struct btrfs_inode *btree_ino = BTRFS_I(eb->fs_info->btree_inode);
> +	struct extent_buffer_head *ebh = eb_head(eb);
> +	struct btrfs_inode *btree_ino = BTRFS_I(ebh->fs_info->btree_inode);
>  
>  	SetPageError(page);
> -	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
> +	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags))
>  		return;
>  
>  	/*
> @@ -3782,7 +3789,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
>  		BUG_ON(!eb);
>  		done = atomic_dec_and_test(&eb->io_pages);
>  
> -		if (err || test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
> +		if (err || test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags)) {
>  			ClearPageUptodate(page);
>  			set_btree_ioerr(page);
>  		}
> @@ -3811,14 +3818,14 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>  	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
>  	int ret = 0;
>  
> -	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
> +	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags);
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	atomic_set(&eb->io_pages, num_pages);
>  	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
>  		bio_flags = EXTENT_BIO_TREE_LOG;
>  
>  	for (i = 0; i < num_pages; i++) {
> -		struct page *p = eb->pages[i];
> +		struct page *p = eb_head(eb)->pages[i];
>  
>  		clear_page_dirty_for_io(p);
>  		set_page_writeback(p);
> @@ -3842,7 +3849,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>  
>  	if (unlikely(ret)) {
>  		for (; i < num_pages; i++) {
> -			struct page *p = eb->pages[i];
> +			struct page *p = eb_head(eb)->pages[i];
>  			clear_page_dirty_for_io(p);
>  			unlock_page(p);
>  		}
> @@ -4605,17 +4612,36 @@ out:
>  	return ret;
>  }
>  
> -static void __free_extent_buffer(struct extent_buffer *eb)
> +static void __free_extent_buffer(struct extent_buffer_head *ebh)
>  {
> -	btrfs_leak_debug_del(&eb->leak_list);
> -	kmem_cache_free(extent_buffer_cache, eb);
> +	struct extent_buffer *eb, *next_eb;
> +
> +	btrfs_leak_debug_del(&ebh->leak_list);
> +
> +	eb = ebh->eb.eb_next;
> +	while (eb) {
> +		next_eb = eb->eb_next;
> +		kfree(eb);
> +		eb = next_eb;
> +	}
> +
> +	kmem_cache_free(extent_buffer_cache, ebh);
>  }
>  
>  int extent_buffer_under_io(struct extent_buffer *eb)
>  {
> -	return (atomic_read(&eb->io_pages) ||
> -		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> -		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +	struct extent_buffer_head *ebh = eb->ebh;
> +	int dirty_or_writeback = 0;
> +
> +	for (eb = &ebh->eb; eb; eb = eb->eb_next) {
> +		if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)
> +			|| test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags)) {
> +			dirty_or_writeback = 1;
> +			break;
> +		}
> +	}
> +
> +	return (atomic_read(&ebh->io_bvecs) || dirty_or_writeback);
>  }
>  
>  /*
> @@ -4625,7 +4651,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>  {
>  	unsigned long index;
>  	struct page *page;
> -	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
> +	struct extent_buffer_head *ebh = eb_head(eb);
> +	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags);
>  
>  	BUG_ON(extent_buffer_under_io(eb));
>  
> @@ -4634,8 +4661,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>  		return;
>  
>  	do {
> +		struct extent_buffer *e;
> +
>  		index--;
> -		page = eb->pages[index];
> +		page = ebh->pages[index];
>  		if (page && mapped) {
>  			spin_lock(&page->mapping->private_lock);
>  			/*
> @@ -4646,8 +4675,10 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>  			 * this eb.
>  			 */
>  			if (PagePrivate(page) &&
> -			    page->private == (unsigned long)eb) {
> -				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +				page->private == (unsigned long)(&ebh->eb)) {
> +				for (e = &ebh->eb; !e; e = e->eb_next)
> +					BUG_ON(test_bit(EXTENT_BUFFER_DIRTY,
> +								&e->ebflags));
>  				BUG_ON(PageDirty(page));
>  				BUG_ON(PageWriteback(page));
>  				/*
> @@ -4675,22 +4706,18 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>  static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
>  {
>  	btrfs_release_extent_buffer_page(eb);
> -	__free_extent_buffer(eb);
> +	__free_extent_buffer(eb_head(eb));
>  }
>  
> -static struct extent_buffer *
> -__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
> -		      unsigned long len)
> +static void __init_extent_buffer(struct extent_buffer *eb,
> +				struct extent_buffer_head *ebh,
> +				u64 start,
> +				unsigned long len)
>  {
> -	struct extent_buffer *eb = NULL;
> -
> -	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS);
> -	if (eb == NULL)
> -		return NULL;
>  	eb->start = start;
>  	eb->len = len;
> -	eb->fs_info = fs_info;
> -	eb->bflags = 0;
> +	eb->ebh = ebh;
> +	eb->eb_next = NULL;
>  	rwlock_init(&eb->lock);
>  	atomic_set(&eb->write_locks, 0);
>  	atomic_set(&eb->read_locks, 0);
> @@ -4701,12 +4728,26 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>  	eb->lock_nested = 0;
>  	init_waitqueue_head(&eb->write_lock_wq);
>  	init_waitqueue_head(&eb->read_lock_wq);
> +}
>  
> -	btrfs_leak_debug_add(&eb->leak_list, &buffers);
> +static struct extent_buffer *
> +__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
> +		      unsigned long len)
> +{
> +	struct extent_buffer_head *ebh = NULL;
> +	struct extent_buffer *eb = NULL;
> +	int i;
> +
> +	ebh = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS);
> +	if (ebh == NULL)
> +		return NULL;
> +	ebh->fs_info = fs_info;
> +	ebh->bflags = 0;
> +	btrfs_leak_debug_add(&ebh->leak_list, &buffers);
>  
> -	spin_lock_init(&eb->refs_lock);
> -	atomic_set(&eb->refs, 1);
> -	atomic_set(&eb->io_pages, 0);
> +	spin_lock_init(&ebh->refs_lock);
> +	atomic_set(&ebh->refs, 1);
> +	atomic_set(&ebh->io_bvecs, 0);
>  
>  	/*
>  	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
> @@ -4715,6 +4756,29 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
>  		> MAX_INLINE_EXTENT_BUFFER_SIZE);
>  	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
>  
> +	if (len < PAGE_CACHE_SIZE) {
> +		struct extent_buffer *cur_eb, *prev_eb;
> +		int ebs_per_page = PAGE_CACHE_SIZE / len;
> +		u64 st = start & ~(PAGE_CACHE_SIZE - 1);
> +
> +		prev_eb = NULL;
> +		cur_eb = &ebh->eb;
> +		for (i = 0; i < ebs_per_page; i++, st += len) {
> +			if (prev_eb) {
> +				cur_eb = kzalloc(sizeof(*eb), GFP_NOFS);
> +				prev_eb->eb_next = cur_eb;
> +			}
> +			__init_extent_buffer(cur_eb, ebh, st, len);
> +			prev_eb = cur_eb;
> +			if (st == start)
> +				eb = cur_eb;
> +		}
> +		BUG_ON(!eb);
> +	} else {
> +		eb = &ebh->eb;
> +		__init_extent_buffer(eb, ebh, start, len);
> +	}
> +
>  	return eb;
>  }
>  
> @@ -4725,7 +4789,8 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  	struct extent_buffer *new;
>  	unsigned long num_pages = num_extent_pages(src->start, src->len);
>  
> -	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
> +	new = __alloc_extent_buffer(eb_head(src)->fs_info, src->start,
> +				src->len);
>  	if (new == NULL)
>  		return NULL;
>  
> @@ -4735,15 +4800,16 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  			btrfs_release_extent_buffer(new);
>  			return NULL;
>  		}
> -		attach_extent_buffer_page(new, p);
> +		attach_extent_buffer_page(&(eb_head(new)->eb), p);
>  		WARN_ON(PageDirty(p));
>  		SetPageUptodate(p);
> -		new->pages[i] = p;
> +		eb_head(new)->pages[i] = p;
>  	}
>  
> +	set_bit(EXTENT_BUFFER_UPTODATE, &new->ebflags);
> +	set_bit(EXTENT_BUFFER_DUMMY, &eb_head(new)->bflags);
> +
>  	copy_extent_buffer(new, src, 0, 0, src->len);
> -	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
> -	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
>  
>  	return new;
>  }
> @@ -4772,19 +4838,19 @@ struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>  		return NULL;
>  
>  	for (i = 0; i < num_pages; i++) {
> -		eb->pages[i] = alloc_page(GFP_NOFS);
> -		if (!eb->pages[i])
> +		eb_head(eb)->pages[i] = alloc_page(GFP_NOFS);
> +		if (!eb_head(eb)->pages[i])
>  			goto err;
>  	}
>  	set_extent_buffer_uptodate(eb);
>  	btrfs_set_header_nritems(eb, 0);
> -	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
> +	set_bit(EXTENT_BUFFER_DUMMY, &eb_head(eb)->bflags);
>  
>  	return eb;
>  err:
>  	for (; i > 0; i--)
> -		__free_page(eb->pages[i - 1]);
> -	__free_extent_buffer(eb);
> +		__free_page(eb_head(eb)->pages[i - 1]);
> +	__free_extent_buffer(eb_head(eb));
>  	return NULL;
>  }
>  
> @@ -4811,14 +4877,15 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
>  	 * So bump the ref count first, then set the bit.  If someone
>  	 * beat us to it, drop the ref we added.
>  	 */
> -	refs = atomic_read(&eb->refs);
> -	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
> +	refs = atomic_read(&eb_head(eb)->refs);
> +	if (refs >= 2 && test_bit(EXTENT_BUFFER_TREE_REF,
> +					&eb_head(eb)->bflags))
>  		return;
>  
> -	spin_lock(&eb->refs_lock);
> -	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
> -		atomic_inc(&eb->refs);
> -	spin_unlock(&eb->refs_lock);
> +	spin_lock(&eb_head(eb)->refs_lock);
> +	if (!test_and_set_bit(EXTENT_BUFFER_TREE_REF, &eb_head(eb)->bflags))
> +		atomic_inc(&eb_head(eb)->refs);
> +	spin_unlock(&eb_head(eb)->refs_lock);
>  }
>  
>  static void mark_extent_buffer_accessed(struct extent_buffer *eb,
> @@ -4830,7 +4897,7 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
>  
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	for (i = 0; i < num_pages; i++) {
> -		struct page *p = eb->pages[i];
> +		struct page *p = eb_head(eb)->pages[i];
>  
>  		if (p != accessed)
>  			mark_page_accessed(p);
> @@ -4840,15 +4907,24 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
>  struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
>  					 u64 start)
>  {
> +	struct extent_buffer_head *ebh;
>  	struct extent_buffer *eb;
>  
>  	rcu_read_lock();
> -	eb = radix_tree_lookup(&fs_info->buffer_radix,
> -			       start >> PAGE_CACHE_SHIFT);
> -	if (eb && atomic_inc_not_zero(&eb->refs)) {
> +	ebh = radix_tree_lookup(&fs_info->buffer_radix,
> +				start >> PAGE_CACHE_SHIFT);
> +	if (ebh && atomic_inc_not_zero(&ebh->refs)) {
>  		rcu_read_unlock();
> -		mark_extent_buffer_accessed(eb, NULL);
> -		return eb;
> +
> +		eb = &ebh->eb;
> +		do {
> +			if (eb->start == start) {
> +				mark_extent_buffer_accessed(eb, NULL);
> +				return eb;
> +			}
> +		} while ((eb = eb->eb_next) != NULL);
> +
> +		BUG();
>  	}
>  	rcu_read_unlock();
>  
> @@ -4909,7 +4985,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  	unsigned long num_pages = num_extent_pages(start, len);
>  	unsigned long i;
>  	unsigned long index = start >> PAGE_CACHE_SHIFT;
> -	struct extent_buffer *eb;
> +	struct extent_buffer *eb, *cur_eb;
>  	struct extent_buffer *exists = NULL;
>  	struct page *p;
>  	struct address_space *mapping = fs_info->btree_inode->i_mapping;
> @@ -4939,12 +5015,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  			 * overwrite page->private.
>  			 */
>  			exists = (struct extent_buffer *)p->private;
> -			if (atomic_inc_not_zero(&exists->refs)) {
> +			if (atomic_inc_not_zero(&eb_head(exists)->refs)) {
>  				spin_unlock(&mapping->private_lock);
>  				unlock_page(p);
>  				page_cache_release(p);
> -				mark_extent_buffer_accessed(exists, p);
> -				goto free_eb;
> +				do {
> +					if (exists->start == start) {
> +						mark_extent_buffer_accessed(exists, p);
> +						goto free_eb;
> +					}
> +				} while ((exists = exists->eb_next) != NULL);
> +
> +				BUG();
>  			}
>  
>  			/*
> @@ -4955,10 +5037,11 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  			WARN_ON(PageDirty(p));
>  			page_cache_release(p);
>  		}
> -		attach_extent_buffer_page(eb, p);
> +		attach_extent_buffer_page(&(eb_head(eb)->eb), p);
>  		spin_unlock(&mapping->private_lock);
>  		WARN_ON(PageDirty(p));
> -		eb->pages[i] = p;
> +		mark_page_accessed(p);
> +		eb_head(eb)->pages[i] = p;
>  		if (!PageUptodate(p))
>  			uptodate = 0;
>  
> @@ -4967,16 +5050,22 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  		 * and why we unlock later
>  		 */
>  	}
> -	if (uptodate)
> -		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> +	if (uptodate) {
> +		cur_eb = &(eb_head(eb)->eb);
> +		do {
> +			set_bit(EXTENT_BUFFER_UPTODATE, &cur_eb->ebflags);
> +		} while ((cur_eb = cur_eb->eb_next) != NULL);
> +	}
>  again:
>  	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
> -	if (ret)
> +	if (ret) {
> +		exists = NULL;
>  		goto free_eb;
> +	}
>  
>  	spin_lock(&fs_info->buffer_lock);
>  	ret = radix_tree_insert(&fs_info->buffer_radix,
> -				start >> PAGE_CACHE_SHIFT, eb);
> +				start >> PAGE_CACHE_SHIFT, eb_head(eb));
>  	spin_unlock(&fs_info->buffer_lock);
>  	radix_tree_preload_end();
>  	if (ret == -EEXIST) {
> @@ -4988,7 +5077,7 @@ again:
>  	}
>  	/* add one reference for the tree */
>  	check_buffer_tree_ref(eb);
> -	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
> +	set_bit(EXTENT_BUFFER_IN_TREE, &eb_head(eb)->bflags);
>  
>  	/*
>  	 * there is a race where release page may have
> @@ -4999,114 +5088,131 @@ again:
>  	 * after the extent buffer is in the radix tree so
>  	 * it doesn't get lost
>  	 */
> -	SetPageChecked(eb->pages[0]);
> +	SetPageChecked(eb_head(eb)->pages[0]);
>  	for (i = 1; i < num_pages; i++) {
> -		p = eb->pages[i];
> +		p = eb_head(eb)->pages[i];
>  		ClearPageChecked(p);
>  		unlock_page(p);
>  	}
> -	unlock_page(eb->pages[0]);
> +	unlock_page(eb_head(eb)->pages[0]);
>  	return eb;
>  
>  free_eb:
>  	for (i = 0; i < num_pages; i++) {
> -		if (eb->pages[i])
> -			unlock_page(eb->pages[i]);
> +		if (eb_head(eb)->pages[i])
> +			unlock_page(eb_head(eb)->pages[i]);
>  	}
>  
> -	WARN_ON(!atomic_dec_and_test(&eb->refs));
> +	WARN_ON(!atomic_dec_and_test(&eb_head(eb)->refs));
>  	btrfs_release_extent_buffer(eb);
>  	return exists;
>  }
>  
>  static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
>  {
> -	struct extent_buffer *eb =
> -			container_of(head, struct extent_buffer, rcu_head);
> +	struct extent_buffer_head *ebh =
> +			container_of(head, struct extent_buffer_head, rcu_head);
>  
> -	__free_extent_buffer(eb);
> +	__free_extent_buffer(ebh);
>  }
>  
>  /* Expects to have eb->eb_lock already held */
> -static int release_extent_buffer(struct extent_buffer *eb)
> +static int release_extent_buffer(struct extent_buffer_head *ebh)
>  {
> -	WARN_ON(atomic_read(&eb->refs) == 0);
> -	if (atomic_dec_and_test(&eb->refs)) {
> -		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
> -			struct btrfs_fs_info *fs_info = eb->fs_info;
> +	WARN_ON(atomic_read(&ebh->refs) == 0);
> +	if (atomic_dec_and_test(&ebh->refs)) {
> +		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &ebh->bflags)) {
> +			struct btrfs_fs_info *fs_info = ebh->fs_info;
>  
> -			spin_unlock(&eb->refs_lock);
> +			spin_unlock(&ebh->refs_lock);
>  
>  			spin_lock(&fs_info->buffer_lock);
>  			radix_tree_delete(&fs_info->buffer_radix,
> -					  eb->start >> PAGE_CACHE_SHIFT);
> +					ebh->eb.start >> PAGE_CACHE_SHIFT);
>  			spin_unlock(&fs_info->buffer_lock);
>  		} else {
> -			spin_unlock(&eb->refs_lock);
> +			spin_unlock(&ebh->refs_lock);
>  		}
>  
>  		/* Should be safe to release our pages at this point */
> -		btrfs_release_extent_buffer_page(eb);
> +		btrfs_release_extent_buffer_page(&ebh->eb);
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
> -			__free_extent_buffer(eb);
> +		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb_head(buf)->bflags))) {
> +			__free_extent_buffer(eb_head(eb));
>  			return 1;
>  		}
>  #endif
> -		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
> +		call_rcu(&ebh->rcu_head, btrfs_release_extent_buffer_rcu);
>  		return 1;
>  	}
> -	spin_unlock(&eb->refs_lock);
> +	spin_unlock(&ebh->refs_lock);
>  
>  	return 0;
>  }
>  
>  void free_extent_buffer(struct extent_buffer *eb)
>  {
> +	struct extent_buffer_head *ebh;
>  	int refs;
>  	int old;
>  	if (!eb)
>  		return;
>  
> +	ebh = eb_head(eb);
>  	while (1) {
> -		refs = atomic_read(&eb->refs);
> +		refs = atomic_read(&ebh->refs);
>  		if (refs <= 3)
>  			break;
> -		old = atomic_cmpxchg(&eb->refs, refs, refs - 1);
> +		old = atomic_cmpxchg(&ebh->refs, refs, refs - 1);
>  		if (old == refs)
>  			return;
>  	}
>  
> -	spin_lock(&eb->refs_lock);
> -	if (atomic_read(&eb->refs) == 2 &&
> -	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
> -		atomic_dec(&eb->refs);
> +	spin_lock(&ebh->refs_lock);
> +	if (atomic_read(&ebh->refs) == 2 &&
> +	    test_bit(EXTENT_BUFFER_DUMMY, &ebh->bflags))
> +		atomic_dec(&ebh->refs);
>  
> -	if (atomic_read(&eb->refs) == 2 &&
> -	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
> +	if (atomic_read(&ebh->refs) == 2 &&
> +	    test_bit(EXTENT_BUFFER_STALE, &eb->ebflags) &&
>  	    !extent_buffer_under_io(eb) &&
> -	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
> -		atomic_dec(&eb->refs);
> +	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags))
> +		atomic_dec(&ebh->refs);
>  
>  	/*
>  	 * I know this is terrible, but it's temporary until we stop tracking
>  	 * the uptodate bits and such for the extent buffers.
>  	 */
> -	release_extent_buffer(eb);
> +	release_extent_buffer(ebh);
>  }
>  
>  void free_extent_buffer_stale(struct extent_buffer *eb)
>  {
> +	struct extent_buffer_head *ebh;
>  	if (!eb)
>  		return;
>  
> -	spin_lock(&eb->refs_lock);
> -	set_bit(EXTENT_BUFFER_STALE, &eb->bflags);
> +	ebh = eb_head(eb);
> +	spin_lock(&ebh->refs_lock);
> +
> +	set_bit(EXTENT_BUFFER_STALE, &eb->ebflags);
> +	if (atomic_read(&ebh->refs) == 2 && !extent_buffer_under_io(eb) &&
> +	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags))
> +		atomic_dec(&ebh->refs);
>  
> -	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
> -	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
> -		atomic_dec(&eb->refs);
> -	release_extent_buffer(eb);
> +	release_extent_buffer(ebh);
> +}
> +
> +static int page_ebs_clean(struct extent_buffer_head *ebh)
> +{
> +	struct extent_buffer *eb = &ebh->eb;
> +
> +	do {
> +		if (test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
> +			return 0;
> +	} while ((eb = eb->eb_next) != NULL);
> +
> +	return 1;
>  }
>  
>  void clear_extent_buffer_dirty(struct extent_buffer *eb)
> @@ -5117,8 +5223,11 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
>  
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  
> +	if (eb->len < PAGE_CACHE_SIZE && !page_ebs_clean(eb_head(eb)))
> +		return;
> +
>  	for (i = 0; i < num_pages; i++) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		if (!PageDirty(page))
>  			continue;
>  
> @@ -5136,7 +5245,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
>  		ClearPageError(page);
>  		unlock_page(page);
>  	}
> -	WARN_ON(atomic_read(&eb->refs) == 0);
> +	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
>  }
>  
>  int set_extent_buffer_dirty(struct extent_buffer *eb)
> @@ -5147,14 +5256,14 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
>  
>  	check_buffer_tree_ref(eb);
>  
> -	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
> +	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
>  
>  	num_pages = num_extent_pages(eb->start, eb->len);
> -	WARN_ON(atomic_read(&eb->refs) == 0);
> -	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
> +	WARN_ON(atomic_read(&eb_head(eb)->refs) == 0);
> +	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb_head(eb)->bflags));
>  
>  	for (i = 0; i < num_pages; i++)
> -		set_page_dirty(eb->pages[i]);
> +		set_page_dirty(eb_head(eb)->pages[i]);
>  	return was_dirty;
>  }
>  
> @@ -5164,10 +5273,12 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
>  	struct page *page;
>  	unsigned long num_pages;
>  
> -	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> +	if (!eb || !eb_head(eb))
> +		return 0;
> +	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	for (i = 0; i < num_pages; i++) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		if (page)
>  			ClearPageUptodate(page);
>  	}
> @@ -5176,22 +5287,43 @@ int clear_extent_buffer_uptodate(struct extent_buffer *eb)
>  
>  int set_extent_buffer_uptodate(struct extent_buffer *eb)
>  {
> +	struct extent_buffer_head *ebh;
>  	unsigned long i;
>  	struct page *page;
>  	unsigned long num_pages;
> +	int uptodate;
>  
> -	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> -	num_pages = num_extent_pages(eb->start, eb->len);
> -	for (i = 0; i < num_pages; i++) {
> -		page = eb->pages[i];
> -		SetPageUptodate(page);
> +	ebh = eb->ebh;
> +
> +	set_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
> +	if (eb->len < PAGE_CACHE_SIZE) {
> +		eb = &(eb_head(eb)->eb);
> +		uptodate = 1;
> +		do {
> +			if (!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags)) {
> +				uptodate = 0;
> +				break;
> +			}
> +		} while ((eb = eb->eb_next) != NULL);
> +
> +		if (uptodate) {
> +			page = ebh->pages[0];
> +			SetPageUptodate(page);
> +		}
> +	} else {
> +		num_pages = num_extent_pages(eb->start, eb->len);
> +		for (i = 0; i < num_pages; i++) {
> +			page = ebh->pages[i];
> +			SetPageUptodate(page);
> +		}
>  	}
> +
>  	return 0;
>  }
>  
>  int extent_buffer_uptodate(struct extent_buffer *eb)
>  {
> -	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> +	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
>  }
>  
>  int read_extent_buffer_pages(struct extent_io_tree *tree,
> @@ -5210,7 +5342,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  	struct bio *bio = NULL;
>  	unsigned long bio_flags = 0;
>  
> -	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
> +	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags))
>  		return 0;
>  
>  	if (start) {
> @@ -5223,7 +5355,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  
>  	num_pages = num_extent_pages(eb->start, eb->len);
>  	for (i = start_i; i < num_pages; i++) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		if (wait == WAIT_NONE) {
>  			if (!trylock_page(page))
>  				goto unlock_exit;
> @@ -5238,15 +5370,15 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  	}
>  	if (all_uptodate) {
>  		if (start_i == 0)
> -			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> +			set_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags);
>  		goto unlock_exit;
>  	}
>  
> -	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
> +	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->ebflags);
>  	eb->read_mirror = 0;
>  	atomic_set(&eb->io_pages, num_reads);
>  	for (i = start_i; i < num_pages; i++) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		if (!PageUptodate(page)) {
>  			ClearPageError(page);
>  			err = __extent_read_full_page(tree, page,
> @@ -5271,7 +5403,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  		return ret;
>  
>  	for (i = start_i; i < num_pages; i++) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		wait_on_page_locked(page);
>  		if (!PageUptodate(page))
>  			ret = -EIO;
> @@ -5282,7 +5414,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  unlock_exit:
>  	i = start_i;
>  	while (locked_pages > 0) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  		i++;
>  		unlock_page(page);
>  		locked_pages--;
> @@ -5308,7 +5440,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
>  	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
>  
>  	while (len > 0) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  
>  		cur = min(len, (PAGE_CACHE_SIZE - offset));
>  		kaddr = page_address(page);
> @@ -5340,7 +5472,7 @@ int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
>  	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
>  
>  	while (len > 0) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  
>  		cur = min(len, (PAGE_CACHE_SIZE - offset));
>  		kaddr = page_address(page);
> @@ -5389,7 +5521,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>  		return -EINVAL;
>  	}
>  
> -	p = eb->pages[i];
> +	p = eb_head(eb)->pages[i];
>  	kaddr = page_address(p);
>  	*map = kaddr + offset;
>  	*map_len = PAGE_CACHE_SIZE - offset;
> @@ -5415,7 +5547,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
>  	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
>  
>  	while (len > 0) {
> -		page = eb->pages[i];
> +		page = eb_head(eb)->pages[i];
>  
>  		cur = min(len, (PAGE_CACHE_SIZE - offset));
>  
> @@ -5445,12 +5577,12 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
>  
>  	WARN_ON(start > eb->len);
>  	WARN_ON(start + len > eb->start + eb->len);
> +	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
>  
>  	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
>  
>  	while (len > 0) {
> -		page = eb->pages[i];
> -		WARN_ON(!PageUptodate(page));
> +		page = eb_head(eb)->pages[i];
>  
>  		cur = min(len, PAGE_CACHE_SIZE - offset);
>  		kaddr = page_address(page);
> @@ -5478,9 +5610,10 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
>  
>  	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
>  
> +	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &eb->ebflags));
> +
>  	while (len > 0) {
> -		page = eb->pages[i];
> -		WARN_ON(!PageUptodate(page));
> +		page = eb_head(eb)->pages[i];
>  
>  		cur = min(len, PAGE_CACHE_SIZE - offset);
>  		kaddr = page_address(page);
> @@ -5509,9 +5642,10 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
>  	offset = (start_offset + dst_offset) &
>  		(PAGE_CACHE_SIZE - 1);
>  
> +	WARN_ON(!test_bit(EXTENT_BUFFER_UPTODATE, &dst->ebflags));
> +
>  	while (len > 0) {
> -		page = dst->pages[i];
> -		WARN_ON(!PageUptodate(page));
> +		page = eb_head(dst)->pages[i];
>  
>  		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
>  
> @@ -5588,8 +5722,9 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  		cur = min_t(unsigned long, cur,
>  			(unsigned long)(PAGE_CACHE_SIZE - dst_off_in_page));
>  
> -		copy_pages(dst->pages[dst_i], dst->pages[src_i],
> -			   dst_off_in_page, src_off_in_page, cur);
> +		copy_pages(eb_head(dst)->pages[dst_i],
> +			eb_head(dst)->pages[src_i],
> +			dst_off_in_page, src_off_in_page, cur);
>  
>  		src_offset += cur;
>  		dst_offset += cur;
> @@ -5634,9 +5769,10 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  
>  		cur = min_t(unsigned long, len, src_off_in_page + 1);
>  		cur = min(cur, dst_off_in_page + 1);
> -		copy_pages(dst->pages[dst_i], dst->pages[src_i],
> -			   dst_off_in_page - cur + 1,
> -			   src_off_in_page - cur + 1, cur);
> +		copy_pages(eb_head(dst)->pages[dst_i],
> +			eb_head(dst)->pages[src_i],
> +			dst_off_in_page - cur + 1,
> +			src_off_in_page - cur + 1, cur);
>  
>  		dst_end -= cur;
>  		src_end -= cur;
> @@ -5646,6 +5782,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
>  
>  int try_release_extent_buffer(struct page *page)
>  {
> +	struct extent_buffer_head *ebh;
>  	struct extent_buffer *eb;
>  
>  	/*
> @@ -5661,14 +5798,15 @@ int try_release_extent_buffer(struct page *page)
>  	eb = (struct extent_buffer *)page->private;
>  	BUG_ON(!eb);
>  
> +	ebh = eb->ebh;
>  	/*
>  	 * This is a little awful but should be ok, we need to make sure that
>  	 * the eb doesn't disappear out from under us while we're looking at
>  	 * this page.
>  	 */
> -	spin_lock(&eb->refs_lock);
> -	if (atomic_read(&eb->refs) != 1 || extent_buffer_under_io(eb)) {
> -		spin_unlock(&eb->refs_lock);
> +	spin_lock(&ebh->refs_lock);
> +	if (atomic_read(&ebh->refs) != 1 || extent_buffer_under_io(eb)) {
> +		spin_unlock(&ebh->refs_lock);
>  		spin_unlock(&page->mapping->private_lock);
>  		return 0;
>  	}
> @@ -5678,10 +5816,11 @@ int try_release_extent_buffer(struct page *page)
>  	 * If tree ref isn't set then we know the ref on this eb is a real ref,
>  	 * so just return, this page will likely be freed soon anyway.
>  	 */
> -	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
> -		spin_unlock(&eb->refs_lock);
> +	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &ebh->bflags)) {
> +		spin_unlock(&ebh->refs_lock);
>  		return 0;
>  	}
>  
> -	return release_extent_buffer(eb);
> +	return release_extent_buffer(ebh);
>  }
> +
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 541b40a..8fe5ac3 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -131,17 +131,17 @@ struct extent_state {
>  
>  #define INLINE_EXTENT_BUFFER_PAGES 16
>  #define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * PAGE_CACHE_SIZE)
> +
> +/* Forward declaration */
> +struct extent_buffer_head;
> +
>  struct extent_buffer {
>  	u64 start;
>  	unsigned long len;
> -	unsigned long bflags;
> -	struct btrfs_fs_info *fs_info;
> -	spinlock_t refs_lock;
> -	atomic_t refs;
> -	atomic_t io_pages;
> +	unsigned long ebflags;
> +	struct extent_buffer_head *ebh;
> +	struct extent_buffer *eb_next;
>  	int read_mirror;
> -	struct rcu_head rcu_head;
> -	pid_t lock_owner;
>  
>  	/* count of read lock holders on the extent buffer */
>  	atomic_t write_locks;
> @@ -154,6 +154,8 @@ struct extent_buffer {
>  	/* >= 0 if eb belongs to a log tree, -1 otherwise */
>  	short log_index;
>  
> +	pid_t lock_owner;
> +
>  	/* protects write locks */
>  	rwlock_t lock;
>  
> @@ -166,7 +168,20 @@ struct extent_buffer {
>  	 * to unlock
>  	 */
>  	wait_queue_head_t read_lock_wq;
> +	wait_queue_head_t lock_wq;
> +};
> +
> +struct extent_buffer_head {
> +	unsigned long bflags;
> +	struct btrfs_fs_info *fs_info;
> +	spinlock_t refs_lock;
> +	atomic_t refs;
> +	atomic_t io_bvecs;
> +	struct rcu_head rcu_head;
> +
>  	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
> +
> +	struct extent_buffer eb;
>  #ifdef CONFIG_BTRFS_DEBUG
>  	struct list_head leak_list;
>  #endif
> @@ -183,6 +198,14 @@ static inline int extent_compress_type(unsigned long bio_flags)
>  	return bio_flags >> EXTENT_BIO_FLAG_SHIFT;
>  }
>  
> +/*
> + * return the extent_buffer_head that contains the extent buffer provided.
> + */
> +static inline struct extent_buffer_head *eb_head(struct extent_buffer *eb)
> +{
> +	return eb->ebh;
> +
> +}
>  struct extent_map_tree;
>  
>  typedef struct extent_map *(get_extent_t)(struct inode *inode,
> @@ -304,7 +327,7 @@ static inline unsigned long num_extent_pages(u64 start, u64 len)
>  
>  static inline void extent_buffer_get(struct extent_buffer *eb)
>  {
> -	atomic_inc(&eb->refs);
> +	atomic_inc(&eb_head(eb)->refs);
>  }
>  
>  int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8bcd2a0..9c8eb4a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6282,7 +6282,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>  	 * to silence the warning eg. on PowerPC 64.
>  	 */
>  	if (PAGE_CACHE_SIZE > BTRFS_SUPER_INFO_SIZE)
> -		SetPageUptodate(sb->pages[0]);
> +		SetPageUptodate(eb_head(sb)->pages[0]);
>  
>  	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
>  	array_size = btrfs_super_sys_array_size(super_copy);
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 1faecea..283bbe7 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -699,7 +699,7 @@ TRACE_EVENT(btrfs_cow_block,
>  	TP_fast_assign(
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->buf_start	= buf->start;
> -		__entry->refs		= atomic_read(&buf->refs);
> +		__entry->refs		= atomic_read(&eb_head(buf)->refs);
>  		__entry->cow_start	= cow->start;
>  		__entry->buf_level	= btrfs_header_level(buf);
>  		__entry->cow_level	= btrfs_header_level(cow);
> -- 
> 2.1.0
> 
