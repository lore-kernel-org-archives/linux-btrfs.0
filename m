Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51212 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3A3Ido (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 03:33:44 -0500
Message-ID: <5108DAAF.7040006@oracle.com>
Date: Wed, 30 Jan 2013 16:32:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH v2 2/2] btrfs-progs: move btrfslabel.[c|h] stuff to utils.[c|h]
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean btrfslabel.[c|h] out of the source tree and move those related
functions to utils.[c|h].

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
CC: Gene Czarcinski <gene@czarc.net>

---
 Makefile          |    4 +-
 btrfslabel.c      |  178 -----------------------------------------------------
 btrfslabel.h      |    5 --
 cmds-filesystem.c |    1 -
 utils.c           |  130 ++++++++++++++++++++++++++++++++++++++
 utils.h           |    2 +
 6 files changed, 134 insertions(+), 186 deletions(-)
 delete mode 100644 btrfslabel.c
 delete mode 100644 btrfslabel.h

diff --git a/Makefile b/Makefile
index 4894903..e54b21e 100644
--- a/Makefile
+++ b/Makefile
@@ -4,8 +4,8 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o
+	  volumes.o utils.o btrfs-list.o repair.o send-stream.o \
+	  send-utils.o qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o
diff --git a/btrfslabel.c b/btrfslabel.c
deleted file mode 100644
index 2826050..0000000
--- a/btrfslabel.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * Copyright (C) 2008 Morey Roof.   All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#define _GNU_SOURCE
-
-#ifndef __CHECKER__
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include "ioctl.h"
-#endif /* __CHECKER__ */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <dirent.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <linux/fs.h>
-#include <linux/limits.h>
-#include <ctype.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "utils.h"
-#include "version.h"
-#include "disk-io.h"
-#include "transaction.h"
-
-#define MOUNTED                        1
-#define UNMOUNTED                      2
-#define GET_LABEL                      3
-#define SET_LABEL                      4
-
-static int set_label_unmounted(const char *dev, const char *label)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root;
-	int ret;
-
-	ret = check_mounted(dev);
-	if (ret < 0) {
-	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
-	       return -1;
-	}
-	if (ret > 0) {
-		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
-			dev);
-		return -1;
-	}
-
-	if (strlen(label) > BTRFS_LABEL_SIZE - 1) {
-		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
-			label, BTRFS_LABEL_SIZE - 1);
-		return -1;
-	}
-
-	/* Open the super_block at the default location
-	 * and as read-write.
-	 */
-	root = open_ctree(dev, 0, 1);
-	if (!root) /* errors are printed by open_ctree() */
-		return -1;
-
-	trans = btrfs_start_transaction(root, 1);
-	snprintf(root->fs_info->super_copy.label, BTRFS_LABEL_SIZE, "%s",
-		 label);
-	btrfs_commit_transaction(trans, root);
-
-	/* Now we close it since we are done. */
-	close_ctree(root);
-	return 0;
-}
-
-static int set_label_mounted(const char *mount_path, const char *label)
-{
-	int fd;
-
-	fd = open(mount_path, O_RDONLY | O_NOATIME);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
-		return -1;
-	}
-
-	if (ioctl(fd, BTRFS_IOC_SET_FSLABEL, label) < 0) {
-		fprintf(stderr, "ERROR: unable to set label %s\n",
-			strerror(errno));
-		close(fd);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int get_label_unmounted(const char *dev)
-{
-	struct btrfs_root *root;
-	int ret;
-
-	ret = check_mounted(dev);
-	if (ret < 0) {
-	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
-	       return -1;
-	}
-	if (ret > 0) {
-		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
-			dev);
-		return -1;
-	}
-
-	/* Open the super_block at the default location
-	 * and as read-only.
-	 */
-	root = open_ctree(dev, 0, 0);
-	if(!root)
-		return -1;
-
-	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
-
-	/* Now we close it since we are done. */
-	close_ctree(root);
-	return 0;
-}
-
-/*
- * If a partition is mounted, try to get the filesystem label via its
- * mounted path rather than device.  Return the corresponding error
- * the user specified the device path.
- */
-static int get_label_mounted(const char *mount_path)
-{
-	char label[BTRFS_LABEL_SIZE];
-	int fd;
-
-	fd = open(mount_path, O_RDONLY | O_NOATIME);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
-		return -1;
-	}
-
-	memset(label, '\0', sizeof(label));
-	if (ioctl(fd, BTRFS_IOC_GET_FSLABEL, label) < 0) {
-		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
-		close(fd);
-		return -1;
-	}
-
-	fprintf(stdout, "%s\n", label);
-	return 0;
-}
-
-int get_label(const char *btrfs_dev)
-{
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		get_label_unmounted(btrfs_dev) :
-		get_label_mounted(btrfs_dev);
-}
-
-int set_label(char *btrfs_dev, char *label)
-{
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		set_label_unmounted(btrfs_dev, label) :
-		set_label_mounted(btrfs_dev, label);
-}
diff --git a/btrfslabel.h b/btrfslabel.h
deleted file mode 100644
index abf43ad..0000000
--- a/btrfslabel.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* btrflabel.h */
-
-
-int get_label(char *btrfs_dev);
-int set_label(char *btrfs_dev, char *nLabel);
\ No newline at end of file
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5770d8b..3752703 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -32,7 +32,6 @@
 #include "version.h"
 
 #include "commands.h"
