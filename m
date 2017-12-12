Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54959 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdLLHfF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 11/14] btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item
Date: Tue, 12 Dec 2017 15:34:33 +0800
Message-Id: <20171212073436.16447-12-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quite similar for delalloc, some modification to delayed-inode and
delayed-item reservation.
Also needs extra parameter for release case to distinguish normal release and
error release.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-inode.c | 50 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d73f79ded8b..ccfaf643cfe1 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -22,6 +22,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "ctree.h"
+#include "qgroup.h"
 
 #define BTRFS_DELAYED_WRITEBACK		512
 #define BTRFS_DELAYED_BACKGROUND	128
@@ -528,11 +529,12 @@ static struct btrfs_delayed_item *__btrfs_next_delayed_item(
 }
 
 static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
-					       struct btrfs_fs_info *fs_info,
+					       struct btrfs_root *root,
 					       struct btrfs_delayed_item *item)
 {
 	struct btrfs_block_rsv *src_rsv;
 	struct btrfs_block_rsv *dst_rsv;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 num_bytes;
 	int ret;
 
@@ -543,6 +545,10 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	dst_rsv = &fs_info->delayed_block_rsv;
 
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
+	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+	if (ret < 0)
+		return ret;
+
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_item",
@@ -554,15 +560,17 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void btrfs_delayed_item_release_metadata(struct btrfs_fs_info *fs_info,
+static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 						struct btrfs_delayed_item *item)
 {
 	struct btrfs_block_rsv *rsv;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (!item->bytes_reserved)
 		return;
 
 	rsv = &fs_info->delayed_block_rsv;
+	btrfs_qgroup_convert_reserved_meta(root, item->bytes_reserved);
 	trace_btrfs_space_reservation(fs_info, "delayed_item",
 				      item->key.objectid, item->bytes_reserved,
 				      0);
@@ -587,6 +595,9 @@ static int btrfs_delayed_inode_reserve_metadata(
 
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
+	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+	if (ret < 0)
+		return ret;
 	/*
 	 * btrfs_dirty_inode will update the inode under btrfs_join_transaction
 	 * which doesn't reserve space for speed.  This is a problem since we
@@ -606,8 +617,10 @@ static int btrfs_delayed_inode_reserve_metadata(
 		 * EAGAIN to make us stop the transaction we have, so return
 		 * ENOSPC instead so that btrfs_dirty_inode knows what to do.
 		 */
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN) {
 			ret = -ENOSPC;
+			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
+		}
 		if (!ret) {
 			node->bytes_reserved = num_bytes;
 			trace_btrfs_space_reservation(fs_info,
@@ -629,7 +642,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 }
 
 static void btrfs_delayed_inode_release_metadata(struct btrfs_fs_info *fs_info,
-						struct btrfs_delayed_node *node)
+						struct btrfs_delayed_node *node,
+						bool qgroup_free)
 {
 	struct btrfs_block_rsv *rsv;
 
@@ -641,6 +655,12 @@ static void btrfs_delayed_inode_release_metadata(struct btrfs_fs_info *fs_info,
 				      node->inode_id, node->bytes_reserved, 0);
 	btrfs_block_rsv_release(fs_info, rsv,
 				node->bytes_reserved);
+	if (qgroup_free)
+		btrfs_qgroup_free_meta_prealloc(node->root,
+				node->bytes_reserved);
+	else
+		btrfs_qgroup_convert_reserved_meta(node->root,
+				node->bytes_reserved);
 	node->bytes_reserved = 0;
 }
 
@@ -742,7 +762,7 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
 				    curr->data_len);
 		slot++;
 
-		btrfs_delayed_item_release_metadata(fs_info, curr);
+		btrfs_delayed_item_release_metadata(root, curr);
 
 		list_del(&curr->tree_list);
 		btrfs_release_delayed_item(curr);
@@ -764,7 +784,6 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 				     struct btrfs_path *path,
 				     struct btrfs_delayed_item *delayed_item)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *leaf;
 	char *ptr;
 	int ret;
