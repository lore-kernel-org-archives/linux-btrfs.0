Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36726 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932504AbcKMTmI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 14:42:08 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so24689865pfz.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Nov 2016 11:42:08 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 3/6] btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
Date: Sun, 13 Nov 2016 11:35:21 -0800
Message-Id: <b22be9b08513c06ad7a091ea502aaa31ee03ca34.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If this flag is passed to open_ctree(), we'll clear the
FREE_SPACE_TREE_VALID compat_ro bit. The kernel will then reconstruct
the free space tree the next time the filesystem is mounted.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 chunk-recover.c |  2 +-
 disk-io.c       | 28 ++++++++++++++++++----------
 disk-io.h       |  8 +++++++-
 3 files changed, 26 insertions(+), 12 deletions(-)

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
index a576300..a55fcc1 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -904,7 +904,7 @@ free_all:
 	return NULL;
 }
 
-int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, unsigned flags)
 {
 	u64 features;
 
@@ -923,13 +923,22 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
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
@@ -1320,8 +1329,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_fs_compatibility(fs_info->super_copy,
-					   flags & OPEN_CTREE_WRITES);
+	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
 	if (ret)
 		goto out_devices;
 
diff --git a/disk-io.h b/disk-io.h
index 8ab36aa..5d4b281 100644
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
@@ -128,7 +134,7 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
-int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, unsigned flags);
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 			  unsigned flags);
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
-- 
2.10.2

