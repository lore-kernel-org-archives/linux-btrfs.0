Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62142 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3CALdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 06:33:07 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1690285pbc.24
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2013 03:33:07 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, chris.mason@fusionio.com,
        wangshilong1991@gmail.com
Subject: [PATCH 1/2] Btrfs: don't call btrfs_qgroup_free if just btrfs_qgroup_reserve fails
Date: Fri,  1 Mar 2013 19:33:01 +0800
Message-Id: <1362137581-1797-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

commit eb6b88d92c6df083dd09a8c471011e3788dfd7c6 leads into another bug.
If it is just because qgroup_reserve fails, the function btrfs_qgroup_free
should not be called, otherwise, it will cause the wrong quota accounting.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 34ade06..f0c960b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4772,9 +4772,14 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * ret != 0 here means the qgroup reservation failed, we go straight to
 	 * the shared error handling then.
 	 */
-	if (ret == 0)
+	if (ret == 0) {
 		ret = reserve_metadata_bytes(root, block_rsv,
 					     to_reserve, flush);
+		if (ret && root->fs_info->quota_enabled) {
+			btrfs_qgroup_free(root, num_bytes +
+						nr_extents * root->leafsize);
+		}
+	}
 
 	if (ret) {
 		u64 to_free = 0;
@@ -4805,10 +4810,6 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 						      btrfs_ino(inode),
 						      to_free, 0);
 		}
-		if (root->fs_info->quota_enabled) {
-			btrfs_qgroup_free(root, num_bytes +
-						nr_extents * root->leafsize);
-		}
 		if (delalloc_lock)
 			mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 		return ret;
-- 
1.7.7.6

