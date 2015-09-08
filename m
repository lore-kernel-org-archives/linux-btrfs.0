Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47953 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbIIFF0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 01:05:26 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t888dQvD019126
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 16:39:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/19] btrfs: Switch to new check_data_free_space
Date: Tue,  8 Sep 2015 16:37:31 +0800
Message-Id: <1441701456-8034-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new check_data_free_space for buffered write and inode cache.

For buffered write case, as nodatacow write won't increase quota account,
so unlike old behavior which does reserve before check nocow, now we
check nocow first and then only reserve data if we can't do nocow write.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/file.c        | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61366ca..2e3f19e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3352,7 +3352,7 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, num_pages, num_pages);
+	ret = __btrfs_check_data_free_space(inode, 0, num_pages);
 	if (ret)
 		goto out_put;
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..c1eec4f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1510,12 +1510,17 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
-		ret = btrfs_check_data_free_space(inode, reserve_bytes, write_bytes);
-		if (ret == -ENOSPC &&
-		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
-					      BTRFS_INODE_PREALLOC))) {
+
+		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					     BTRFS_INODE_PREALLOC)) {
 			ret = check_can_nocow(inode, pos, &write_bytes);
+			if (ret < 0)
+				break;
 			if (ret > 0) {
+				/*
+				 * For nodata cow case, no need to reserve
+				 * data space.
+				 */
 				only_release_metadata = true;
 				/*
 				 * our prealloc extent may be smaller than
@@ -1524,15 +1529,14 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
 							 PAGE_CACHE_SIZE);
 				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
-				ret = 0;
-			} else {
-				ret = -ENOSPC;
+				goto reserve_metadata;
 			}
 		}
-
-		if (ret)
+		ret = __btrfs_check_data_free_space(inode, pos, write_bytes);
+		if (ret < 0)
 			break;
 
+reserve_metadata:
 		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
 		if (ret) {
 			if (!only_release_metadata)
-- 
2.5.1

