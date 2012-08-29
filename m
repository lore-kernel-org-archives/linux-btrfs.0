Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:41590 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2H2HJd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 03:09:33 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH 2/2] Btrfs: check if an inode has no checksum when logging it
Date: Wed, 29 Aug 2012 15:07:56 +0800
Message-Id: <1346224076-17573-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346224076-17573-1-git-send-email-bo.li.liu@oracle.com>
References: <1346224076-17573-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is based on Josef's "Btrfs: turbo charge fsync".

If an inode is a BTRFS_INODE_NODATASUM one, we don't need to look for csum
items any more.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 03af7f7..2df2b7a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2680,13 +2680,14 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 }
 
 static noinline int copy_items(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *log,
+			       struct inode *inode,
 			       struct btrfs_path *dst_path,
 			       struct extent_buffer *src,
 			       int start_slot, int nr, int inode_only)
 {
 	unsigned long src_offset;
 	unsigned long dst_offset;
+	struct btrfs_root *log = BTRFS_I(inode)->root->log_root;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_inode_item *inode_item;
 	int ret;
@@ -2695,6 +2696,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	char *ins_data;
 	int i;
 	struct list_head ordered_sums;
+	int skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	INIT_LIST_HEAD(&ordered_sums);
 
@@ -2745,7 +2747,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		 * or deletes of this inode don't have to relog the inode
 		 * again
 		 */
-		if (btrfs_key_type(ins_keys + i) == BTRFS_EXTENT_DATA_KEY) {
+		if (btrfs_key_type(ins_keys + i) == BTRFS_EXTENT_DATA_KEY &&
+		    !skip_csum) {
 			int found_type;
 			extent = btrfs_item_ptr(src, start_slot + i,
 						struct btrfs_file_extent_item);
@@ -2873,7 +2876,7 @@ next_slot:
 		    args->start_slot + args->nr == path->slots[0]) {
 			args->nr++;
 		} else if (args->nr) {
-			ret = copy_items(trans, log, dst_path, args->src,
+			ret = copy_items(trans, inode, dst_path, args->src,
 					 args->start_slot, args->nr,
 					 LOG_INODE_ALL);
 			if (ret)
@@ -2910,7 +2913,7 @@ next_slot:
 		}
 
 		if (args->nr) {
-			ret = copy_items(trans, log, dst_path, args->src,
+			ret = copy_items(trans, inode, dst_path, args->src,
 					 args->start_slot, args->nr,
 					 LOG_INODE_ALL);
 			if (ret)
@@ -2930,7 +2933,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 				     struct btrfs_path *dst_path)
 {
 	struct log_args args;
-	struct btrfs_root *log = root->log_root;
 	struct extent_map *em, *n;
 	struct list_head extents;
 	struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
@@ -2971,7 +2973,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		 * our search
 		 */
 		if (args.nr && em->mod_start != args.next_offset) {
-			ret = copy_items(trans, log, dst_path, args.src,
+			ret = copy_items(trans, inode, dst_path, args.src,
 					 args.start_slot, args.nr,
 					 LOG_INODE_ALL);
 			if (ret)
@@ -2984,7 +2986,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	if (!ret && args.nr)
-		ret = copy_items(trans, log, dst_path, args.src,
+		ret = copy_items(trans, inode, dst_path, args.src,
 				 args.start_slot, args.nr, LOG_INODE_ALL);
 	btrfs_release_path(path);
 	WARN_ON(!list_empty(&extents));
@@ -3109,7 +3111,7 @@ again:
 			goto next_slot;
 		}
 
-		ret = copy_items(trans, log, dst_path, src, ins_start_slot,
+		ret = copy_items(trans, inode, dst_path, src, ins_start_slot,
 				 ins_nr, inode_only);
 		if (ret) {
 			err = ret;
@@ -3127,7 +3129,7 @@ next_slot:
 			goto again;
 		}
 		if (ins_nr) {
-			ret = copy_items(trans, log, dst_path, src,
+			ret = copy_items(trans, inode, dst_path, src,
 					 ins_start_slot,
 					 ins_nr, inode_only);
 			if (ret) {
@@ -3148,8 +3150,7 @@ next_slot:
 			break;
 	}
 	if (ins_nr) {
-		ret = copy_items(trans, log, dst_path, src,
-				 ins_start_slot,
+		ret = copy_items(trans, inode, dst_path, src, ins_start_slot,
 				 ins_nr, inode_only);
 		if (ret) {
 			err = ret;
-- 
1.7.7.6

