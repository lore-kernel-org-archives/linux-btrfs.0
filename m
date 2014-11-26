Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40778 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbaKZRUK (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 26 Nov 2014 12:20:10 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 4/6] Btrfs: fix race between fs trimming and block group remove/allocation
Date: Wed, 26 Nov 2014 17:19:45 +0000
Message-Id: <1417022385-19474-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1417015735-8581-5-git-send-email-fdmanana@suse.com>
References: <1417015735-8581-5-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our fs trim operation, which is completely transactionless (doesn't start
or joins an existing transaction) consists of visiting all block groups
and then for each one to iterate its free space entries and perform a
discard operation against the space range represented by the free space
entries. However before performing a discard, the corresponding free space
entry is removed from the free space rbtree, and when the discard completes
it is added back to the free space rbtree.

If a block group remove operation happens while the discard is ongoing (or
before it starts and after a free space entry is hidden), we end up not
waiting for the discard to complete, remove the extent map that maps
logical address to physical addresses and the corresponding chunk metadata
from the the chunk and device trees. After that and before the discard
completes, the current running transaction can finish and a new one start,
allowing for new block groups that map to the same physical addresses to
be allocated and written to.

So fix this by keeping the extent map in memory until the discard completes
so that the same physical addresses aren't reused before it completes.

If the physical locations that are under a discard operation end up being
used for a new metadata block group for example, and dirty metadata extents
are written before the discard finishes (the VM might call writepages() of
our btree inode's i_mapping for example, or an fsync log commit happens) we
end up overwriting metadata with zeroes, which leads to errors from fsck
like the following:

        checking extents
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        read block failed check_tree_block
        owner ref check failed [833912832 16384]
        Errors found in extent allocation tree or chunk allocation
        checking free space cache
        checking fs roots
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        Check tree block failed, want=833912832, have=0
        read block failed check_tree_block
        root 5 root dir 256 error
        root 5 inode 260 errors 2001, no inode item, link count wrong
                unresolved ref dir 256 index 0 namelen 8 name foobar_3 filetype 1 errors 6, no dir index, no inode ref
        root 5 inode 262 errors 2001, no inode item, link count wrong
                unresolved ref dir 256 index 0 namelen 8 name foobar_5 filetype 1 errors 6, no dir index, no inode ref
        root 5 inode 263 errors 2001, no inode item, link count wrong
        (...)

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Added a comment to better explain the synchronization between block
    group removal and triming, as requested by Josef.

 fs/btrfs/ctree.h            | 13 ++++++++++++-
 fs/btrfs/disk-io.c          | 14 ++++++++++++++
 fs/btrfs/extent-tree.c      | 28 +++++++++++++++++++++++++++-
 fs/btrfs/free-space-cache.c | 26 +++++++++++++++++++++++++-
 fs/btrfs/volumes.c          | 33 ++++++++++++++++++++++++++-------
 5 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7f40a65..51056c7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1278,6 +1278,7 @@ struct btrfs_block_group_cache {
 	unsigned int dirty:1;
 	unsigned int iref:1;
 	unsigned int has_caching_ctl:1;
+	unsigned int removed:1;
 
 	int disk_cache_state;
 
@@ -1307,6 +1308,8 @@ struct btrfs_block_group_cache {
 
 	/* For delayed block group creation or deletion of empty block groups */
 	struct list_head bg_list;
+
+	atomic_t trimming;
 };
 
 /* delayed seq elem */
@@ -1731,6 +1734,13 @@ struct btrfs_fs_info {
 
 	/* For btrfs to record security options */
 	struct security_mnt_opts security_opts;
+
+	/*
+	 * Chunks that can't be freed yet (under a trim/discard operation)
+	 * and will be latter freed.
+	 */
+	rwlock_t pinned_chunks_lock;
+	struct list_head pinned_chunks;
 };
 
 struct btrfs_subvolume_writers {
@@ -3353,7 +3363,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start);
+			     struct btrfs_root *root, u64 group_start,
+			     bool *remove_em);
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9d4fb0a..76012d0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2397,6 +2397,9 @@ int open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
 
+	rwlock_init(&fs_info->pinned_chunks_lock);
+	INIT_LIST_HEAD(&fs_info->pinned_chunks);
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
@@ -3726,6 +3729,17 @@ void close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
+
+	write_lock(&fs_info->pinned_chunks_lock);
+	while (!list_empty(&fs_info->pinned_chunks)) {
+		struct extent_map *em;
+
+		em = list_first_entry(&fs_info->pinned_chunks,
+				      struct extent_map, list);
+		list_del_init(&em->list);
+		free_extent_map(em);
+	}
+	write_unlock(&fs_info->pinned_chunks_lock);
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 92f61f2..12dc053 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9016,6 +9016,7 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->bg_list);
 	btrfs_init_free_space_ctl(cache);
+	atomic_set(&cache->trimming, 0);
 
 	return cache;
 }
