Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37302 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLVCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 17:02:00 -0400
Received: by mail-pd0-f171.google.com with SMTP id ft15so4589757pdb.30
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 14:01:59 -0700 (PDT)
Received: from target.stec-inc.ad (pat.hitachigst.com. [199.255.44.5])
        by mx.google.com with ESMTPSA id oo8sm9220438pdb.86.2014.10.12.14.01.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 12 Oct 2014 14:01:58 -0700 (PDT)
From: neo <cknvme@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] [PATCH]Btrfs-prog: uniform error handling for utils.c
Date: Sun, 12 Oct 2014 14:01:56 -0700
Message-Id: <1413147716-7478-1-git-send-email-cknvme@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 Makefile         |   4 +-
 btrfs-syscalls.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-syscalls.h |  55 +++++++++++++++
 kerncompat.h     |   5 +-
 utils.c          | 200 +++++++++++++++++++++++++++----------------------------
 5 files changed, 337 insertions(+), 107 deletions(-)
 create mode 100644 btrfs-syscalls.c
 create mode 100644 btrfs-syscalls.h

diff --git a/Makefile b/Makefile
index 18eb944..d738f20 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ CC = gcc
 LN = ln
 AR = ar
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing
+CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
@@ -17,7 +17,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
-		   uuid-tree.o utils-lib.o
+		   uuid-tree.o utils-lib.o btrfs-syscalls.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
diff --git a/btrfs-syscalls.c b/btrfs-syscalls.c
new file mode 100644
index 0000000..b4d791b
--- /dev/null
+++ b/btrfs-syscalls.c
@@ -0,0 +1,180 @@
+/*******************************************************************************
+ *      File Name   :   btrfs-syscalls.c
+ *      Description :   This file contains system call wrapper functions with
+ *                      uniform error handling.
+ ******************************************************************************/
+#include "btrfs-syscalls.h"
+
+#define BKTRACE_BUFFER_SIZE 1024
+
+int err_verbose = 0;
+static void *buf[BKTRACE_BUFFER_SIZE];
+
+void
+btrfs_backtrace(void)
+{
+    int i;
+    int nptrs;
+    char **entries;
+
+    fprintf(stderr, "Call trace:\n");
+    nptrs = backtrace(buf, BKTRACE_BUFFER_SIZE);
+    entries = backtrace_symbols(buf, nptrs);
+    if (entries == NULL) {
+        fprintf(stderr, "ERROR: backtrace_symbols\n");
+        exit(EXIT_FAILURE);
+    }
+    for (i = 0; i < nptrs; i++) {
+        if (strstr(entries[i], "btrfs_backtrace") == NULL);
+            fprintf(stderr, "\t%s\n", entries[i]);
+    }
+    free(entries);
+}
+
+int
+btrfs_open(const char *pathname, int flags)
+{
+    int ret;
+
+    if ((ret = open(pathname, flags)) < 0)
+        SYS_ERROR("open : %s", pathname);
+
+    return ret;
+}
+
+int
+btrfs_close(int fd)
+{
+    int ret;
+
+    if ((ret = close(fd)) < 0)
+        SYS_ERROR("close :");
+
+    return ret;
+}
+
+int
+btrfs_stat(const char *path, struct stat *buf)
+{
+    int ret;
+
+    if ((ret = stat(path, buf)) < 0)
+        SYS_ERROR("stat : %s", path);
+
+    return ret;
+}
+
+int
+btrfs_lstat(const char *path, struct stat *buf)
+{
+    int ret;
+
+    if ((ret = lstat(path, buf)) < 0) {
+        SYS_ERROR("lstat : %s", path);
+    }
+
+    return ret;
+}
+
+int
+btrfs_fstat(int fd, struct stat *buf)
+{
+    int ret;
+
+    if ((ret = fstat(fd, buf)) < 0)
+        SYS_ERROR("fstat :");
+
+    return ret;
+}
+
+void*
+btrfs_malloc(size_t size)
+{
+    void *p;
+
+    if ((p = malloc(size)) == NULL) {
+        if (size != 0)
+            SYS_ERROR("malloc :");
+    }
+
+    return p;
+}
+
+void*
+btrfs_calloc(size_t nmemb, size_t size)
+{
+    void *p;
+
+    if ((p = calloc(nmemb, size)) == NULL) {
+        if (size != 0)
+            SYS_ERROR("calloc :");
+    }
+
+    return p;
+}
+
+FILE*
+btrfs_fopen(const char *path, const char *mode)
+{
+    FILE *f;
+
+    if ((f = fopen(path, mode)) == NULL)
+        SYS_ERROR("fopen : %s", path);
+
+    return f;
+}
+
+DIR*
+btrfs_opendir(const char *name)
+{
+    DIR *d;
+
+    if ((d = opendir(name)) == NULL)
+        SYS_ERROR("opendir :");
+
+    return d;
+}
+
+int
+btrfs_dirfd(DIR *dirp)
+{
+    int fd;
+
+    if ((fd = dirfd(dirp)) < 0)
+        SYS_ERROR("dirfd :");
+
+    return fd;
+}
+
+int
+btrfs_closedir(DIR *dirp)
+{
+    int ret;
+
+    if ((ret = closedir(dirp)) < 0)
+        SYS_ERROR("closedir :");
+
+    return ret;
+}
+
+ssize_t
+btrfs_pwrite(int fd, const void *buf, size_t count, off_t offset)
+{
+    ssize_t ret;
+
+    if ((ret = pwrite(fd, buf, count, offset)) < 0)
+       SYS_ERROR("pwrite :");
+
+    return ret;
+}
+
+ssize_t
+btrfs_pread(int fd, const void *buf, size_t count, off_t offset)
+{
+    ssize_t ret;
+
+    if ((ret = pread(fd, buf, count, offset)) < 0)
+       SYS_ERROR("pread :");
+
+    return ret;
+}
diff --git a/btrfs-syscalls.h b/btrfs-syscalls.h
new file mode 100644
index 0000000..2c717bf
--- /dev/null
+++ b/btrfs-syscalls.h
@@ -0,0 +1,55 @@
+#ifndef __BTRFS_SYSCALLS_H__
+#define __BTRFS_SYSCALLS_H__
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <execinfo.h>
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdlib.h>
+
+
+extern int err_verbose;
+#define SYS_ERROR(M, ...)\
+    do {\
+        int e;\
+        e = errno;\
+        switch (err_verbose) {\
+            case 0:\
+                fprintf(stderr, "ERROR: " M " %s\n", ##__VA_ARGS__,\
+                        strerror(errno));\
+                break;\
+            case 1:\
+                fprintf(stderr, "ERROR: %s: %s: %d: " M " %s\n", __FILE__, __func__,\
+                        __LINE__,  ##__VA_ARGS__, strerror(errno));\
+                break;\
+            case 2:\
+                btrfs_backtrace();\
+                fprintf(stderr, "ERROR: %s: %s: %d: " M " %s\n", __FILE__, __func__,\
+                        __LINE__,  ##__VA_ARGS__, strerror(errno));\
+                break;\
+        }\
+        errno = e;\
+    } while (0);
+
+int btrfs_open(const char *pathname, int flags);
+int btrfs_close(int fd);
+int btrfs_stat(const char *path, struct stat *buf);
+int btrfs_fstat(int fd, struct stat *buf);
+int btrfs_lstat(const char *path, struct stat *buf);
+void* btrfs_malloc(size_t size);
+void* btrfs_calloc(size_t nmemb, size_t size);
+void btrfs_free(void *ptr);
+FILE* btrfs_fopen(const char *path, const char *mode);
+DIR* btrfs_opendir(const char *name);
+int btrfs_dirfd(DIR *dirp);
+int btrfs_closedir(DIR *dirp);
+ssize_t btrfs_pwrite(int fd, const void *buf, size_t count, off_t offset);
+ssize_t btrfs_pread(int fd, const void *buf, size_t count, off_t offset);
+void btrfs_backtrace(void);
+#endif /* EOF __BTRFS_SYSCALLS_H__ */
diff --git a/kerncompat.h b/kerncompat.h
index bb03194..4542318 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,6 +29,7 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
+#include "btrfs-syscalls.h"
 
 #define ptr_to_u64(x)	((u64)(uintptr_t)x)
 #define u64_to_ptr(x)	((void *)(uintptr_t)x)
@@ -232,8 +233,8 @@ static inline long IS_ERR(const void *ptr)
 /*
  * kmalloc/kfree
  */
-#define kmalloc(x, y) malloc(x)
-#define kzalloc(x, y) calloc(1, x)
+#define kmalloc(x, y) btrfs_malloc(x)
+#define kzalloc(x, y) btrfs_calloc(1, x)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
diff --git a/utils.c b/utils.c
index c4f2a00..f18c4ae 100644
--- a/utils.c
+++ b/utils.c
@@ -47,6 +47,7 @@
 #include "utils.h"
 #include "volumes.h"
 #include "ioctl.h"
+#include "btrfs-syscalls.h"
 
 #ifndef BLKDISCARD
 #define BLKDISCARD	_IO(0x12,119)
@@ -105,8 +106,11 @@ static int discard_range(int fd, u64 start, u64 len)
 {
 	u64 range[2] = { start, len };
 
-	if (ioctl(fd, BLKDISCARD, &range) < 0)
+	if (ioctl(fd, BLKDISCARD, &range) < 0) {
+		if (err_verbose > 1)
+			SYS_ERROR("ioctl : BLKDISCARD ");
 		return errno;
+	}
 	return 0;
 }
 
@@ -236,7 +240,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	if (label)
 		strncpy(super.label, label, BTRFS_LABEL_SIZE - 1);
 
-	buf = malloc(sizeof(*buf) + max(sectorsize, leafsize));
+	buf = btrfs_malloc(sizeof(*buf) + max(sectorsize, leafsize));
 
 	/* create the tree of root objects */
 	memset(buf->data, 0, leafsize);
@@ -319,7 +323,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 
 
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[1]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[1]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -378,7 +382,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[2]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -465,7 +469,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[3]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -504,7 +508,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[4]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -517,7 +521,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[5]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -529,7 +533,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, leafsize, blocks[6]);
+	ret = btrfs_pwrite(fd, buf->data, leafsize, blocks[6]);
 	if (ret != leafsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -541,7 +545,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
 	memcpy(buf->data, &super, sizeof(super));
 	buf->len = sectorsize;
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
+	ret = btrfs_pwrite(fd, buf->data, sectorsize, blocks[0]);
 	if (ret != sectorsize) {
 		ret = (ret < 0 ? -errno : -EIO);
 		goto out;
@@ -565,20 +569,22 @@ u64 btrfs_device_size(int fd, struct stat *st)
 	}
 	if (ioctl(fd, BLKGETSIZE64, &size) >= 0) {
 		return size;
+	} else {
+		SYS_ERROR("ioctl : BLKGETSIZE64 ");
 	}
 	return 0;
 }
 
 static int zero_blocks(int fd, off_t start, size_t len)
 {
-	char *buf = malloc(len);
+	char *buf = btrfs_malloc(len);
 	int ret = 0;
 	ssize_t written;
 
 	if (!buf)
 		return -ENOMEM;
 	memset(buf, 0, len);
-	written = pwrite(fd, buf, len, start);
+	written = btrfs_pwrite(fd, buf, len, start);
 	if (written != len)
 		ret = -EIO;
 	free(buf);
@@ -669,7 +675,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_device_bytes_used(dev_item, device->bytes_used);
 	memcpy(&dev_item->uuid, device->uuid, BTRFS_UUID_SIZE);
 
-	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
+	ret = btrfs_pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
 	BUG_ON(ret != sectorsize);
 
 	kfree(buf);
@@ -685,7 +691,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	struct stat st;
 	int i, ret;
 
-	ret = fstat(fd, &st);
+	ret = btrfs_fstat(fd, &st);
 	if (ret < 0) {
 		fprintf(stderr, "unable to stat %s\n", file);
 		return 1;
@@ -781,7 +787,7 @@ int is_block_device(const char *path)
 {
 	struct stat statbuf;
 
-	if (stat(path, &statbuf) < 0)
+	if (btrfs_stat(path, &statbuf) < 0)
 		return -errno;
 
 	return S_ISBLK(statbuf.st_mode);
@@ -834,7 +840,7 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size)
 		goto out;
 	}
 
-	fd = open(dev, O_RDONLY);
+	fd = btrfs_open(dev, O_RDONLY);
 	if (fd < 0) {
 		ret = -errno;
 		fprintf(stderr, "Could not open %s: %s\n", dev, strerror(errno));
@@ -849,7 +855,7 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size)
 	}
 out:
 	if (fd != -1)
-		close(fd);
+		btrfs_close(fd);
 	return ret;
 }
 
