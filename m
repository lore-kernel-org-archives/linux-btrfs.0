From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 60/66] btrfs: __btrfs_mod_ref should return void
Date: Mon, 24 Oct 2011 21:03:36 -0400
Message-ID: <20111025010857.449132573@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2604ec4..bdaf3ad 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -224,7 +224,6 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid)
 {
 	struct extent_buffer *cow;
-	int ret = 0;
 	int level;
 	struct btrfs_disk_key disk_key;
 
@@ -261,12 +260,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
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
@@ -350,25 +346,21 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
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
@@ -381,12 +373,10 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b791b8f..51f2840 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2193,10 +2193,10 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c2dcfd8..fac996d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2551,10 +2551,10 @@ out:
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
@@ -2573,7 +2573,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(buf);
 
 	if (!root->ref_cows && level == 0)
-		return 0;
+		return;
 
 	if (inc)
 		process_func = btrfs_inc_extent_ref;
@@ -2610,19 +2610,18 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
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
@@ -5985,10 +5984,8 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
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
@@ -6204,10 +6201,9 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
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



