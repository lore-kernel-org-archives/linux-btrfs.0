Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56762 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaIHOPG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 10:15:06 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 8 Sep 2014 19:45:04 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 7A510E0045
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2014 19:47:26 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s88EFQ8e49938558
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:27 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s88EF0SU022340
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:45:01 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V6 03/15] Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release extents aligned to block size.
Date: Mon,  8 Sep 2014 19:44:14 +0530
Message-Id: <1410185666-23308-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
units. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d3afac2..444819d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1366,18 +1366,21 @@ fail:
 static noinline int
 lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 				size_t num_pages, loff_t pos,
+				size_t write_bytes,
 				u64 *lockstart, u64 *lockend,
 				struct extent_state **cached_state)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start_pos;
 	u64 last_pos;
 	int i;
 	int ret = 0;
 
-	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
-	last_pos = start_pos + ((u64)num_pages << PAGE_CACHE_SHIFT) - 1;
+       start_pos = pos & ~((u64)root->sectorsize - 1);
+       last_pos = start_pos
+               + ALIGN(pos + write_bytes - start_pos, root->sectorsize) - 1;
 
-	if (start_pos < inode->i_size) {
+       if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos, 0, cached_state);
@@ -1494,6 +1497,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
+		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
@@ -1514,7 +1518,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+		sector_offset = pos & (root->sectorsize - 1);
+		reserve_bytes = ALIGN(write_bytes + sector_offset, root->sectorsize);
+
 		ret = btrfs_check_data_free_space(inode, reserve_bytes);
 		if (ret == -ENOSPC &&
 		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
@@ -1529,7 +1535,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				num_pages = (write_bytes + offset +
 					     PAGE_CACHE_SIZE - 1) >>
 					PAGE_CACHE_SHIFT;
-				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+
+				reserve_bytes = ALIGN(write_bytes + sector_offset,
+						root->sectorsize);
 				ret = 0;
 			} else {
 				ret = -ENOSPC;
@@ -1564,8 +1572,8 @@ again:
 			break;
 
 		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
-						      pos, &lockstart, &lockend,
-						      &cached_state);
+						pos, write_bytes, &lockstart, &lockend,
+						&cached_state);
 		if (ret < 0) {
 			if (ret == -EAGAIN)
 				goto again;
@@ -1602,9 +1610,9 @@ again:
 		 * we still have an outstanding extent for the chunk we actually
 		 * managed to copy.
 		 */
-		if (num_pages > dirty_pages) {
-			release_bytes = (num_pages - dirty_pages) <<
-				PAGE_CACHE_SHIFT;
+		if (write_bytes > copied) {
+			release_bytes = (write_bytes - copied)
+				& ~((u64)root->sectorsize - 1);
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
@@ -1618,7 +1626,7 @@ again:
 							     release_bytes);
 		}
 
-		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
+		release_bytes = ALIGN(copied + sector_offset, root->sectorsize);
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
@@ -1640,7 +1648,7 @@ again:
 		if (only_release_metadata && copied > 0) {
 			u64 lockstart = round_down(pos, root->sectorsize);
 			u64 lockend = lockstart +
-				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
+				ALIGN(copied, root->sectorsize) - 1;
 
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
-- 
1.8.3.1