@@ -886,7 +892,7 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 static int is_loop_device (const char* device) {
 	struct stat statbuf;
 
-	if(stat(device, &statbuf) < 0)
+	if(btrfs_stat(device, &statbuf) < 0)
 		return -errno;
 
 	return (S_ISBLK(statbuf.st_mode) &&
@@ -908,7 +914,7 @@ static int resolve_loop_device(const char* loop_dev, char* loop_file,
 	if (!realpath(loop_dev, real_loop_dev))
 		return -errno;
 	snprintf(p, PATH_MAX, "/sys/block/%s/loop/backing_file", strrchr(real_loop_dev, '/'));
-	if (!(f = fopen(p, "r")))
+	if (!(f = btrfs_fopen(p, "r")))
 		return -errno;
 
 	snprintf(fmt, 20, "%%%i[^\n]", max_len-1);
@@ -939,8 +945,8 @@ static int is_same_blk_file(const char* a, const char* b)
 	if(strcmp(real_a, real_b) == 0)
 		return 1;
 
-	if(stat(a, &st_buf_a) < 0 ||
-	   stat(b, &st_buf_b) < 0)
+	if(btrfs_stat(a, &st_buf_a) < 0 ||
+	   btrfs_stat(b, &st_buf_b) < 0)
 	{
 		if (errno == ENOENT)
 			return 0;
@@ -1020,7 +1026,7 @@ static int is_existing_blk_or_reg_file(const char* filename)
 {
 	struct stat st_buf;
 
-	if(stat(filename, &st_buf) < 0) {
+	if(btrfs_stat(filename, &st_buf) < 0) {
 		if(errno == ENOENT)
 			return 0;
 		else
@@ -1067,7 +1073,7 @@ char *canonicalize_dm_name(const char *ptname)
 		return NULL;
 
 	snprintf(path, sizeof(path), "/sys/block/%s/dm/name", ptname);
-	if (!(f = fopen(path, "r")))
+	if (!(f = btrfs_fopen(path, "r")))
 		return NULL;
 
 	/* read <name>\n from sysfs */
@@ -1119,14 +1125,14 @@ int check_mounted(const char* file)
 	int fd;
 	int ret;
 
-	fd = open(file, O_RDONLY);
+	fd = btrfs_open(file, O_RDONLY);
 	if (fd < 0) {
 		fprintf (stderr, "check_mounted(): Could not open %s\n", file);
 		return -errno;
 	}
 
 	ret =  check_mounted_where(fd, file, NULL, 0, NULL);
-	close(fd);
+	btrfs_close(fd);
 
 	return ret;
 }
@@ -1205,24 +1211,20 @@ void btrfs_register_one_device(char *fname)
 	struct btrfs_ioctl_vol_args args;
 	int fd;
 	int ret;
-	int e;
 
-	fd = open("/dev/btrfs-control", O_RDONLY);
+	fd = btrfs_open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "failed to open /dev/btrfs-control "
-			"skipping device registration: %s\n",
-			strerror(errno));
+			"skipping device registration.");
 		return;
 	}
 	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
 	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
-	e = errno;
 	if(ret<0){
-		fprintf(stderr, "ERROR: device scan failed '%s' - %s\n",
-			fname, strerror(e));
+		SYS_ERROR("ioctl : BTRFS_IOC_SCAN_DEV : device scan failed %s", fname)
 	}
-	close(fd);
+	btrfs_close(fd);
 }
 
 int btrfs_scan_one_dir(char *dirname, int run_ioctl)
@@ -1241,21 +1243,21 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 
 	INIT_LIST_HEAD(&pending_list);
 
-	pending = malloc(sizeof(*pending));
+	pending = btrfs_malloc(sizeof(*pending));
 	if (!pending)
 		return -ENOMEM;
 	strcpy(pending->name, dirname);
 
 again:
 	dirname_len = strlen(pending->name);
-	fullpath = malloc(PATH_MAX);
+	fullpath = btrfs_malloc(PATH_MAX);
 	dirname = pending->name;
 
 	if (!fullpath) {
 		ret = -ENOMEM;
 		goto fail;
 	}
-	dirp = opendir(dirname);
+	dirp = btrfs_opendir(dirname);
 	if (!dirp) {
 		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
 		ret = -errno;
@@ -1272,15 +1274,14 @@ again:
 			goto fail;
 		}
 		snprintf(fullpath, PATH_MAX, "%s/%s", dirname, dirent->d_name);
-		ret = lstat(fullpath, &st);
+		ret = btrfs_lstat(fullpath, &st);
 		if (ret < 0) {
-			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
 		}
 		if (S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
-			struct pending_dir *next = malloc(sizeof(*next));
+			struct pending_dir *next = btrfs_malloc(sizeof(*next));
 			if (!next) {
 				ret = -ENOMEM;
 				goto fail;
@@ -1291,7 +1292,7 @@ again:
 		if (!S_ISBLK(st.st_mode)) {
 			continue;
 		}
-		fd = open(fullpath, O_RDONLY);
+		fd = btrfs_open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			/* ignore the following errors:
 				ENXIO (device don't exists) 
@@ -1299,8 +1300,8 @@ again:
 					like a cd tray empty)
 			*/
 			if(errno != ENXIO && errno != ENOMEDIUM) 
-				fprintf(stderr, "failed to read %s: %s\n", 
-					fullpath, strerror(errno));
+				fprintf(stderr, "failed to read %s\n", 
+					fullpath);
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
@@ -1309,7 +1310,7 @@ again:
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
+		btrfs_close(fd);
 	}
 	if (!list_empty(&pending_list)) {
 		free(pending);
@@ -1317,7 +1318,7 @@ again:
 				     list);
 		free(fullpath);
 		list_del(&pending->list);
-		closedir(dirp);
+		btrfs_closedir(dirp);
 		dirp = NULL;
 		goto again;
 	}
@@ -1332,7 +1333,7 @@ fail:
 		free(pending);
 	}
 	if (dirp)
-		closedir(dirp);
+		btrfs_closedir(dirp);
 	return ret;
 }
 
