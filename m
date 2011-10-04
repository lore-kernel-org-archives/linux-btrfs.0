From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 59/65] btrfs: __btrfs_mod_ref should return void
Date: Mon, 03 Oct 2011 23:23:29 -0400
Message-ID: <20111004032306.677614908@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that process_func can't return an error, __btrfs_mod_ref has no more
 error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c       |   30 ++++++++++--------------------
 fs/btrfs/ctree.h       |    8 ++++----
 fs/btrfs/extent-tree.c |   34 +++++++++++++++-------------------
 3 files changed, 29 insertions(+), 43 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -222,7 +222,6 @@ int btrfs_copy_root(struct btrfs_trans_h
 		      struct extent_buffer **cow_ret, u64 new_root_objectid)
 {
 	struct extent_buffer *cow;
-	int ret = 0;
 	int level;
 	struct btrfs_disk_key disk_key;
 
@@ -259,12 +258,9 @@ int btrfs_copy_root(struct btrfs_trans_h
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
-		ret = btrfs_inc_ref(trans, root, cow, 1);
+		btrfs_inc_ref(trans, root, cow, 1);
 	else
-		ret = btrfs_inc_ref(trans, root, cow, 0);
-
-	if (ret)
-		return ret;
+		btrfs_inc_ref(trans, root, cow, 0);
 
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;
@@ -348,25 +344,21 @@ static noinline int update_ref_for_cow(s
 		if ((owner == root->root_key.objectid ||
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
-			ret = btrfs_inc_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+			btrfs_inc_ref(trans, root, buf, 1);
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
-				ret = btrfs_dec_ref(trans, root, buf, 0);
-				BUG_ON(ret);
-				ret = btrfs_inc_ref(trans, root, cow, 1);
-				BUG_ON(ret);
+				btrfs_dec_ref(trans, root, buf, 0);
+				btrfs_inc_ref(trans, root, cow, 1);
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 		} else {
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				btrfs_inc_ref(trans, root, cow, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
+				btrfs_inc_ref(trans, root, cow, 0);
 		}
 		if (new_flags != 0) {
 			ret = btrfs_set_disk_extent_flags(trans, root,
@@ -379,12 +371,10 @@ static noinline int update_ref_for_cow(s
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				btrfs_inc_ref(trans, root, cow, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
-			ret = btrfs_dec_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+				btrfs_inc_ref(trans, root, cow, 0);
+			btrfs_dec_ref(trans, root, buf, 1);
 		}
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2183,10 +2183,10 @@ int btrfs_reserve_extent(struct btrfs_tr
 				  u64 empty_size, u64 hint_byte,
 				  u64 search_end, struct btrfs_key *ins,
 				  u64 data);
-int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
-int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
+void btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   struct extent_buffer *buf, int full_backref);
+void btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   struct extent_buffer *buf, int full_backref);
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2535,10 +2535,10 @@ out:
 	return ret;
 }
 
-static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   struct extent_buffer *buf,
-			   int full_backref, int inc)
+static void __btrfs_mod_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct extent_buffer *buf,
+			    int full_backref, int inc)
 {
 	u64 bytenr;
 	u64 num_bytes;
@@ -2557,7 +2557,7 @@ static int __btrfs_mod_ref(struct btrfs_
 	level = btrfs_header_level(buf);
 
 	if (!root->ref_cows && level == 0)
-		return 0;
+		return;
 
 	if (inc)
 		process_func = btrfs_inc_extent_ref;
@@ -2594,19 +2594,18 @@ static int __btrfs_mod_ref(struct btrfs_
 				     ref_root, level - 1, 0);
 		}
 	}
-	return 0;
 }
 
-int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+void btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   struct extent_buffer *buf, int full_backref)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 1);
+	__btrfs_mod_ref(trans, root, buf, full_backref, 1);
 }
 
-int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+void btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		   struct extent_buffer *buf, int full_backref)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 0);
+	__btrfs_mod_ref(trans, root, buf, full_backref, 0);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -5946,10 +5945,8 @@ static noinline int walk_down_proc(struc
 	/* wc->stage == UPDATE_BACKREF */
 	if (!(wc->flags[level] & flag)) {
 		BUG_ON(!path->locks[level]);
-		ret = btrfs_inc_ref(trans, root, eb, 1);
-		BUG_ON(ret);
-		ret = btrfs_dec_ref(trans, root, eb, 0);
-		BUG_ON(ret);
+		btrfs_inc_ref(trans, root, eb, 1);
+		btrfs_dec_ref(trans, root, eb, 0);
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
 						  eb->len, flag, 0);
 		BUG_ON(ret);
@@ -6165,10 +6162,9 @@ static noinline int walk_up_proc(struct
 	if (wc->refs[level] == 1) {
 		if (level == 0) {
 			if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
-				ret = btrfs_dec_ref(trans, root, eb, 1);
+				btrfs_dec_ref(trans, root, eb, 1);
 			else
-				ret = btrfs_dec_ref(trans, root, eb, 0);
-			BUG_ON(ret);
+				btrfs_dec_ref(trans, root, eb, 0);
 		}
 		/* make block locked assertion in clean_tree_block happy */
 		if (!path->locks[level] &&



