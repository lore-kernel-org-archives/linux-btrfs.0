Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3IRIaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 04:30:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8I8UG7H030190
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 16:30:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs-progs: pass flag to control whether run ioctl in btrfs_scan_for_fsid()
Date: Wed, 18 Sep 2013 16:27:34 +0800
Message-Id: <1379492856-30639-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If some fatal superblocks are damaged, running ioctl will return failure,
in this case, we should avoid run ioctl.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c | 2 +-
 chunk-recover.c   | 2 +-
 disk-io.c         | 6 +++---
 disk-io.h         | 3 ++-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index b48c800..7572f52 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -82,7 +82,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		return NULL;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
 	if (ret)
 		goto out;
 
diff --git a/chunk-recover.c b/chunk-recover.c
index 45da9a6..9af4887 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1291,7 +1291,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		goto fail_free_sb;
 	}
 
-	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0);
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices, 0, 1);
 	if (ret)
 		goto fail_free_sb;
 
diff --git a/disk-io.c b/disk-io.c
index bc673c2..6281569 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -911,7 +911,7 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices,
-			  u64 sb_bytenr)
+			  u64 sb_bytenr, int run_ioctl)
 {
 	u64 total_devs;
 	int ret;
@@ -926,7 +926,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(1);
+		ret = btrfs_scan_for_fsid(run_ioctl);
 		if (ret)
 			return ret;
 	}
@@ -1005,7 +1005,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (restore)
 		fs_info->on_restoring = 1;
 
-	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr);
+	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr, 1);
 	if (ret)
 		goto out;
 
diff --git a/disk-io.h b/disk-io.h
index b61eb43..7219c2e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -57,7 +57,8 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
-			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr);
+			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
+			  int run_ioctl);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
-- 
1.8.3.1

