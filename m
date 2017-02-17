Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36608 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934444AbdBQOoJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:09 -0500
Received: by mail-wr0-f193.google.com with SMTP id z61so4718050wrc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:09 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 21/38] btrfs: Make check_can_nocow take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:12 +0200
Message-Id: <1487342609-20652-22-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c12d7308205b..8e223c78c8fe 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1474,11 +1474,11 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 	return ret;
 }
 
-static noinline int check_can_nocow(struct inode *inode, loff_t pos,
+static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 				    size_t *write_bytes)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct btrfs_ordered_extent *ordered;
 	u64 lockstart, lockend;
 	u64 num_bytes;
@@ -1493,19 +1493,19 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 			   fs_info->sectorsize) - 1;
 
 	while (1) {
-		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
-		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), lockstart,
+		lock_extent(&inode->io_tree, lockstart, lockend);
+		ordered = btrfs_lookup_ordered_range(inode, lockstart,
 						     lockend - lockstart + 1);
 		if (!ordered) {
 			break;
 		}
-		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
-		btrfs_start_ordered_extent(inode, ordered, 1);
+		unlock_extent(&inode->io_tree, lockstart, lockend);
+		btrfs_start_ordered_extent(&inode->vfs_inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
 
 	num_bytes = lockend - lockstart + 1;
-	ret = can_nocow_extent(inode, lockstart, &num_bytes, NULL, NULL, NULL);
+	ret = can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes, NULL, NULL, NULL);
 	if (ret <= 0) {
 		ret = 0;
 		btrfs_end_write_no_snapshoting(root);
@@ -1514,7 +1514,7 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 				     num_bytes - pos + lockstart);
 	}
 
-	unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+	unlock_extent(&inode->io_tree, lockstart, lockend);
 
 	return ret;
 }
@@ -1579,7 +1579,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
-			    check_can_nocow(inode, pos, &write_bytes) > 0) {
+			    check_can_nocow(BTRFS_I(inode), pos, &write_bytes) > 0) {
 				/*
 				 * For nodata cow case, no need to reserve
 				 * data space.
-- 
2.7.4

