Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaKKLgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 06:36:13 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org, Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, Karel Zak <kzak@redhat.com>
Subject: [PATCH 2/2] btrfs-progs: use udev to scan for devices
Date: Tue, 11 Nov 2014 12:35:59 +0100
Message-Id: <1415705759-2681-2-git-send-email-kzak@redhat.com>
In-Reply-To: <1415705759-2681-1-git-send-email-kzak@redhat.com>
References: <1415705759-2681-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs uses libblkid to scan for block devices with BTRFS.
The disadvantage is that this method is expensive. The udevd maintains
information about all block devices in udev db and all devices are
probed by udevd (it's linked with libblkid). We don't have to duplicate
this thing in btrfs.

This patch links btrfs with libudev, the original blkid based method
is used as fallback (for systems without udev, etc.)

Note that btrfs-progs project does not use autoconf, so dependence on
libudev is hardcoded to Makefile for now. It would be probably better
to add ./configure script to the project and make dependence on
libudev optional.

udev:
	# time ./btrfs device scan
	Scanning for Btrfs filesystems
	real    0m0.012s
	user    0m0.004s
	sys     0m0.003s

blkid:
	# time ./btrfs device scan
	Scanning for Btrfs filesystems
	real    0m0.076s
	user    0m0.008s
	sys     0m0.024s

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile |   2 +-
 utils.c  | 107 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/Makefile b/Makefile
index 203597c..768c5e0 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ TESTS = fsck-tests.sh convert-tests.sh
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
+lib_LIBS = -ludev -luuid -lblkid -lm -lz -llzo2 -L.
 libdir ?= $(prefix)/lib
 incdir = $(prefix)/include/btrfs
 LIBS = $(lib_LIBS) $(libs_static)
diff --git a/utils.c b/utils.c
index cc33cfc..5c71336 100644
--- a/utils.c
+++ b/utils.c
@@ -38,6 +38,7 @@
 #include <linux/kdev_t.h>
 #include <limits.h>
 #include <blkid/blkid.h>
+#include <libudev.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -2181,20 +2182,34 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int btrfs_scan_devices()
+static int scan_device(const char *path)
+{
+	int rc;
+	int fd = open(path, O_RDONLY);
+	struct btrfs_fs_devices *devs = NULL;
+	u64 ndevs;
+
+	if (fd < 0) {
+		printf("ERROR: could not open %s\n", path);
+		return 1;
+	}
+
+	rc = btrfs_scan_one_device(fd, path, &devs, &ndevs, BTRFS_SUPER_INFO_OFFSET, 0);
+	if (rc)
+		printf("ERROR: could not scan %s\n", path);
+
+	close(fd);
+	return rc;
+}
+
+
+static int btrfs_scan_devices_by_blkid(void)
 {
-	int fd = -1;
-	int ret;
-	u64 num_devices;
-	struct btrfs_fs_devices *tmp_devices;
 	blkid_dev_iterate iter = NULL;
 	blkid_dev dev = NULL;
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
 
-	if (btrfs_scan_done)
-		return 0;
-
 	if (blkid_get_cache(&cache, 0) < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
@@ -2209,29 +2224,73 @@ int btrfs_scan_devices()
 		/* if we are here its definitely a btrfs disk*/
 		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 
-		fd = open(path, O_RDONLY);
-		if (fd < 0) {
-			printf("ERROR: could not open %s\n", path);
-			continue;
-		}
-		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
-				&num_devices, BTRFS_SUPER_INFO_OFFSET, 0);
-		if (ret) {
-			printf("ERROR: could not scan %s\n", path);
-			close (fd);
-			continue;
-		}
-
-		close(fd);
+		scan_device(path);
 	}
 	blkid_dev_iterate_end(iter);
 	blkid_put_cache(cache);
 
-	btrfs_scan_done = 1;
-
 	return 0;
 }
 
+static int btrfs_scan_devices_by_udev(void)
+{
+	int rc = 1;
+	struct udev *udev = NULL;
+	struct udev_enumerate *en = NULL;
+	struct udev_list_entry *ent, *devs;
+
+	udev = udev_new();
+	if (!udev)
+		goto done;
+	en = udev_enumerate_new(udev);
+	if (!en)
+		goto done;
+
+	udev_enumerate_add_match_subsystem(en, "block");
+	if (udev_enumerate_scan_devices(en) != 0)
+		goto done;
+	devs = udev_enumerate_get_list_entry(en);
+	if (!devs)
+		goto done;
+
+	udev_list_entry_foreach(ent, devs) {
+		const char *val, *name = udev_list_entry_get_name(ent);
+		struct udev_device *dev = udev_device_new_from_syspath(udev, name);
+
+		if (!dev)
+			continue;
+		val = udev_device_get_property_value(dev, "ID_FS_TYPE");
+		if (val && strcmp(val, "btrfs") == 0) {
+			const char *path = udev_device_get_devnode(dev);
+			if (path)
+				scan_device(path);
+		}
+		udev_device_unref(dev);
+	}
+
+	rc = 0;
+done:
+	udev_enumerate_unref(en);
+	udev_unref(udev);
+
+	return rc;
+}
+
+int btrfs_scan_devices()
+{
+	int rc = 1;
+
+	if (btrfs_scan_done)
+		return 0;
+
+	rc = btrfs_scan_devices_by_udev();
+	if (rc)
+		rc = btrfs_scan_devices_by_blkid();
+
+	btrfs_scan_done = 1;
+	return rc;
+}
+
 int is_vol_small(char *file)
 {
 	int fd = -1;
-- 
1.9.3

