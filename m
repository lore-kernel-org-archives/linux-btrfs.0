Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18876 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751399AbdJaJXN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:23:13 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 0414C47F13A4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:23:09 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Remove unused parameter trans
Date: Tue, 31 Oct 2017 17:23:03 +0800
Message-ID: <1509441784-52316-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some parameter of trans is not used indeed.
Let's remove them.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c  |  9 ++++-----
 ctree.h       |  3 +--
 extent-tree.c | 18 ++++++++----------
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a6198bad..a7a36ee9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2626,8 +2626,7 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 		}
 		btrfs_mark_buffer_dirty(eb);
 		printf("Added an extent item [%llu %u]\n", bytenr, node_size);
-		btrfs_update_block_group(trans, extent_root, bytenr, node_size,
-					 1, 0);
+		btrfs_update_block_group(extent_root, bytenr, node_size, 1, 0);
 
 		nrefs->refs[level] = 0;
 		nrefs->full_backref[level] =
@@ -9656,7 +9655,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 			u64 bytes = (found_key.type == BTRFS_EXTENT_ITEM_KEY) ?
 				found_key.offset : root->fs_info->nodesize;
 
-			ret = btrfs_update_block_group(trans, root, bytenr,
+			ret = btrfs_update_block_group(root, bytenr,
 						       bytes, 0, 0);
 			if (ret)
 				break;
@@ -9735,7 +9734,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 		}
 
 		btrfs_mark_buffer_dirty(leaf);
-		ret = btrfs_update_block_group(trans, extent_root, rec->start,
+		ret = btrfs_update_block_group(extent_root, rec->start,
 					       rec->max_size, 1, 0);
 		if (ret)
 			goto fail;
@@ -11944,7 +11943,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		btrfs_set_extent_flags(eb, ei, BTRFS_EXTENT_FLAG_DATA);
 
 		btrfs_mark_buffer_dirty(eb);
-		ret = btrfs_update_block_group(trans, extent_root, disk_bytenr,
+		ret = btrfs_update_block_group(extent_root, disk_bytenr,
 					       num_bytes, 1, 0);
 		btrfs_release_path(&path);
 	}
diff --git a/ctree.h b/ctree.h
index b92df1c1..a8f0ec5e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2504,8 +2504,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   u64 size);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info);
-int btrfs_update_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr, u64 num,
+int btrfs_update_block_group(struct btrfs_root *root, u64 bytenr, u64 num,
 			     int alloc, int mark_free);
 int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 objectid,
diff --git a/extent-tree.c b/extent-tree.c
index 055582c3..edf659d5 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1921,8 +1921,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
+static int update_block_group(struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
 			      int mark_free)
 {
@@ -2387,7 +2386,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
-		update_block_group(trans, root, bytenr, num_bytes, 0, mark_free);
+		update_block_group(root, bytenr, num_bytes, 0, mark_free);
 	}
 fail:
 	btrfs_free_path(path);
@@ -2747,7 +2746,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, fs_info->nodesize,
+	ret = update_block_group(root, ins->objectid, fs_info->nodesize,
 				 1, 0);
 	return ret;
 }
@@ -3474,12 +3473,11 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_update_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
+int btrfs_update_block_group(struct btrfs_root *root,
 			     u64 bytenr, u64 num_bytes, int alloc,
 			     int mark_free)
 {
-	return update_block_group(trans, root, bytenr, num_bytes,
+	return update_block_group(root, bytenr, num_bytes,
 				  alloc, mark_free);
 }
 
@@ -3898,12 +3896,12 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.type == BTRFS_EXTENT_ITEM_KEY) {
 			bytes_used += key.offset;
-			ret = btrfs_update_block_group(trans, root,
+			ret = btrfs_update_block_group(root,
 				  key.objectid, key.offset, 1, 0);
 			BUG_ON(ret);
 		} else if (key.type == BTRFS_METADATA_ITEM_KEY) {
 			bytes_used += fs_info->nodesize;
-			ret = btrfs_update_block_group(trans, root,
+			ret = btrfs_update_block_group(root,
 				  key.objectid, fs_info->nodesize, 1, 0);
 			if (ret)
 				goto out;
@@ -4058,7 +4056,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 					       BTRFS_EXTENT_FLAG_DATA);
 			btrfs_mark_buffer_dirty(leaf);
 
-			ret = btrfs_update_block_group(trans, root, disk_bytenr,
+			ret = btrfs_update_block_group(root, disk_bytenr,
 						       num_bytes, 1, 0);
 			if (ret)
 				goto fail;
-- 
2.13.6



