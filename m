Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54809 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbbIBHv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:28 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t810XlIr023763
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 08:34:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 14/14] btrfs: Use new check_data_free_space for buffered write
Date: Tue,  1 Sep 2015 08:31:54 +0800
Message-Id: <1441067515-21105-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new check_data_free_space for buffered write.

Because nodatacow write won't increase quota account, so unlike only
behavior which does reserve before check nocow, here we check nocow
first and then only reserve data if we can't do nocow write.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

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
2.5.0

