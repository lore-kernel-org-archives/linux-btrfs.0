Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53142 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3JGTWA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 15:22:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DF8877C0690
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 13:21:59 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id YRpVR2AZxW32MT1F (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 13:21:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: free reserved space on error in a few places
Date: Mon, 7 Oct 2013 15:21:57 -0400
Message-ID: <1381173717-8432-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to track down a reserved space leak I noticed a few places where we
won't properly clean up reserved space if we have an error, this patch fixes
those up.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c | 21 +++++++++++++++++++--
 fs/btrfs/inode.c       |  2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 86b57c8..9be5e35 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2235,8 +2235,12 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 
-	if (trans->aborted)
+	if (trans->aborted) {
+		if (insert_reserved)
+			btrfs_pin_extent(root, node->bytenr,
+					 node->num_bytes, 1);
 		return 0;
+	}
 
 	if (btrfs_delayed_ref_is_head(node)) {
 		struct btrfs_delayed_ref_head *head;
@@ -2412,6 +2416,14 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 				btrfs_free_delayed_extent_op(extent_op);
 
 				if (ret) {
+					/*
+					 * Need to reset must_insert_reserved if
+					 * there was an error so the abort stuff
+					 * can cleanup the reserved space
+					 * properly.
+					 */
+					if (must_insert_reserved)
+						locked_ref->must_insert_reserved = 1;
 					btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
 					spin_lock(&delayed_refs->lock);
 					btrfs_delayed_ref_unlock(locked_ref);
@@ -6732,13 +6744,18 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		size += sizeof(*block_info);
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		btrfs_free_and_pin_reserved_extent(root, ins->objectid,
+						   root->leafsize);
 		return -ENOMEM;
+	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
 	if (ret) {
+		btrfs_free_and_pin_reserved_extent(root, ins->objectid,
+						   root->leafsize);
 		btrfs_free_path(path);
 		return ret;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cc3de9d..1d7ef37 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8497,6 +8497,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  ins.offset, 0, 0, 0,
 						  BTRFS_FILE_EXTENT_PREALLOC);
 		if (ret) {
+			btrfs_free_reserved_extent(root, ins.objectid,
+						   ins.offset);
 			btrfs_abort_transaction(trans, root, ret);
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
-- 
1.8.3.1

