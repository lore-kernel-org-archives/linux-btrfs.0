Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25587 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3DEFxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355r3su031944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:04 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355r3xn000342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:03 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355r33m016643
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:03 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: introduce passing flags to btrfs_scan_one_device
Date: Fri,  5 Apr 2013 13:54:17 +0800
Message-Id: <1365141259-10529-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
References: <5127022B.6070200@oracle.com>
 <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check_mounted would need to check backup SB to see if the
device is mounted to accommodate the situation when the
primary SB is corrupted (even in multi dev btrfs).
so we need flag to communicate to btrfs_read_dev_super
to check backup SB.

this patch will just introduce the flag with access
to backup SB disable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 2 +-
 disk-io.c      | 2 +-
 find-root.c    | 3 ++-
 utils.c        | 9 ++++++---
 volumes.c      | 2 +-
 volumes.h      | 2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..ab34388 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -280,7 +280,7 @@ static int cmd_start_replace(int argc, char **argv)
 		goto leave_with_error;
 	}
 	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0ull);
 	if (ret >= 0 && !force_using_targetdev) {
 		fprintf(stderr,
 			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
diff --git a/disk-io.c b/disk-io.c
index 8d68c2e..82c3b66 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -827,7 +827,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fprintf(stderr, "Warning, could not drop caches\n");
 
 	ret = btrfs_scan_one_device(fp, path, &fs_devices,
-				    &total_devs, sb_bytenr);
+				    &total_devs, sb_bytenr, 0ull);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
diff --git a/find-root.c b/find-root.c
index 0b08358..eac3d79 100644
--- a/find-root.c
+++ b/find-root.c
@@ -102,7 +102,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	u64 features;
 
 	ret = btrfs_scan_one_device(fd, device, &fs_devices,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
+				    0ull);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", device);
diff --git a/utils.c b/utils.c
index a15789e..3b46889 100644
--- a/utils.c
+++ b/utils.c
@@ -922,7 +922,8 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
+				    0ull);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
@@ -1121,7 +1122,8 @@ again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    0ull);
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1452,7 +1454,8 @@ scan_again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    0ull);
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
diff --git a/volumes.c b/volumes.c
index 1113cb5..a18b219 100644
--- a/volumes.c
+++ b/volumes.c
@@ -213,7 +213,7 @@ fail:
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset)
+			  u64 *total_devs, u64 super_offset, u64 flags)
 {
 	struct btrfs_super_block *disk_super;
 	char *buf;
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
1.8.1.227.g44fe835

