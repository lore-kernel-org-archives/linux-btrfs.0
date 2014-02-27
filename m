Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaB0F4g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 00:56:36 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1R5uVRb006350
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 13:56:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix preallocate vs double nocow write
Date: Thu, 27 Feb 2014 13:58:05 +0800
Message-Id: <1393480685-4320-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
References: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can not release the reserved metadata space for the first write if we
find the write position is pre-allocated. Because the kernel might write
the data on the disk before we do the second write but after the can-nocow
check, if we release the space for the first write, we might fail to update
the metadata because of no space.

Fix this problem by end nocow write if there is dirty data in the range whose
space is pre-allocated.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c  |  9 ++-------
 fs/btrfs/inode.c | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 56f8a07..1654d68 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1413,16 +1413,11 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 
 	num_bytes = lockend - lockstart + 1;
 	ret = can_nocow_extent(inode, lockstart, &num_bytes, NULL, NULL, NULL);
-	if (ret <= 0) {
+	if (ret <= 0)
 		ret = 0;
-	} else {
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				 EXTENT_DIRTY | EXTENT_DELALLOC |
-				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
-				 NULL, GFP_NOFS);
+	else
 		*write_bytes = min_t(size_t, *write_bytes ,
 				     num_bytes - pos + lockstart);
-	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..17415a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6546,6 +6546,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	int ret;
 	struct extent_buffer *leaf;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	u64 disk_bytenr;
@@ -6622,6 +6623,20 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 
 	if (btrfs_extent_readonly(root, disk_bytenr))
 		goto out;
+
+	num_bytes = min(offset + *len, extent_end) - offset;
+	if (!nocow && found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		u64 range_end;
+
+		range_end = round_up(offset + num_bytes, root->sectorsize) - 1;
+		ret = test_range_bit(io_tree, offset, range_end,
+				     EXTENT_DELALLOC, 0, NULL);
+		if (ret) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
+
 	btrfs_release_path(path);
 
 	/*
@@ -6650,7 +6665,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	 */
 	disk_bytenr += backref_offset;
 	disk_bytenr += offset - key.offset;
-	num_bytes = min(offset + *len, extent_end) - offset;
 	if (csum_exist_in_range(root, disk_bytenr, num_bytes))
 				goto out;
 	/*
-- 
1.8.1.4

