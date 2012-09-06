Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758115Ab2IFKov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:51 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A3GCM017584
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:03:17 +0800
Message-ID: <504874D8.60001@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:03:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 07/12] Btrfs: fix corrupted metadata in the snapshot
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

When we delete a inode, we will remove all the delayed items including delayed
inode update, and then truncate all the relative metadata. If there is lots of
metadata, we will end the current transaction, and start a new transaction to
truncate the left metadata. In this way, we will leave a inode item that its
link counter is > 0, and also may leave some directory index items in fs/file tree
after the current transaction ends. In other words, the metadata in this fs/file tree
is inconsistent. If we create a snapshot for this tree now, we will find a inode with
corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
because its link counter is not 0.

We fix this problem by updating the inode item before the current transaction ends.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- Update the comment of the truncation in the btrfs_evict_inode()
- Fix enospc problem of the inode update
---
 fs/btrfs/delayed-inode.c |    3 ++-
 fs/btrfs/inode.c         |   23 ++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index eb768c4..8f2d1bf 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -650,7 +650,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 * we're accounted for.
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
-			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
+			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC &&
+			 src_rsv->type != BTRFS_BLOCK_RSV_TEMP)) {
 		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
 		/*
 		 * Since we're under a transaction reserve_metadata_bytes could
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d494c11..709f5b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3738,7 +3738,7 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size;
 	unsigned long nr;
 	int ret;
 
@@ -3772,21 +3772,23 @@ void btrfs_evict_inode(struct inode *inode)
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
+
+	min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	min_size += btrfs_calc_trans_metadata_size(root, 1);
 	rsv->size = min_size;
 	global_rsv = &root->fs_info->global_block_rsv;
 
 	btrfs_i_size_write(inode, 0);
 
 	/*
-	 * This is a bit simpler than btrfs_truncate since
-	 *
-	 * 1) We've already reserved our space for our orphan item in the
-	 *    unlink.
-	 * 2) We're going to delete the inode item, so we don't need to update
-	 *    it at all.
+	 * This is a bit simpler than btrfs_truncate since we've already
+	 * reserved our space for our orphan item in the unlink, so we just
+	 * need to reserve some slack space in case we add bytes and update
+	 * inode item when doing the truncate.
 	 *
-	 * So we just need to reserve some slack space in case we add bytes when
-	 * doing the truncate.
+	 * The differentiation is we can not reserve the space for the inode
+	 * update when starting the transaction because it may cause
+	 * the deadlock.
 	 */
 	while (1) {
 		ret = btrfs_block_rsv_refill_noflush(root, rsv, min_size);
@@ -3820,6 +3822,9 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret != -EAGAIN)
 			break;
 
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
-- 
1.7.6.5
