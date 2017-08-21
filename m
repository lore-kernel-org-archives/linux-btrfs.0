Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49202 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753499AbdHUMjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:39:10 -0400
Subject: [PATCH 2/5] btrfs: Use common error handling code in
 __btrfs_free_extent()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Message-ID: <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:38:58 +0200
MIME-Version: 1.0
In-Reply-To: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 21 Aug 2017 10:03:00 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/extent-tree.c | 69 ++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 116c5615d6c2..c6b7aca88491 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6913,10 +6913,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, info, path, NULL,
 						    refs_to_drop,
 						    is_data, &last_ref);
-			if (ret) {
-				btrfs_abort_transaction(trans, ret);
-				goto out;
-			}
+			if (ret)
+				goto abort_transaction;
+
 			btrfs_release_path(path);
 			path->leave_spinning = 1;
 
@@ -6962,10 +6961,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				if (ret > 0)
 					btrfs_print_leaf(path->nodes[0]);
 			}
-			if (ret < 0) {
-				btrfs_abort_transaction(trans, ret);
-				goto out;
-			}
+			if (ret < 0)
+				goto abort_transaction;
+
 			extent_slot = path->slots[0];
 		}
 	} else if (WARN_ON(ret == -ENOENT)) {
@@ -6974,11 +6972,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
 			bytenr, parent, root_objectid, owner_objectid,
 			owner_offset);
-		btrfs_abort_transaction(trans, ret);
-		goto out;
+		goto abort_transaction;
 	} else {
-		btrfs_abort_transaction(trans, ret);
-		goto out;
+		goto abort_transaction;
 	}
 
 	leaf = path->nodes[0];
@@ -6988,10 +6984,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(found_extent || extent_slot != path->slots[0]);
 		ret = convert_extent_item_v0(trans, info, path, owner_objectid,
 					     0);
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 
 		btrfs_release_path(path);
 		path->leave_spinning = 1;
@@ -7008,10 +7002,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				ret, bytenr);
 			btrfs_print_leaf(path->nodes[0]);
 		}
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 
 		extent_slot = path->slots[0];
 		leaf = path->nodes[0];
@@ -7035,8 +7027,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			  "trying to drop %d refs but we only have %Lu for bytenr %Lu",
 			  refs_to_drop, refs, bytenr);
 		ret = -EINVAL;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
+		goto abort_transaction;
 	}
 	refs -= refs_to_drop;
 
@@ -7057,10 +7048,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, info, path,
 						    iref, refs_to_drop,
 						    is_data, &last_ref);
-			if (ret) {
-				btrfs_abort_transaction(trans, ret);
-				goto out;
-			}
+			if (ret)
+				goto abort_transaction;
 		}
 	} else {
 		if (found_extent) {
@@ -7078,37 +7067,33 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		last_ref = 1;
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
+
 		btrfs_release_path(path);
 
 		if (is_data) {
 			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
-			if (ret) {
-				btrfs_abort_transaction(trans, ret);
-				goto out;
-			}
+			if (ret)
+				goto abort_transaction;
 		}
 
 		ret = add_to_free_space_tree(trans, info, bytenr, num_bytes);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
 
 		ret = update_block_group(trans, info, bytenr, num_bytes, 0);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
 	}
 	btrfs_release_path(path);
 
 out:
 	btrfs_free_path(path);
 	return ret;
+abort_transaction:
+	btrfs_abort_transaction(trans, ret);
+	goto out;
 }
 
 /*
-- 
2.14.0

