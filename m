Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaHTWYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 18:24:24 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMOOkb002641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:24:24 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMOMGO023567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:24:23 -0400
Message-ID: <53F5201B.6030504@redhat.com>
Date: Wed, 20 Aug 2014 17:24:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: remove BTRFS_SCAN_DEV and btrfs_scan_one_dir
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the previous 2 patches, nothing uses
whole-dev-tree scanning, so remove the code which
implemented that functionality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/utils.c b/utils.c
index 12ed7a2..765a214 100644
--- a/utils.c
+++ b/utils.c
@@ -1228,117 +1228,6 @@ void btrfs_register_one_device(char *fname)
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
@@ -2291,9 +2180,6 @@ int scan_for_btrfs(int where, int update_kernel)
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
index 0c9b65f..3a05131 100644
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
 
@@ -70,7 +69,6 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(int run_ioctls);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 char *canonicalize_dm_name(const char *ptname);
 char *canonicalize_path(const char *path);
 int check_mounted(const char *devicename);

