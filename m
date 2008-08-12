From: "Morey Roof" <moreyroof@gmail.com>
Subject: [PATCH] progs-unstable: Adds btrfslabel program
Date: Tue, 12 Aug 2008 15:17:44 -0600
Message-ID: <91a37e890808121417j35e64391v77f78c8897d7db55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds a new program called btrfslabel that allows one to
change the labels of btrfs volumes.

Signed-off-by: Morey Roof <moreyroof@gmail.com>
---
diff -r da35ab2b0b54 Makefile
--- a/Makefile	Wed Aug 06 12:17:01 2008 -0400
+++ b/Makefile	Tue Aug 12 15:10:29 2008 -0600
@@ -15,7 +15,7 @@
 bindir = $(prefix)/bin
 LIBS=-luuid

-progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
+progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol btrfslabel

 # make C=1 to enable sparse
 ifdef C
@@ -45,6 +45,9 @@

 btrfsck: $(objects) btrfsck.o bit-radix.o
 	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) bit-radix.o $(LDFLAGS) $(LIBS)
+
+btrfslabel: $(objects) btrfslabel.o
+	gcc $(CFLAGS) -o btrfslabel btrfslabel.o $(objects) $(LDFLAGS) $(LIBS)

 mkfs.btrfs: $(objects) mkfs.o
 	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
diff -r da35ab2b0b54 btrfslabel.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/btrfslabel.c	Tue Aug 12 15:10:29 2008 -0600
@@ -0,0 +1,244 @@
+/*
+ * Copyright (C) 2008 Morey Roof.   All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define _GNU_SOURCE
+
+#ifndef __CHECKER__
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include "ioctl.h"
+#endif /* __CHECKER__ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/limits.h>
+#include <ctype.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "utils.h"
+#include "version.h"
+#include "disk-io.h"
+#include "transaction.h"
+
+#define MOUNTED			1
+#define UNMOUNTED			2
+#define GET_LABEL			3
+#define SET_LABEL			4
+
+#ifdef __CHECKER__
+#define BTRFS_IOC_SET_LABEL		0
+#define BTRFS_IOC_GET_LABEL		0
+struct btrfs_ioctl_label_args { char name[BTRFS_LABEL_SIZE]; };
+static inline int ioctl(int fd, int define, void *arg) { return 0; }
+#endif /*__CHECKER__*/
+
+static void print_usage(void)
+{
+	fprintf(stderr, "usage: btrfslabel dev [newlabel]\n");
+	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	exit(1);
+}
+
+static void change_label_unmounted(char *dev, char *nLabel)
+{
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+
+	trans = btrfs_start_transaction(root, 1);
+	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+	btrfs_commit_transaction(trans, root);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+}
+
+static void get_label_unmounted(char *dev)
+{
+	struct btrfs_root *root;
+
+	/* Open the super_block at the default location
+	 * and as read-only.
+	 */
+	root = open_ctree(dev, 0, 0);
+
+	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+}
+
+static void mount_label_op(char *dev, char *nLabel, int cmd)
+{
+	struct btrfs_ioctl_label_args label_args;	
+	int ret = 0;
+	DIR *dirstream;
+	int fd;
+	char *mount_point;
+
+	mount_point = malloc(PATH_MAX);
+	if (mount_point == NULL)
+	{
+		fprintf(stderr, "FATAL: Unable to allocate memory\n");
+		exit(1);
+	}
+
+	if (get_mountpt(dev, mount_point, PATH_MAX) != 0)
+	{
+		fprintf(stderr, "FATAL: Unable to determine mount point\n");
+		exit(1);
+	}
+
+	dirstream = opendir(mount_point);
+	if (!dirstream)
+	{
+		fprintf(stderr, "FATAL: Unable to access mount point %s\n", mount_point);
+		exit(1);
+	}
+
+	fd = dirfd(dirstream);
+	if (!fd)
+	{
+		fprintf(stderr, "FATAL: Unable to access btrfs on %s\n", dev);
+		exit(1);
+	}
+	
+	switch(cmd)
+	{
+		case GET_LABEL:
+			ret = ioctl(fd, BTRFS_IOC_GET_LABEL, &label_args);
+			if (ret == 0)
+			{
+				fprintf(stdout, "%s\n", label_args.name);
+			} else
+			{
+				fprintf(stderr, "FATAL: Unable to get label for %s\n", dev);
+				exit(1);
+			}
+			break;
+		case SET_LABEL:
+			strncpy(label_args.name, nLabel, BTRFS_LABEL_SIZE);
+
+			ret = ioctl(fd, BTRFS_IOC_SET_LABEL, &label_args);
+			if (ret != 0)
+			{
+				fprintf(stderr, "FATAL: Unable to set label for %s\n", dev);
+				exit(1);
+			}
+			break;
+		default:
+			fprintf(stderr, "FATAL: Unknown mounted label operation\n");
+			exit(1);
+			break;
+	}
+
+	/* Release the memory we used */
+	free(mount_point);
+}
+
+int main(int argc, char **argv)
+{
+	char *btrfs_dev;
+	char *nLabel;
+	int ret = 0;
+	int workas = 0;
+	int check_val = 0;
+
+	if (argc <= 1)
+	{
+		print_usage();
+	}
+
+	btrfs_dev = argv[1];
+	ret = check_mounted(btrfs_dev);
+	if (ret < 0)
+	{
+		fprintf(stderr, "FATAL: error checking %s mount status\n", btrfs_dev);
+		exit(1);
+	}
+
+	switch(ret)
+	{
+		case 0:
+			workas = UNMOUNTED;
+			break;
+		case 1:
+			workas = MOUNTED;
+			break;
+		default:
+			fprintf(stderr, "BUG: unknown return code from check_mounted()\n");
+			exit(1);
+			break;
+	}
+
+	if (argc == 2)
+	{
+		/* They just want to know what the current label is */
+		if (workas == MOUNTED)
+		{
+			mount_label_op(btrfs_dev, NULL, GET_LABEL);
+		} else
+		{
+			/* Get the label from an unmouted filesystem */
+			get_label_unmounted(btrfs_dev);
+		}
+	} else if (argc == 3)
+	{
+		/* They have requested we change the label */
+		nLabel = argv[2];
+		check_val = check_label(nLabel);
+
+		if (check_val == -1)
+		{
+			fprintf(stderr, "Label %s is too long (max %d)\n", nLabel,
+				BTRFS_LABEL_SIZE);
+			exit(1);
+		}
+
+		if (check_val == -2)
+		{
+			fprintf(stderr, "invalid label %s\n", nLabel);
+			exit(1);
+		}
+
+		if (workas == MOUNTED)
+		{
+			mount_label_op(btrfs_dev, nLabel, SET_LABEL);
+		} else
+		{
+			/* We are going to change the label on an unmounted filesystem */
+			change_label_unmounted(btrfs_dev, nLabel);
+		}
+	} else
+	{
+		fprintf(stderr, "FATAL: too many arguements\n\n");
+		print_usage();
+	}
+
+	return ret;
+}
diff -r da35ab2b0b54 ioctl.h
--- a/ioctl.h	Wed Aug 06 12:17:01 2008 -0400
+++ b/ioctl.h	Tue Aug 12 15:10:29 2008 -0600
@@ -19,6 +19,7 @@
 #ifndef __IOCTL_
 #define __IOCTL_
 #include <linux/ioctl.h>
