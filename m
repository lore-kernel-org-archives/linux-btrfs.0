Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61832 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaLDSYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:24:43 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so9363519wid.17
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:24:42 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/5] Avoid to consider lvm snapshots when scanning devices.
Date: Thu,  4 Dec 2014 19:24:26 +0100
Message-Id: <1417717470-6298-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
References: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

LVM snapshots create a problem to the btrfs devices management.
BTRFS assumes that each device haw an unique 'device UUID'.
A LVM snapshot breaks this assumption.

This patch skips LVM snapshots during the device scan phase.
If you need to consider a LVM snapshot you have to set the
environmental variable BTRFS_SKIP_LVM_SNAPSHOT to "no".

To check if a device is a LVM snapshot, it is checked the
'udev' device property 'DM_UDEV_LOW_PRIORITY_FLAG' .
If it is set to 1, the device has to be skipped.

As conseguence, btrfs now depends by libudev.

Programmatically you can control this behavior with the functions:
- btrfs_scan_set_skip_lvm_snapshot(int new_value)
- int btrfs_scan_get_skip_lvm_snapshot( )

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile |   4 +--
 utils.c  | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h  |   9 +++++-
 3 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 4cae30c..9464361 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ TESTS = fsck-tests.sh convert-tests.sh
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
+lib_LIBS = -luuid -lblkid -lm -lz -ludev -llzo2 -L.
 libdir ?= $(prefix)/lib
 incdir = $(prefix)/include/btrfs
 LIBS = $(lib_LIBS) $(libs_static)
@@ -99,7 +99,7 @@ lib_links = libbtrfs.so.0 libbtrfs.so
 headers = $(libbtrfs_headers)
 
 # make C=1 to enable sparse
-check_defs := .cc-defines.h 
+check_defs := .cc-defines.h
 ifdef C
 	#
 	# We're trying to use sparse against glibc headers which go wild
diff --git a/utils.c b/utils.c
index 2a92416..9887f8b 100644
--- a/utils.c
+++ b/utils.c
@@ -29,6 +29,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
+#include <libudev.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <mntent.h>
@@ -52,6 +53,13 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+/*
+ * This variable controls if the lvm snapshot have to be skipped or not.
+ * Access this variable only via the btrfs_scan_[sg]et_skip_lvm_snapshot()
+ * functions
+ */
+static int __scan_device_skip_lvm_snapshot = -1;
+
 static int btrfs_scan_done = 0;
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
@@ -1593,6 +1601,9 @@ int btrfs_scan_block_devices(int run_ioctl)
 	char fullpath[110];
 	int scans = 0;
 	int special;
+	int skip_snapshot;
+
+	skip_snapshot = btrfs_scan_get_skip_lvm_snapshot();
 
 scan_again:
 	proc_partitions = fopen("/proc/partitions","r");
@@ -1642,6 +1653,9 @@ scan_again:
 			continue;
 		}
 
+		if (skip_snapshot && is_low_priority_device(fullpath))
+			continue;
+
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			if (errno != ENOMEDIUM)
@@ -2182,6 +2196,30 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
+int btrfs_scan_get_skip_lvm_snapshot( )
+{
+	const char *value;
+
+	if (__scan_device_skip_lvm_snapshot != -1 )
+		return __scan_device_skip_lvm_snapshot;
+
+	value = getenv(BTRFS_SKIP_LVM_SNAPSHOT_ENV_NAME);
+	if (value && !strcasecmp(value, "NO"))
+		__scan_device_skip_lvm_snapshot = 0;
+	else  if (value && !strcasecmp(value, "YES"))
+		__scan_device_skip_lvm_snapshot = 1;
+	else
+		__scan_device_skip_lvm_snapshot =
+			BTRFS_SKIP_LVM_SNAPSHOT_DEFAULT;
+
+	return __scan_device_skip_lvm_snapshot;
+}
+
+void btrfs_scan_set_skip_lvm_snapshot(int new_value)
+{
+	__scan_device_skip_lvm_snapshot = !!new_value;
+}
+
 int btrfs_scan_lblkid()
 {
 	int fd = -1;
@@ -2192,6 +2230,9 @@ int btrfs_scan_lblkid()
 	blkid_dev dev = NULL;
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
+	int skip_snapshot;
+
+	skip_snapshot = btrfs_scan_get_skip_lvm_snapshot();
 
 	if (btrfs_scan_done)
 		return 0;
@@ -2210,6 +2251,9 @@ int btrfs_scan_lblkid()
 		/* if we are here its definitely a btrfs disk*/
 		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 
+		if (skip_snapshot && is_low_priority_device(path))
+			continue;
+
 		fd = open(path, O_RDONLY);
 		if (fd < 0) {
 			printf("ERROR: could not open %s\n", path);
@@ -2450,3 +2494,66 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
 	}
 	return 1;
 }
+
+/*
+ * This function return 1 if the device (path) is consdered "LOW_PRIORITY" by
+ * LVM2 library. These device are typically the nsapshot.
+ * This function return < 0 in case of error; 0 otherwise.
+ */
+int is_low_priority_device(const char *path)
+{
+
+	struct udev *udev=NULL;
+	struct udev_device *dev;
+	struct udev_enumerate *enumerate=NULL;
+	struct udev_list_entry *devices;
+	struct udev_list_entry *node, *list;
+	int ret=-1;
+	const char *value, *syspath;
+	char *rpath=NULL;
+
+	rpath = realpath(path, NULL);
+	if (!rpath) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret=-2;
+		goto exit;
+	}
+
+	/* Create the udev object */
+	udev = udev_new();
+	if (!udev) {
+		fprintf(stderr, "ERROR: Can't create udev\n");
+		ret=-1;
+		goto exit;
+	}
+
+	enumerate = udev_enumerate_new(udev);
+	udev_enumerate_add_match_subsystem(enumerate, "block");
+	udev_enumerate_add_match_property(enumerate, "DEVNAME", rpath);
+	udev_enumerate_scan_devices(enumerate);
+
+	devices = udev_enumerate_get_list_entry(enumerate);
+	syspath = udev_list_entry_get_name(devices);
+
+	dev = udev_device_new_from_syspath(udev, syspath);
+
+	list = udev_device_get_properties_list_entry (dev);
+
+	ret = 0;
+	node = udev_list_entry_get_by_name(list, "DM_UDEV_LOW_PRIORITY_FLAG");
+	if (node) {
+		value = udev_list_entry_get_value(node);
+		if (value && !strcmp(value, "1"))
+			ret = 1;
+	}
+
+exit:
+	free(rpath);
+
+	/* Free the enumerator object */
+	udev_enumerate_unref(enumerate);
+
+	udev_unref(udev);
+
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 289e86b..9855f09 100644
--- a/utils.h
+++ b/utils.h
@@ -128,7 +128,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
-int btrfs_scan_lblkid(void);
+int btrfs_scan_lblkid();
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int find_mount_root(const char *path, char **mount_root);
 int get_device_info(int fd, u64 devid,
@@ -161,4 +161,11 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 
+#define BTRFS_SKIP_LVM_SNAPSHOT_DEFAULT 1
+#define BTRFS_SKIP_LVM_SNAPSHOT_ENV_NAME "BTRFS_SKIP_LVM_SNAPSHOT"
+
+int is_low_priority_device(const char *path);
+void btrfs_scan_set_skip_lvm_snapshot(int new_value);
+int btrfs_scan_get_skip_lvm_snapshot( );
+
 #endif
-- 
2.1.3

