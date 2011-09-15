From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 02/20] btrfs: Don't BUG_ON() errors in update_ref_for_cow()
Date: Thu, 15 Sep 2011 10:34:41 -0700
Message-ID: <1316108099-5099-3-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

The only caller of update_ref_for_cow() is __btrfs_cow_block() which was
originally ignoring any return values. update_ref_for_cow() however doesn't
look like a candidate to become a void function - there are a few places
where errors can occur.

So instead I changed update_ref_for_cow() to bubble all errors up (instead
of BUG_ON). __btrfs_cow_block() was then updated to catch and BUG_ON() any
errors from update_ref_for_cow(). The end effect is that we have no change
in behavior, but about 8 different places where a BUG_ON(ret) was removed.

Obviously a future patch will have to address the BUG_ON() in
__btrfs_cow_block().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..5064930 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -331,7 +331,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	if (btrfs_block_can_be_shared(root, buf)) {
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
 					       buf->len, &refs, &flags);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		BUG_ON(refs == 0);
 	} else {
 		refs = 1;
@@ -351,14 +352,18 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
 			ret = btrfs_inc_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
 				ret = btrfs_dec_ref(trans, root, buf, 0);
-				BUG_ON(ret);
+				if (ret)
+					return ret;
+
 				ret = btrfs_inc_ref(trans, root, cow, 1);
-				BUG_ON(ret);
+				if (ret)
+					return ret;
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 		} else {
@@ -368,14 +373,16 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
 				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 		}
 		if (new_flags != 0) {
 			ret = btrfs_set_disk_extent_flags(trans, root,
 							  buf->start,
 							  buf->len,
 							  new_flags, 0);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 		}
 	} else {
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
@@ -384,9 +391,12 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_ref(trans, root, cow, 1);
 			else
 				ret = btrfs_inc_ref(trans, root, cow, 0);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
+
 			ret = btrfs_dec_ref(trans, root, buf, 1);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 		}
 		clean_tree_block(trans, root, buf);
 		*last_ref = 1;
@@ -415,7 +425,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *cow;
-	int level;
+	int level, ret;
 	int last_ref = 0;
 	int unlock_orig = 0;
 	u64 parent_start;
@@ -467,7 +477,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	update_ref_for_cow(trans, root, buf, cow, &last_ref);
+	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
+	BUG_ON(ret);
 
 	if (root->ref_cows)
 		btrfs_reloc_cow_block(trans, root, buf, cow);
-- 
1.7.6

