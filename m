Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:32869 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3GQQDr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 12:03:47 -0400
Received: by mail-pb0-f42.google.com with SMTP id un1so2075908pbc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 09:03:47 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs-progs: fix wrong arg sb_bytenr for btrfs_scan_fs_devices()
Date: Thu, 18 Jul 2013 00:03:40 +0800
Message-Id: <1374077020-21354-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

For most time, In open_ctree_*(), we use the first superblock
(BTRFS_SUPER_INFO_OFFSET). However, for btrfs-convert, we don't,
we should pass the correct sb_bytenr to btrfs_scan_fs_devices() rather
than always use BTRFS_SUPER_INFO_OFFSET.This patch fix the following
regression:

mkfs.ext2 <dev>
btrfs-convert <dev>

warning, device 1 is missing
Check tree block failed, want=2670592, have=0
read block failed check_tree_block
Couldn't read chunk root
Segmentation fault (core dumped)

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c | 2 +-
 cmds-chunk.c      | 2 +-
 disk-io.c         | 9 ++++++---
 disk-io.h         | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 9b3d7df..374cf81 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -82,7 +82,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		return NULL;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0);
 	if (ret)
 		goto out;
 
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..6ada328 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1291,7 +1291,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_free_sb;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0);
 	if (ret)
 		goto fail_free_sb;
 
diff --git a/disk-io.c b/disk-io.c
index 13dbe27..f8e236c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -909,13 +909,16 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 }
 
 int btrfs_scan_fs_devices(int fd, const char *path,
-			  struct btrfs_fs_devices **fs_devices)
+			  struct btrfs_fs_devices **fs_devices,
+			  u64 sb_bytenr)
 {
 	u64 total_devs;
 	int ret;
+	if (!sb_bytenr)
+		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, sb_bytenr);
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
 		return ret;
@@ -1001,7 +1004,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (restore)
 		fs_info->on_restoring = 1;
 
-	ret = btrfs_scan_fs_devices(fp, path, &fs_devices);
+	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr);
 	if (ret)
 		goto out;
 
diff --git a/disk-io.h b/disk-io.h
index effaa9f..bc749c3 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -59,7 +59,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
-			  struct btrfs_fs_devices **fs_devices);
+			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
-- 
1.7.11.7

