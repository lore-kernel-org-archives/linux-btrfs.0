From: jeffm@suse.com
Subject: [patch v3 19/23] btrfs: extent-tree.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:59 -0400
Message-ID: <20110909002733.405638846@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_prepare_extent_commit, btrfs_set_block_group_rw, and
 setup_inline_extent_backref have no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    8 ++++----
 fs/btrfs/extent-tree.c |   20 +++++++++-----------
 2 files changed, 13 insertions(+), 15 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2201,8 +2201,8 @@ int btrfs_free_extent(struct btrfs_trans
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 				u64 num_bytes, int reserve, int sinfo);
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root);
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
@@ -2264,8 +2264,8 @@ int btrfs_truncate_reserve_metadata(stru
 				    struct btrfs_block_rsv *rsv);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
-int btrfs_set_block_group_rw(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *cache);
+void btrfs_set_block_group_rw(struct btrfs_root *root,
+			      struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1539,7 +1539,7 @@ out:
  * helper to add new inline back ref
  */
 static noinline_for_stack
-int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
+void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_path *path,
 				struct btrfs_extent_inline_ref *iref,
@@ -1599,7 +1599,6 @@ int setup_inline_extent_backref(struct b
 		btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
 	}
 	btrfs_mark_buffer_dirty(leaf);
-	return 0;
 }
 
 static int lookup_extent_backref(struct btrfs_trans_handle *trans,
@@ -1718,10 +1717,11 @@ int insert_inline_extent_backref(struct
 		ret = update_inline_extent_backref(trans, root, path, iref,
 						   refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
-		ret = setup_inline_extent_backref(trans, root, path, iref,
-						  parent, root_objectid,
-						  owner, offset, refs_to_add,
-						  extent_op);
+		ret = 0;
+		setup_inline_extent_backref(trans, root, path, iref,
+					    parent, root_objectid,
+					    owner, offset, refs_to_add,
+					    extent_op);
 	}
 	return ret;
 }
@@ -4263,8 +4263,8 @@ int btrfs_update_reserved_bytes(struct b
 	return ret;
 }
 
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root)
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_caching_control *next;
@@ -4293,7 +4293,6 @@ int btrfs_prepare_extent_commit(struct b
 	up_write(&fs_info->extent_commit_sem);
 
 	update_global_block_rsv(fs_info);
-	return 0;
 }
 
 static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
@@ -6719,7 +6718,7 @@ u64 btrfs_account_ro_block_groups_free_s
 	return free_bytes;
 }
 
-int btrfs_set_block_group_rw(struct btrfs_root *root,
+void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
@@ -6735,7 +6734,6 @@ int btrfs_set_block_group_rw(struct btrf
 	cache->ro = 0;
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
-	return 0;
 }
 
 /*


