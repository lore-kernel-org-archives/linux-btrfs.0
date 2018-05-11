Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34733 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeEKJcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 05:32:01 -0400
Subject: Re: [PATCH v3 10/11] Btrfs: get rid of unused orphan infrastructure
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1526025007.git.osandov@fb.com>
 <5305fb5f6784df0fba0eaeca168c0cd691ea8c45.1526025007.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <29e3c423-46eb-7dcf-4d38-bb339f38b092@suse.com>
Date: Fri, 11 May 2018 12:31:59 +0300
MIME-Version: 1.0
In-Reply-To: <5305fb5f6784df0fba0eaeca168c0cd691ea8c45.1526025007.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.05.2018 10:56, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Now that we don't keep long-standing reservations for orphan items,
> root->orphan_block_rsv isn't used. We can git rid of it, along with
> root->orphan_lock, which was used to protect it, root->orphan_inodes,
> which was used as a refcount for it, and btrfs_orphan_commit_root(),
> which was the last user of all of these.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h       |  8 --------
>  fs/btrfs/disk-io.c     |  9 ---------
>  fs/btrfs/extent-tree.c | 38 -------------------------------------
>  fs/btrfs/inode.c       | 43 +-----------------------------------------
>  fs/btrfs/transaction.c |  1 -
>  5 files changed, 1 insertion(+), 98 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2771cc56a622..51408de11af2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1219,9 +1219,6 @@ struct btrfs_root {
>  	spinlock_t log_extents_lock[2];
>  	struct list_head logged_list[2];
>  
> -	spinlock_t orphan_lock;
> -	atomic_t orphan_inodes;
> -	struct btrfs_block_rsv *orphan_block_rsv;
>  	int orphan_cleanup_state;
>  
>  	spinlock_t inode_lock;
> @@ -2764,9 +2761,6 @@ void btrfs_delalloc_release_space(struct inode *inode,
>  void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
>  					    u64 len);
>  void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
> -int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
> -				  struct btrfs_inode *inode);
> -void btrfs_orphan_release_metadata(struct btrfs_inode *inode);
>  int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
>  				     struct btrfs_block_rsv *rsv,
>  				     int nitems,
> @@ -3238,8 +3232,6 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
>  int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  		struct btrfs_inode *inode);
>  int btrfs_orphan_cleanup(struct btrfs_root *root);
> -void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root);
>  int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
>  void btrfs_invalidate_inodes(struct btrfs_root *root);
>  void btrfs_add_delayed_iput(struct inode *inode);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60caa68c3618..4a40bfdddabc 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1185,7 +1185,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	root->inode_tree = RB_ROOT;
>  	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
>  	root->block_rsv = NULL;
> -	root->orphan_block_rsv = NULL;
>  
>  	INIT_LIST_HEAD(&root->dirty_list);
>  	INIT_LIST_HEAD(&root->root_list);
> @@ -1195,7 +1194,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	INIT_LIST_HEAD(&root->ordered_root);
>  	INIT_LIST_HEAD(&root->logged_list[0]);
>  	INIT_LIST_HEAD(&root->logged_list[1]);
> -	spin_lock_init(&root->orphan_lock);
>  	spin_lock_init(&root->inode_lock);
>  	spin_lock_init(&root->delalloc_lock);
>  	spin_lock_init(&root->ordered_extent_lock);
> @@ -1216,7 +1214,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	atomic_set(&root->log_commit[1], 0);
>  	atomic_set(&root->log_writers, 0);
>  	atomic_set(&root->log_batch, 0);
> -	atomic_set(&root->orphan_inodes, 0);
>  	refcount_set(&root->refs, 1);
>  	atomic_set(&root->will_be_snapshotted, 0);
>  	root->log_transid = 0;
> @@ -3674,8 +3671,6 @@ static void free_fs_root(struct btrfs_root *root)
>  {
>  	iput(root->ino_cache_inode);
>  	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
> -	btrfs_free_block_rsv(root->fs_info, root->orphan_block_rsv);
> -	root->orphan_block_rsv = NULL;
>  	if (root->anon_dev)
>  		free_anon_bdev(root->anon_dev);
>  	if (root->subv_writers)
> @@ -3766,7 +3761,6 @@ int btrfs_commit_super(struct btrfs_fs_info *fs_info)
>  
>  void close_ctree(struct btrfs_fs_info *fs_info)
>  {
> -	struct btrfs_root *root = fs_info->tree_root;
>  	int ret;
>  
>  	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
> @@ -3861,9 +3855,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  	btrfs_free_stripe_hash_table(fs_info);
>  	btrfs_free_ref_cache(fs_info);
>  
> -	__btrfs_free_block_rsv(root->orphan_block_rsv);
> -	root->orphan_block_rsv = NULL;
> -
>  	while (!list_empty(&fs_info->pinned_chunks)) {
>  		struct extent_map *em;
>  
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 51b5e2da708c..3f2e026bc206 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5949,44 +5949,6 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
>  	trans->chunk_bytes_reserved = 0;
>  }
>  
> -/* Can only return 0 or -ENOSPC */
> -int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
> -				  struct btrfs_inode *inode)
> -{
> -	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
> -	struct btrfs_root *root = inode->root;
> -	/*
> -	 * We always use trans->block_rsv here as we will have reserved space
> -	 * for our orphan when starting the transaction, using get_block_rsv()
> -	 * here will sometimes make us choose the wrong block rsv as we could be
> -	 * doing a reloc inode for a non refcounted root.
> -	 */
> -	struct btrfs_block_rsv *src_rsv = trans->block_rsv;
> -	struct btrfs_block_rsv *dst_rsv = root->orphan_block_rsv;
> -
> -	/*
> -	 * We need to hold space in order to delete our orphan item once we've
> -	 * added it, so this takes the reservation so we can release it later
> -	 * when we are truly done with the orphan item.
> -	 */
> -	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> -
> -	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
> -			num_bytes, 1);
> -	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
> -}
> -
> -void btrfs_orphan_release_metadata(struct btrfs_inode *inode)
> -{
> -	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
> -	struct btrfs_root *root = inode->root;
> -	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> -
> -	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
> -			num_bytes, 0);
> -	btrfs_block_rsv_release(fs_info, root->orphan_block_rsv, num_bytes);
> -}
> -
>  /*
>   * btrfs_subvolume_reserve_metadata() - reserve space for subvolume operation
>   * root: the root of the parent directory
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b64c4189e2c0..1edb4148ec74 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3292,42 +3292,6 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
>  	spin_unlock(&fs_info->delayed_iput_lock);
>  }
>  
> -/*
> - * This is called in transaction commit time. If there are no orphan
> - * files in the subvolume, it removes orphan item and frees block_rsv
> - * structure.
> - */
> -void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root)
> -{
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	struct btrfs_block_rsv *block_rsv;
> -
> -	if (atomic_read(&root->orphan_inodes) ||
> -	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
> -		return;
> -
> -	spin_lock(&root->orphan_lock);
> -	if (atomic_read(&root->orphan_inodes)) {
> -		spin_unlock(&root->orphan_lock);
> -		return;
> -	}
> -
> -	if (root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE) {
> -		spin_unlock(&root->orphan_lock);
> -		return;
> -	}
> -
> -	block_rsv = root->orphan_block_rsv;
> -	root->orphan_block_rsv = NULL;
> -	spin_unlock(&root->orphan_lock);
> -
> -	if (block_rsv) {
> -		WARN_ON(block_rsv->size > 0);
> -		btrfs_free_block_rsv(fs_info, block_rsv);
> -	}
> -}
> -
>  /*
>   * This creates an orphan entry for the given inode in case something goes wrong
>   * in the middle of an unlink.
> @@ -3521,12 +3485,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  
>  	root->orphan_cleanup_state = ORPHAN_CLEANUP_DONE;
>  
> -	if (root->orphan_block_rsv)
> -		btrfs_block_rsv_release(fs_info, root->orphan_block_rsv,
> -					(u64)-1);
> -
> -	if (root->orphan_block_rsv ||
> -	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
> +	if (test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
>  		trans = btrfs_join_transaction(root);
>  		if (!IS_ERR(trans))
>  			btrfs_end_transaction(trans);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c944b4769e3c..44af1edf15d1 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1250,7 +1250,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
>  
>  			btrfs_free_log(trans, root);
>  			btrfs_update_reloc_root(trans, root);
> -			btrfs_orphan_commit_root(trans, root);
>  
>  			btrfs_save_ino_cache(root, trans);
>  
> 
