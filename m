Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38981 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3GOF0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 01/11] btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
Date: Mon, 15 Jul 2013 13:30:47 +0800
Message-Id: <1373866257-10519-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

btrfs_scan_for_fsid uses only one argument run_ioctl out of 3
so remove the rest two of them

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-find-root.c |    2 +-
 disk-io.c         |    2 +-
 utils.c           |    5 ++---
 utils.h           |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 967486a..253c200 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -110,7 +110,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(1);
 		if (ret)
 			goto out;
 	}
diff --git a/disk-io.c b/disk-io.c
index 7c842be..5b84b02 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -716,7 +716,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(1);
 		if (ret)
 			goto out;
 	}
diff --git a/utils.c b/utils.c
index ca4eb1b..4f74d78 100644
--- a/utils.c
+++ b/utils.c
@@ -950,7 +950,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(1)))
 			return ret;
 	}
 
@@ -1132,8 +1132,7 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
 
diff --git a/utils.h b/utils.h
index 36fb591..5e5ea53 100644
--- a/utils.h
+++ b/utils.h
@@ -35,8 +35,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
-int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls);
+int btrfs_scan_for_fsid(int run_ioctls);
 void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(const char *devicename);
-- 
1.7.7.6

