Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60402 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757518AbaIRDcl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 23:32:41 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: fix device missing of btrfs fi show with seeding devices
Date: Thu, 18 Sep 2014 11:31:46 +0800
Message-ID: <1411011106-21945-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1411011106-21945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1411011106-21945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*Note*: this handles the problem under umounted state,
	the problem under mounted state is already fixed by Anand.

Steps to reproduce:
	# mkfs.btrfs -f /dev/sda1
	# btrfstune -S 1 /dev/sda1
	# mount /dev/sda1 /mnt
	# btrfs dev add /dev/sda2 /mnt
	# umount /mnt			<== (umounted)
	# btrfs fi show /dev/sda2
result:
	Label: none  uuid: XXXXXXXXXXXXXXXXXX
	Total devices 2 FS bytes used 368.00KiB
	devid    2 size 9.31GiB used 1.25GiB path /dev/sda2
	*** Some devices missing
	Btrfs v3.16-67-g69f54ea-dirty

It is because the @btrfs_scan_lblkid procedure is not capable of detecting
seeding devices since the seeding devices have different FSIDs from
derived devices. So when it tries to show all devices under the derived
fs, only the derived devices are shown.
Actually the @open_ctree deal with the seeding devices properly, so
we can make use of it to find seeding devices.
We call @open_ctree on every block device with a btrfs on it,
and all devices under the opening filesystem including the seed devices
will be ready to be shown.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 104 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 69 insertions(+), 35 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index dc5185e..f978175 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -28,6 +28,7 @@
 #include <mntent.h>
 #include <linux/limits.h>
 #include <getopt.h>
+#include <blkid/blkid.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -268,10 +269,26 @@ static int cmp_device_id(void *priv, struct list_head *a,
 		da->devid > db->devid ? 1 : 0;
 }
 
+static void print_devices(struct btrfs_fs_devices *fs_devices, u64 *devs_found)
+{
+	struct btrfs_device *device;
+	struct list_head *cur;
+
+	list_sort(NULL, &fs_devices->devices, cmp_device_id);
+	list_for_each(cur, &fs_devices->devices) {
+		device = list_entry(cur, struct btrfs_device, dev_list);
+
+		printf("\tdevid %4llu size %s used %s path %s\n",
+			(unsigned long long)device->devid,
+			pretty_size(device->total_bytes),
+			pretty_size(device->bytes_used), device->name);
+			(*devs_found)++;
+		}
+}
+
 static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 {
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
-	struct list_head *cur;
 	struct btrfs_device *device;
 	u64 devs_found = 0;
 	u64 total;
@@ -293,17 +310,10 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	       (unsigned long long)total,
 	       pretty_size(device->super_bytes_used));
 
-	list_sort(NULL, &fs_devices->devices, cmp_device_id);
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
-
-		printf("\tdevid %4llu size %s used %s path %s\n",
-		       (unsigned long long)device->devid,
-		       pretty_size(device->total_bytes),
-		       pretty_size(device->bytes_used), device->name);
+	if (fs_devices->seed)
+		print_devices(fs_devices->seed, &devs_found);
+	print_devices(fs_devices, &devs_found);
 
-		devs_found++;
-	}
 	if (devs_found < total) {
 		printf("\t*** Some devices missing\n");
 	}
@@ -489,6 +499,53 @@ out:
 	return ret;
 }
 
+static int scan_all_fs_lblkid(char *search_target)
+{
+	blkid_dev_iterate iter = NULL;
+	blkid_dev dev = NULL;
+	blkid_cache cache = NULL;
+	char path[PATH_MAX];
+	struct btrfs_fs_info *fs_info;
+	int found = 0;
+
+	if (blkid_get_cache(&cache, 0) < 0) {
+		printf("ERROR: lblkid cache get failed\n");
+		return -1;
+	}
+	blkid_probe_all(cache);
+	iter = blkid_dev_iterate_begin(cache);
+	blkid_dev_set_search(iter, "TYPE", "btrfs");
+	while (blkid_dev_next(iter, &dev) == 0) {
+		dev = blkid_verify(cache, dev);
+		if (!dev)
+			continue;
+		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
+		fs_info = open_ctree_fs_info(path, 0, 0, OPEN_CTREE_PARTIAL);
+		if (!fs_info)
+			continue;
+
+		if (search_target
+			&& !uuid_search(fs_info->fs_devices, search_target)) {
+			close_ctree(fs_info->fs_root);
+			continue;
+		}
+
+		if (search_target)
+			found = 1;
+		print_one_uuid(fs_info->fs_devices);
+
+		close_ctree(fs_info->fs_root);
+	}
+	blkid_dev_iterate_end(iter);
+	blkid_put_cache(cache);
+
+	if (search_target && !found)
+		return 1;
+
+	return 0;
+}
+
+
 static const char * const cmd_show_usage[] = {
 	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
 	"Show the structure of a filesystem",
@@ -500,9 +557,6 @@ static const char * const cmd_show_usage[] = {
 
 static int cmd_show(int argc, char **argv)
 {
-	struct list_head *all_uuids;
-	struct btrfs_fs_devices *fs_devices;
-	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
 	int where = -1; // default, search both kernel and udev
@@ -511,7 +565,6 @@ static int cmd_show(int argc, char **argv)
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
 	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
-	int found = 0;
 
 	while (1) {
 		int long_index;
@@ -601,31 +654,12 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
-
+	ret = scan_all_fs_lblkid(search);
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 1;
 	}
 	
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
-					list);
-		if (search && uuid_search(fs_devices, search) == 0)
-			continue;
-
-		print_one_uuid(fs_devices);
-		found = 1;
-	}
-	if (search && !found)
-		ret = 1;
-
-	while (!list_empty(all_uuids)) {
-		fs_devices = list_entry(all_uuids->next,
-					struct btrfs_fs_devices, list);
-		btrfs_close_devices(fs_devices);
-	}
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	free_seen_fsid();
-- 
1.8.1.4

