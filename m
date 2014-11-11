Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaKKLgJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 06:36:09 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org, Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, Karel Zak <kzak@redhat.com>
Subject: [PATCH 1/2] btrfs-progs: rename btrfs_scan_lblkid() to btrfs_scan_devices()
Date: Tue, 11 Nov 2014 12:35:58 +0100
Message-Id: <1415705759-2681-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems like bad idea to use a library name (lblkid) within generic
function name. The currently used scanning library is implementation
detail and this detail should be hidden for rest of the code.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 cmds-device.c     | 2 +-
 cmds-filesystem.c | 2 +-
 disk-io.c         | 2 +-
 utils.c           | 6 +++---
 utils.h           | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 9323986..e18ef4b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -235,7 +235,7 @@ static int cmd_scan_dev(int argc, char **argv)
 
 	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = btrfs_scan_lblkid();
+		ret = btrfs_scan_devices();
 		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 		ret = btrfs_register_all_devices();
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e4b2785..25ef382 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -948,7 +948,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = btrfs_scan_lblkid();
+	ret = btrfs_scan_devices();
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index bade5f0..85a2a57 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1019,7 +1019,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_lblkid();
+		ret = btrfs_scan_devices();
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index 4b3bace..cc33cfc 100644
--- a/utils.c
+++ b/utils.c
@@ -1188,7 +1188,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		ret = btrfs_scan_lblkid();
+		ret = btrfs_scan_devices();
 		if (ret)
 			return ret;
 	}
@@ -1270,7 +1270,7 @@ int btrfs_register_one_device(const char *fname)
 
 /*
  * Register all devices in the fs_uuid list created in the user
- * space. Ensure btrfs_scan_lblkid() is called before this func.
+ * space. Ensure btrfs_scan_devices() is called before this func.
  */
 int btrfs_register_all_devices(void)
 {
@@ -2181,7 +2181,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int btrfs_scan_lblkid()
+int btrfs_scan_devices()
 {
 	int fd = -1;
 	int ret;
diff --git a/utils.h b/utils.h
index 8c94624..919dfcf 100644
--- a/utils.h
+++ b/utils.h
@@ -128,7 +128,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
-int btrfs_scan_lblkid(void);
+int btrfs_scan_devices(void);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int find_mount_root(const char *path, char **mount_root);
 int get_device_info(int fd, u64 devid,
-- 
1.9.3

