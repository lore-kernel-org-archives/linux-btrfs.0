Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46688 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaBOP4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 10:56:09 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so1268633wib.3
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Feb 2014 07:56:08 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't insert useless holes when punching beyond the inode's size
Date: Sat, 15 Feb 2014 15:55:58 +0000
Message-Id: <1392479758-9108-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we punch beyond the size of an inode, we'll correctly remove any prealloc extents,
but we'll also insert file extent items representing holes (disk bytenr == 0) that start
with a key offset that lies beyond the inode's size and are not contiguous with the last
file extent item.

Example:

  $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
  $XFS_IO_PROG -c "fpunch 582007 864596" $SCRATCH_MNT/foo
  $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" $SCRATCH_MNT/foo

btrfs-debug-tree output:

  item 4 key (257 INODE_ITEM 0) itemoff 15885 itemsize 160
	inode generation 6 transid 6 size 132254 block group 0 mode 100600 links 1
  item 5 key (257 INODE_REF 256) itemoff 15872 itemsize 13
	inode ref index 2 namelen 3 name: foo
  item 6 key (257 EXTENT_DATA 0) itemoff 15819 itemsize 53
	extent data disk byte 0 nr 0 gen 6
	extent data offset 0 nr 90112 ram 122880
	extent compression 0
  item 7 key (257 EXTENT_DATA 90112) itemoff 15766 itemsize 53
	extent data disk byte 12845056 nr 4096 gen 6
	extent data offset 0 nr 45056 ram 45056
	extent compression 2
  item 8 key (257 EXTENT_DATA 585728) itemoff 15713 itemsize 53
	extent data disk byte 0 nr 0 gen 6
	extent data offset 0 nr 860160 ram 860160
	extent compression 0

The last extent item, which represents a hole, is useless as it lies beyond the inode's
size.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 006af2f..5133d71 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2165,6 +2165,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
 			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
+	u64 ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
 
 	ret = btrfs_wait_ordered_range(inode, offset, len);
 	if (ret)
@@ -2180,14 +2181,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 * entire page.
 	 */
 	if (same_page && len < PAGE_CACHE_SIZE) {
-		if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE))
+		if (offset < ino_size)
 			ret = btrfs_truncate_page(inode, offset, len, 0);
 		mutex_unlock(&inode->i_mutex);
 		return ret;
 	}
 
 	/* zero back part of the first page */
-	if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE)) {
+	if (offset < ino_size) {
 		ret = btrfs_truncate_page(inode, offset, 0, 0);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
@@ -2196,7 +2197,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	/* zero the front end of the last page */
-	if (offset + len < round_up(inode->i_size, PAGE_CACHE_SIZE)) {
+	if (offset + len < ino_size) {
 		ret = btrfs_truncate_page(inode, offset + len, 0, 1);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
@@ -2285,10 +2286,13 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
 
-		ret = fill_holes(trans, inode, path, cur_offset, drop_end);
-		if (ret) {
-			err = ret;
-			break;
+		if (cur_offset < ino_size) {
+			ret = fill_holes(trans, inode, path, cur_offset,
+					 drop_end);
+			if (ret) {
+				err = ret;
+				break;
+			}
 		}
 
 		cur_offset = drop_end;
@@ -2321,10 +2325,12 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
-	ret = fill_holes(trans, inode, path, cur_offset, drop_end);
-	if (ret) {
-		err = ret;
-		goto out_trans;
+	if (cur_offset < ino_size) {
+		ret = fill_holes(trans, inode, path, cur_offset, drop_end);
+		if (ret) {
+			err = ret;
+			goto out_trans;
+		}
 	}
 
 out_trans:
-- 
1.7.9.5

