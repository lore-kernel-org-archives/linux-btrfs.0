From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 1/2] btrfs: document where we use BUG_ON instead of error handling
Date: Thu, 2 Sep 2010 17:06:32 -0700
Message-ID: <20100903000632.GB4364@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Document those places in the btrfs code which are BUGing on non-fatal error
conditions that should be handled by proper error paths. This makes it
easier to distinguish between what needs fixing versus which BUG_ON's we
might want to keep (to trap code bugs, unexpected inconsistencies, etc).

Do this with a trivial macro, 'btrfs_fixable_bug_on' which just defines to
BUG_ON(). The rest of this patch is basically a manual search and replace
for all the places where it was obvious to me we simply needed better
handling of errors.

No code functionality has changed.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/btrfs_inode.h |    6 ++
 fs/btrfs/compression.c |   20 +++---
 fs/btrfs/ctree.c       |   24 ++++----
 fs/btrfs/delayed-ref.c |   16 +++---
 fs/btrfs/disk-io.c     |   20 +++---
 fs/btrfs/extent-tree.c |  156 ++++++++++++++++++++++++------------------------
 fs/btrfs/file-item.c   |   14 ++--
 fs/btrfs/file.c        |   24 ++++----
 fs/btrfs/inode.c       |  122 +++++++++++++++++++-------------------
 fs/btrfs/ioctl.c       |   30 +++++-----
 fs/btrfs/relocation.c  |   54 ++++++++--------
 fs/btrfs/transaction.c |   48 +++++++-------
 fs/btrfs/tree-log.c    |   84 +++++++++++++-------------
 fs/btrfs/volumes.c     |   64 ++++++++++----------
 fs/btrfs/xattr.c       |    6 +-
 15 files changed, 347 insertions(+), 341 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6ad63f1..8a6a2d9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -173,4 +173,10 @@ static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 	BTRFS_I(inode)->disk_i_size = size;
 }
 
