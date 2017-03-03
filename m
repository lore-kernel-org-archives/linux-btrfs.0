Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36189 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdCCQ77 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 11:59:59 -0500
Received: by mail-pg0-f52.google.com with SMTP id s67so45783018pgb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 08:59:53 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Cc: kernel-team@fb.com
Subject: [PATCH] btrfs-progs: report I/O errors when closing the filesystem
Date: Fri,  3 Mar 2017 08:59:02 -0800
Message-Id: <d187bd863a7eacb2172b693a95c6a8b875e144c4.1488560213.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If the final fsync() on the Btrfs device fails, we just swallow the
error and don't alert the user in any way. This was uncovered by xfstest
generic/405, which checks that mkfs fails when it encounters EIO.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 disk-io.c | 4 ++--
 volumes.c | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 2a94d4fc..48fb3c6b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1817,10 +1817,10 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 	free_fs_roots_tree(&fs_info->fs_root_tree);
 
 	btrfs_release_all_roots(fs_info);
-	btrfs_close_devices(fs_info->fs_devices);
+	ret = btrfs_close_devices(fs_info->fs_devices);
 	btrfs_cleanup_all_caches(fs_info);
 	btrfs_free_fs_info(fs_info);
-	return 0;
+	return ret;
 }
 
 int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/volumes.c b/volumes.c
index a0a85edd..89335d35 100644
--- a/volumes.c
+++ b/volumes.c
@@ -160,6 +160,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
 	struct btrfs_device *device;
+	int ret = 0;
 
 again:
 	if (!fs_devices)
@@ -168,7 +169,11 @@ again:
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		if (device->fd != -1) {
-			fsync(device->fd);
+			if (fsync(device->fd) == -1) {
+				warning("fsync on device %llu failed: %s",
+					device->devid, strerror(errno));
+				ret = -1;
+			}
 			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
 				fprintf(stderr, "Warning, could not drop caches\n");
 			close(device->fd);
@@ -197,7 +202,7 @@ again:
 		free(fs_devices);
 	}
 
-	return 0;
+	return ret;
 }
 
 void btrfs_close_all_devices(void)
-- 
2.12.0

