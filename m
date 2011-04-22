From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 12/12] btrfs: drop unused parameter from btrfs_release_path
Date: Fri, 22 Apr 2011 11:43:25 +0200
Message-ID: <a8d83648edda606b1673d5889063714ce59a61ce.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

parameter tree root it's not used since commit
5f39d397dfbe140a14edecd4e73c34ce23c4f9ee ("Btrfs: Create extent_buffer
interface for large blocksizes")

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c            |   28 ++++++------
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/dir-item.c         |    2 +-
 fs/btrfs/extent-tree.c      |   44 ++++++++++----------
 fs/btrfs/file-item.c        |   12 +++---
 fs/btrfs/file.c             |   12 +++---
 fs/btrfs/free-space-cache.c |   14 +++---
 fs/btrfs/inode.c            |   34 +++++++-------
 fs/btrfs/ioctl.c            |   12 +++---
 fs/btrfs/relocation.c       |   30 +++++++-------
 fs/btrfs/root-tree.c        |   10 ++--
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |   98 +++++++++++++++++++++---------------------
 fs/btrfs/volumes.c          |   16 ++++----
 fs/btrfs/xattr.c            |    4 +-
 15 files changed, 160 insertions(+), 160 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a36c87db..fad8f23 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -107,7 +107,7 @@ void btrfs_free_path(struct btrfs_path *p)
 {
 	if (!p)
 		return;
-	btrfs_release_path(NULL, p);
+	btrfs_release_path(p);
 	kmem_cache_free(btrfs_path_cachep, p);
 }
 
@@ -117,7 +117,7 @@ void btrfs_free_path(struct btrfs_path *p)
  *
  * It is safe to call this on paths that no locks or extent buffers held.
  */
-noinline void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p)
+noinline void btrfs_release_path(struct btrfs_path *p)
 {
 	int i;
 
@@ -1328,7 +1328,7 @@ static noinline int reada_for_balance(struct btrfs_root *root,
 		ret = -EAGAIN;
 
 		/* release the whole path */
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		/* read the blocks */
 		if (block1)
@@ -1475,7 +1475,7 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 				return 0;
 			}
 			free_extent_buffer(tmp);
-			btrfs_release_path(NULL, p);
+			btrfs_release_path(p);
 			return -EIO;
 		}
 	}
@@ -1494,7 +1494,7 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 	if (p->reada)
 		reada_for_search(root, p, level, slot, key->objectid);
 
-	btrfs_release_path(NULL, p);
+	btrfs_release_path(p);
 
 	ret = -EAGAIN;
 	tmp = read_tree_block(root, blocknr, blocksize, 0);
@@ -1563,7 +1563,7 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 		}
 		b = p->nodes[level];
 		if (!b) {
-			btrfs_release_path(NULL, p);
+			btrfs_release_path(p);
 			goto again;
 		}
 		BUG_ON(btrfs_header_nritems(b) == 1);
@@ -1753,7 +1753,7 @@ done:
 	if (!p->leave_spinning)
 		btrfs_set_path_blocking(p);
 	if (ret < 0)
-		btrfs_release_path(root, p);
+		btrfs_release_path(p);
 	return ret;
 }
 
@@ -3026,7 +3026,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 				    struct btrfs_file_extent_item);
 		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	path->keep_locks = 1;
 	path->search_for_split = 1;
@@ -3948,7 +3948,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 	else
 		return 1;
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		return ret;
@@ -4072,7 +4072,7 @@ find_next_key:
 			sret = btrfs_find_next_key(root, path, min_key, level,
 						  cache_only, min_trans);
 			if (sret == 0) {
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				goto again;
 			} else {
 				goto out;
@@ -4151,7 +4151,7 @@ next:
 				btrfs_node_key_to_cpu(c, &cur_key, slot);
 
 			orig_lowest = path->lowest_level;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			path->lowest_level = level;
 			ret = btrfs_search_slot(NULL, root, &cur_key, path,
 						0, 0);
@@ -4228,7 +4228,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 again:
 	level = 1;
 	next = NULL;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	path->keep_locks = 1;
 
@@ -4284,7 +4284,7 @@ again:
 			goto again;
 
 		if (ret < 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto done;
 		}
 
@@ -4323,7 +4323,7 @@ again:
 			goto again;
 
 		if (ret < 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto done;
 		}
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 45d9678..2f5012c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2290,7 +2290,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
 		       int start_slot, int cache_only, u64 *last_ret,
 		       struct btrfs_key *progress);
