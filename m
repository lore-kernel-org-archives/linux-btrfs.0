Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcEIErM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 00:47:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Add compatible layer for old e2fsprogs
Date: Mon,  9 May 2016 12:46:46 +0800
Message-Id: <1462769206-7211-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new convert framework copies code from current dumpe2fs, which uses
BIGALLOC feature introduced in e2fsprogs v1.42.

While there are a lot of enterprise distributions which are still using
v1.41 e2fsprogs, this will cause compile error for them.

This patch introduce backward compatibility for new convert framework,
by manually introduce macros for ext2 BIGALLOC feature.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
This is based on david's foreign/qu/convert-rework-v3-fixups branch.
---
 btrfs-convert.c | 34 ++++++++++++++++++++++++++++++----
 configure.ac    |  6 +++++-
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b323bb1..a77a97a 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -44,6 +44,18 @@
 #define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
 #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
+/*
+ * Special hacks to support old (v1.41) e2fsprogs which doesn't
+ * support ro compat flag BIGALLOC.
+ * Unlike normal ro compat flag, BIGALLOC affects how e2fsprogs check
+ * used space, and btrfs-convert heavily rely it.
+ */
+#ifdef HAVE_OLD_E2FSPROGS
+#define EXT2FS_CLUSTER_RATIO(fs)	(1)
+#define EXT2_CLUSTERS_PER_GROUP(s)	(EXT2_BLOCKS_PER_GROUP(s))
+#define EXT2FS_B2C(fs, blk)		(blk)
+#endif
+
 struct task_ctx {
 	uint32_t max_copy_inodes;
 	uint32_t cur_copy_inodes;
@@ -124,9 +136,22 @@ static int ext2_open_fs(struct btrfs_convert_context *cctx, const char *name)
 	errcode_t ret;
 	ext2_filsys ext2_fs;
 	ext2_ino_t ino;
+	u32 ro_feature;
+
 	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
 	if (ret) {
 		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
+		return -1;
+	}
+	/*
+	 * We need to know exactly the used space, some RO compat flags like
+	 * BIGALLOC will affect how used space is present.
+	 * So we need manuall check any unsupported RO compat flags
+	 */
+	ro_feature = ext2_fs->super->s_feature_ro_compat;
+	if (ro_feature & ~EXT2_LIB_FEATURE_RO_COMPAT_SUPP) {
+		error("Unsupported ro features detected: %x, abort convert to avoid possible corruption",
+		      ro_feature & ~EXT2_LIB_FEATURE_COMPAT_SUPP);
 		goto fail;
 	}
 	ret = ext2fs_read_inode_bitmap(ext2_fs);
@@ -168,6 +193,7 @@ static int ext2_open_fs(struct btrfs_convert_context *cctx, const char *name)
 	cctx->free_inodes_count = ext2_fs->super->s_free_inodes_count;
 	return 0;
 fail:
+	ext2fs_close(ext2_fs);
 	return -1;
 }
 
@@ -180,8 +206,8 @@ static int __ext2_add_one_block(ext2_filsys fs, char *bitmap,
 
 	offset = fs->super->s_first_data_block;
 	offset /= EXT2FS_CLUSTER_RATIO(fs);
-	offset += group_nr * fs->super->s_clusters_per_group;
-	for (i = 0; i < fs->super->s_clusters_per_group; i++) {
+	offset += group_nr * EXT2_CLUSTERS_PER_GROUP(fs->super);
+	for (i = 0; i < EXT2_CLUSTERS_PER_GROUP(fs->super); i++) {
 		if (ext2fs_test_bit(i, bitmap)) {
 			u64 start;
 
@@ -218,7 +244,7 @@ static int ext2_read_used_space(struct btrfs_convert_context *cctx)
 		return -ENOMEM;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
+		ret = ext2fs_get_block_bitmap_range(fs->block_map, blk_itr,
 						block_nbytes * 8, block_bitmap);
 		if (ret) {
 			error("fail to get bitmap from ext2, %s",
@@ -231,7 +257,7 @@ static int ext2_read_used_space(struct btrfs_convert_context *cctx)
 			      strerror(-ret));
 			break;
 		}
-		blk_itr += fs->super->s_clusters_per_group;
+		blk_itr += EXT2_CLUSTERS_PER_GROUP(fs->super);
 	}
 
 	free(block_bitmap);
diff --git a/configure.ac b/configure.ac
index fc343ea..84b7b2d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -105,7 +105,11 @@ AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFS
 AC_SUBST([DISABLE_BTRFSCONVERT])
 
 if test "x$enable_convert" = xyes; then
-	PKG_CHECK_MODULES(EXT2FS, [ext2fs])
+	PKG_CHECK_MODULES(EXT2FS, [ext2fs >= 1.42],,
+		[PKG_CHECK_MODULES(EXT2FS, [ext2fs],
+			[AC_DEFINE([HAVE_OLD_E2FSPROGS], [1],
+				  [E2fsprogs does not support BIGALLOC])]
+			)])
 	PKG_CHECK_MODULES(COM_ERR, [com_err])
 fi
 
-- 
2.8.2



