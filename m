From: "Morey Roof" <moreyroof@gmail.com>
Subject: Another Try
Date: Wed, 6 Aug 2008 11:55:24 -0600
Message-ID: <91a37e890808061055u1ca6baa6ie638787cee7139ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is change you requested Yan.  When I was looking at the sources I
missed that the transaction_commit would get the superblock.

Thanks,

Morey

diff -r bbb347e93aa3 Makefile
--- a/Makefile  Mon Aug 04 15:46:36 2008 -0400
+++ b/Makefile  Wed Aug 06 11:54:50 2008 -0600
@@ -15,7 +15,7 @@
 bindir = $(prefix)/bin
 LIBS=-luuid

-progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
+progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol btrfslabel

 # make C=1 to enable sparse
 ifdef C
@@ -45,6 +45,9 @@

 btrfsck: $(objects) btrfsck.o bit-radix.o
        gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) bit-radix.o
$(LDFLAGS) $(LIBS)
+
+btrfslabel: $(objects) btrfslabel.o
+       gcc $(CFLAGS) -o btrfslabel btrfslabel.o $(objects) $(LDFLAGS) $(LIBS)

 mkfs.btrfs: $(objects) mkfs.o
        gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
diff -r bbb347e93aa3 btrfslabel.c
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/btrfslabel.c      Wed Aug 06 11:54:50 2008 -0600
@@ -0,0 +1,169 @@
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <ctype.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "utils.h"
+#include "version.h"
+#include "disk-io.h"
+#include "transaction.h"
+
+#define	MOUNTED				1
+#define	UNMOUNTED			2
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
+static void change_label_mounted(char *dev, char *nLabel)
+{
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
+static void get_label_mounted(char *dev)
+{
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
+			get_label_mounted(btrfs_dev);
+		} else
+		{
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
+			/* TODO: Handle changing the label on a mounted filesystem. */
+			change_label_mounted(btrfs_dev, nLabel);
+			fprintf(stderr, "FATAL: cannot change a label on a mounted filesystem\n");
+			exit(1);
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
diff -r bbb347e93aa3 mkfs.c
--- a/mkfs.c	Mon Aug 04 15:46:36 2008 -0400
+++ b/mkfs.c	Wed Aug 06 11:54:50 2008 -0600
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

diff -r bbb347e93aa3 utils.c
--- a/utils.c	Mon Aug 04 15:46:36 2008 -0400
+++ b/utils.c	Wed Aug 06 11:54:50 2008 -0600
@@ -572,7 +572,7 @@
 }

 /*
- * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 1 if the device is mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesystems
  */
 int check_mounted(char *file)
@@ -803,3 +803,27 @@
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
diff -r bbb347e93aa3 utils.h
--- a/utils.h	Mon Aug 04 15:46:36 2008 -0400
+++ b/utils.h	Wed Aug 06 11:54:50 2008 -0600
@@ -40,4 +40,5 @@
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+int check_label(char *input);
 #endif