-void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
+void btrfs_release_path(struct btrfs_path *p);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
 void btrfs_set_path_blocking(struct btrfs_path *p);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..ab8afed 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -172,7 +172,7 @@ second_insert:
 		ret = 0;
 		goto out_free;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
 	key.offset = index;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e03bc1b..ff595e6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -379,7 +379,7 @@ again:
 				break;
 
 			caching_ctl->progress = last;
-			btrfs_release_path(extent_root, path);
+			btrfs_release_path(path);
 			up_read(&fs_info->extent_commit_sem);
 			mutex_unlock(&caching_ctl->mutex);
 			if (btrfs_transaction_in_commit(fs_info))
@@ -754,7 +754,7 @@ again:
 			atomic_inc(&head->node.refs);
 			spin_unlock(&delayed_refs->lock);
 
-			btrfs_release_path(root->fs_info->extent_root, path);
+			btrfs_release_path(path);
 
 			btrfs_put_delayed_ref(&head->node);
 			goto again;
@@ -932,7 +932,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 			break;
 		}
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID)
 		new_size += sizeof(*bi);
@@ -1040,7 +1040,7 @@ again:
 			return 0;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		key.type = BTRFS_EXTENT_REF_V0_KEY;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret < 0) {
 			err = ret;
@@ -1078,7 +1078,7 @@ again:
 		if (match_extent_data_ref(leaf, ref, root_objectid,
 					  owner, offset)) {
 			if (recow) {
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				goto again;
 			}
 			err = 0;
@@ -1139,7 +1139,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 			if (match_extent_data_ref(leaf, ref, root_objectid,
 						  owner, offset))
 				break;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			key.offset++;
 			ret = btrfs_insert_empty_item(trans, root, path, &key,
 						      size);
@@ -1165,7 +1165,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 fail:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1291,7 +1291,7 @@ static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
 		ret = -ENOENT;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (ret == -ENOENT && parent) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		key.type = BTRFS_EXTENT_REF_V0_KEY;
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0)
@@ -1320,7 +1320,7 @@ static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1606,7 +1606,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 	if (ret != -ENOENT)
 		return ret;
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	*ref_ret = NULL;
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
@@ -1860,7 +1860,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		__run_delayed_extent_op(extent_op, leaf, item);
 
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root->fs_info->extent_root, path);
+	btrfs_release_path(path);
 
 	path->reada = 1;
 	path->leave_spinning = 1;
@@ -2357,7 +2357,7 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 		atomic_inc(&head->node.refs);
 		spin_unlock(&delayed_refs->lock);
 
-		btrfs_release_path(root->fs_info->extent_root, path);
+		btrfs_release_path(path);
 
 		btrfs_put_delayed_ref(&head->node);
 		return -EAGAIN;
@@ -2726,7 +2726,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	bi = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	write_extent_buffer(leaf, &cache->item, bi, sizeof(cache->item));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(extent_root, path);
+	btrfs_release_path(path);
 fail:
 	if (ret)
 		return ret;
@@ -2779,7 +2779,7 @@ again:
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
 		ret = PTR_ERR(inode);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		goto out;
 	}
 
@@ -2848,7 +2848,7 @@ again:
 out_put:
 	iput(inode);
 out_free:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 out:
 	spin_lock(&block_group->lock);
 	block_group->disk_cache_state = dcs;
@@ -4535,7 +4535,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 						    NULL, refs_to_drop,
 						    is_data);
 			BUG_ON(ret);
-			btrfs_release_path(extent_root, path);
+			btrfs_release_path(path);
 			path->leave_spinning = 1;
 
 			key.objectid = bytenr;
@@ -4574,7 +4574,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 					     owner_objectid, 0);
 		BUG_ON(ret < 0);
 
-		btrfs_release_path(extent_root, path);
+		btrfs_release_path(path);
 		path->leave_spinning = 1;
 
 		key.objectid = bytenr;
