Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3GHHeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 03:34:20 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r687YIHM019012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Jul 2013 07:34:19 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r687YIeh014719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Jul 2013 07:34:18 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r687YHhB020306
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Jul 2013 07:34:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/13] btrfs-progs: fix memory leaks of device_list_add()
Date: Mon,  8 Jul 2013 15:39:00 +0800
Message-Id: <1373269140-29733-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

memory allocated by device_list_add has to be freed, the
function introduced here device_list_remove() would just
go that.
however the challenging part is about where we would
call this function.

there are two ways its handled
 the threads calling open_ctree_broken(), open_ctree() and
 open_ctree_fd() (which leads call to device_list_add)
 would anyway call close_ctree() so we put device_list_remove()
 there which will take care of freeing memory.

 now for threads calling device_list_add() outside of
 open_ctree(), has to call device_list_remove() separately
 which can be called as a last function in the thread
 this patch just does that.

device_list_remove accepts() NULL (deletes entire list)
or fsid (which would delete only the fsid matched in the
device_fs list). As of now though all calling functions
use NULL, I see potential that we would use fsid when we
have to create a single device list using both the
device-tree and from the btrfs-kernel.

further, mkfs.c thread should call device_list_remove()
as well, however mkfs.c uses a lot of in-flight exits()
which makes it very difficult to bring in this fix into
mkfs.c.  I shall be doing it in a separate patch.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |    4 +++
 cmds-filesystem.c |   11 ++++++++-
 cmds-replace.c    |    2 +
 cmds-scrub.c      |    3 ++
 disk-io.c         |    1 +
 mkfs.c            |    1 +
 utils.h           |    1 +
 volumes.c         |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 volumes.h         |    3 ++
 9 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 9525fcf..e4a1f1b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -29,6 +29,7 @@
 #include "utils.h"
 
 #include "commands.h"
+#include "volumes.h"
 
 /* FIXME - imported cruft, fix sparse errors and warnings */
 #ifdef __CHECKER__
@@ -128,6 +129,7 @@ static int cmd_add_dev(int argc, char **argv)
 	}
 
 	close(fdmnt);
+	device_list_remove(NULL);
 	if (ret)
 		return ret+20;
 	else
@@ -213,6 +215,7 @@ static int cmd_scan_dev(int argc, char **argv)
 		int ret;
 		printf("Scanning for Btrfs filesystems\n");
 		ret = scan_for_btrfs(where, 1);
+		device_list_remove(NULL);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
@@ -397,6 +400,7 @@ static int cmd_dev_stats(int argc, char **argv)
 out:
 	free(di_args);
 	close(fdmnt);
+	device_list_remove(NULL);
 
 	return err;
 }
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a028e1d..1c26476 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -455,6 +455,7 @@ static int cmd_show(int argc, char **argv)
 		print_one_uuid(fs_devices);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
+	device_list_remove(NULL);
 	return 0;
 }
 
@@ -683,13 +684,19 @@ static const char * const cmd_label_usage[] = {
 
 static int cmd_label(int argc, char **argv)
 {
+	int ret;
 	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
 		usage(cmd_label_usage);
 
 	if (argc > 2)
-		return set_label(argv[1], argv[2]);
+		ret = set_label(argv[1], argv[2]);
 	else
-		return get_label(argv[1]);
+		ret = get_label(argv[1]);
+
+	if (is_existing_blk_or_reg_file(argv[1]))
+		device_list_remove(NULL);
+
+	return ret;
 }
 
 const struct cmd_group filesystem_cmd_group = {
diff --git a/cmds-replace.c b/cmds-replace.c
index c68986a..99a5abc 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -340,6 +340,7 @@ static int cmd_start_replace(int argc, char **argv)
 		}
 	}
 	close(fdmnt);
+	device_list_remove(NULL);
 	return 0;
 
 leave_with_error:
@@ -349,6 +350,7 @@ leave_with_error:
 		close(fdsrcdev);
 	if (fddstdev != -1)
 		close(fddstdev);
