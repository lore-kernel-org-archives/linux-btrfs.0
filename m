From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 59/66] btrfs: __btrfs_mod_refs process_func should return void
Date: Mon, 24 Oct 2011 21:03:35 -0400
Message-ID: <20111025010857.334739678@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 __btrfs_mod_ref's process_func function pointer calls btrfs_free_extent
 and btrfs_inc_extent_ref, which now both return only 0. This patches
 makes them return void and eliminates the error condition in
 __btrfs_mod_ref.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |   16 ++++++++--------
 fs/btrfs/extent-tree.c |   39 ++++++++++++++-------------------------
 2 files changed, 22 insertions(+), 33 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2201,20 +2201,20 @@ int btrfs_set_disk_extent_flags(struct b
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int is_data);
-int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 owner, u64 offset);
+void btrfs_free_extent(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       u64 bytenr, u64 num_bytes, u64 parent,
+		       u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root);
-int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset);
+void btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, u64 parent,
+			  u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1832,10 +1832,10 @@ static int btrfs_discard_extent(struct b
 	return ret;
 }
 
-int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset)
+void btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, u64 parent,
+			  u64 root_objectid, u64 owner, u64 offset)
 {
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
@@ -1849,7 +1849,6 @@ int btrfs_inc_extent_ref(struct btrfs_tr
 					   root_objectid, owner, offset,
 					   BTRFS_ADD_DELAYED_REF, NULL);
 	}
-	return 0;
 }
 
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
@@ -2566,9 +2565,8 @@ static int __btrfs_mod_ref(struct btrfs_
 	struct btrfs_file_extent_item *fi;
 	int i;
 	int level;
-	int ret = 0;
-	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
+	void (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
+			     u64, u64, u64, u64, u64, u64);
 
 	ref_root = btrfs_header_owner(buf);
 	nritems = btrfs_header_nritems(buf);
@@ -2603,24 +2601,16 @@ static int __btrfs_mod_ref(struct btrfs_
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, key.objectid,
-					   key.offset);
-			if (ret)
-				goto fail;
+			process_func(trans, root, bytenr, num_bytes, parent,
+				     ref_root, key.objectid, key.offset);
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = btrfs_level_size(root, level - 1);
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, level - 1, 0);
-			if (ret)
-				goto fail;
+			process_func(trans, root, bytenr, num_bytes, parent,
+				     ref_root, level - 1, 0);
 		}
 	}
 	return 0;
-fail:
-	BUG();
-	return ret;
 }
 
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -4800,10 +4790,10 @@ out:
 	btrfs_put_block_group(cache);
 }
 
-int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent,
-		      u64 root_objectid, u64 owner, u64 offset)
+void btrfs_free_extent(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       u64 bytenr, u64 num_bytes, u64 parent,
+		       u64 root_objectid, u64 owner, u64 offset)
 {
 	/*
 	 * tree log blocks never actually go into the extent allocation
@@ -4826,7 +4816,6 @@ int btrfs_free_extent(struct btrfs_trans
 		btrfs_add_delayed_data_ref(trans, bytenr, num_bytes, parent,
 					   root_objectid, owner, offset,
 					   BTRFS_DROP_DELAYED_REF, NULL);
-	return 0;
 }
 
 static u64 stripe_align(struct btrfs_root *root, u64 val)