@@ -4644,7 +4644,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		BUG_ON(ret);
-		btrfs_release_path(extent_root, path);
+		btrfs_release_path(path);
 
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
@@ -6474,7 +6474,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				trans->block_rsv = block_rsv;
 		}
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	BUG_ON(err);
 
 	ret = btrfs_del_root(trans, tree_root, &root->root_key);
@@ -8570,7 +8570,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		memcpy(&cache->key, &found_key, sizeof(found_key));
 
 		key.objectid = found_key.objectid + found_key.offset;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		cache->sectorsize = root->sectorsize;
 
@@ -8792,12 +8792,12 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 	if (ret > 0)
-		btrfs_release_path(tree_root, path);
+		btrfs_release_path(path);
 	if (ret == 0) {
 		ret = btrfs_del_item(trans, tree_root, path);
 		if (ret)
 			goto out;
-		btrfs_release_path(tree_root, path);
+		btrfs_release_path(path);
 	}
 
 	spin_lock(&root->fs_info->block_group_cache_lock);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..f47e43d 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -193,7 +193,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 			u32 item_size;
 
 			if (item)
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 			item = btrfs_lookup_csum(NULL, root->fs_info->csum_root,
 						 path, disk_bytenr, 0);
 			if (IS_ERR(item)) {
@@ -213,7 +213,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 					       (unsigned long long)offset);
 				}
 				item = NULL;
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				goto found;
 			}
 			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
@@ -631,7 +631,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 			if (key.offset < bytenr)
 				break;
 		}
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 	}
 out:
 	btrfs_free_path(path);
@@ -722,7 +722,7 @@ again:
 	 * at this point, we know the tree has an item, but it isn't big
 	 * enough yet to put our csum in.  Grow it
 	 */
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	ret = btrfs_search_slot(trans, root, &file_key, path,
 				csum_size, 1);
 	if (ret < 0)
@@ -766,7 +766,7 @@ again:
 	}
 
 insert:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	csum_offset = 0;
 	if (found_next) {
 		u64 tmp = total_bytes + root->sectorsize;
@@ -850,7 +850,7 @@ next_sector:
 	}
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	if (total_bytes < sums->len) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		cond_resched();
 		goto again;
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 80eabe8..566bdf2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -376,7 +376,7 @@ next_slot:
 
 		search_start = max(key.offset, start);
 		if (recow) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			continue;
 		}
 
@@ -393,7 +393,7 @@ next_slot:
 			ret = btrfs_duplicate_item(trans, root, path,
 						   &new_key);
 			if (ret == -EAGAIN) {
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				continue;
 			}
 			if (ret < 0)
@@ -516,7 +516,7 @@ next_slot:
 			del_nr = 0;
 			del_slot = 0;
 
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			continue;
 		}
 
@@ -681,7 +681,7 @@ again:
 		new_key.offset = split;
 		ret = btrfs_duplicate_item(trans, root, path, &new_key);
 		if (ret == -EAGAIN) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto again;
 		}
 		BUG_ON(ret < 0);
@@ -721,7 +721,7 @@ again:
 			     inode->i_ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
 		if (recow) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto again;
 		}
 		extent_end = other_end;
@@ -738,7 +738,7 @@ again:
 			     inode->i_ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
 		if (recow) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto again;
 		}
 		key.offset = other_start;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5ae7a6d..5c1aafe 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -61,7 +61,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	if (ret < 0)
 		return ERR_PTR(ret);
 	if (ret > 0) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		return ERR_PTR(-ENOENT);
 	}
 
@@ -70,7 +70,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 				struct btrfs_free_space_header);
 	btrfs_free_space_key(leaf, header, &disk_key);
 	btrfs_disk_key_to_cpu(&location, &disk_key);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	inode = btrfs_iget(root->fs_info->sb, &location, root, NULL);
 	if (!inode)
@@ -134,7 +134,7 @@ int create_free_space_inode(struct btrfs_root *root,
 	btrfs_set_inode_block_group(leaf, inode_item,
 				    block_group->key.objectid);
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
 	key.offset = block_group->key.objectid;
@@ -143,7 +143,7 @@ int create_free_space_inode(struct btrfs_root *root,
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(struct btrfs_free_space_header));
 	if (ret < 0) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		return ret;
 	}
 	leaf = path->nodes[0];