@@ -1353,12 +1354,12 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 	char *buf;
 	int ret = 0;
 
-	buf = malloc(BTRFS_SUPER_INFO_SIZE);
+	buf = btrfs_malloc(BTRFS_SUPER_INFO_SIZE);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = pread(fd, buf, BTRFS_SUPER_INFO_SIZE, super_offset);
+	ret = btrfs_pread(fd, buf, BTRFS_SUPER_INFO_SIZE, super_offset);
 	if (ret != BTRFS_SUPER_INFO_SIZE)
 		goto brelse;
 
@@ -1484,20 +1485,18 @@ static int set_label_mounted(const char *mount_path, const char *label)
 {
 	int fd;
 
-	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	fd = btrfs_open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable to access '%s'\n", mount_path);
 		return -1;
 	}
 
 	if (ioctl(fd, BTRFS_IOC_SET_FSLABEL, label) < 0) {
-		fprintf(stderr, "ERROR: unable to set label %s\n",
-			strerror(errno));
-		close(fd);
+		SYS_ERROR("ioctl : BTRFS_IOC_SET_FSLABEL : unable to set label %s", mount_path);
+		btrfs_close(fd);
 		return -1;
 	}
 
-	close(fd);
+	btrfs_close(fd);
 	return 0;
 }
 
