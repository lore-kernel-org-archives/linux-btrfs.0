Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59255 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbFAPYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:24:25 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:24:23 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 522122BB004D
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:20 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FOCKG3997994
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:20 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FNl2X027268
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:23:47 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 03/21] Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release extents aligned to block size.
Date: Mon,  1 Jun 2015 20:52:38 +0530
Message-Id: <1433172176-8742-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
units. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cbe6381..287192fb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1378,18 +1378,21 @@ fail:
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
@@ -1505,6 +1508,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
+		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
@@ -1513,6 +1517,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		size_t reserve_bytes;
 		size_t dirty_pages;
 		size_t copied;
+		size_t dirty_sectors;
+		size_t num_sectors;
 
 		WARN_ON(num_pages > nrptrs);
 
@@ -1525,8 +1531,11 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+		sector_offset = pos & (root->sectorsize - 1);
+		reserve_bytes = ALIGN(write_bytes + sector_offset, root->sectorsize);
+
 		ret = btrfs_check_data_free_space(inode, reserve_bytes, write_bytes);
+
 		if (ret == -ENOSPC &&
 		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC))) {
@@ -1539,7 +1548,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				 */
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
 							 PAGE_CACHE_SIZE);
-				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+				reserve_bytes = ALIGN(write_bytes + sector_offset,
+						root->sectorsize);
+
 				ret = 0;
 			} else {
 				ret = -ENOSPC;
@@ -1574,8 +1585,8 @@ again:
 			break;
 
 		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
-						      pos, &lockstart, &lockend,
-						      &cached_state);
+						pos, write_bytes, &lockstart, &lockend,
+						&cached_state);
 		if (ret < 0) {
 			if (ret == -EAGAIN)
 				goto again;
@@ -1611,9 +1622,14 @@ again:
 		 * we still have an outstanding extent for the chunk we actually
 		 * managed to copy.
 		 */
-		if (num_pages > dirty_pages) {
-			release_bytes = (num_pages - dirty_pages) <<
-				PAGE_CACHE_SHIFT;
+		num_sectors = reserve_bytes >> inode->i_blkbits;
+		dirty_sectors = round_up(copied + sector_offset,
+					root->sectorsize);
+		dirty_sectors >>= inode->i_blkbits;
+
+		if (num_sectors > dirty_sectors) {
+			release_bytes = (write_bytes - copied)
+				& ~((u64)root->sectorsize - 1);
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
@@ -1627,7 +1643,7 @@ again:
 							     release_bytes);
 		}
 
-		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
+		release_bytes = ALIGN(copied + sector_offset, root->sectorsize);
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
@@ -1649,7 +1665,7 @@ again:
 		if (only_release_metadata && copied > 0) {
 			lockstart = round_down(pos, root->sectorsize);
 			lockend = lockstart +
-				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
+				ALIGN(copied, root->sectorsize) - 1;
 
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
-- 
2.1.0