+/*
+ * This macro documents all the places in the btrfs code where we're failing
+ * to correctly handle a recoverable error condition.
+ */
+#define btrfs_fixable_bug_on(_err) BUG_ON(_err)
+
 #endif
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 396039b..b06e1bf 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -394,13 +394,13 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			 */
 			atomic_inc(&cb->pending_bios);
 			ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			ret = btrfs_csum_one_bio(root, inode, bio, start, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			bio_put(bio);
 
@@ -420,13 +420,13 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bio_get(bio);
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_csum_one_bio(root, inode, bio, start, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	bio_put(bio);
 	return 0;
@@ -646,7 +646,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			bio_get(comp_bio);
 
 			ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			/*
 			 * inc the count before we submit the bio so
@@ -665,7 +665,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
 					    mirror_num, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			bio_put(comp_bio);
 
@@ -681,13 +681,13 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	bio_get(comp_bio);
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
 		btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	bio_put(comp_bio);
 	return 0;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c3df14c..781b4ae 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -309,7 +309,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	if (btrfs_block_can_be_shared(root, buf)) {
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
 					       buf->len, &refs, &flags);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		BUG_ON(refs == 0);
 	} else {
 		refs = 1;
@@ -329,14 +329,14 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
 			ret = btrfs_inc_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
 				ret = btrfs_dec_ref(trans, root, buf, 0);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				ret = btrfs_inc_ref(trans, root, cow, 1);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 		} else {
@@ -346,14 +346,14 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
 				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		if (new_flags != 0) {
 			ret = btrfs_set_disk_extent_flags(trans, root,
 							  buf->start,
 							  buf->len,
 							  new_flags, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	} else {
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
@@ -362,9 +362,9 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
 				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			ret = btrfs_dec_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
@@ -3094,7 +3094,7 @@ again:
 	}
 
 	ret = copy_for_split(trans, root, path, l, right, slot, mid, nritems);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (split == 2) {
 		BUG_ON(num_doubles != 0);
@@ -3307,7 +3307,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 	ret = setup_items_for_insert(trans, root, path, new_key, &item_size,
 				     item_size, item_size +
 				     sizeof(struct btrfs_item), 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	memcpy_extent_buffer(leaf,
@@ -3982,7 +3982,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			btrfs_set_path_blocking(path);
 			clean_tree_block(trans, root, leaf);
 			ret = btrfs_del_leaf(trans, root, path, leaf);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	} else {
 		int used = leaf_space_used(leaf, 0, nritems);
@@ -4022,7 +4022,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
 				ret = btrfs_del_leaf(trans, root, path, leaf);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				free_extent_buffer(leaf);
 			} else {
 				/* if we're still in the path, make sure
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e807b14..ee1cf82 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -644,11 +644,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	 */
 	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 				   action, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, level, action);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -689,11 +689,11 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 */
 	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes,
 				   action, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = add_delayed_data_ref(trans, &ref->node, bytenr, num_bytes,
 				   parent, ref_root, owner, offset, action);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
@@ -718,7 +718,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_trans_handle *trans,
 	ret = add_delayed_ref_head(trans, &head_ref->node, bytenr,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
@@ -801,18 +801,18 @@ int btrfs_update_delayed_ref(struct btrfs_trans_handle *trans,
 	ret = __btrfs_add_delayed_ref(trans, &head_ref->node, bytenr, num_bytes,
 				      (u64)-1, 0, 0, 0,
 				      BTRFS_UPDATE_DELAYED_HEAD, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = __btrfs_add_delayed_ref(trans, &ref->node, bytenr, num_bytes,
 				      parent, ref_root, ref_generation,
 				      owner_objectid, BTRFS_ADD_DELAYED_REF, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = __btrfs_add_delayed_ref(trans, &old_ref->node, bytenr, num_bytes,
 				      orig_parent, orig_ref_root,
 				      orig_ref_generation, owner_objectid,
 				      BTRFS_DROP_DELAYED_REF, pin);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64f1008..b5440f5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -355,7 +355,7 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
 	ret = btree_read_extent_buffer_pages(root, eb, start + PAGE_CACHE_SIZE,
 					     btrfs_header_generation(eb));
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != start) {
 		WARN_ON(1);
@@ -666,7 +666,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 
 	ret = btrfs_bio_wq_end_io(BTRFS_I(inode)->root->fs_info,
 					  bio, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (!(rw & REQ_WRITE)) {
 		/*
@@ -974,7 +974,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 				   &root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
@@ -1501,7 +1501,7 @@ static int transaction_kthread(void *arg)
 		trans = btrfs_join_transaction(root, 1);
 		if (transid == trans->transid) {
 			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else {
 			btrfs_end_transaction(trans, root);
 		}
@@ -1954,20 +1954,20 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 						      blocksize,
 						      generation + 1);
 		ret = btrfs_recover_log_trees(log_tree_root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (sb->s_flags & MS_RDONLY) {
 			ret =  btrfs_commit_super(tree_root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 
 	ret = btrfs_find_orphan_roots(tree_root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_cleanup_fs_roots(fs_info);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		ret = btrfs_recover_relocation(tree_root);
 		if (ret < 0) {
@@ -2402,12 +2402,12 @@ int btrfs_commit_super(struct btrfs_root *root)
 
 	trans = btrfs_join_transaction(root, 1);
 	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_join_transaction(root, 1);
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = write_ctree_super(NULL, root, 0);
 	return ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..801db4e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -209,7 +209,7 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		cache->bytes_super += stripe_len;
 		ret = add_excluded_extent(root, cache->key.objectid,
 					  stripe_len);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -217,13 +217,13 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
 			ret = add_excluded_extent(root, logical[nr],
 						  stripe_len);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		kfree(logical);
@@ -279,7 +279,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 			total_added += size;
 			ret = btrfs_add_free_space(block_group, start,
 						   size);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			start = extent_end + 1;
 		} else {
 			break;
@@ -290,7 +290,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		size = end - start;
 		total_added += size;
 		ret = btrfs_add_free_space(block_group, start, size);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	return total_added;
@@ -879,10 +879,10 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 				new_size + extra_size, 1);
 	if (ret < 0)
 		return ret;
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_extend_item(trans, root, path, new_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1350,7 +1350,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		err = ret;
 		goto out;
 	}
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -1490,7 +1490,7 @@ int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	size = btrfs_extent_inline_ref_size(type);
 
 	ret = btrfs_extend_item(trans, root, path, size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
@@ -1619,7 +1619,7 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 					      end - ptr - size);
 		item_size -= size;
 		ret = btrfs_truncate_item(trans, root, path, item_size, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_mark_buffer_dirty(leaf);
 	return 0;
@@ -1801,7 +1801,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
 				    path, bytenr, parent, root_objectid,
 				    owner, offset, refs_to_add);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 out:
 	btrfs_free_path(path);
 	return err;
@@ -2003,7 +2003,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 		}
 		mutex_unlock(&head->mutex);
@@ -2125,7 +2125,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 				ret = run_delayed_extent_op(trans, root,
 							    ref, extent_op);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				kfree(extent_op);
 
 				cond_resched();
@@ -2145,7 +2145,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
 					  must_insert_reserved);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_put_delayed_ref(ref);
 		kfree(extent_op);
@@ -2656,7 +2656,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, extent_root, &cache->key, path, 0, 1);
 	if (ret < 0)
 		goto fail;
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	bi = btrfs_item_ptr_offset(leaf, path->slots[0]);
@@ -3030,7 +3030,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	if (!space_info) {
 		ret = update_space_info(extent_root->fs_info, flags,
 					0, 0, &space_info);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	BUG_ON(!space_info);
 
@@ -3192,7 +3192,7 @@ static int should_retry_reserve(struct btrfs_trans_handle *trans,
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
 	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	return 1;
 }
@@ -4133,7 +4133,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, extent_root, path,
 						    NULL, refs_to_drop,
 						    is_data);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			btrfs_release_path(extent_root, path);
 			path->leave_spinning = 1;
 
@@ -4149,7 +4149,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				       (unsigned long long)bytenr);
 				btrfs_print_leaf(extent_root, path->nodes[0]);
 			}
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			extent_slot = path->slots[0];
 		}
 	} else {
@@ -4188,7 +4188,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       (unsigned long long)bytenr);
 			btrfs_print_leaf(extent_root, path->nodes[0]);
 		}
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		extent_slot = path->slots[0];
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, extent_slot);
@@ -4225,7 +4225,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, extent_root, path,
 						    iref, refs_to_drop,
 						    is_data);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	} else {
 		if (found_extent) {
@@ -4242,12 +4242,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		btrfs_release_path(extent_root, path);
 
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else {
 			invalidate_mapping_pages(info->btree_inode->i_mapping,
 			     bytenr >> PAGE_CACHE_SHIFT,
@@ -4255,7 +4255,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		}
 
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_free_path(path);
 	return ret;
@@ -4352,7 +4352,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 						parent, root->root_key.objectid,
 						btrfs_header_level(buf),
 						BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	if (!last_ref)
@@ -4440,12 +4440,12 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
 					parent, root_objectid, (int)owner,
 					BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, bytenr, num_bytes,
 					parent, root_objectid, owner,
 					offset, BTRFS_DROP_DELAYED_REF, NULL);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	return ret;
 }
@@ -4663,7 +4663,7 @@ have_block_group:
 			    (loop > LOOP_FIND_IDEAL &&
 			     atomic_read(&space_info->caching_threads) < 2)) {
 				ret = cache_block_group(block_group);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			found_uncached_bg = true;
 
@@ -5088,7 +5088,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
@@ -5148,7 +5148,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
@@ -5225,28 +5225,28 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	if (!caching_ctl) {
 		BUG_ON(!block_group_cache_done(block_group));
 		ret = btrfs_remove_free_space(block_group, start, num_bytes);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else {
 		mutex_lock(&caching_ctl->mutex);
 
 		if (start >= caching_ctl->progress) {
 			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else if (start + num_bytes <= caching_ctl->progress) {
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else {
 			num_bytes = caching_ctl->progress - start;
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			start = caching_ctl->progress;
 			num_bytes = ins->objectid + ins->offset -
 				    caching_ctl->progress;
 			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		mutex_unlock(&caching_ctl->mutex);
@@ -5254,7 +5254,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	}
 
 	ret = update_reserved_bytes(block_group, ins->offset, 1, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
@@ -5392,7 +5392,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					ins.offset, parent, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
 					extent_op);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	return buf;
 }
@@ -5530,7 +5530,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 					       eb->start, eb->len,
 					       &wc->refs[level],
 					       &wc->flags[level]);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		BUG_ON(wc->refs[level] == 0);
 	}
 
@@ -5549,12 +5549,12 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	if (!(wc->flags[level] & flag)) {
 		BUG_ON(!path->locks[level]);
 		ret = btrfs_inc_ref(trans, root, eb, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		ret = btrfs_dec_ref(trans, root, eb, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
 						  eb->len, flag, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		wc->flags[level] |= flag;
 	}
 
@@ -5626,7 +5626,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
 				       &wc->refs[level - 1],
 				       &wc->flags[level - 1]);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	BUG_ON(wc->refs[level - 1] == 0);
 	*lookup_info = 0;
 
@@ -5693,7 +5693,7 @@ skip:
 
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
 					root->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_tree_unlock(next);
 	free_extent_buffer(next);
@@ -5751,7 +5751,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 						       eb->start, eb->len,
 						       &wc->refs[level],
 						       &wc->flags[level]);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			BUG_ON(wc->refs[level] == 0);
 			if (wc->refs[level] == 1) {
 				btrfs_tree_unlock(eb);
@@ -5770,7 +5770,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				ret = btrfs_dec_ref(trans, root, eb, 1);
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		/* make block locked assertion in clean_tree_block happy */
 		if (!path->locks[level] &&
@@ -5941,7 +5941,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 						path->nodes[level]->len,
 						&wc->refs[level],
 						&wc->flags[level]);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			BUG_ON(wc->refs[level] == 0);
 
 			if (level == root_item->drop_level)
@@ -5991,7 +5991,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 			ret = btrfs_update_root(trans, tree_root,
 						&root->root_key,
 						root_item);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			btrfs_end_transaction_throttle(trans, tree_root);
 			trans = btrfs_start_transaction(tree_root, 0);
@@ -6003,7 +6003,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	BUG_ON(err);
 
 	ret = btrfs_del_root(trans, tree_root, &root->root_key);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		ret = btrfs_find_last_root(tree_root, root->root_key.objectid,
@@ -6012,7 +6012,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		if (ret > 0) {
 			ret = btrfs_del_orphan_item(trans, tree_root,
 						    root->root_key.objectid);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 
@@ -6798,7 +6798,7 @@ next:
 						root->root_key.objectid,
 						trans->transid,
 						key.objectid);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			ret = btrfs_free_extent(trans, root,
 						extent_key->objectid,
@@ -6807,7 +6807,7 @@ next:
 						btrfs_header_owner(leaf),
 						btrfs_header_generation(leaf),
 						key.objectid, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			btrfs_release_path(root, path);
 			key.offset += num_bytes;
@@ -6825,7 +6825,7 @@ next:
 			ret = btrfs_drop_extents(trans, root, inode, key.offset,
 						 key.offset + num_bytes,
 						 key.offset, &alloc_hint);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			for (i = 0; i < nr_extents; i++) {
 				if (ext_offset >= new_extents[i].num_bytes) {
@@ -6838,7 +6838,7 @@ next:
 				ret = btrfs_insert_empty_item(trans, root,
 							      path, &key,
 							      sizeof(*fi));
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 
 				leaf = path->nodes[0];
 				fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -6877,7 +6877,7 @@ next:
 						leaf->start,
 						root->root_key.objectid,
 						trans->transid, key.objectid);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				btrfs_release_path(root, path);
 
 				inode_add_bytes(inode, extent_len);
@@ -7086,14 +7086,14 @@ static noinline int replace_extents_in_leaf(struct btrfs_trans_handle *trans,
 					leaf->start,
 					root->root_key.objectid,
 					trans->transid, key.objectid);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		ret = btrfs_free_extent(trans, root,
 					bytenr, num_bytes, leaf->start,
 					btrfs_header_owner(leaf),
 					btrfs_header_generation(leaf),
 					key.objectid, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		cond_resched();
 	}
 	kfree(new_extent);
@@ -7125,7 +7125,7 @@ int btrfs_free_reloc_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_root(trans, root->fs_info->tree_root,
 					&reloc_root->root_key,
 					&reloc_root->root_item);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	return 0;
 }
@@ -7160,7 +7160,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 
 			nr = trans->blocks_used;
 			ret = btrfs_end_transaction(trans, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			btrfs_btree_balance_dirty(root, nr);
 		}
 
@@ -7168,12 +7168,12 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 
 		ret = btrfs_del_root(trans, root->fs_info->tree_root,
 				     &reloc_root->root_key);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		mutex_unlock(&root->fs_info->drop_mutex);
 
 		nr = trans->blocks_used;
 		ret = btrfs_end_transaction(trans, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		btrfs_btree_balance_dirty(root, nr);
 
 		kfree(prev_root);
@@ -7202,7 +7202,7 @@ int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
 
 	mutex_lock(&root->fs_info->tree_reloc_mutex);
 	ret = btrfs_find_dead_roots(root, BTRFS_TREE_RELOC_OBJECTID, NULL);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	found = !list_empty(&root->fs_info->dead_reloc_roots);
 	mutex_unlock(&root->fs_info->tree_reloc_mutex);
 
@@ -7210,7 +7210,7 @@ int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
 		trans = btrfs_start_transaction(root, 1);
 		BUG_ON(!trans);
 		ret = btrfs_commit_transaction(trans, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	location.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
@@ -7241,7 +7241,7 @@ static noinline int init_reloc_tree(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_copy_root(trans, root, root->commit_root,
 			      &eb, BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.offset = root->root_key.objectid;
@@ -7258,7 +7258,7 @@ static noinline int init_reloc_tree(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
 				&root_key, root_item);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	kfree(root_item);
 
 	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
@@ -7313,7 +7313,7 @@ static noinline int relocate_one_path(struct btrfs_trans_handle *trans,
 	if (!root->ref_cows) {
 		path->lowest_level = lowest_level;
 		ret = btrfs_search_slot(trans, root, first_key, path, 0, 1);
-		BUG_ON(ret < 0);
+		btrfs_fixable_bug_on(ret < 0);
 		path->lowest_level = 0;
 		btrfs_release_path(root, path);
 		return 0;
@@ -7321,7 +7321,7 @@ static noinline int relocate_one_path(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&root->fs_info->tree_reloc_mutex);
 	ret = init_reloc_tree(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	reloc_root = root->reloc_root;
 
 	shared_level = ref_path->shared_level;
@@ -7338,7 +7338,7 @@ static noinline int relocate_one_path(struct btrfs_trans_handle *trans,
 		path->lowest_level = lowest_level;
 		ret = btrfs_search_slot(trans, reloc_root, first_key, path,
 					0, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		for (level = lowest_level; level < BTRFS_MAX_LEVEL; level++) {
 			eb = path->nodes[level];
 			if (!eb || eb == reloc_root->node)
@@ -7354,13 +7354,13 @@ static noinline int relocate_one_path(struct btrfs_trans_handle *trans,
 			eb = path->nodes[0];
 			ret = replace_extents_in_leaf(trans, reloc_root, eb,
 						      group, reloc_inode);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		btrfs_release_path(reloc_root, path);
 	} else {
 		ret = btrfs_merge_path(trans, reloc_root, keys, nodes,
 				       lowest_level);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	/*
@@ -7368,17 +7368,17 @@ static noinline int relocate_one_path(struct btrfs_trans_handle *trans,
 	 * the reloc tree.
 	 */
 	ret = btrfs_merge_path(trans, root, keys, nodes, lowest_level);
-	BUG_ON(ret < 0);
+	btrfs_fixable_bug_on(ret < 0);
 
 	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_search_slot(trans, reloc_root, first_key, path,
 					0, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		extent_buffer_get(path->nodes[0]);
 		eb = path->nodes[0];
 		btrfs_release_path(reloc_root, path);
 		ret = invalidate_extent_cache(reloc_root, eb, group, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		free_extent_buffer(eb);
 	}
 
@@ -7397,7 +7397,7 @@ static noinline int relocate_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = relocate_one_path(trans, root, path, first_key,
 				ref_path, NULL, NULL);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	return 0;
 }
@@ -7972,7 +7972,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		cache->space_info = space_info;
 		spin_lock(&cache->space_info->lock);
 		cache->space_info->bytes_readonly += cache->bytes_super;
@@ -7981,7 +7981,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		__link_block_group(space_info, cache);
 
 		ret = btrfs_add_block_group_cache(root->fs_info, cache);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		set_avail_alloc_bits(root->fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
@@ -8062,7 +8062,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	spin_lock(&cache->space_info->lock);
 	cache->space_info->bytes_readonly += cache->bytes_super;
@@ -8071,11 +8071,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	__link_block_group(cache->space_info, cache);
 
 	ret = btrfs_add_block_group_cache(root->fs_info, cache);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
 				sizeof(cache->item));
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	set_avail_alloc_bits(extent_root->fs_info, type);
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a562a25..0936d41 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -58,7 +58,7 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 				      sizeof(*item));
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0],
 			      struct btrfs_file_extent_item);
@@ -492,7 +492,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
 		ret = btrfs_truncate_item(trans, root, path, new_size, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
 		/*
@@ -505,11 +505,11 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		new_size *= csum_size;
 
 		ret = btrfs_truncate_item(trans, root, path, new_size, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		key->offset = end_byte;
 		ret = btrfs_set_item_key_safe(trans, root, path, key);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else {
 		BUG();
 	}
@@ -571,7 +571,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		/* delete the entire item, it is inside our range */
 		if (key.offset >= bytenr && csum_end <= end_byte) {
 			ret = btrfs_del_item(trans, root, path);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -619,7 +619,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		} else {
 			ret = truncate_one_csum(trans, root, path,
 						&key, bytenr, len);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			if (key.offset < bytenr)
 				break;
 		}
@@ -753,7 +753,7 @@ again:
 			goto insert;
 
 		ret = btrfs_extend_item(trans, root, path, diff);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		goto csum;
 	}
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..0f32ed8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -221,7 +221,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->bdev = em->bdev;
 			split->flags = flags;
 			ret = add_extent_mapping(em_tree, split);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			free_extent_map(split);
 			split = split2;
 			split2 = NULL;
@@ -246,7 +246,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			}
 
 			ret = add_extent_mapping(em_tree, split);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			free_extent_map(split);
 			split = NULL;
 		}
@@ -404,7 +404,7 @@ next_slot:
 						root->root_key.objectid,
 						new_key.objectid,
 						start - extent_offset);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				*hint_byte = disk_bytenr;
 			}
 			key.offset = start;
@@ -479,7 +479,7 @@ next_slot:
 						root->root_key.objectid,
 						key.objectid, key.offset -
 						extent_offset);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
 				*hint_byte = disk_bytenr;
@@ -495,7 +495,7 @@ next_slot:
 
 			ret = btrfs_del_items(trans, root, path, del_slot,
 					      del_nr);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			del_nr = 0;
 			del_slot = 0;
@@ -509,7 +509,7 @@ next_slot:
 
 	if (del_nr > 0) {
 		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	btrfs_free_path(path);
@@ -685,7 +685,7 @@ again:
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
 					   root->root_key.objectid,
 					   inode->i_ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (split == start) {
 			key.offset = start;
@@ -712,7 +712,7 @@ again:
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					inode->i_ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	other_start = 0;
 	other_end = start;
@@ -729,7 +729,7 @@ again:
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					inode->i_ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	if (del_nr == 0) {
 		fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -747,7 +747,7 @@ again:
 		btrfs_mark_buffer_dirty(leaf);
 
 		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 out:
 	btrfs_free_path(path);
@@ -942,7 +942,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
 		if (!PageUptodate(pinned[0])) {
 			ret = btrfs_readpage(NULL, pinned[0]);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			wait_on_page_locked(pinned[0]);
 		} else {
 			unlock_page(pinned[0]);
@@ -952,7 +952,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
 		if (!PageUptodate(pinned[1])) {
 			ret = btrfs_readpage(NULL, pinned[1]);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			wait_on_page_locked(pinned[1]);
 		} else {
 			unlock_page(pinned[1]);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..ad15e7b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -144,7 +144,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	inode_add_bytes(inode, size);
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	if (ret) {
 		err = ret;
 		goto fail;
@@ -244,14 +244,14 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_drop_extents(trans, inode, start, aligned_end,
 				 &hint_byte, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (isize > actual_end)
 		inline_len = min_t(u64, isize, actual_end);
 	ret = insert_inline_extent(trans, root, inode, start,
 				   inline_len, compressed_size,
 				   compressed_pages);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;
@@ -667,7 +667,7 @@ retry:
 					       async_extent->ram_size,
 					       ins.offset,
 					       BTRFS_ORDERED_COMPRESSED);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		/*
 		 * clear dirty, set writeback and unlock the pages.
@@ -689,7 +689,7 @@ retry:
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages);
 
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
 		cond_resched();
@@ -812,7 +812,7 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		em = alloc_extent_map(GFP_NOFS);
 		em->start = start;
@@ -840,13 +840,13 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
 					       ram_size, cur_alloc_size, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (root->root_key.objectid ==
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		if (disk_num_bytes < cur_alloc_size)
@@ -1149,7 +1149,7 @@ out_check:
 			ret = cow_file_range(inode, locked_page, cow_start,
 					found_key.offset - 1, page_started,
 					nr_written, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			cow_start = (u64)-1;
 		}
 
@@ -1183,13 +1183,13 @@ out_check:
 
 		ret = btrfs_add_ordered_extent(inode, cur_offset, disk_bytenr,
 					       num_bytes, num_bytes, type);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (root->root_key.objectid ==
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			ret = btrfs_reloc_clone_csums(inode, cur_offset,
 						      num_bytes);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
@@ -1208,11 +1208,11 @@ out_check:
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	ret = btrfs_end_transaction(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_free_path(path);
 	return 0;
 }
@@ -1392,7 +1392,7 @@ static int __btrfs_submit_bio_start(struct inode *inode, int rw,
 	int ret = 0;
 
 	ret = btrfs_csum_one_bio(root, inode, bio, 0, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -1427,7 +1427,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (!(rw & REQ_WRITE)) {
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
@@ -1603,13 +1603,13 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 */
 	ret = btrfs_drop_extents(trans, inode, file_pos, file_pos + num_bytes,
 				 &hint, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ins.objectid = inode->i_ino;
 	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &ins, sizeof(*fi));
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
@@ -1637,7 +1637,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
 					inode->i_ino, file_pos, &ins);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_free_path(path);
 
 	return 0;
@@ -1677,7 +1677,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode(trans, root, inode);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		goto out;
 	}
@@ -1698,7 +1698,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						ordered_extent->len);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else {
 		ret = insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
@@ -1711,7 +1711,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 				   ordered_extent->file_offset,
 				   ordered_extent->len);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	unlock_extent_cached(io_tree, ordered_extent->file_offset,
 			     ordered_extent->file_offset +
@@ -1722,7 +1722,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 
 	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 out:
 	btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans)
@@ -2060,7 +2060,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      root->orphan_block_rsv,
 					      num_bytes);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	/* setup orphan block reservation for the snapshot */
@@ -2073,14 +2073,14 @@ void btrfs_orphan_post_snapshot(struct btrfs_trans_handle *trans,
 	num_bytes = root->orphan_block_rsv->size;
 	ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 				      block_rsv, num_bytes);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 #if 0
 	/* insert orphan item for the snapshot */
 	WARN_ON(!root->orphan_item_inserted);
 	ret = btrfs_insert_orphan_item(trans, root->fs_info->tree_root,
 				       snap->root_key.objectid);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	snap->orphan_item_inserted = 1;
 #endif
 }
@@ -2108,7 +2108,7 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
 					    root->root_key.objectid);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		root->orphan_item_inserted = 0;
 	}
 
@@ -2177,20 +2177,20 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	/* grab metadata reservation from transaction handle */
 	if (reserve) {
 		ret = btrfs_orphan_reserve_metadata(trans, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, inode->i_ino);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	/* insert an orphan item to track subvolume contains orphan files */
 	if (insert >= 2) {
 		ret = btrfs_insert_orphan_item(trans, root->fs_info->tree_root,
 					       root->root_key.objectid);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	return 0;
 }
@@ -2220,7 +2220,7 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	if (trans && delete_item) {
 		ret = btrfs_del_orphan_item(trans, root, inode->i_ino);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	if (release_rsv)
@@ -2651,7 +2651,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
 					   dir, index);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 err:
 	btrfs_free_path(path);
 	if (ret)
@@ -2868,11 +2868,11 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (inode->i_nlink == 0) {
 		ret = btrfs_orphan_add(trans, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	nr = trans->blocks_used;
@@ -2905,7 +2905,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
 	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_release_path(root, path);
 
 	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
@@ -2931,13 +2931,13 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
 	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_release_path(root, path);
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_free_path(path);
 	return 0;
@@ -3118,7 +3118,7 @@ next_node:
 	 * csum items from this inode at an offset >= new_size
 	 */
 	ret = btrfs_del_leaf(trans, root, path, leaf_start);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (root->ref_cows && leaf_gen < trans->transid) {
 		ref = btrfs_alloc_leaf_ref(root, 0);
@@ -3321,7 +3321,7 @@ search_again:
 				    btrfs_file_extent_calc_inline_size(size);
 				ret = btrfs_truncate_item(trans, root, path,
 							  size, 1);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			} else if (root->ref_cows) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);
@@ -3350,7 +3350,7 @@ delete:
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
 						inode->i_ino, extent_offset);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		if (found_type == BTRFS_INODE_ITEM_KEY)
@@ -3366,7 +3366,7 @@ delete:
 				ret = btrfs_del_items(trans, root, path,
 						pending_del_slot,
 						pending_del_nr);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				pending_del_nr = 0;
 			}
 			btrfs_release_path(root, path);
@@ -3379,7 +3379,7 @@ out:
 	if (pending_del_nr) {
 		ret = btrfs_del_items(trans, root, path, pending_del_slot,
 				      pending_del_nr);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_free_path(path);
 	return err;
@@ -3592,7 +3592,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 	btrfs_set_trans_block_group(trans, inode);
 
 	ret = btrfs_orphan_add(trans, inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
@@ -3615,10 +3615,10 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 		BUG_ON(!trans->block_rsv);
 
 		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		if (inode->i_nlink > 0) {
 			ret = btrfs_orphan_del(trans, inode);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
@@ -3636,7 +3636,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 
 	/* we don't support swapfiles, so vmtruncate shouldn't fail */
 	ret = vmtruncate(inode, attr->ia_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	return 0;
 }
@@ -3708,7 +3708,7 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret) {
 			BUG_ON(ret != -EAGAIN);
 			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			continue;
 		}
 
@@ -3725,7 +3725,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 	if (ret == 0) {
 		ret = btrfs_orphan_del(trans, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	nr = trans->blocks_used;
@@ -4566,7 +4566,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		ret = btrfs_insert_dir_item(trans, root, name, name_len,
 					    parent_inode->i_ino, &key,
 					    btrfs_inode_type(inode), index);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_i_size_write(parent_inode, parent_inode->i_size +
 				   name_len * 2);
@@ -5089,7 +5089,7 @@ again:
 				ret = uncompress_inline(path, inode, page,
 							pg_offset,
 							extent_offset, item);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			} else {
 				map = kmap(page);
 				read_extent_buffer(leaf, map + pg_offset, ptr,
@@ -5635,7 +5635,7 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	ret = btrfs_csum_one_bio(root, inode, bio, offset, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -6158,7 +6158,7 @@ static void btrfs_truncate(struct inode *inode)
 		if (ret) {
 			BUG_ON(ret != -EAGAIN);
 			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			trans = NULL;
 			continue;
 		}
@@ -6170,7 +6170,7 @@ static void btrfs_truncate(struct inode *inode)
 			break;
 
 		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
@@ -6180,15 +6180,15 @@ static void btrfs_truncate(struct inode *inode)
 
 	if (ret == 0 && inode->i_nlink > 0) {
 		ret = btrfs_orphan_del(trans, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_btree_balance_dirty(root, nr);
 }
 
@@ -6517,7 +6517,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					 old_dentry->d_name.name,
 					 old_dentry->d_name.len);
 	}
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME;
@@ -6535,17 +6535,17 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
 		}
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		if (new_inode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
 		btrfs_log_new_name(trans, old_inode, old_dir,
@@ -6786,7 +6786,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
 						  BTRFS_FILE_EXTENT_PREALLOC);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		btrfs_drop_extent_cache(inode, cur_offset,
 					cur_offset + ins.offset -1, 0);
 
@@ -6808,7 +6808,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 		}
 
 		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_end_transaction(trans, root);
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..18ba85b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -203,7 +203,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	BUG_ON(!trans);
 
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_update_iflags(inode);
 	inode->i_ctime = CURRENT_TIME;
@@ -318,7 +318,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(dir, &index);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_insert_dir_item(trans, root,
 				    name, namelen, dir->i_ino, &key,
@@ -328,13 +328,13 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	btrfs_i_size_write(dir, dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 dir->i_ino, index, name, namelen);
 
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
@@ -369,12 +369,12 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry)
 	}
 
 	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
 	ret = btrfs_commit_transaction(trans, root->fs_info->extent_root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = pending_snapshot->error;
 	if (ret)
@@ -1288,7 +1288,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 				dest->root_key.objectid,
 				dentry->d_name.name,
 				dentry->d_name.len);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_record_root_in_trans(trans, dest);
 
@@ -1301,11 +1301,11 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		ret = btrfs_insert_orphan_item(trans,
 					root->fs_info->tree_root,
 					dest->root_key.objectid);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	inode->i_flags |= S_DEAD;
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
@@ -1633,11 +1633,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 							 new_key.offset,
 							 new_key.offset + datal,
 							 &hint_byte, 1);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
 							      &new_key, size);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 
 				leaf = path->nodes[0];
 				slot = path->slots[0];
@@ -1663,7 +1663,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 							root->root_key.objectid,
 							inode->i_ino,
 							new_key.offset - datao);
-					BUG_ON(ret);
+					btrfs_fixable_bug_on(ret);
 				}
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 				u64 skip = 0;
@@ -1688,11 +1688,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 							 new_key.offset,
 							 new_key.offset + datal,
 							 &hint_byte, 1);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
 							      &new_key, size);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 
 				if (skip) {
 					u32 start =
@@ -1727,7 +1727,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 			BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
 			ret = btrfs_update_inode(trans, root, inode);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			btrfs_end_transaction(trans, root);
 		}
 next:
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b37d723..ce76176 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1275,7 +1275,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		/* called by btrfs_init_reloc_root */
 		ret = btrfs_copy_root(trans, root, root->commit_root, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_set_root_last_snapshot(&root->root_item,
 					     trans->transid - 1);
@@ -1289,7 +1289,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		 */
 		ret = btrfs_copy_root(trans, root, root->node, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	memcpy(root_item, &root->root_item, sizeof(*root_item));
@@ -1309,7 +1309,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
 				&root_key, root_item);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	kfree(root_item);
 
 	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
@@ -1386,7 +1386,7 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&reloc_root->root_key, root_item);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -1598,12 +1598,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
 					   key.objectid, key.offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
 					key.objectid, key.offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	if (dirty)
 		btrfs_mark_buffer_dirty(leaf);
@@ -1672,7 +1672,7 @@ again:
 
 	if (cow) {
 		ret = btrfs_cow_block(trans, dest, eb, NULL, 0, &eb);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_set_lock_blocking(eb);
 
@@ -1728,7 +1728,7 @@ again:
 			if (cow) {
 				ret = btrfs_cow_block(trans, dest, eb, parent,
 						      slot, &eb);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			btrfs_set_lock_blocking(eb);
 
@@ -1753,7 +1753,7 @@ again:
 		path->lowest_level = level;
 		ret = btrfs_search_slot(trans, src, &key, path, 0, 1);
 		path->lowest_level = 0;
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		/*
 		 * swap blocks in fs tree and reloc tree.
@@ -1771,21 +1771,21 @@ again:
 		ret = btrfs_inc_extent_ref(trans, src, old_bytenr, blocksize,
 					path->nodes[level]->start,
 					src->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
 					0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
 					path->nodes[level]->start,
 					src->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
 					0);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_unlock_up_safe(path, 0);
 
@@ -2036,7 +2036,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		if (ret) {
 			BUG_ON(ret != -EAGAIN);
 			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			continue;
 		}
 
@@ -2218,7 +2218,7 @@ again:
 			BUG_ON(root->reloc_root != reloc_root);
 
 			ret = merge_reloc_root(rc, root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
@@ -2465,7 +2465,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			if (!lowest) {
 				ret = btrfs_bin_search(upper->eb, key,
 						       upper->level, &slot);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				bytenr = btrfs_node_blockptr(upper->eb, slot);
 				if (node->eb->start == bytenr)
 					goto next;
@@ -2496,7 +2496,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 		} else {
 			ret = btrfs_bin_search(upper->eb, key, upper->level,
 					       &slot);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		bytenr = btrfs_node_blockptr(upper->eb, slot);
@@ -2535,10 +2535,10 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						upper->eb->start,
 						btrfs_header_owner(upper->eb),
 						node->level, 0);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 next:
 		if (!upper->pending)
@@ -3182,7 +3182,7 @@ static int block_use_full_backref(struct reloc_control *rc,
 
 	ret = btrfs_lookup_extent_info(NULL, rc->extent_root,
 				       eb->start, eb->len, NULL, &flags);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 		ret = 1;
@@ -3622,7 +3622,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		if (item_size >= sizeof(*ei)) {
 			flags = btrfs_extent_flags(path->nodes[0], ei);
 			ret = check_extent_flags(flags);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 		} else {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -3696,7 +3696,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		if (rc->commit_transaction) {
 			rc->commit_transaction = 0;
 			ret = btrfs_commit_transaction(trans, rc->extent_root);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else {
 			nr = trans->blocks_used;
 			btrfs_end_transaction_throttle(trans, rc->extent_root);
@@ -3952,10 +3952,10 @@ static noinline_for_stack int mark_garbage_root(struct btrfs_root *root)
 	btrfs_set_root_refs(&root->root_item, 0);
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_end_transaction(trans, root->fs_info->tree_root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -4196,7 +4196,7 @@ void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 
 	if (level == 0 && first_cow && rc->stage == UPDATE_DATA_PTRS) {
 		ret = replace_file_extents(trans, rc, root, cow);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 }
 
@@ -4257,7 +4257,7 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      rc->block_rsv,
 					      rc->nodes_relocated);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	new_root = pending->snap;
@@ -4269,6 +4269,6 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 
 	if (rc->create_reloc_tree) {
 		ret = clone_backref_node(trans, rc, root, reloc_root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 66e4c66..8af7081 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -191,7 +191,7 @@ again:
 		wait_current_trans(root);
 
 	ret = join_transaction(root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	cur_trans = root->fs_info->running_transaction;
 	cur_trans->use_count++;
@@ -586,11 +586,11 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_root(trans, tree_root,
 					&root->root_key,
 					&root->root_item);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		old_root_used = btrfs_root_used(&root->root_item);
 		ret = btrfs_write_dirty_block_groups(trans, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	if (root != root->fs_info->extent_root)
@@ -611,7 +611,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	eb = btrfs_lock_root_node(fs_info->tree_root);
 	btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb);
@@ -619,7 +619,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	free_extent_buffer(eb);
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
@@ -795,19 +795,19 @@ int btrfs_drop_dead_root(struct btrfs_root *root)
 
 		nr = trans->blocks_used;
 		ret = btrfs_end_transaction(trans, tree_root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_btree_balance_dirty(tree_root, nr);
 		cond_resched();
 	}
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_del_root(trans, tree_root, &root->root_key);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction(trans, tree_root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
@@ -880,17 +880,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				dentry->d_name.name, dentry->d_name.len,
 				parent_inode->i_ino, &key,
 				BTRFS_FT_DIR, index);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
@@ -910,7 +910,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_root(trans, tree_root, &key, new_root_item);
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	/*
 	 * insert root back/forward references
@@ -919,7 +919,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_root->root_key.objectid,
 				 parent_inode->i_ino, index,
 				 dentry->d_name.name, dentry->d_name.len);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
@@ -945,7 +945,7 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 
 	list_for_each_entry(pending, head, list) {
 		ret = create_pending_snapshot(trans, fs_info, pending);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	return 0;
 }
@@ -1007,7 +1007,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * any runnings procs may add more while we are here
 	 */
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_trans_release_metadata(trans, root);
 
@@ -1019,7 +1019,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	cur_trans->delayed_refs.flushing = 1;
 
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (cur_trans->in_commit) {
@@ -1028,7 +1028,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		btrfs_end_transaction(trans, root);
 
 		ret = wait_for_commit(root, cur_trans);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		mutex_lock(&root->fs_info->trans_mutex);
 		put_transaction(cur_trans);
@@ -1073,7 +1073,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		if (flush_on_commit || snap_pending) {
 			btrfs_start_delalloc_inodes(root, 1);
 			ret = btrfs_wait_ordered_extents(root, 0, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		/*
@@ -1098,10 +1098,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		 (should_grow && cur_trans->num_joined != joined));
 
 	ret = create_pending_snapshots(trans, root->fs_info);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	WARN_ON(cur_trans != trans->transaction);
 
@@ -1121,7 +1121,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	mutex_lock(&root->fs_info->tree_log_mutex);
 
 	ret = commit_fs_roots(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
@@ -1129,7 +1129,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
 	ret = commit_cowonly_roots(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_prepare_extent_commit(trans, root);
 
@@ -1162,7 +1162,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	mutex_unlock(&root->fs_info->trans_mutex);
 	ret = btrfs_write_and_wait_transaction(trans, root);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	write_ctree_super(trans, root, 0);
 
 	/*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fb102a9..2bf678c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -376,7 +376,7 @@ insert:
 		} else if (found_size < item_size) {
 			ret = btrfs_extend_item(trans, root, path,
 						item_size - found_size);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	} else if (ret) {
 		return ret;
@@ -548,7 +548,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
 				 &alloc_hint, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -558,7 +558,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_insert_empty_item(trans, root, path, key,
 					      sizeof(*item));
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		dest_offset = btrfs_item_ptr_offset(path->nodes[0],
 						    path->slots[0]);
 		copy_extent_buffer(path->nodes[0], eb, dest_offset,
@@ -592,7 +592,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				ret = btrfs_alloc_logged_file_extent(trans,
 						root, root->root_key.objectid,
 						key->objectid, offset, &ins);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			btrfs_release_path(root, path);
 
@@ -609,7 +609,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_lookup_csums_range(root->log_root,
 						csum_start, csum_end - 1,
 						&ordered_sums);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			while (!list_empty(&ordered_sums)) {
 				struct btrfs_ordered_sum *sums;
 				sums = list_entry(ordered_sums.next,
@@ -618,7 +618,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				ret = btrfs_csum_file_blocks(trans,
 						root->fs_info->csum_root,
 						sums);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 				list_del(&sums->list);
 				kfree(sums);
 			}
@@ -628,7 +628,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		/* inline extents are easy, we just overwrite them */
 		ret = overwrite_item(trans, root, path, eb, slot, key);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	inode_set_bytes(inode, saved_nbytes);
@@ -672,10 +672,10 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	BUG_ON(!inode);
 
 	ret = link_to_fixup_dir(trans, root, path, location.objectid);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	kfree(name);
 
 	iput(inode);
@@ -886,7 +886,7 @@ conflict_again:
 			kfree(victim_name);
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
 		}
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_release_path(root, path);
 
@@ -896,7 +896,7 @@ conflict_again:
 					 name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_release_path(root, path);
 
@@ -906,14 +906,14 @@ conflict_again:
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_release_path(root, path);
 
 	/* insert our name */
 	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
 			     btrfs_inode_ref_index(eb, ref));
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_update_inode(trans, root, inode);
 
@@ -925,7 +925,7 @@ out:
 
 	/* finally write the back reference in the inode */
 	ret = overwrite_item(trans, root, path, eb, slot, key);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 out_nowrite:
 	btrfs_release_path(root, path);
@@ -1016,10 +1016,10 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 		if (S_ISDIR(inode->i_mode)) {
 			ret = replay_dir_deletes(trans, root, NULL, path,
 						 inode->i_ino, 1);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		ret = insert_orphan_item(trans, root, inode->i_ino);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_free_path(path);
 
@@ -1054,14 +1054,14 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 			break;
 
 		ret = btrfs_del_item(trans, root, path);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_release_path(root, path);
 		inode = read_one_inode(root, key.offset);
 		BUG_ON(!inode);
 
 		ret = fixup_inode_link_count(trans, root, inode);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		iput(inode);
 
@@ -1232,7 +1232,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto out;
 
 	ret = drop_one_dir_item(trans, root, path, dir, dst_di);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (key->type == BTRFS_DIR_INDEX_KEY)
 		goto insert;
@@ -1276,7 +1276,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 		di = (struct btrfs_dir_item *)ptr;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		ptr = (unsigned long)(di + 1);
 		ptr += name_len;
 	}
@@ -1429,11 +1429,11 @@ again:
 
 			ret = link_to_fixup_dir(trans, root,
 						path, location.objectid);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			btrfs_inc_nlink(inode);
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			kfree(name);
 			iput(inode);
 
@@ -1539,7 +1539,7 @@ again:
 			ret = check_item_in_log(trans, root, log, path,
 						log_path, dir,
 						&found_key);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 			if (found_key.offset == (u64)-1)
 				break;
 			dir_key.offset = found_key.offset + 1;
@@ -1615,11 +1615,11 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 			if (S_ISDIR(mode)) {
 				ret = replay_dir_deletes(wc->trans,
 					 root, log, path, key.objectid, 0);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			ret = overwrite_item(wc->trans, root, path,
 					     eb, i, &key);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 
 			/* for regular files, make sure corresponding
 			 * orhpan item exist. extents past the new EOF
@@ -1628,12 +1628,12 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 			if (S_ISREG(mode)) {
 				ret = insert_orphan_item(wc->trans, root,
 							 key.objectid);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 
 			ret = link_to_fixup_dir(wc->trans, root,
 						path, key.objectid);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 		if (wc->stage < LOG_WALK_REPLAY_ALL)
 			continue;
@@ -1642,7 +1642,7 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		if (key.type == BTRFS_XATTR_ITEM_KEY) {
 			ret = overwrite_item(wc->trans, root, path,
 					     eb, i, &key);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else if (key.type == BTRFS_INODE_REF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
@@ -1650,12 +1650,12 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		} else if (key.type == BTRFS_EXTENT_DATA_KEY) {
 			ret = replay_one_extent(wc->trans, root, path,
 						eb, i, &key);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		} else if (key.type == BTRFS_DIR_ITEM_KEY ||
 			   key.type == BTRFS_DIR_INDEX_KEY) {
 			ret = replay_one_dir_item(wc->trans, root, path,
 						  eb, i, &key);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 	btrfs_free_path(path);
@@ -1719,7 +1719,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 					BTRFS_TREE_LOG_OBJECTID);
 				ret = btrfs_free_reserved_extent(root,
 							 bytenr, blocksize);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			free_extent_buffer(next);
 			continue;
@@ -1789,7 +1789,7 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				ret = btrfs_free_reserved_extent(root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
@@ -1856,7 +1856,7 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 				BTRFS_TREE_LOG_OBJECTID);
 			ret = btrfs_free_reserved_extent(log, next->start,
 							 next->len);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 
@@ -2000,7 +2000,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * wait for them until later.
 	 */
 	ret = btrfs_write_marked_extents(log, &log->dirty_log_pages, mark);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_set_root_node(&log->root_item, log->node);
 
@@ -2070,7 +2070,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	ret = btrfs_write_and_wait_marked_extents(log_root_tree,
 				&log_root_tree->dirty_log_pages,
 				EXTENT_DIRTY | EXTENT_NEW);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 
 	btrfs_set_super_log_root(&root->fs_info->super_for_commit,
@@ -2124,7 +2124,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	};
 
 	ret = walk_log_tree(trans, log, &wc);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
@@ -2216,7 +2216,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	btrfs_release_path(log, path);
 	di = btrfs_lookup_dir_index_item(trans, log, path, dir->i_ino,
@@ -2228,7 +2228,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	/* update the directory size in the log to reflect the names
@@ -2579,7 +2579,7 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 			break;
 
 		ret = btrfs_del_item(trans, log, path);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		btrfs_release_path(log, path);
 	}
 	btrfs_release_path(log, path);
@@ -2679,7 +2679,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						log->fs_info->csum_root,
 						ds + cs, ds + cs + cl - 1,
 						&ordered_sums);
-				BUG_ON(ret);
+				btrfs_fixable_bug_on(ret);
 			}
 		}
 	}
@@ -3123,12 +3123,12 @@ again:
 		wc.replay_dest->log_root = log;
 		btrfs_record_root_in_trans(trans, wc.replay_dest);
 		ret = walk_log_tree(trans, log, &wc);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (wc.stage == LOG_WALK_REPLAY_ALL) {
 			ret = fixup_inode_link_counts(trans, wc.replay_dest,
 						      path);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 
 		key.offset = found_key.offset - 1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd318ff..61b3440 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -879,7 +879,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 	if (ret > 0) {
 		ret = btrfs_previous_item(root, path, key.objectid,
 					  BTRFS_DEV_EXTENT_KEY);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		extent = btrfs_item_ptr(leaf, path->slots[0],
@@ -892,12 +892,12 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 		extent = btrfs_item_ptr(leaf, path->slots[0],
 					struct btrfs_dev_extent);
 	}
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (device->bytes_used > 0)
 		device->bytes_used -= btrfs_dev_extent_length(leaf, extent);
 	ret = btrfs_del_item(trans, root, path);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_free_path(path);
 	return ret;
@@ -925,7 +925,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
@@ -1509,7 +1509,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(trans, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	device->fs_devices = root->fs_info->fs_devices;
@@ -1541,9 +1541,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	if (seeding_dev) {
 		ret = init_first_rw_device(trans, root, device);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		ret = btrfs_finish_sprout(trans, root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	} else {
 		ret = btrfs_add_device(trans, root, device);
 	}
@@ -1562,7 +1562,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		up_write(&sb->s_umount);
 
 		ret = btrfs_relocate_sys_chunks(root);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
@@ -1674,10 +1674,10 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_del_item(trans, root, path);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	btrfs_free_path(path);
 	return 0;
@@ -1774,25 +1774,25 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	for (i = 0; i < map->num_stripes; i++) {
 		ret = btrfs_free_dev_extent(trans, map->stripes[i].dev,
 					    map->stripes[i].physical);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		if (map->stripes[i].dev) {
 			ret = btrfs_update_device(trans, map->stripes[i].dev);
-			BUG_ON(ret);
+			btrfs_fixable_bug_on(ret);
 		}
 	}
 	ret = btrfs_free_chunk(trans, root, chunk_tree, chunk_objectid,
 			       chunk_offset);
 
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_del_sys_chunk(root, chunk_objectid, chunk_offset);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 
 	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	write_lock(&em_tree->lock);
 	remove_extent_mapping(em_tree, em);
@@ -1924,13 +1924,13 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
 		if (ret == -ENOSPC)
 			break;
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		trans = btrfs_start_transaction(dev_root, 0);
 		BUG_ON(!trans);
 
 		ret = btrfs_grow_device(trans, device, old_size);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 
 		btrfs_end_transaction(trans, dev_root);
 	}
@@ -2351,13 +2351,13 @@ again:
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	write_unlock(&em_tree->lock);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	free_extent_map(em);
 
 	ret = btrfs_make_block_group(trans, extent_root, 0, type,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     start, *num_bytes);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	index = 0;
 	while (index < map->num_stripes) {
@@ -2368,7 +2368,7 @@ again:
 				info->chunk_root->root_key.objectid,
 				BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				start, dev_offset, calc_size);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		index++;
 	}
 
@@ -2399,7 +2399,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		device = map->stripes[index].dev;
 		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		index++;
 	}
 
@@ -2431,12 +2431,12 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	key.offset = chunk_offset;
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_add_system_chunk(trans, chunk_root, &key, chunk,
 					     item_size);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 	}
 	kfree(chunk);
 	return 0;
@@ -2471,7 +2471,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
 				   chunk_size, stripe_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -2494,7 +2494,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = find_next_chunk(fs_info->chunk_root,
 			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
 			(fs_info->metadata_alloc_profile &
@@ -2503,7 +2503,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
 				  &stripe_size, chunk_offset, alloc_profile);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	sys_chunk_offset = chunk_offset + chunk_size;
 
@@ -2515,10 +2515,10 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
 				  &sys_chunk_size, &sys_stripe_size,
 				  sys_chunk_offset, alloc_profile);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = btrfs_add_device(trans, fs_info->chunk_root, device);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	/*
 	 * Modifying chunk tree needs allocating new blocks from both
@@ -2528,12 +2528,12 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	 */
 	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
 				   chunk_size, stripe_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	ret = __finish_chunk_alloc(trans, extent_root, sys_map,
 				   sys_chunk_offset, sys_chunk_size,
 				   sys_stripe_size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	return 0;
 }
 
@@ -3006,7 +3006,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	ret = btrfs_map_block(map_tree, rw, logical, &map_length, &multi,
 			      mirror_num);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 
 	total_devs = multi->num_stripes;
 	if (map_length < length) {
@@ -3178,7 +3178,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	write_lock(&map_tree->map_tree.lock);
 	ret = add_extent_mapping(&map_tree->map_tree, em);
 	write_unlock(&map_tree->map_tree.lock);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 	free_extent_map(em);
 
 	return 0;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 88ecbb2..0b4f7e6 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -119,7 +119,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		}
 
 		ret = btrfs_delete_one_dir_name(trans, root, path, di);
-		BUG_ON(ret);
+		btrfs_fixable_bug_on(ret);
 		btrfs_release_path(root, path);
 
 		/* if we don't have a value then we are removing the xattr */
@@ -138,7 +138,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	/* ok we have to create a completely new xattr */
 	ret = btrfs_insert_xattr_item(trans, root, path, inode->i_ino,
 				      name, name_len, value, size);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -166,7 +166,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 
 	inode->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
+	btrfs_fixable_bug_on(ret);
 out:
 	btrfs_end_transaction_throttle(trans, root);
 	return ret;
-- 
1.6.4.2

