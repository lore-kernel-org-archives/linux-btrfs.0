Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59220 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3G2Tex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 15:34:53 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 211749A0407
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 13:34:52 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id F0UMLXa96sBXS3So (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 13:34:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix what bits we clear when erroring out from delalloc V2
Date: Mon, 29 Jul 2013 15:34:49 -0400
Message-ID: <1375126489-1623-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First of all we no longer set EXTENT_DIRTY when we dirty an extent so this patch
removes the clearing of EXTENT_DIRTY since it confuses me.  This patch also adds
clearing EXTENT_DEFRAG and also doing EXTENT_DO_ACCOUNTING when we have errors.
This is because if we are clearing delalloc without adding an ordered extent
then we need to make sure the enospc handling stuff is accounted for.  Also if
this range was DEFRAG we need to make sure that bit is cleared so we dont leak
it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
- only do EXTENT_DO_ACCOUNTING in compress_file_range if we had an error

 fs/btrfs/inode.c |   49 ++++++++++++++++++++++++++++---------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a60be02..88fe045 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -484,15 +484,17 @@ cont:
 						    compress_type, pages);
 		}
 		if (ret <= 0) {
+			unsigned long clear_flags = EXTENT_DELALLOC |
+				EXTENT_DEFRAG;
+			clear_flags |= (ret < 0) ? EXTENT_DO_ACCOUNTING : 0;
+
 			/*
 			 * inline extent creation worked or returned error,
 			 * we don't need to create any more async work items.
 			 * Unlock and free up our temp pages.
 			 */
 			extent_clear_unlock_delalloc(inode, start, end, NULL,
-						     EXTENT_DIRTY |
-						     EXTENT_DELALLOC,
-						     PAGE_UNLOCK |
+						     clear_flags, PAGE_UNLOCK |
 						     PAGE_CLEAR_DIRTY |
 						     PAGE_SET_WRITEBACK |
 						     PAGE_END_WRITEBACK);
@@ -593,9 +595,10 @@ free_pages_out:
 
 cleanup_and_out:
 	extent_clear_unlock_delalloc(inode, start, end, NULL,
-				     EXTENT_DIRTY | EXTENT_DELALLOC,
-				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+				     EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+				     EXTENT_DEFRAG, PAGE_UNLOCK |
+				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+				     PAGE_END_WRITEBACK);
 	if (!trans || IS_ERR(trans))
 		btrfs_error(root->fs_info, ret, "Failed to join transaction");
 	else
@@ -770,8 +773,8 @@ retry:
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
-				NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
-				EXTENT_DIRTY, PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
+				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
+				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
 		ret = btrfs_submit_compressed_write(inode,
 				    async_extent->start,
@@ -795,9 +798,9 @@ out_free:
 				     async_extent->start +
 				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
-				     EXTENT_DIRTY, PAGE_UNLOCK |
-				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
-				     PAGE_END_WRITEBACK);
+				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
+				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
 	kfree(async_extent);
 	goto again;
 }
@@ -884,7 +887,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		if (ret == 0) {
 			extent_clear_unlock_delalloc(inode, start, end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
-				     EXTENT_DIRTY, PAGE_UNLOCK |
+				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
 				     PAGE_END_WRITEBACK);
 
@@ -995,10 +998,10 @@ out_reserve:
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
 out_unlock:
 	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				     EXTENT_LOCKED | EXTENT_DIRTY |
-				     EXTENT_DELALLOC, PAGE_UNLOCK |
-				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
-				     PAGE_END_WRITEBACK);
+				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
+				     EXTENT_DELALLOC | EXTENT_DEFRAG,
+				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
+				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
 	goto out;
 }
 
@@ -1016,7 +1019,8 @@ static noinline int cow_file_range(struct inode *inode,
 	if (IS_ERR(trans)) {
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
-					     EXTENT_DIRTY, PAGE_UNLOCK |
+					     EXTENT_DO_ACCOUNTING |
+					     EXTENT_DEFRAG, PAGE_UNLOCK |
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
@@ -1201,7 +1205,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	if (!path) {
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
-					     EXTENT_DIRTY, PAGE_UNLOCK |
+					     EXTENT_DO_ACCOUNTING |
+					     EXTENT_DEFRAG, PAGE_UNLOCK |
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
@@ -1218,7 +1223,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	if (IS_ERR(trans)) {
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
-					     EXTENT_DIRTY, PAGE_UNLOCK |
+					     EXTENT_DO_ACCOUNTING |
+					     EXTENT_DEFRAG, PAGE_UNLOCK |
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
@@ -1434,8 +1440,9 @@ error:
 	if (ret && cur_offset < end)
 		extent_clear_unlock_delalloc(inode, cur_offset, end,
 					     locked_page, EXTENT_LOCKED |
-					     EXTENT_DELALLOC | EXTENT_DIRTY,
-					     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
+					     EXTENT_DELALLOC | EXTENT_DEFRAG |
+					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
+					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
 	btrfs_free_path(path);
-- 
1.7.7.6

