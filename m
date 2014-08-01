Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39936 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbaHAXMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:48 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/12] btrfs: remove unused fs_info arg from btrfs_close_extra_devices()
Date: Fri,  1 Aug 2014 18:12:35 -0500
Message-Id: <1406934766-16974-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit:
8dabb74 Btrfs: change core code of btrfs to support the
        device replace operations
added the fs_info argument, but never used it -
just remove it again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |    4 ++--
 fs/btrfs/volumes.c |    3 +--
 fs/btrfs/volumes.h |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08e65e9..f6d7afd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2672,7 +2672,7 @@ int open_ctree(struct super_block *sb,
 	 * keep the device that is marked to be the target device for the
 	 * dev_replace procedure
 	 */
-	btrfs_close_extra_devices(fs_info, fs_devices, 0);
+	btrfs_close_extra_devices(fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
 		printk(KERN_CRIT "BTRFS: failed to read devices on %s\n",
@@ -2778,7 +2778,7 @@ retry_root_backup:
 		goto fail_block_groups;
 	}
 
-	btrfs_close_extra_devices(fs_info, fs_devices, 1);
+	btrfs_close_extra_devices(fs_devices, 1);
 
 	ret = btrfs_sysfs_add_one(fs_info);
 	if (ret) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6cb82f6..b5aa0c9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -574,8 +574,7 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
-void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
-			       struct btrfs_fs_devices *fs_devices, int step)
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 {
 	struct btrfs_device *device, *next;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2aaa00c..2026741 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -307,8 +307,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
-			       struct btrfs_fs_devices *fs_devices, int step);
+void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
-- 
1.7.1