+	device_list_remove(NULL);
 	return -1;
 }
 
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 95dfee3..08aab54 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1496,6 +1496,7 @@ out:
 			unlink(sock_path);
 	}
 	close(fdmnt);
+	device_list_remove(NULL);
 
 	if (err)
 		return 1;
@@ -1564,6 +1565,7 @@ static int cmd_scrub_cancel(int argc, char **argv)
 out:
 	if (fdmnt != -1)
 		close(fdmnt);
+	device_list_remove(NULL);
 	return ret;
 }
 
@@ -1722,6 +1724,7 @@ out:
 	free(di_args);
 	if (fdres > -1)
 		close(fdres);
+	device_list_remove(NULL);
 
 	return err;
 }
diff --git a/disk-io.c b/disk-io.c
index 3937e3f..9b72576 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1338,6 +1338,7 @@ int close_ctree(struct btrfs_root *root)
 	}
 
 	close_all_devices(fs_info);
+	device_list_remove(NULL);
 	free_mapping_cache(fs_info);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
diff --git a/mkfs.c b/mkfs.c
index 95fceb3..5d131dd 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1461,6 +1461,7 @@ int main(int ac, char **av)
 		if (is_block_device(file))
 			if (test_dev_for_mkfs(file, force_overwrite, estr)) {
 				fprintf(stderr, "Error: %s", estr);
+				device_list_remove(NULL);
 				exit(1);
 			}
 	}
diff --git a/utils.h b/utils.h
index 1fa1c5a..f5b03a7 100644
--- a/utils.h
+++ b/utils.h
@@ -70,4 +70,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
+int is_existing_blk_or_reg_file(const char* filename);
 #endif
diff --git a/volumes.c b/volumes.c
index 00c384a..fa27055 100644
--- a/volumes.c
+++ b/volumes.c
@@ -87,7 +87,7 @@ static struct btrfs_fs_devices *find_fsid(u8 *fsid)
 	return NULL;
 }
 
-static int device_list_add(const char *path,
+int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
 {
@@ -155,6 +155,60 @@ static int device_list_add(const char *path,
 	return 0;
 }
 
+/* This will remove given fsid and it devices from the list,
+ * or when arg is NULL it will delete all.
+ */
+int device_list_remove(u8 *fsid)
+{
+	struct list_head *fsids;
+	struct list_head *cur_fsid;
+	struct btrfs_fs_devices *fs_devices;
+	struct list_head *cur_dev;
+	struct btrfs_device *device;
+	int del = 1;
+
+	fsids = btrfs_scanned_uuids();
+	list_for_each(cur_fsid, fsids) {
+		fs_devices = list_entry(cur_fsid, struct btrfs_fs_devices,
+				list);
+		if (fsid && memcmp(fs_devices->fsid, fsid, BTRFS_FSID_SIZE))
+			continue;
+
+		/* first check if all devs are closed before remove */
+		list_for_each(cur_dev, &fs_devices->devices) {
+			device = list_entry(cur_dev,
+					struct btrfs_device, dev_list);
+			if (device->fd > 0) {
+				fprintf(stderr, "attempted to remove device "\
+					"list without closing\n");
+				if (fsid)
+					return 1;
+				else {
+					del = 0;
+					break;
+				}
+			}
+		}
+
+		if (del) {
+			list_for_each(cur_dev, &fs_devices->devices) {
+				device = list_entry(cur_dev,
+					struct btrfs_device, dev_list);
+				list_del(&device->dev_list);
+				if (device->name)
+					kfree(device->name);
+				if (device->label)
+					kfree(device->label);
+				kfree(device);
+			}
+			list_del(&fs_devices->list);
+			kfree(fs_devices);
+		}
+		del = 1;
+	}
+	return 0;
+}
+
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
diff --git a/volumes.h b/volumes.h
index 911f788..55a0b71 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,4 +190,7 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+int device_list_add(const char *path, struct btrfs_super_block *disk_super,
+			   u64 devid, struct btrfs_fs_devices **fs_devices_ret);
+int device_list_remove(u8 *fsid);
 #endif
-- 
1.7.7.6