@@ -9317,7 +9318,8 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 }
 
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start)
+			     struct btrfs_root *root, u64 group_start,
+			     bool *remove_em)
 {
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
@@ -9474,6 +9476,30 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	memcpy(&key, &block_group->key, sizeof(key));
 
+	spin_lock(&block_group->lock);
+	block_group->removed = 1;
+	/*
+	 * At this point trimming can't start on this block group, because we
+	 * removed the block group from the tree fs_info->block_group_cache_tree
+	 * so no one can't find it anymore and even if someone already got this
+	 * block group before we removed it from the rbtree, they have already
+	 * incremented block_group->trimming (and we also removed already all
+	 * the free space entries from the block group's cache through the call
+	 * to btrfs_remove_free_space_cache()).
+	 *
+	 * And we must tell our caller to not remove the extent map from the
+	 * fs_info->mapping_tree to prevent the same logical address range and
+	 * physical device space ranges from being reused for a new block group.
+	 * This is because our fs trim operation (btrfs_trim_fs(),
+	 * btrfs_ioctl_fitrim()) is completely transactionless, so while its
+	 * trimming a range the currently running transaction might finish and
+	 * a new one start, allowing for new block groups to be created that can
+	 * reuse the same physical device locations unless we take this special
+	 * care.
+	 */
+	*remove_em = (atomic_read(&block_group->trimming) == 0);
+	spin_unlock(&block_group->lock);
+
 	btrfs_put_block_group(block_group);
 	btrfs_put_block_group(block_group);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3384819..16c2d39 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3101,11 +3101,35 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 
 	*trimmed = 0;
 
+	atomic_inc(&block_group->trimming);
+
 	ret = trim_no_bitmap(block_group, trimmed, start, end, minlen);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = trim_bitmaps(block_group, trimmed, start, end, minlen);
+out:
+	if (atomic_dec_and_test(&block_group->trimming) &&
+	    block_group->removed) {
+		struct extent_map_tree *em_tree;
+		struct extent_map *em;
+
+		em_tree = &block_group->fs_info->mapping_tree.map_tree;
+		write_lock(&em_tree->lock);
+		em = lookup_extent_mapping(em_tree, block_group->key.objectid,
+					   1);
+		BUG_ON(!em); /* logic error, can't happen */
+		remove_extent_mapping(em_tree, em);
+		write_unlock(&em_tree->lock);
+
+		write_lock(&block_group->fs_info->pinned_chunks_lock);
+		list_del_init(&em->list);
+		write_unlock(&block_group->fs_info->pinned_chunks_lock);
+
+		/* once for us and once for the tree */
+		free_extent_map(em);
+		free_extent_map(em);
+	}
 
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f61278f..e0ad613 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1069,9 +1069,14 @@ static int contains_pending_extent(struct btrfs_trans_handle *trans,
 				   u64 *start, u64 len)
 {
 	struct extent_map *em;
+	struct list_head *search_list = &trans->transaction->pending_chunks;
 	int ret = 0;
 
-	list_for_each_entry(em, &trans->transaction->pending_chunks, list) {
+again:
+	if (search_list == &trans->root->fs_info->pinned_chunks)
+		read_lock(&trans->root->fs_info->pinned_chunks_lock);
+
+	list_for_each_entry(em, search_list, list) {
 		struct map_lookup *map;
 		int i;
 
@@ -1088,6 +1093,12 @@ static int contains_pending_extent(struct btrfs_trans_handle *trans,
 			ret = 1;
 		}
 	}
+	if (search_list == &trans->root->fs_info->pinned_chunks) {
+		read_unlock(&trans->root->fs_info->pinned_chunks_lock);
+	} else {
+		search_list = &trans->root->fs_info->pinned_chunks;
+		goto again;
+	}
 
 	return ret;
 }
@@ -2579,6 +2590,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	u64 chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	u64 chunk_tree = root->fs_info->chunk_root->objectid;
 	int i, ret = 0;
+	bool remove_em;
 
 	/* Just in case */
 	root = root->fs_info->chunk_root;
@@ -2648,18 +2660,25 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
+	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset,
+				       &remove_em);
 	if (ret) {
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
 	}
 
-	write_lock(&em_tree->lock);
-	remove_extent_mapping(em_tree, em);
-	write_unlock(&em_tree->lock);
+	if (remove_em) {
+		write_lock(&em_tree->lock);
+		remove_extent_mapping(em_tree, em);
+		write_unlock(&em_tree->lock);
 
-	/* once for the tree */
-	free_extent_map(em);
+		/* once for the tree */
+		free_extent_map(em);
+	} else {
+		write_lock(&root->fs_info->pinned_chunks_lock);
+		list_move_tail(&em->list, &root->fs_info->pinned_chunks);
+		write_unlock(&root->fs_info->pinned_chunks_lock);
+	}
 out:
 	/* once for us */
 	free_extent_map(em);
-- 
2.1.3

