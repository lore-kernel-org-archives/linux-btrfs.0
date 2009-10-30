From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs-progs: add discard support to mkfs
Date: Fri, 30 Oct 2009 10:46:01 +0100
Message-ID: <20091030094601.GA9906@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Discard the whole device before starting to create the filesystem structures.
Modelled after similar support in mkfs.xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-progs-unstable/utils.c
===================================================================
--- btrfs-progs-unstable.orig/utils.c	2009-10-30 09:34:00.000000000 +0000
+++ btrfs-progs-unstable/utils.c	2009-10-30 09:38:01.000000000 +0000
@@ -46,6 +46,20 @@
 static inline int ioctl(int fd, int define, u64 *size) { return 0; }
 #endif
 
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static int
+discard_blocks(int fd, u64 start, u64 len)
+{
+	u64 range[2] = { start, len };
+
+	if (ioctl(fd, BLKDISCARD, &range) < 0)
+		return errno;
+	return 0;
+}
+
 static u64 reference_root_table[] = {
 	[1] =	BTRFS_ROOT_TREE_OBJECTID,
 	[2] =	BTRFS_EXTENT_TREE_OBJECTID,
@@ -532,6 +546,13 @@ int btrfs_prepare_device(int fd, char *f
 		        "(must be at least 256 MB)\n", file);
 		exit(1);
 	}
+
+	/*
+	 * We intentionally ignore errors from the discard ioctl.  It is
+	 * not necessary for the mkfs functionality but just an optimization.
+	 */
+	discard_blocks(fd, 0, block_count);
+
 	ret = zero_dev_start(fd);
 	if (ret) {
 		fprintf(stderr, "failed to zero device start %d\n", ret);