@@ -152,7 +152,7 @@ int create_free_space_inode(struct btrfs_root *root,
 	memset_extent_buffer(leaf, 0, (unsigned long)header, sizeof(*header));
 	btrfs_set_free_space_key(leaf, header, &disk_key);
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	return 0;
 }
@@ -822,7 +822,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 					 EXTENT_DIRTY | EXTENT_DELALLOC |
 					 EXTENT_DO_ACCOUNTING, 0, 0, NULL,
 					 GFP_NOFS);
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto out_free;
 		}
 	}
@@ -832,7 +832,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	btrfs_set_free_space_bitmaps(leaf, header, bitmaps);
 	btrfs_set_free_space_generation(leaf, header, trans->transid);
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = 1;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a1d4c1..67682a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1163,7 +1163,7 @@ out_check:
 			goto next_slot;
 		}
 
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		if (cow_start != (u64)-1) {
 			ret = cow_file_range(inode, locked_page, cow_start,
 					found_key.offset - 1, page_started,
@@ -1221,7 +1221,7 @@ out_check:
 		if (cur_offset > end)
 			break;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (cur_offset <= end && cow_start == (u64)-1)
 		cow_start = cur_offset;
@@ -2345,7 +2345,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			break;
 
 		/* release the path since we're done with it */
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		/*
 		 * this is where we are basically btrfs_lookup, without the
@@ -2711,7 +2711,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
 	if (ret)
 		goto err;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = btrfs_del_inode_ref(trans, root, name, name_len,
 				  inode->i_ino,
@@ -2734,7 +2734,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
 					 inode, dir->i_ino);
@@ -2861,7 +2861,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	} else {
 		check_link = 0;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = btrfs_lookup_inode(trans, root, path,
 				&BTRFS_I(inode)->location, 0);
@@ -2875,7 +2875,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	} else {
 		check_link = 0;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (ret == 0 && S_ISREG(inode->i_mode)) {
 		ret = btrfs_lookup_file_extent(trans, root, path,
@@ -2887,7 +2887,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		BUG_ON(ret == 0);
 		if (check_path_shared(root, path))
 			goto out;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 	}
 
 	if (!check_link) {
@@ -2908,7 +2908,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		err = 0;
 		goto out;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ref = btrfs_lookup_inode_ref(trans, root, path,
 				dentry->d_name.name, dentry->d_name.len,
@@ -2921,7 +2921,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	if (check_path_shared(root, path))
 		goto out;
 	index = btrfs_inode_ref_index(path->nodes[0], ref);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino, index,
 				dentry->d_name.name, dentry->d_name.len, 0);
@@ -3012,7 +3012,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
 	BUG_ON(ret);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
@@ -3025,7 +3025,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		index = key.offset;
 	}
 
@@ -3038,7 +3038,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
 	BUG_ON(ret);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
@@ -3476,7 +3476,7 @@ delete:
 				BUG_ON(ret);
 				pending_del_nr = 0;
 			}
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto search_again;
 		} else {
 			path->slots[0]--;
@@ -3898,7 +3898,7 @@ static int fixup_tree_root_location(struct btrfs_root *root,
 	if (ret)
 		goto out;
 
-	btrfs_release_path(root->fs_info->tree_root, path);
+	btrfs_release_path(path);
 
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, location);
 	if (IS_ERR(new_root)) {
@@ -5218,7 +5218,7 @@ again:
 				kunmap(page);
 				free_extent_map(em);
 				em = NULL;
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				trans = btrfs_join_transaction(root, 1);
 				if (IS_ERR(trans))
 					return ERR_CAST(trans);
@@ -5244,7 +5244,7 @@ not_found_em:
 	em->block_start = EXTENT_MAP_HOLE;
 	set_bit(EXTENT_FLAG_VACANCY, &em->flags);
 insert:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
 		printk(KERN_ERR "Btrfs: bad extent! em: [%llu %llu] passed "
 		       "[%llu %llu]\n", (unsigned long long)em->start,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ffb48d6c..d11fc65 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1396,7 +1396,7 @@ static noinline int search_ioctl(struct inode *inode,
 		}
 		ret = copy_to_sk(root, path, &key, sk, args->buf,
 				 &sk_offset, &num_found);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		if (ret || num_found >= sk->nr_items)
 			break;
 
@@ -1503,7 +1503,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		if (key.offset == BTRFS_FIRST_FREE_OBJECTID)
 			break;
 
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		key.objectid = key.offset;
 		key.offset = (u64)-1;
 		dirid = key.objectid;
@@ -1982,7 +1982,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				datal = btrfs_file_extent_ram_bytes(leaf,
 								    extent);
 			}
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 
 			if (key.offset + datal <= off ||
 			    key.offset >= off+len)
@@ -2092,7 +2092,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			}
 
 			btrfs_mark_buffer_dirty(leaf);
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 
 			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
@@ -2113,12 +2113,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			btrfs_end_transaction(trans, root);
 		}
 next:
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		key.offset++;
 	}
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2097a88..f7b799b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -961,7 +961,7 @@ again:
 			lower = upper;
 			upper = NULL;
 		}
-		btrfs_release_path(root, path2);
+		btrfs_release_path(path2);
 next:
 		if (ptr < end) {
 			ptr += btrfs_extent_inline_ref_size(key.type);
@@ -974,7 +974,7 @@ next:
 		if (ptr >= end)
 			path1->slots[0]++;
 	}
-	btrfs_release_path(rc->extent_root, path1);
+	btrfs_release_path(path1);
 
 	cur->checked = 1;
 	WARN_ON(exist);
@@ -1749,7 +1749,7 @@ again:
 
 		btrfs_node_key_to_cpu(path->nodes[level], &key,
 				      path->slots[level]);
-		btrfs_release_path(src, path);
+		btrfs_release_path(path);
 
 		path->lowest_level = level;
 		ret = btrfs_search_slot(trans, src, &key, path, 0, 1);
@@ -2496,7 +2496,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			path->locks[upper->level] = 0;
 
 			slot = path->slots[upper->level];
-			btrfs_release_path(NULL, path);
+			btrfs_release_path(path);
 		} else {
 			ret = btrfs_bin_search(upper->eb, key, upper->level,
 					       &slot);
@@ -2737,7 +2737,7 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 		} else {
 			path->lowest_level = node->level;
 			ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			if (ret > 0)
 				ret = 0;
 		}
@@ -3119,7 +3119,7 @@ static int add_tree_block(struct reloc_control *rc,
 #endif
 	}
 
-	btrfs_release_path(rc->extent_root, path);
+	btrfs_release_path(path);
 
 	BUG_ON(level == -1);
 
@@ -3505,7 +3505,7 @@ int add_data_references(struct reloc_control *rc,
 		}
 		path->slots[0]++;
 	}
-	btrfs_release_path(rc->extent_root, path);
+	btrfs_release_path(path);
 	if (err)
 		free_block_list(blocks);
 	return err;
@@ -3568,7 +3568,7 @@ next:
 					    EXTENT_DIRTY);
 
 		if (ret == 0 && start <= key.objectid) {
-			btrfs_release_path(rc->extent_root, path);
+			btrfs_release_path(path);
 			rc->search_start = end + 1;
 		} else {
 			rc->search_start = key.objectid + key.offset;
@@ -3576,7 +3576,7 @@ next:
 			return 0;
 		}
 	}
-	btrfs_release_path(rc->extent_root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -3713,7 +3713,7 @@ restart:
 				flags = BTRFS_EXTENT_FLAG_DATA;
 
 			if (path_change) {
-				btrfs_release_path(rc->extent_root, path);
+				btrfs_release_path(path);
 
 				path->search_commit_root = 1;
 				path->skip_locking = 1;
@@ -3736,7 +3736,7 @@ restart:
 			   (flags & BTRFS_EXTENT_FLAG_DATA)) {
 			ret = add_data_references(rc, &key, path, &blocks);
 		} else {
-			btrfs_release_path(rc->extent_root, path);
+			btrfs_release_path(path);
 			ret = 0;
 		}
 		if (ret < 0) {
@@ -3799,7 +3799,7 @@ restart:
 		}
 	}
 
-	btrfs_release_path(rc->extent_root, path);
+	btrfs_release_path(path);
 	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
 			  GFP_NOFS);
 
@@ -3867,7 +3867,7 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS |
 					  BTRFS_INODE_PREALLOC);
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -4109,7 +4109,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		}
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		btrfs_release_path(root->fs_info->tree_root, path);
+		btrfs_release_path(path);
 
 		if (key.objectid != BTRFS_TREE_RELOC_OBJECTID ||
 		    key.type != BTRFS_ROOT_ITEM_KEY)
@@ -4141,7 +4141,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 
 		key.offset--;
 	}
-	btrfs_release_path(root->fs_info->tree_root, path);
+	btrfs_release_path(path);
 
 	if (list_empty(&reloc_roots))
 		goto out;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 6928bff..59a94c1 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -57,7 +57,7 @@ again:
 	btrfs_item_key_to_cpu(path->nodes[0], &search_key, path->slots[0]);
 	if (search_key.type != BTRFS_ROOT_ITEM_KEY) {
 		search_key.offset++;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		goto again;
 	}
 	ret = 0;
@@ -230,7 +230,7 @@ again:
 
 		memcpy(&found_key, &key, sizeof(key));
 		key.offset++;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		dead_root =
 			btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
 						    &found_key);
@@ -292,7 +292,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 		}
 
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		btrfs_release_path(tree_root, path);
+		btrfs_release_path(path);
 
 		if (key.objectid != BTRFS_ORPHAN_OBJECTID ||
 		    key.type != BTRFS_ORPHAN_ITEM_KEY)
@@ -390,7 +390,7 @@ again:
 		err = -ENOENT;
 
 	if (key.type == BTRFS_ROOT_BACKREF_KEY) {
-		btrfs_release_path(tree_root, path);
+		btrfs_release_path(path);
 		key.objectid = ref_id;
 		key.type = BTRFS_ROOT_REF_KEY;
 		key.offset = root_id;
@@ -463,7 +463,7 @@ again:
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (key.type == BTRFS_ROOT_BACKREF_KEY) {
-		btrfs_release_path(tree_root, path);
+		btrfs_release_path(path);
 		key.objectid = ref_id;
 		key.type = BTRFS_ROOT_REF_KEY;
 		key.offset = root_id;
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 992ab42..3b580ee 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -97,7 +97,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		ret = 0;
 		goto out;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	wret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 
 	if (wret < 0) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6377ff6..014d7fc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -333,13 +333,13 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			goto insert;
 
 		if (item_size == 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			return 0;
 		}
 		dst_copy = kmalloc(item_size, GFP_NOFS);
 		src_copy = kmalloc(item_size, GFP_NOFS);
 		if (!dst_copy || !src_copy) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			kfree(dst_copy);
 			kfree(src_copy);
 			return -ENOMEM;
@@ -361,13 +361,13 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 		 * sync
 		 */
 		if (ret == 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			return 0;
 		}
 
 	}
 insert:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	/* try to insert the key into the destination tree */
 	ret = btrfs_insert_empty_item(trans, root, path,
 				      key, item_size);
@@ -438,7 +438,7 @@ insert:
 	}
 no_copy:
 	btrfs_mark_buffer_dirty(path->nodes[0]);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return 0;
 }
 