-#include "btrfslabel.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
diff --git a/utils.c b/utils.c
index 9dc688a..3bfff5e 100644
--- a/utils.c
+++ b/utils.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2008 Morey Roof.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -16,6 +17,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define _GNU_SOURCE
 #define _XOPEN_SOURCE 600
 #define __USE_XOPEN2K
 #include <stdio.h>
@@ -1134,6 +1136,134 @@ static int check_label(const char *input)
        return 0;
 }
 
+static int set_label_unmounted(const char *dev, const char *label)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
+	int ret;
+
+	ret = check_mounted(dev);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
+	       return -1;
+	}
+	if (ret > 0) {
+		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
+			dev);
+		return -1;
+	}
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+	if (!root) /* errors are printed by open_ctree() */
+		return -1;
+
+	trans = btrfs_start_transaction(root, 1);
+	snprintf(root->fs_info->super_copy.label, BTRFS_LABEL_SIZE, "%s",
+		 label);
+	btrfs_commit_transaction(trans, root);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
+}
+
+static int set_label_mounted(const char *mount_path, const char *label)
+{
+	int fd;
+
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		return -1;
+	}
+
+	if (ioctl(fd, BTRFS_IOC_SET_FSLABEL, label) < 0) {
+		fprintf(stderr, "ERROR: unable to set label %s\n",
+			strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int get_label_unmounted(const char *dev)
+{
+	struct btrfs_root *root;
+	int ret;
+
+	ret = check_mounted(dev);
+	if (ret < 0) {
+	       fprintf(stderr, "FATAL: error checking %s mount status\n", dev);
+	       return -1;
+	}
+	if (ret > 0) {
+		fprintf(stderr, "ERROR: dev %s is mounted, use mount point\n",
+			dev);
+		return -1;
+	}
+
+	/* Open the super_block at the default location
+	 * and as read-only.
+	 */
+	root = open_ctree(dev, 0, 0);
+	if(!root)
+		return -1;
+
+	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
+}
+
+/*
+ * If a partition is mounted, try to get the filesystem label via its
+ * mounted path rather than device.  Return the corresponding error
+ * the user specified the device path.
+ */
+static int get_label_mounted(const char *mount_path)
+{
+	char label[BTRFS_LABEL_SIZE];
+	int fd;
+
+	fd = open(mount_path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		return -1;
+	}
+
+	memset(label, '\0', sizeof(label));
+	if (ioctl(fd, BTRFS_IOC_GET_FSLABEL, label) < 0) {
+		fprintf(stderr, "ERROR: unable get label %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	fprintf(stdout, "%s\n", label);
+	return 0;
+}
+
+int get_label(const char *btrfs_dev)
+{
+	return is_existing_blk_or_reg_file(btrfs_dev) ?
+		get_label_unmounted(btrfs_dev) :
+		get_label_mounted(btrfs_dev);
+}
+
+int set_label(const char *btrfs_dev, const char *label)
+{
+	if (check_label(label))
+		return -1;
+
+	return is_existing_blk_or_reg_file(btrfs_dev) ?
+		set_label_unmounted(btrfs_dev, label) :
+		set_label_mounted(btrfs_dev, label);
+}
+
 int btrfs_scan_block_devices(int run_ioctl)
 {
 
diff --git a/utils.h b/utils.h
index a0b782b..632b01c 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,6 @@ int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
 int is_existing_blk_or_reg_file(const char* filename);
+int get_label(const char *btrfs_dev);
+int set_label(const char *btrfs_dev, const char *label);
 #endif
-- 
1.7.9.5
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
