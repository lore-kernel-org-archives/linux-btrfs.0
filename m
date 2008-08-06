From: Morey Roof <moreyroof@gmail.com>
Subject: Patch - btrfslabel program
Date: Tue, 05 Aug 2008 18:01:30 -0600
Message-ID: <4898E9DA.9080009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm new and just getting starting on the source code and figured I
would start by working on some of the utility programs.  So here is my
first addition a program called btrfslabel which works pretty much
just like e2label.  It currently doesn't work on a mounted filesystem
and I will look at that next.

Thanks,

Morey

diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o hash.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o
+	  volumes.o sanity-checks.o utils.o
 #
 CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 		-Wuninitialized -Wshadow -Wundef
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
diff --git a/btrfslabel.c b/btrfslabel.c
new file mode 100644
--- /dev/null
+++ b/btrfslabel.c
@@ -0,0 +1,179 @@
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
+#include "sanity-checks.h"
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
+	int ret;
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+
+	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+	trans = btrfs_start_transaction(root, 1);
+
+	ret = write_ctree_super(trans, root);
+	if (ret)
+	{
+		fprintf(stderr, "FATAL: Failed to write new super block err %d\n", ret);
+		exit(1);
+	}
+
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
diff --git a/mkfs.c b/mkfs.c
--- a/mkfs.c
+++ b/mkfs.c
@@ -42,6 +42,7 @@
 #include "transaction.h"
 #include "utils.h"
 #include "version.h"
+#include "sanity-checks.h"

 static u64 parse_size(char *s)
 {
@@ -246,6 +247,7 @@
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
+	fprintf(stderr, "\t -L --label of the filesystem\n");
 	fprintf(stderr, "\t -n --nodesize size of btree leaves\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -271,20 +273,19 @@

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

diff --git a/sanity-checks.c b/sanity-checks.c
new file mode 100644
--- /dev/null
+++ b/sanity-checks.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2007 Oracle.  All rights reserved.
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
+#include <string.h>
+#include "ctree.h"
+#include "sanity-checks.h"
+
+/*
+ * Checks to make sure that the label matches our requirements.
+ * Returns:
+		 0 	if everything is safe and usable
+		-1		if the label is too long
+		-2		if the label contains an invalid character
+ */
+int check_label(char *input)
+{
+   int i;
+   int len = strlen(input);
+
+   if (len > BTRFS_LABEL_SIZE) {
+		return -1;
+   }
+
+   for (i = 0; i < len; i++) {
+      if (input[i] == '/' || input[i] == '\\') {
+			return -2;
+      }
+   }
+
+   return 0;
+}
diff --git a/sanity-checks.h b/sanity-checks.h
new file mode 100644
--- /dev/null
+++ b/sanity-checks.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2008 Morey Roof.  All rights reserved.
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
+#ifndef __SANITY_CHECKS__
+#define __SANITY_CHECKS__
+
+int check_label(char *input);
+
+#endif /* __SANITY_CHECKS__ */
diff --git a/utils.c b/utils.c
--- a/utils.c
+++ b/utils.c
@@ -572,7 +572,7 @@
 }

 /*
- * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 1 if the device is mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesystems
  */
 int check_mounted(char *file)

