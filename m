Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30458 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaIMJLu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 05:11:50 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8D9BnBF031284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:50 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s8D9BnD8004798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:49 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s8D9Bm3E004781
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: remove BTRFS_SCAN_DEV and btrfs_scan_one_dir
Date: Sat, 13 Sep 2014 09:21:20 +0800
Message-Id: <1410571282-3482-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
References: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

After the previous 2 patches, nothing uses
whole-dev-tree scanning, so remove the code which
implemented that functionality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 114 ----------------------------------------------------------------
 utils.h |   6 ++--
 2 files changed, 2 insertions(+), 118 deletions(-)

diff --git a/utils.c b/utils.c
index cf7635c..901127f 100644
--- a/utils.c
+++ b/utils.c
@@ -1225,117 +1225,6 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
-{
-	DIR *dirp = NULL;
-	struct dirent *dirent;
-	struct pending_dir *pending;
-	struct stat st;
-	int ret;
-	int fd;
-	int dirname_len;
-	char *fullpath;
-	struct list_head pending_list;
-	struct btrfs_fs_devices *tmp_devices;
-	u64 num_devices;
-
-	INIT_LIST_HEAD(&pending_list);
-
-	pending = malloc(sizeof(*pending));
-	if (!pending)
-		return -ENOMEM;
-	strcpy(pending->name, dirname);
-
-again:
-	dirname_len = strlen(pending->name);
-	fullpath = malloc(PATH_MAX);
-	dirname = pending->name;
-
-	if (!fullpath) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-	dirp = opendir(dirname);
-	if (!dirp) {
-		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
-		ret = -errno;
-		goto fail;
-	}
-	while(1) {
-		dirent = readdir(dirp);
-		if (!dirent)
-			break;
-		if (dirent->d_name[0] == '.')
-			continue;
-		if (dirname_len + strlen(dirent->d_name) + 2 > PATH_MAX) {
-			ret = -EFAULT;
-			goto fail;
-		}
-		snprintf(fullpath, PATH_MAX, "%s/%s", dirname, dirent->d_name);
-		ret = lstat(fullpath, &st);
-		if (ret < 0) {
-			fprintf(stderr, "failed to stat %s\n", fullpath);
-			continue;
-		}
-		if (S_ISLNK(st.st_mode))
-			continue;
-		if (S_ISDIR(st.st_mode)) {
-			struct pending_dir *next = malloc(sizeof(*next));
-			if (!next) {
-				ret = -ENOMEM;
-				goto fail;
-			}
-			strcpy(next->name, fullpath);
-			list_add_tail(&next->list, &pending_list);
-		}
-		if (!S_ISBLK(st.st_mode)) {
-			continue;
-		}
-		fd = open(fullpath, O_RDONLY);
-		if (fd < 0) {
-			/* ignore the following errors:
-				ENXIO (device don't exists) 
-				ENOMEDIUM (No medium found -> 
-					like a cd tray empty)
-			*/
-			if(errno != ENXIO && errno != ENOMEDIUM) 
-				fprintf(stderr, "failed to read %s: %s\n", 
-					fullpath, strerror(errno));
-			continue;
-		}
-		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
-					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET, 0);
-		if (ret == 0 && run_ioctl > 0) {
-			btrfs_register_one_device(fullpath);
-		}
-		close(fd);
-	}
-	if (!list_empty(&pending_list)) {
-		free(pending);
-		pending = list_entry(pending_list.next, struct pending_dir,
-				     list);
-		free(fullpath);
-		list_del(&pending->list);
-		closedir(dirp);
-		dirp = NULL;
-		goto again;
-	}
-	ret = 0;
-fail:
-	free(pending);
-	free(fullpath);
-	while (!list_empty(&pending_list)) {
-		pending = list_entry(pending_list.next, struct pending_dir,
-				     list);
-		list_del(&pending->list);
-		free(pending);
-	}
-	if (dirp)
-		closedir(dirp);
-	return ret;
-}
-
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset)
 {
@@ -2247,9 +2136,6 @@ int scan_for_btrfs(int where, int update_kernel)
 	case BTRFS_SCAN_PROC:
 		ret = btrfs_scan_block_devices(update_kernel);
 		break;
-	case BTRFS_SCAN_DEV:
-		ret = btrfs_scan_one_dir("/dev", update_kernel);
-		break;
 	case BTRFS_SCAN_LBLKID:
 		ret = btrfs_scan_lblkid(update_kernel);
 		break;
diff --git a/utils.h b/utils.h
index 26c767b..52a9dfc 100644
--- a/utils.h
+++ b/utils.h
@@ -27,9 +27,8 @@
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
 
 #define BTRFS_SCAN_PROC		(1ULL << 0)
-#define BTRFS_SCAN_DEV		(1ULL << 1)
-#define BTRFS_SCAN_MOUNTED	(1ULL << 2)
-#define BTRFS_SCAN_LBLKID	(1ULL << 3)
+#define BTRFS_SCAN_MOUNTED	(1ULL << 1)
+#define BTRFS_SCAN_LBLKID	(1ULL << 2)
 
 #define BTRFS_UPDATE_KERNEL	1
 
@@ -62,7 +61,6 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(int run_ioctls);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 char *canonicalize_dm_name(const char *ptname);
 char *canonicalize_path(const char *path);
 int check_mounted(const char *devicename);
-- 
2.0.0.153.g79dcccc

