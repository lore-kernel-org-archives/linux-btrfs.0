Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from net.its-24.pl ([5.63.185.56]:42736 "EHLO adrb.pl"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdBEUtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Feb 2017 15:49:07 -0500
From: Adrian Brzezinski <linux-btrfs@adrb.pl>
To: linux-btrfs@vger.kernel.org
Cc: Adrian Brzezinski <linux-btrfs@adrb.pl>
Subject: [PATCH] btrfs: query for extent compressed size
Date: Sun,  5 Feb 2017 22:09:09 +0100
Message-Id: <1486328949-32600-1-git-send-email-linux-btrfs@adrb.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simple patch which allows you to query with FIEMAP ioctl for
disk blocks allocated per extent. It's done when you set new FIEMAP flag :

* FIEMAP_FLAG_ONDISK
If this flag is set, fe_length returns size of blocks allocated on the disk,
rather than actual data length contained in extent.

Here is also userspace POC code:

https://github.com/adrb/public/blob/master/linux/tools/fiemap.c

Signed-off-by: Adrian Brzezinski <linux-btrfs@adrb.pl>
---
 Documentation/filesystems/fiemap.txt | 7 +++++++
 fs/btrfs/extent_io.c                 | 9 ++++++++-
 fs/btrfs/inode.c                     | 2 +-
 include/uapi/linux/fiemap.h          | 6 +++++-
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index f6d9c99..8d3d94e 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -58,6 +58,13 @@ If this flag is set, the kernel will sync the file before mapping extents.
 If this flag is set, the extents returned will describe the inodes
 extended attribute lookup tree, instead of its data tree.
 
+* FIEMAP_FLAG_ONDISK
+If this flag is set, fe_length returns size of blocks allocated on the disk,
+rather than actual data length contained in extent.
+
+For example, if extent have the FIEMAP_EXTENT_ENCODED flag set and
+the data are compressed, then actual data size contained by extent
+differs from blocks allocated on disk.
 
 Extent Mapping
 --------------
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a..68e92e3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4488,10 +4488,17 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			offset_in_extent = em_start - em->start;
 		em_end = extent_map_end(em);
-		em_len = em_end - em_start;
 		disko = 0;
 		flags = 0;
 
+		if (fieinfo->fi_flags & FIEMAP_FLAG_ONDISK &&
+		    em->block_start != EXTENT_MAP_INLINE &&
+		    em->block_len != (u64)-1) {
+
+			em_len = em->block_len;
+		} else
+			em_len = em_end - em_start;
+
 		/*
 		 * bump off for our next call to get_extent
 		 */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a0..64ca53a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8744,7 +8744,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
-#define BTRFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC)
+#define BTRFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_ONDISK)
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
index 0c51d61..0652bd2 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -41,8 +41,12 @@ struct fiemap {
 #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
 #define FIEMAP_FLAG_XATTR	0x00000002 /* map extended attribute tree */
 #define FIEMAP_FLAG_CACHE	0x00000004 /* request caching of the extents */
+#define FIEMAP_FLAG_ONDISK	0x00000008 /* return size of blocks allocated
+					    * on disk, rather than actual
+					    * data length in extent */
 
-#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+#define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR | \
+				 FIEMAP_FLAG_ONDISK)
 
 #define FIEMAP_EXTENT_LAST		0x00000001 /* Last extent in file. */
 #define FIEMAP_EXTENT_UNKNOWN		0x00000002 /* Data location unknown. */
-- 
2.1.4