@@ -1541,21 +1540,20 @@ int get_label_mounted(const char *mount_path, char *labelp)
 	char label[BTRFS_LABEL_SIZE];
 	int fd;
 
-	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	fd = btrfs_open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable to access '%s'\n", mount_path);
 		return -1;
 	}
 
 	memset(label, '\0', sizeof(label));
 	if (ioctl(fd, BTRFS_IOC_GET_FSLABEL, label) < 0) {
-		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
-		close(fd);
+		SYS_ERROR("ioctl : BTRFS_IOC_GET_FSLABEL : unable to get label %s", mount_path);
+		btrfs_close(fd);
 		return -1;
 	}
 
 	strncpy(labelp, label, sizeof(label));
-	close(fd);
+	btrfs_close(fd);
 	return 0;
 }
 
@@ -1604,7 +1602,7 @@ int btrfs_scan_block_devices(int run_ioctl)
 	int special;
 
 scan_again:
-	proc_partitions = fopen("/proc/partitions","r");
+	proc_partitions = btrfs_fopen("/proc/partitions","r");
 	if (!proc_partitions) {
 		fprintf(stderr, "Unable to open '/proc/partitions' for scanning\n");
 		return -ENOENT;
@@ -1637,7 +1635,7 @@ scan_again:
 		if (scans > 0 && !special)
 			continue;
 
-		ret = lstat(fullpath, &st);
+		ret = btrfs_lstat(fullpath, &st);
 		if (ret < 0) {
 			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
@@ -1646,11 +1644,9 @@ scan_again:
 			continue;
 		}
 
-		fd = open(fullpath, O_RDONLY);
+		fd = btrfs_open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			if (errno != ENOMEDIUM)
-				fprintf(stderr, "failed to open %s: %s\n",
-					fullpath, strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
@@ -1659,7 +1655,7 @@ scan_again:
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
+		btrfs_close(fd);
 	}
 
 	fclose(proc_partitions);
@@ -1765,17 +1761,17 @@ int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
 	struct stat st;
 	int fd;
 
-	ret = stat(fname, &st);
+	ret = btrfs_stat(fname, &st);
 	if (ret < 0) {
 		return -1;
 	}
 	if (S_ISDIR(st.st_mode)) {
-		*dirstream = opendir(fname);
+		*dirstream = btrfs_opendir(fname);
 		if (!*dirstream)
 			return -1;
-		fd = dirfd(*dirstream);
+		fd = btrfs_dirfd(*dirstream);
 	} else if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
-		fd = open(fname, open_flags);
+		fd = btrfs_open(fname, open_flags);
 	} else {
 		/*
 		 * we set this on purpose, in case the caller output
@@ -1787,7 +1783,7 @@ int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
 	if (fd < 0) {
 		fd = -1;
 		if (*dirstream)
-			closedir(*dirstream);
+			btrfs_closedir(*dirstream);
 	}
 	return fd;
 }
@@ -1800,9 +1796,9 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
 void close_file_or_dir(int fd, DIR *dirstream)
 {
 	if (dirstream)
-		closedir(dirstream);
+		btrfs_closedir(dirstream);
 	else if (fd >= 0)
-		close(fd);
+		btrfs_close(fd);
 }
 
 int get_device_info(int fd, u64 devid,
@@ -1813,7 +1809,9 @@ int get_device_info(int fd, u64 devid,
 	di_args->devid = devid;
 	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
 
-	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
+	if ((ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args)) < 0) {
+		SYS_ERROR("ioctl : BTRFS_IOC_DEV_INFO ");
+	}
 	return ret ? -errno : 0;
 }
 
@@ -1847,11 +1845,9 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		u64 devid;
 
 		/* Ensure it's mounted, then set path to the mountpoint */
-		fd = open(path, O_RDONLY);
+		fd = btrfs_open(path, O_RDONLY);
 		if (fd < 0) {
 			ret = -errno;
-			fprintf(stderr, "Couldn't open %s: %s\n",
-				path, strerror(errno));
 			goto out;
 		}
 		ret = check_mounted_where(fd, path, mp, sizeof(mp),
@@ -1879,7 +1875,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		i = devid;
 
 		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
-		close(fd);
+		btrfs_close(fd);
 	}
 
 	/* at this point path must not be for a block device */
@@ -1893,6 +1889,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	if (fi_args->num_devices != 1) {
 		ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
 		if (ret < 0) {
+			SYS_ERROR("ioctl : BTRFS_IOC_FS_INFO ");
 			ret = -errno;
 			goto out;
 		}
@@ -1901,7 +1898,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	if (!fi_args->num_devices)
 		goto out;
 
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	di_args = *di_ret = btrfs_malloc(fi_args->num_devices * sizeof(*di_args));
 	if (!di_args) {
 		ret = -errno;
 		goto out;
@@ -1962,7 +1959,7 @@ static int is_swap_device(const char *file)
 	char	*cp;
 	int	ret = 0;
 
-	if (stat(file, &st_buf) < 0)
+	if (btrfs_stat(file, &st_buf) < 0)
 		return -errno;
 	if (S_ISBLK(st_buf.st_mode))
 		dev = st_buf.st_rdev;
@@ -1972,7 +1969,7 @@ static int is_swap_device(const char *file)
 	} else
 		return 0;
 
-	if ((f = fopen("/proc/swaps", "r")) == NULL)
+	if ((f = btrfs_fopen("/proc/swaps", "r")) == NULL)
 		return 0;
 
 	/* skip the first line */
@@ -1985,7 +1982,7 @@ static int is_swap_device(const char *file)
 		if ((cp = strchr(tmp, '\t')) != NULL)
 			*cp = '\0';
 		translate(tmp, buf);
-		if (stat(buf, &st_buf) != 0)
+		if (btrfs_stat(buf, &st_buf) != 0)
 			continue;
 		if (S_ISBLK(st_buf.st_mode)) {
 			if (dev == st_buf.st_rdev) {
@@ -2165,24 +2162,24 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 		return 1;
 	}
 	/* check if the device is busy */
-	fd = open(file, O_RDWR|O_EXCL);
+	fd = btrfs_open(file, O_RDWR|O_EXCL);
 	if (fd < 0) {
 		snprintf(estr, sz, "unable to open %s: %s\n", file,
 			strerror(errno));
 		return 1;
 	}
-	if (fstat(fd, &st)) {
+	if (btrfs_fstat(fd, &st)) {
 		snprintf(estr, sz, "unable to stat %s: %s\n", file,
 			strerror(errno));
-		close(fd);
+		btrfs_close(fd);
 		return 1;
 	}
 	if (!S_ISBLK(st.st_mode)) {
 		fprintf(stderr, "'%s' is not a block device\n", file);
-		close(fd);
+		btrfs_close(fd);
 		return 1;
 	}
-	close(fd);
+	btrfs_close(fd);
 	return 0;
 }
 
@@ -2211,7 +2208,7 @@ int btrfs_scan_lblkid(int update_kernel)
 		/* if we are here its definitely a btrfs disk*/
 		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 
-		fd = open(path, O_RDONLY);
+		fd = btrfs_open(path, O_RDONLY);
 		if (fd < 0) {
 			printf("ERROR: could not open %s\n", path);
 			continue;
@@ -2261,24 +2258,24 @@ int is_vol_small(char *file)
 	struct stat st;
 	u64 size;
 
-	fd = open(file, O_RDONLY);
+	fd = btrfs_open(file, O_RDONLY);
 	if (fd < 0)
 		return -errno;
-	if (fstat(fd, &st) < 0) {
+	if (btrfs_fstat(fd, &st) < 0) {
 		e = -errno;
-		close(fd);
+		btrfs_close(fd);
 		return e;
 	}
 	size = btrfs_device_size(fd, &st);
 	if (size == 0) {
-		close(fd);
+		btrfs_close(fd);
 		return -1;
 	}
 	if (size < BTRFS_MKFS_SMALL_VOLUME_SIZE) {
-		close(fd);
+		btrfs_close(fd);
 		return 1;
 	} else {
-		close(fd);
+		btrfs_close(fd);
 		return 0;
 	}
 }
@@ -2312,17 +2309,14 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 {
 	struct btrfs_ioctl_ino_lookup_args args;
 	int ret;
-	int e;
 
 	memset(&args, 0, sizeof(args));
 	args.treeid = 0;
 	args.objectid = BTRFS_FIRST_FREE_OBJECTID;
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
-	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: Failed to lookup root id - %s\n",
-			strerror(e));
+		SYS_ERROR("ioctl : BTRFS_IOC_INO_LOOKUP : Failed to lookup root id");
 		return ret;
 	}
 
@@ -2347,10 +2341,10 @@ int find_mount_root(const char *path, char **mount_root)
 	int longest_matchlen = 0;
 	char *longest_match = NULL;
 
-	fd = open(path, O_RDONLY | O_NOATIME);
+	fd = btrfs_open(path, O_RDONLY | O_NOATIME);
 	if (fd < 0)
 		return -errno;
-	close(fd);
+	btrfs_close(fd);
 
 	mnttab = setmntent("/proc/self/mounts", "r");
 	if (!mnttab)
@@ -2391,18 +2385,18 @@ int test_minimum_size(const char *file, u32 leafsize)
 	int fd;
 	struct stat statbuf;
 
-	fd = open(file, O_RDONLY);
+	fd = btrfs_open(file, O_RDONLY);
 	if (fd < 0)
 		return -errno;
-	if (stat(file, &statbuf) < 0) {
-		close(fd);
+	if (btrfs_stat(file, &statbuf) < 0) {
+		btrfs_close(fd);
 		return -errno;
 	}
 	if (btrfs_device_size(fd, &statbuf) < btrfs_min_dev_size(leafsize)) {
-		close(fd);
+		btrfs_close(fd);
 		return 1;
 	}
-	close(fd);
+	btrfs_close(fd);
 	return 0;
 }
 
@@ -2430,7 +2424,7 @@ int test_isdir(const char *path)
 	struct stat st;
 	int ret;
 
-	ret = stat(path, &st);
+	ret = btrfs_stat(path, &st);
 	if(ret < 0 )
 		return -1;
 
-- 
1.9.1