@@ -782,7 +801,7 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 			    delayed_item->data_len);
 	btrfs_mark_buffer_dirty(leaf);
 
-	btrfs_delayed_item_release_metadata(fs_info, delayed_item);
+	btrfs_delayed_item_release_metadata(root, delayed_item);
 	return 0;
 }
 
@@ -834,7 +853,6 @@ static int btrfs_batch_delete_items(struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
 				    struct btrfs_delayed_item *item)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_delayed_item *curr, *next;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
@@ -884,7 +902,7 @@ static int btrfs_batch_delete_items(struct btrfs_trans_handle *trans,
 		goto out;
 
 	list_for_each_entry_safe(curr, next, &head, tree_list) {
-		btrfs_delayed_item_release_metadata(fs_info, curr);
+		btrfs_delayed_item_release_metadata(root, curr);
 		list_del(&curr->tree_list);
 		btrfs_release_delayed_item(curr);
 	}
@@ -1027,7 +1045,7 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 no_iref:
 	btrfs_release_path(path);
 err_out:
-	btrfs_delayed_inode_release_metadata(fs_info, node);
+	btrfs_delayed_inode_release_metadata(fs_info, node, (ret < 0));
 	btrfs_release_delayed_inode(node);
 
 	return ret;
@@ -1420,7 +1438,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_dir_type(dir_item, type);
 	memcpy((char *)(dir_item + 1), name, name_len);
 
-	ret = btrfs_delayed_item_reserve_metadata(trans, fs_info, delayed_item);
+	ret = btrfs_delayed_item_reserve_metadata(trans, dir->root, delayed_item);
 	/*
 	 * we have reserved enough space when we start a new transaction,
 	 * so reserving metadata failure is impossible
@@ -1457,7 +1475,7 @@ static int btrfs_delete_delayed_insertion_item(struct btrfs_fs_info *fs_info,
 		return 1;
 	}
 
-	btrfs_delayed_item_release_metadata(fs_info, item);
+	btrfs_delayed_item_release_metadata(node->root, item);
 	btrfs_release_delayed_item(item);
 	mutex_unlock(&node->mutex);
 	return 0;
@@ -1492,7 +1510,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 	item->key = item_key;
 
-	ret = btrfs_delayed_item_reserve_metadata(trans, fs_info, item);
+	ret = btrfs_delayed_item_reserve_metadata(trans, dir->root, item);
 	/*
 	 * we have reserved enough space when we start a new transaction,
 	 * so reserving metadata failure is impossible.
@@ -1865,7 +1883,7 @@ static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 	mutex_lock(&delayed_node->mutex);
 	curr_item = __btrfs_first_delayed_insertion_item(delayed_node);
 	while (curr_item) {
-		btrfs_delayed_item_release_metadata(fs_info, curr_item);
+		btrfs_delayed_item_release_metadata(root, curr_item);
 		prev_item = curr_item;
 		curr_item = __btrfs_next_delayed_item(prev_item);
 		btrfs_release_delayed_item(prev_item);
@@ -1873,7 +1891,7 @@ static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 
 	curr_item = __btrfs_first_delayed_deletion_item(delayed_node);
 	while (curr_item) {
-		btrfs_delayed_item_release_metadata(fs_info, curr_item);
+		btrfs_delayed_item_release_metadata(root, curr_item);
 		prev_item = curr_item;
 		curr_item = __btrfs_next_delayed_item(prev_item);
 		btrfs_release_delayed_item(prev_item);
@@ -1883,7 +1901,7 @@ static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 		btrfs_release_delayed_iref(delayed_node);
 
 	if (test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		btrfs_delayed_inode_release_metadata(fs_info, delayed_node);
+		btrfs_delayed_inode_release_metadata(fs_info, delayed_node, false);
 		btrfs_release_delayed_inode(delayed_node);
 	}
 	mutex_unlock(&delayed_node->mutex);
-- 
2.15.1

