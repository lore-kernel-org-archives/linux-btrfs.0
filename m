Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44699 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759557Ab3CHPYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2013 10:24:46 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r28FOiU7015765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:45 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r28FOicj007078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:44 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r28FOioP012895
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 09:24:44 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device
Date: Fri,  8 Mar 2013 23:25:00 +0800
Message-Id: <1362756300-30212-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>

bug:
-------
mkfs.btrfs /dev/sdb -f && yes| mkfs.ext4 /dev/sdb && mount /dev/sdb /ext4
mkfs.btrfs -f /dev/sdc /dev/sdd (run twice)
mkfs.btrfs -f /dev/sdc /dev/sdd
::
ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
adding device /dev/sdd id 2
fs created label (null) on /dev/sdc
	nodesize 4096 leafsize 4096 sectorsize 4096 size 3.11GB
--------

Since we run mkfs.btrfs twice above, there is already a stale
btrfs when mkfs.btrfs is run for the 2nd time. which kicks in
btrfs_scan_for_fsid() to perform a system-wide scan to find the
stale btrfs's partner (to check if that by any chance is mounted)
which in process comes across /dev/sdb. Now when it finds
/dev/sdb it finds that primary SB is not present and we need
to stop him there.
This is done by NOT setting BTRFS_SCAN_BACKUP_SB for the function
btrfs_scan_for_fsid(). To ensure rest of the logic is unaffected,
this patch will ensure BTRFS_SCAN_BACKUP_SB is set for all other
places except at check_mounted_where().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     | 3 ++-
 cmds-filesystem.c | 2 +-
 cmds-replace.c    | 3 ++-
 disk-io.c         | 7 ++++---
 find-root.c       | 5 +++--
 utils.c           | 9 ++++++---
 volumes.c         | 4 ++--
 volumes.h         | 2 +-
 8 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 1b8f378..9447e7f 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -203,7 +203,8 @@ static int cmd_scan_dev(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems\n");
 		if(checklist)
-			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER);
+			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER|
+						       BTRFS_SCAN_BACKUP_SB);
 		else
 			ret = btrfs_scan_one_dir("/dev", BTRFS_SCAN_REGISTER);
 		if (ret){
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..d2e708d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -257,7 +257,7 @@ static int cmd_show(int argc, char **argv)
 		usage(cmd_show_usage);
 
 	if(checklist)
-		ret = btrfs_scan_block_devices(0);
+		ret = btrfs_scan_block_devices(BTRFS_SCAN_BACKUP_SB);
 	else
 		ret = btrfs_scan_one_dir("/dev", 0);
 
diff --git a/cmds-replace.c b/cmds-replace.c
index 4cc32df..f6e1619 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -275,7 +275,8 @@ static int cmd_start_replace(int argc, char **argv)
 		goto leave_with_error;
 	}
 	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
+				    BTRFS_SCAN_BACKUP_SB);
 	if (ret >= 0 && !force_using_targetdev) {
 		fprintf(stderr,
 			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
diff --git a/disk-io.c b/disk-io.c
index 33e7e78..914b567 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -825,7 +825,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED);
 
 	ret = btrfs_scan_one_device(fp, path, &fs_devices,
-				    &total_devs, sb_bytenr);
+				    &total_devs, sb_bytenr,
+				    BTRFS_SCAN_BACKUP_SB);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
@@ -834,7 +835,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	if (total_devs != 1) {
 		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
-			BTRFS_SCAN_REGISTER);
+			BTRFS_SCAN_REGISTER|BTRFS_SCAN_BACKUP_SB);
 		if (ret)
 			goto out;
 	}
@@ -1102,7 +1103,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 }
 
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
-	u64 flags)
+			 u64 flags)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
diff --git a/find-root.c b/find-root.c
index c76de2b..40cacf1 100644
--- a/find-root.c
+++ b/find-root.c
@@ -102,7 +102,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	u64 features;
 
 	ret = btrfs_scan_one_device(fd, device, &fs_devices,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
+				    BTRFS_SCAN_BACKUP_SB);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", device);
@@ -111,7 +112,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	if (total_devs != 1) {
 		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
-			BTRFS_SCAN_REGISTER);
+			BTRFS_SCAN_REGISTER|BTRFS_SCAN_BACKUP_SB);
 		if (ret)
 			goto out;
 	}
diff --git a/utils.c b/utils.c
index feee572..95dee29 100644
--- a/utils.c
+++ b/utils.c
@@ -835,7 +835,8 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
+				    BTRFS_SCAN_BACKUP_SB);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
@@ -1032,7 +1033,8 @@ again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    BTRFS_SCAN_BACKUP_SB);
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1361,7 +1363,8 @@ scan_again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    flags);
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
diff --git a/volumes.c b/volumes.c
index b6e3f29..e1795e3 100644
--- a/volumes.c
+++ b/volumes.c
@@ -212,7 +212,7 @@ fail:
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset)
+			  u64 *total_devs, u64 super_offset, u64 flags)
 {
 	struct btrfs_super_block *disk_super;
 	char *buf;
@@ -227,7 +227,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
-		BTRFS_SCAN_BACKUP_SB);
+				flags);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
diff --git a/volumes.h b/volumes.h
index 911f788..f87aa5b 100644
--- a/volumes.h
+++ b/volumes.h
@@ -179,7 +179,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset);
+			  u64 *total_devs, u64 super_offset, u64 flags);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 			      struct btrfs_fs_devices *fs_devices);
-- 
1.8.1.191.g414c78c

