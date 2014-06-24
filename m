Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37161 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaFXO3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 10:29:46 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Jun 2014 19:59:43 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 5ED93394005B
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:40 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5OETuwB12976600
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:56 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5OETcX8023333
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:39 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V3 3/9] Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release extents aligned to block size.
Date: Tue, 24 Jun 2014 19:59:02 +0530
Message-Id: <1403620148-28774-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
units. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 006af2f..541e227 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1339,18 +1339,21 @@ fail:
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
@@ -1468,6 +1471,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
+		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
@@ -1488,7 +1492,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+		sector_offset = pos & (root->sectorsize - 1);
+		reserve_bytes = ALIGN(write_bytes + sector_offset, root->sectorsize);
+
 		ret = btrfs_check_data_free_space(inode, reserve_bytes);
 		if (ret == -ENOSPC &&
 		    (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
@@ -1503,7 +1509,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
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
@@ -1536,8 +1544,8 @@ again:
 			break;
 
 		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
-						      pos, &lockstart, &lockend,
-						      &cached_state);
+						pos, write_bytes, &lockstart, &lockend,
+						&cached_state);
 		if (ret < 0) {
 			if (ret == -EAGAIN)
 				goto again;
@@ -1574,9 +1582,9 @@ again:
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
@@ -1590,7 +1598,7 @@ again:
 							     release_bytes);
 		}
 
-		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
+		release_bytes = ALIGN(copied + sector_offset, root->sectorsize);
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
@@ -1609,7 +1617,7 @@ again:
 		if (only_release_metadata && copied > 0) {
 			u64 lockstart = round_down(pos, root->sectorsize);
 			u64 lockend = lockstart +
-				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
+				ALIGN(copied, root->sectorsize) - 1;
 
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
-- 
1.8.3.1