+#include "ctree.h"

 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
@@ -26,6 +27,10 @@

 struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
+struct btrfs_ioctl_label_args {
+	char name[BTRFS_LABEL_SIZE + 1];
 };

 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
@@ -52,4 +57,10 @@
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)

+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 13, \
+					struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 14, \
+					struct btrfs_ioctl_label_args)
+
 #endif
diff -r da35ab2b0b54 mkfs.c
--- a/mkfs.c	Wed Aug 06 12:17:01 2008 -0400
+++ b/mkfs.c	Tue Aug 12 15:10:29 2008 -0600
@@ -246,6 +246,7 @@
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
+	fprintf(stderr, "\t -L --label of the filesystem\n");
 	fprintf(stderr, "\t -n --nodesize size of btree leaves\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -271,20 +272,19 @@

 static char *parse_label(char *input)
 {
-	int i;
-	int len = strlen(input);
+	int check_val = check_label(input);

-	if (len > BTRFS_LABEL_SIZE) {
+	if (check_val == -1) {
 		fprintf(stderr, "Label %s is too long (max %d)\n", input,
 			BTRFS_LABEL_SIZE);
 		exit(1);
 	}
-	for (i = 0; i < len; i++) {
-		if (input[i] == '/' || input[i] == '\\') {
-			fprintf(stderr, "invalid label %s\n", input);
-			exit(1);
-		}
+
+	if (check_val == -2) {
+		fprintf(stderr, "invalid label %s\n", input);
+		exit(1);
 	}
+
 	return strdup(input);
 }

diff -r da35ab2b0b54 utils.c
--- a/utils.c	Wed Aug 06 12:17:01 2008 -0400
+++ b/utils.c	Tue Aug 12 15:10:29 2008 -0600
@@ -572,7 +572,7 @@
 }

 /*
- * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 1 if the device is mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesystems
  */
 int check_mounted(char *file)
@@ -620,6 +620,39 @@
 	}

 	endmntent (f);
+	return ret;
+}
+
+/* Gets the mount point of btrfs filesystem that is using the specified device.
+ * Returns 0 is everything is good, <0 if we have an error.
+ * TODO: Fix this fucntion and check_mounted to work with multiple drive BTRFS
+ * setups.
+ */
+int get_mountpt(char *dev, char *mntpt, size_t size)
+{
+	struct mntent *mnt;
+	FILE *f;
+	int ret = 0;
+
+	f = setmntent("/proc/mounts", "r");
+	if (f == NULL)
+		return -errno;
+
+	while ((mnt = getmntent(f)) != NULL )
+	{
+		if (strcmp(dev, mnt->mnt_fsname) == 0)
+		{
+			strncpy(mntpt, mnt->mnt_dir, size);
+			break;
+		}
+	}
+
+	if (mnt == NULL)
+	{
+		/* We didn't find an entry so lets report an error */
+		ret = -1;
+	}
+
 	return ret;
 }

@@ -803,3 +836,27 @@
 	return pretty;
 }

+/*
+ * Checks to make sure that the label matches our requirements.
+ * Returns:
+       0    if everything is safe and usable
+      -1    if the label is too long
+      -2    if the label contains an invalid character
+ */
+int check_label(char *input)
+{
+	int i;
+	int len = strlen(input);
+
+	if (len > BTRFS_LABEL_SIZE) {
+		return -1;
+	}
+
+	for (i = 0; i < len; i++) {
+		if (input[i] == '/' || input[i] == '\\') {
+			return -2;
+		}
+	}
+
+	return 0;
+}
diff -r da35ab2b0b54 utils.h
--- a/utils.h	Wed Aug 06 12:17:01 2008 -0400
+++ b/utils.h	Tue Aug 12 15:10:29 2008 -0600
@@ -40,4 +40,6 @@
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+int check_label(char *input);
+int get_mountpt(char *dev, char *mntpt, size_t size);
 #endif