@@ -544,11 +544,11 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		 * we don't have to do anything
 		 */
 		if (memcmp(&cmp1, &cmp2, sizeof(cmp1)) == 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto out;
 		}
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
@@ -600,7 +600,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						key->objectid, offset, &ins);
 				BUG_ON(ret);
 			}
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 
 			if (btrfs_file_extent_compression(eb, item)) {
 				csum_start = ins.objectid;
@@ -629,7 +629,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				kfree(sums);
 			}
 		} else {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 		}
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		/* inline extents are easy, we just overwrite them */
@@ -675,7 +675,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	inode = read_one_inode(root, location.objectid);
 	BUG_ON(!inode);
@@ -713,7 +713,7 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 			goto out;
 	} else
 		goto out;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	di = btrfs_lookup_dir_item(NULL, root, path, dirid, name, name_len, 0);
 	if (di && !IS_ERR(di)) {
@@ -724,7 +724,7 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 		goto out;
 	match = 1;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return match;
 }
 
@@ -884,7 +884,7 @@ again:
 			if (!backref_in_log(log, key, victim_name,
 					    victim_name_len)) {
 				btrfs_inc_nlink(inode);
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
@@ -901,7 +901,7 @@ again:
 		 */
 		search_done = 1;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 insert:
 	/* insert our name */
@@ -922,7 +922,7 @@ out:
 	BUG_ON(ret);
 
 out_nowrite:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	iput(dir);
 	iput(inode);
 	return 0;
@@ -999,9 +999,9 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 		if (key.offset == 0)
 			break;
 		key.offset--;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	if (nlink != inode->i_nlink) {
 		inode->i_nlink = nlink;
 		btrfs_update_inode(trans, root, inode);
@@ -1052,7 +1052,7 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_item(trans, root, path);
 		BUG_ON(ret);
 
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		inode = read_one_inode(root, key.offset);
 		BUG_ON(!inode);
 
@@ -1068,7 +1068,7 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 		 */
 		key.offset = (u64)-1;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return 0;
 }
 
@@ -1096,7 +1096,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	if (ret == 0) {
 		btrfs_inc_nlink(inode);
 		btrfs_update_inode(trans, root, inode);
@@ -1192,7 +1192,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		exists = 1;
 	else
 		exists = 0;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (key->type == BTRFS_DIR_ITEM_KEY) {
 		dst_di = btrfs_lookup_dir_item(trans, root, path, key->objectid,
@@ -1236,13 +1236,13 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	if (key->type == BTRFS_DIR_INDEX_KEY)
 		goto insert;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	kfree(name);
 	iput(dir);
 	return 0;
 
 insert:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	ret = insert_one_name(trans, root, path, key->objectid, key->offset,
 			      name, name_len, log_type, &log_key);
 
@@ -1363,7 +1363,7 @@ next:
 	*end_ret = found_end;
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1428,8 +1428,8 @@ again:
 		}
 		if (IS_ERR_OR_NULL(log_di)) {
 			btrfs_dir_item_key_to_cpu(eb, di, &location);
-			btrfs_release_path(root, path);
-			btrfs_release_path(log, log_path);
+			btrfs_release_path(path);
+			btrfs_release_path(log_path);
 			inode = read_one_inode(root, location.objectid);
 			BUG_ON(!inode);
 
@@ -1453,7 +1453,7 @@ again:
 			ret = 0;
 			goto out;
 		}
-		btrfs_release_path(log, log_path);
+		btrfs_release_path(log_path);
 		kfree(name);
 
 		ptr = (unsigned long)(di + 1);
@@ -1461,8 +1461,8 @@ again:
 	}
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
-	btrfs_release_path(log, log_path);
+	btrfs_release_path(path);
+	btrfs_release_path(log_path);
 	return ret;
 }
 
@@ -1550,7 +1550,7 @@ again:
 				break;
 			dir_key.offset = found_key.offset + 1;
 		}
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		if (range_end == (u64)-1)
 			break;
 		range_start = range_end + 1;
