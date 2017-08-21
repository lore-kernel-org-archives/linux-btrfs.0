Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63037 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753021AbdHUMmu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:42:50 -0400
Subject: [PATCH 5/5] btrfs: Use common error handling code in
 btrfs_mark_extent_written()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Message-ID: <93116379-7a82-733a-6957-4e01b3572d8f@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:42:40 +0200
MIME-Version: 1.0
In-Reply-To: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:15:23 +0200

Add jump targets so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/file.c | 62 ++++++++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 74fd7756cff3..675683051cbc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1122,25 +1122,17 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-	if (key.objectid != ino ||
-	    key.type != BTRFS_EXTENT_DATA_KEY) {
-		ret = -EINVAL;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY)
+		goto e_inval;
+
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
-	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_PREALLOC) {
-		ret = -EINVAL;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_PREALLOC)
+		goto e_inval;
+
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-	if (key.offset > start || extent_end < end) {
-		ret = -EINVAL;
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	if (key.offset > start || extent_end < end)
+		goto e_inval;
 
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
@@ -1213,10 +1205,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			btrfs_release_path(path);
 			goto again;
 		}
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 
 		leaf = path->nodes[0];
 		fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
@@ -1237,18 +1227,15 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_extent_ref(trans, fs_info, bytenr, num_bytes,
 					   0, root->root_key.objectid,
 					   ino, orig_offset);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
 
 		if (split == start) {
 			key.offset = start;
 		} else {
 			if (start != key.offset) {
 				ret = -EINVAL;
-				btrfs_abort_transaction(trans, ret);
-				goto out;
+				goto abort_transaction;
 			}
 			path->slots[0]--;
 			extent_end = end;
@@ -1271,10 +1258,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
 	}
 	other_start = 0;
 	other_end = start;
@@ -1291,10 +1276,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		ret = btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret)
+			goto abort_transaction;
 	}
 	if (del_nr == 0) {
 		fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -1314,14 +1297,17 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		btrfs_mark_buffer_dirty(leaf);
 
 		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 	}
 out:
 	btrfs_free_path(path);
 	return 0;
+e_inval:
+	ret = -EINVAL;
+abort_transaction:
+	btrfs_abort_transaction(trans, ret);
+	goto out;
 }
 
 /*
-- 
2.14.0

