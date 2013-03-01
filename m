Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:37824 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3CALgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 06:36:07 -0500
Received: by mail-da0-f52.google.com with SMTP id x33so1365969dad.39
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2013 03:36:06 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, chris.mason@fusionio.com,
        wangshilong1991@gmail.com
Subject: [PATCH 2/2] Btrfs: cleanup to make the function btrfs_delalloc_reserve_metadata more logic
Date: Fri,  1 Mar 2013 19:36:01 +0800
Message-Id: <1362137761-1864-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code is a little confusing and not clear, The right
way to deal with the kernel code like this:
		[...]
		if (ret)
			goto out;
		[...]

So i move the common clean_up code to the place labeled with
out_fail, this will be easier to maintain.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   82 ++++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f0c960b..8e57870 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4721,6 +4721,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
+	u64 to_free = 0;
+	unsigned dropped;
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -4764,55 +4766,19 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
-	if (root->fs_info->quota_enabled)
+	if (root->fs_info->quota_enabled) {
 		ret = btrfs_qgroup_reserve(root, num_bytes +
 					   nr_extents * root->leafsize);
+		if (ret)
+			goto out_fail;
+	}
 
-	/*
-	 * ret != 0 here means the qgroup reservation failed, we go straight to
-	 * the shared error handling then.
-	 */
-	if (ret == 0) {
-		ret = reserve_metadata_bytes(root, block_rsv,
-					     to_reserve, flush);
-		if (ret && root->fs_info->quota_enabled) {
+	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
+	if (unlikely(ret)) {
+		if (root->fs_info->quota_enabled)
 			btrfs_qgroup_free(root, num_bytes +
 						nr_extents * root->leafsize);
-		}
-	}
-
-	if (ret) {
-		u64 to_free = 0;
-		unsigned dropped;
-
-		spin_lock(&BTRFS_I(inode)->lock);
-		dropped = drop_outstanding_extent(inode);
-		/*
-		 * If the inodes csum_bytes is the same as the original
-		 * csum_bytes then we know we haven't raced with any free()ers
-		 * so we can just reduce our inodes csum bytes and carry on.
-		 * Otherwise we have to do the normal free thing to account for
-		 * the case that the free side didn't free up its reserve
-		 * because of this outstanding reservation.
-		 */
-		if (BTRFS_I(inode)->csum_bytes == csum_bytes)
-			calc_csum_metadata_size(inode, num_bytes, 0);
-		else
-			to_free = calc_csum_metadata_size(inode, num_bytes, 0);
-		spin_unlock(&BTRFS_I(inode)->lock);
-		if (dropped)
-			to_free += btrfs_calc_trans_metadata_size(root, dropped);
-
-		if (to_free) {
-			btrfs_block_rsv_release(root, block_rsv, to_free);
-			trace_btrfs_space_reservation(root->fs_info,
-						      "delalloc",
-						      btrfs_ino(inode),
-						      to_free, 0);
-		}
-		if (delalloc_lock)
-			mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
-		return ret;
+		goto out_fail;
 	}
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -4833,6 +4799,34 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
 	return 0;
+
+out_fail:
+	spin_lock(&BTRFS_I(inode)->lock);
+	dropped = drop_outstanding_extent(inode);
+	/*
+	 * If the inodes csum_bytes is the same as the original
+	 * csum_bytes then we know we haven't raced with any free()ers
+	 * so we can just reduce our inodes csum bytes and carry on.
+	 * Otherwise we have to do the normal free thing to account for
+	 * the case that the free side didn't free up its reserve
+	 * because of this outstanding reservation.
+	 */
+	if (BTRFS_I(inode)->csum_bytes == csum_bytes)
+		calc_csum_metadata_size(inode, num_bytes, 0);
+	else
+		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+	spin_unlock(&BTRFS_I(inode)->lock);
+	if (dropped)
+		to_free += btrfs_calc_trans_metadata_size(root, dropped);
+
+	if (to_free) {
+		btrfs_block_rsv_release(root, block_rsv, to_free);
+		trace_btrfs_space_reservation(root->fs_info, "delalloc",
+					      btrfs_ino(inode), to_free, 0);
+	}
+	if (delalloc_lock)
+		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
+	return ret;
 }
 
 /**
-- 
1.7.7.6