@@ -1561,11 +1561,11 @@ next_type:
 	if (key_type == BTRFS_DIR_LOG_ITEM_KEY) {
 		key_type = BTRFS_DIR_LOG_INDEX_KEY;
 		dir_key.type = BTRFS_DIR_INDEX_KEY;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		goto again;
 	}
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(log_path);
 	iput(dir);
 	return ret;
@@ -2223,7 +2223,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		bytes_del += name_len;
 		BUG_ON(ret);
 	}
-	btrfs_release_path(log, path);
+	btrfs_release_path(path);
 	di = btrfs_lookup_dir_index_item(trans, log, path, dir->i_ino,
 					 index, name, name_len, -1);
 	if (IS_ERR(di)) {
@@ -2245,7 +2245,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		key.objectid = dir->i_ino;
 		key.offset = 0;
 		key.type = BTRFS_INODE_ITEM_KEY;
-		btrfs_release_path(log, path);
+		btrfs_release_path(path);
 
 		ret = btrfs_search_slot(trans, log, &key, path, 0, 1);
 		if (ret < 0) {
@@ -2267,7 +2267,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(path->nodes[0]);
 		} else
 			ret = 0;
-		btrfs_release_path(log, path);
+		btrfs_release_path(path);
 	}
 fail:
 	btrfs_free_path(path);
