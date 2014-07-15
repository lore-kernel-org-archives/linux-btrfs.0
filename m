Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaGOVH4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 17:07:56 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/4] Btrfs: __btrfs_mod_ref should always use no_quota
Date: Tue, 15 Jul 2014 14:06:23 -0700
Message-Id: <1405458384-17516-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1405458384-17516-1-git-send-email-mfasheh@suse.de>
References: <1405458384-17516-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Before I extended the no_quota arg to btrfs_dec/inc_ref because I didn't
understand how snapshot delete was using it and assumed that we needed the
quota operations there.  With Mark's work this has turned out to be not the
case, we _always_ need to use no_quota for btrfs_dec/inc_ref, so just drop the
argument and make __btrfs_mod_ref call it's process function with no_quota set
always.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c       | 20 ++++++++++----------
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/extent-tree.c | 24 +++++++++++-------------
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index aeab453..44ee5d2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -280,9 +280,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
-		ret = btrfs_inc_ref(trans, root, cow, 1, 1);
+		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else
-		ret = btrfs_inc_ref(trans, root, cow, 0, 1);
+		ret = btrfs_inc_ref(trans, root, cow, 0);
 
 	if (ret)
 		return ret;
@@ -1035,14 +1035,14 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if ((owner == root->root_key.objectid ||
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
-			ret = btrfs_inc_ref(trans, root, buf, 1, 1);
+			ret = btrfs_inc_ref(trans, root, buf, 1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
-				ret = btrfs_dec_ref(trans, root, buf, 0, 1);
+				ret = btrfs_dec_ref(trans, root, buf, 0);
 				BUG_ON(ret); /* -ENOMEM */
-				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1);
 				BUG_ON(ret); /* -ENOMEM */
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
@@ -1050,9 +1050,9 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 0);
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		if (new_flags != 0) {
@@ -1069,11 +1069,11 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 0);
 			BUG_ON(ret); /* -ENOMEM */
-			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
+			ret = btrfs_dec_ref(trans, root, buf, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		clean_tree_block(trans, root, buf);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be91397..8e29b61 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3326,9 +3326,9 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 num_bytes,
 			 u64 min_alloc_size, u64 empty_size, u64 hint_byte,
 			 struct btrfs_key *ins, int is_data, int delalloc);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref, int no_quota);
+		  struct extent_buffer *buf, int full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref, int no_quota);
+		  struct extent_buffer *buf, int full_backref);
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1aa4325..ed9e13c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3057,7 +3057,7 @@ out:
 static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   int full_backref, int inc, int no_quota)
+			   int full_backref, int inc)
 {
 	u64 bytenr;
 	u64 num_bytes;
@@ -3111,7 +3111,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
-					   key.offset, no_quota);
+					   key.offset, 1);
 			if (ret)
 				goto fail;
 		} else {
@@ -3119,7 +3119,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			num_bytes = btrfs_level_size(root, level - 1);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0,
-					   no_quota);
+					   1);
 			if (ret)
 				goto fail;
 		}
@@ -3130,15 +3130,15 @@ fail:
 }
 
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref, int no_quota)
+		  struct extent_buffer *buf, int full_backref)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 1, no_quota);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 1);
 }
 
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref, int no_quota)
+		  struct extent_buffer *buf, int full_backref)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 0, no_quota);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 0);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -7746,9 +7746,9 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	/* wc->stage == UPDATE_BACKREF */
 	if (!(wc->flags[level] & flag)) {
 		BUG_ON(!path->locks[level]);
-		ret = btrfs_inc_ref(trans, root, eb, 1, wc->for_reloc);
+		ret = btrfs_inc_ref(trans, root, eb, 1);
 		BUG_ON(ret); /* -ENOMEM */
-		ret = btrfs_dec_ref(trans, root, eb, 0, wc->for_reloc);
+		ret = btrfs_dec_ref(trans, root, eb, 0);
 		BUG_ON(ret); /* -ENOMEM */
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
 						  eb->len, flag,
@@ -7995,11 +7995,9 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 	if (wc->refs[level] == 1) {
 		if (level == 0) {
 			if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
-				ret = btrfs_dec_ref(trans, root, eb, 1,
-						    wc->for_reloc);
+				ret = btrfs_dec_ref(trans, root, eb, 1);
 			else
-				ret = btrfs_dec_ref(trans, root, eb, 0,
-						    wc->for_reloc);
+				ret = btrfs_dec_ref(trans, root, eb, 0);
 			BUG_ON(ret); /* -ENOMEM */
 			ret = account_leaf_items(trans, root, eb);
 			if (ret) {
-- 
1.8.4.5

