Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbbIHJ2A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 05:28:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t889RkSj011245
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 17:27:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/19] btrfs: extent-tree: Use new __btrfs_delalloc_reserve_space function
Date: Tue, 8 Sep 2015 17:25:54 +0800
Message-ID: <1441704356-1940-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new __btrfs_delalloc_reserve_space to reserve space.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode-map.c |  2 +-
 fs/btrfs/inode.c     | 16 ++++++++++------
 fs/btrfs/ioctl.c     |  5 +++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d4a582a..ab639d3 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -488,7 +488,7 @@ again:
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_CACHE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, prealloc);
+	ret = __btrfs_delalloc_reserve_space(inode, 0, prealloc);
 	if (ret)
 		goto out_put;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f7cac0..d70cb26 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1985,7 +1985,8 @@ again:
 		goto again;
 	}
 
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = __btrfs_delalloc_reserve_space(inode, page_start,
+					     PAGE_CACHE_SIZE);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -4581,7 +4582,8 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = __btrfs_delalloc_reserve_space(inode,
+			round_down(from, PAGE_CACHE_SIZE), PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
 
@@ -8373,7 +8375,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			mutex_unlock(&inode->i_mutex);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, count);
+		ret = __btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
 			goto out;
 		outstanding_extents = div64_u64(count +
@@ -8620,7 +8622,11 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_end;
 
 	sb_start_pagefault(inode->i_sb);
-	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	page_start = page_offset(page);
+	page_end = page_start + PAGE_CACHE_SIZE - 1;
+
+	ret = __btrfs_delalloc_reserve_space(inode, page_start,
+					     PAGE_CACHE_SIZE);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -8639,8 +8645,6 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 again:
 	lock_page(page);
 	size = i_size_read(inode);
-	page_start = page_offset(page);
-	page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_start >= size)) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0adf542..e0291fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1119,8 +1119,9 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
-	ret = btrfs_delalloc_reserve_space(inode,
-					   page_cnt << PAGE_CACHE_SHIFT);
+	ret = __btrfs_delalloc_reserve_space(inode,
+			start_index << PAGE_CACHE_SHIFT,
+			page_cnt << PAGE_CACHE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
-- 
2.5.1