@@ -2341,7 +2341,7 @@ static noinline int insert_dir_log_key(struct btrfs_trans_handle *trans,
 			      struct btrfs_dir_log_item);
 	btrfs_set_dir_log_end(path->nodes[0], item, last_offset);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
-	btrfs_release_path(log, path);
+	btrfs_release_path(path);
 	return 0;
 }
 
@@ -2390,10 +2390,10 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 		min_key.objectid = inode->i_ino;
 		min_key.type = key_type;
 		min_key.offset = (u64)-1;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
 		if (ret < 0) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			return ret;
 		}
 		ret = btrfs_previous_item(root, path, inode->i_ino, key_type);
@@ -2429,7 +2429,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 			}
 		}
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	/* find the first key from this transaction again */
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
@@ -2487,8 +2487,8 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 		}
 	}
 done:
-	btrfs_release_path(root, path);
-	btrfs_release_path(log, dst_path);
+	btrfs_release_path(path);
+	btrfs_release_path(dst_path);
 
 	if (err == 0) {
 		*last_offset_ret = last_offset;
@@ -2585,9 +2585,9 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_del_item(trans, log, path);
 		BUG_ON(ret);
-		btrfs_release_path(log, path);
+		btrfs_release_path(path);
 	}
-	btrfs_release_path(log, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -2693,7 +2693,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_mark_buffer_dirty(dst_path->nodes[0]);
-	btrfs_release_path(log, dst_path);
+	btrfs_release_path(dst_path);
 	kfree(ins_data);
 
 	/*
@@ -2842,7 +2842,7 @@ next_slot:
 			}
 			ins_nr = 0;
 		}
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		if (min_key.offset < (u64)-1)
 			min_key.offset++;
@@ -2865,8 +2865,8 @@ next_slot:
 	}
 	WARN_ON(ins_nr);
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		btrfs_release_path(root, path);
-		btrfs_release_path(log, dst_path);
+		btrfs_release_path(path);
+		btrfs_release_path(dst_path);
 		ret = log_directory_changes(trans, root, inode, path, dst_path);
 		if (ret) {
 			err = ret;
@@ -3133,7 +3133,7 @@ again:
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
-		btrfs_release_path(log_root_tree, path);
+		btrfs_release_path(path);
 		if (found_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 			break;
 
@@ -3168,7 +3168,7 @@ again:
 		if (found_key.offset == 0)
 			break;
 	}
-	btrfs_release_path(log_root_tree, path);
+	btrfs_release_path(path);
 
 	/* step one is to pin it all, step two is to replay just inodes */
 	if (wc.pin) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d48bbe6..cbf2407 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1465,7 +1465,7 @@ next_slot:
 				goto error;
 			leaf = path->nodes[0];
 			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			continue;
 		}
 
