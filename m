Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38557 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbcAUK1E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:27:04 -0500
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 21 Jan 2016 20:27:02 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 528582BB0059
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:59 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0LAQpM367043530
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:59 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0LAQQ5o013717
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:26:26 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH V10 01/12] Btrfs: __btrfs_buffered_write: Reserve/release extents aligned to block size
Date: Thu, 21 Jan 2016 15:55:53 +0530
Message-Id: <1453371964-4917-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the code reserves/releases extents in multiples of PAGE_CACHE_SIZE
units. Fix this by doing reservation/releases in block size units.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |  3 +++
 fs/btrfs/file.c  | 43 ++++++++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9a88d0c..9f4609c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2351,6 +2351,9 @@ struct btrfs_map_token {
 	unsigned long offset;
 };
 
+#define BTRFS_BYTES_TO_BLKS(fs_info, bytes) \
+				((bytes) >> (fs_info)->sb->s_blocksize_bits)
+
 static inline void btrfs_init_map_token (struct btrfs_map_token *token)
 {
 	token->kaddr = NULL;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 364e0f1..e294620 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -499,7 +499,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	loff_t isize = i_size_read(inode);
 
 	start_pos = pos & ~((u64)root->sectorsize - 1);
-	num_bytes = ALIGN(write_bytes + pos - start_pos, root->sectorsize);
+	num_bytes = round_up(write_bytes + pos - start_pos, root->sectorsize);
 
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
@@ -1380,16 +1380,19 @@ fail:
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
+	start_pos = round_down(pos, root->sectorsize);
+	last_pos = start_pos
+		+ round_up(pos + write_bytes - start_pos, root->sectorsize) - 1;
 
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
@@ -1504,6 +1507,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
+		size_t sector_offset;
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
@@ -1512,6 +1516,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		size_t reserve_bytes;
 		size_t dirty_pages;
 		size_t copied;
+		size_t dirty_sectors;
+		size_t num_sectors;
 
 		WARN_ON(num_pages > nrptrs);
 
@@ -1524,7 +1530,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+		sector_offset = pos & (root->sectorsize - 1);
+		reserve_bytes = round_up(write_bytes + sector_offset,
+				root->sectorsize);
 
 		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					     BTRFS_INODE_PREALLOC)) {
@@ -1543,7 +1551,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				 */
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
 							 PAGE_CACHE_SIZE);
-				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+				reserve_bytes = round_up(write_bytes
+							+ sector_offset,
+							root->sectorsize);
 				goto reserve_metadata;
 			}
 		}
@@ -1577,8 +1587,8 @@ again:
 			break;
 
 		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
-						      pos, &lockstart, &lockend,
-						      &cached_state);
+						pos, write_bytes, &lockstart,
+						&lockend, &cached_state);
 		if (ret < 0) {
 			if (ret == -EAGAIN)
 				goto again;
@@ -1614,9 +1624,16 @@ again:
 		 * we still have an outstanding extent for the chunk we actually
 		 * managed to copy.
 		 */
-		if (num_pages > dirty_pages) {
-			release_bytes = (num_pages - dirty_pages) <<
-				PAGE_CACHE_SHIFT;
+		num_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info,
+						reserve_bytes);
+		dirty_sectors = round_up(copied + sector_offset,
+					root->sectorsize);
+		dirty_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info,
+						dirty_sectors);
+
+		if (num_sectors > dirty_sectors) {
+			release_bytes = (write_bytes - copied)
+				& ~((u64)root->sectorsize - 1);
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
@@ -1635,7 +1652,8 @@ again:
 			}
 		}
 
-		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
+		release_bytes = round_up(copied + sector_offset,
+					root->sectorsize);
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
@@ -1656,8 +1674,7 @@ again:
 
 		if (only_release_metadata && copied > 0) {
 			lockstart = round_down(pos, root->sectorsize);
-			lockend = lockstart +
-				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
+			lockend = round_up(pos + copied, root->sectorsize) - 1;
 
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				       lockend, EXTENT_NORESERVE, NULL,
-- 
2.1.0

