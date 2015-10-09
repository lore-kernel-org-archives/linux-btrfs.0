Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:40499 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916AbbJIC2L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:28:11 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992RVdT023461
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:27:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 14/23] btrfs: extent-tree: Switch to new check_data_free_space and free_reserved_data_space
Date: Fri, 9 Oct 2015 10:25:48 +0800
Message-ID: <1444357551-1286-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new reserve/free for buffered write and inode cache.

For buffered write case, as nodatacow write won't increase quota account,
so unlike old behavior which does reserve before check nocow, now we
check nocow first and then only reserve data if we can't do nocow write.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add call for new free function too. Or we will leak reserved space in
  case of data reservation succeeded but metadata reservation failed.
---
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/file.c        | 34 +++++++++++++++++++++-------------
 fs/btrfs/relocation.c  |  8 ++++----
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0cd6baa..f4b9db8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3356,7 +3356,7 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, num_pages, num_pages);
+	ret = __btrfs_check_data_free_space(inode, 0, num_pages);
 	if (ret)
 		goto out_put;
 
@@ -3365,7 +3365,7 @@ again:
 					      &alloc_hint);
 	if (!ret)
 		dcs = BTRFS_DC_SETUP;
-	btrfs_free_reserved_data_space(inode, num_pages);
+	__btrfs_free_reserved_data_space(inode, 0, num_pages);
 
 out_put:
 	iput(inode);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..142b217 100644
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
@@ -1524,20 +1529,19 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
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
-				btrfs_free_reserved_data_space(inode,
-							       reserve_bytes);
+				__btrfs_free_reserved_data_space(inode, pos,
+							         write_bytes);
 			else
 				btrfs_end_write_no_snapshoting(root);
 			break;
@@ -2569,8 +2573,11 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/*
 	 * Make sure we have enough space before we do the
 	 * allocation.
+	 * XXX: The behavior must be changed to do accurate check first
+	 * and then check data reserved space.
 	 */
-	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start, alloc_end - alloc_start);
+	ret = btrfs_check_data_free_space(inode, alloc_start,
+					  alloc_end - alloc_start);
 	if (ret)
 		return ret;
 
@@ -2703,7 +2710,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 out:
 	mutex_unlock(&inode->i_mutex);
 	/* Let go of our reservation. */
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
+	__btrfs_free_reserved_data_space(inode, alloc_start,
+					 alloc_end - alloc_start);
 	return ret;
 }
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 303babe..f4621c5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3034,8 +3034,8 @@ int prealloc_file_extent_cluster(struct inode *inode,
 	BUG_ON(cluster->start != cluster->boundary[0]);
 	mutex_lock(&inode->i_mutex);
 
-	ret = btrfs_check_data_free_space(inode, cluster->end +
-					  1 - cluster->start, 0);
+	ret = __btrfs_check_data_free_space(inode, cluster->start,
+					    cluster->end + 1 - cluster->start);
 	if (ret)
 		goto out;
 
@@ -3056,8 +3056,8 @@ int prealloc_file_extent_cluster(struct inode *inode,
 			break;
 		nr++;
 	}
-	btrfs_free_reserved_data_space(inode, cluster->end +
-				       1 - cluster->start);
+	__btrfs_free_reserved_data_space(inode, cluster->start,
+					 cluster->end + 1 - cluster->start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
-- 
2.6.1