@@ -1937,7 +1937,7 @@ again:
 		chunk = btrfs_item_ptr(leaf, path->slots[0],
 				       struct btrfs_chunk);
 		chunk_type = btrfs_chunk_type(leaf, chunk);
-		btrfs_release_path(chunk_root, path);
+		btrfs_release_path(path);
 
 		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
 			ret = btrfs_relocate_chunk(chunk_root, chunk_tree,
@@ -2055,7 +2055,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		if (found_key.offset == 0)
 			break;
 
-		btrfs_release_path(chunk_root, path);
+		btrfs_release_path(path);
 		ret = btrfs_relocate_chunk(chunk_root,
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
@@ -2127,7 +2127,7 @@ again:
 			goto done;
 		if (ret) {
 			ret = 0;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			break;
 		}
 
@@ -2136,7 +2136,7 @@ again:
 		btrfs_item_key_to_cpu(l, &key, path->slots[0]);
 
 		if (key.objectid != device->devid) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			break;
 		}
 
@@ -2144,14 +2144,14 @@ again:
 		length = btrfs_dev_extent_length(l, dev_extent);
 
 		if (key.offset + length <= new_size) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			break;
 		}
 
 		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
 		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		ret = btrfs_relocate_chunk(root, chunk_tree, chunk_objectid,
 					   chunk_offset);
@@ -3803,7 +3803,7 @@ again:
 	}
 	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
 		key.objectid = 0;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		goto again;
 	}
 	ret = 0;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cfd6605..4ca88d1 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -120,13 +120,13 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_delete_one_dir_name(trans, root, path, di);
 		BUG_ON(ret);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		/* if we don't have a value then we are removing the xattr */
 		if (!value)
 			goto out;
 	} else {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 
 		if (flags & XATTR_REPLACE) {
 			/* we couldn't find the attr to replace */
-- 
1.7.5.rc3
