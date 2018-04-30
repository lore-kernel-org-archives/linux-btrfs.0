Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-226-31-50-static.hfc.comcastbusiness.net ([50.226.31.50]:55554
        "EHLO linux-q7u8.site" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753827AbeD3Om2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 10:42:28 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/3] btrfs-progs: convert: fix support for e2fsprogs < 1.42
Date: Mon, 30 Apr 2018 10:37:06 -0400
Message-Id: <1525099028-11737-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Commit 324d4c1857a (btrfs-progs: convert: Add larger device support)
introduced new dependencies on the 64-bit API provided by e2fsprogs.
That API was introduced in v1.42 (along with bigalloc).

This patch maps the following to their equivalents in e2fsprogs < 1.42.
- ext2fs_get_block_bitmap_range2
- ext2fs_inode_data_blocks2
- ext2fs_read_ext_attr2

Since we need to detect and define EXT2_FLAG_64BITS for compatibilty
anyway, it makes sense to use that to detect the older e2fsprogs instead
of defining a new flag ourselves.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 configure.ac          |  6 +-----
 convert/source-ext2.h | 12 +++++++++++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index af13a95..2dea1c6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -140,11 +140,7 @@ BTRFSCONVERT_EXT2=0
 BTRFSCONVERT_REISERFS=0
 if test "x$enable_convert" = xyes; then
 	if test "x$with_convert" = "xauto" || echo "$with_convert" | grep -q "ext2"; then
-		PKG_CHECK_MODULES(EXT2FS, [ext2fs >= 1.42],,
-			[PKG_CHECK_MODULES(EXT2FS, [ext2fs],
-				[AC_DEFINE([HAVE_OLD_E2FSPROGS], [1],
-					  [E2fsprogs does not support BIGALLOC])]
-				)])
+		PKG_CHECK_MODULES(EXT2FS, [ext2fs])
 		PKG_CHECK_MODULES(COM_ERR, [com_err])
 		convertfs="${convertfs:+$convertfs,}ext2"
 		BTRFSCONVERT_EXT2=1
diff --git a/convert/source-ext2.h b/convert/source-ext2.h
index 80833b2..c321412 100644
--- a/convert/source-ext2.h
+++ b/convert/source-ext2.h
@@ -33,8 +33,18 @@
  * BIGALLOC.
  * Unlike normal RO compat flag, BIGALLOC affects how e2fsprogs check used
  * space, and btrfs-convert heavily relies on it.
+ *
+ * e2fsprogs 1.42 also introduced the 64-bit API.  Any file system
+ * that requires it will have EXT4_FEATURE_INCOMPAT_64BIT set and
+ * will fail to open with earlier releases.  We can map it to the
+ * older API without risk of corruption.
  */
-#ifdef HAVE_OLD_E2FSPROGS
+#ifndef EXT2_FLAG_64BITS
+#define EXT2_FLAG_64BITS		(0)
+#define ext2fs_get_block_bitmap_range2 ext2fs_get_block_bitmap_range
+#define ext2fs_inode_data_blocks2 ext2fs_inode_data_blocks
+#define ext2fs_read_ext_attr2 ext2fs_read_ext_attr
+#define ext2fs_blocks_count(s)		((s)->s_blocks_count)
 #define EXT2FS_CLUSTER_RATIO(fs)	(1)
 #define EXT2_CLUSTERS_PER_GROUP(s)	(EXT2_BLOCKS_PER_GROUP(s))
 #define EXT2FS_B2C(fs, blk)		(blk)
-- 
1.7.12.4

