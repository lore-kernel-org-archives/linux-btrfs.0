Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33393 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753468AbcKNSne (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:43:34 -0500
Received: by mail-pg0-f48.google.com with SMTP id 3so56981444pgd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 10:43:34 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 3/6] btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
Date: Mon, 14 Nov 2016 10:43:20 -0800
Message-Id: <761a130a531803e85e75b7332a2393e8e950396d.1479148594.git.osandov@fb.com>
In-Reply-To: <cover.1479148594.git.osandov@fb.com>
References: <cover.1479148594.git.osandov@fb.com>
In-Reply-To: <cover.1479148594.git.osandov@fb.com>
References: <cover.1479148594.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If this flag is passed to open_ctree(), we'll clear the
FREE_SPACE_TREE_VALID compat_ro bit. The kernel will then reconstruct
the free space tree the next time the filesystem is mounted.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 chunk-recover.c |  2 +-
 disk-io.c       | 29 +++++++++++++++++++----------
 disk-io.h       |  9 ++++++++-
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index e33ee8b..e6b26ac 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1477,7 +1477,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_fs_compatibility(disk_super, 1);
+	ret = btrfs_check_fs_compatibility(disk_super, OPEN_CTREE_WRITES);
 	if (ret)
 		goto out_devices;
 
diff --git a/disk-io.c b/disk-io.c
index a576300..de25fcd 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -904,7 +904,8 @@ free_all:
 	return NULL;
 }
 
-int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
+				 unsigned int flags)
 {
 	u64 features;
 
@@ -923,13 +924,22 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
 		btrfs_set_super_incompat_flags(sb, features);
 	}
 
-	features = btrfs_super_compat_ro_flags(sb) &
-		~BTRFS_FEATURE_COMPAT_RO_SUPP;
-	if (writable && features) {
-		printk("couldn't open RDWR because of unsupported "
-		       "option features (%Lx).\n",
-		       (unsigned long long)features);
-		return -ENOTSUP;
+	features = btrfs_super_compat_ro_flags(sb);
+	if (flags & OPEN_CTREE_WRITES) {
+		if (flags & OPEN_CTREE_INVALIDATE_FST) {
+			/* Clear the FREE_SPACE_TREE_VALID bit on disk... */
+			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID;
+			btrfs_set_super_compat_ro_flags(sb, features);
+			/* ... and ignore the free space tree bit. */
+			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE;
+		}
+		if (features & ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
+			printk("couldn't open RDWR because of unsupported "
+			       "option features (%Lx).\n",
+			       (unsigned long long)features);
+			return -ENOTSUP;
+		}
+
 	}
 	return 0;
 }
@@ -1320,8 +1330,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_fs_compatibility(fs_info->super_copy,
-					   flags & OPEN_CTREE_WRITES);
+	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
 	if (ret)
 		goto out_devices;
 
diff --git a/disk-io.h b/disk-io.h
index 8ab36aa..d4a0e7f 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -74,6 +74,12 @@ enum btrfs_open_ctree_flags {
 
 	/* Allow to open a partially created filesystem */
 	OPEN_CTREE_FS_PARTIAL = (1U << 12),
+
+	/*
+	 * Invalidate the free space tree (i.e., clear the FREE_SPACE_TREE_VALID
+	 * compat_ro bit).
+	 */
+	OPEN_CTREE_INVALIDATE_FST = (1U << 13),
 };
 
 /*
@@ -128,7 +134,8 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
-int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
+				 unsigned int flags);
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 			  unsigned flags);
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
-- 
2.10.2

