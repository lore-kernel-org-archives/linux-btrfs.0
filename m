From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs-progs: btrfs-reada, test program for readahead
Date: Mon, 23 May 2011 17:57:27 +0200
Message-ID: <1306166247-15142-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple interface to test the new readahead-facility. You can
trigger a readahead in the kernel for a given tree and key range. The
default is to read the full extent tree.
You can also specify to wait on it to finish (-w), or choose the traditional
tree walk (-t) instead.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 Makefile      |    5 +-
 btrfs-reada.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |   16 +++++
 3 files changed, 200 insertions(+), 1 deletions(-)
 create mode 100644 btrfs-reada.c

diff --git a/Makefile b/Makefile
index 6e6f6c6..3d6ec54 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,7 @@ LIBS=-luuid
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 	btrfs \
-	btrfs-map-logical
+	btrfs-map-logical btrfs-reada
 
 # make C=1 to enable sparse
 ifdef C
@@ -62,6 +62,9 @@ btrfs-debug-tree: $(objects) debug-tree.o
 btrfs-zero-log: $(objects) btrfs-zero-log.o
 	gcc $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
 
+btrfs-reada: $(objects) btrfs-reada.o
+	gcc $(CFLAGS) -o btrfs-reada $(objects) btrfs-reada.o $(LDFLAGS) $(LIBS)
+
 btrfstune: $(objects) btrfstune.o
 	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
diff --git a/btrfs-reada.c b/btrfs-reada.c
new file mode 100644
index 0000000..b495017
--- /dev/null
+++ b/btrfs-reada.c
@@ -0,0 +1,180 @@
+/*
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <uuid/uuid.h>
+#include <ctype.h>
+
+
+#include "kerncompat.h"
+#include "btrfs_cmds.h"
+#include "version.h"
+#include "ioctl.h"
+#include "ctree.h"
+
+static int open_file_or_dir(const char *fname)
+{
+	int ret;
+	struct stat st;
+	DIR *dirstream;
+	int fd;
+
+	ret = stat(fname, &st);
+	if (ret < 0)
+		return -1;
+
+	if (S_ISDIR(st.st_mode)) {
+		dirstream = opendir(fname);
+		if (!dirstream)
+			return -2;
+		fd = dirfd(dirstream);
+	} else {
+		fd = open(fname, O_RDWR);
+	}
+	if (fd < 0)
+		return -3;
+
+	return fd;
+}
+
+void usage(void)
+{
+	printf("usage: btrfs-reada [-w] <mntpnt> [<tree> [<start> [<end>]]]\n");
+	printf("      <start|end>: max|<num>[:<num>[:<num>]]\n");
+	printf("      <tree>: csum|extent|<num>\n");
+	printf("      -w: wait\n");
+	printf("      -t: read tree the old fashioned way\n");
+	exit(1);
+}
+
+void parse_key(struct btrfs_key *key, char *p)
+{
+	char *n;
+
+	if (strcmp(p, "max") == 0) {
+		key->objectid = -1LL;
+		key->type = -1;
+		key->offset = -1LL;
+		return;
+	}
+	memset(key, 0, sizeof(*key));
+	n = strtok(p, ":");
+	if (n == NULL)
+		usage();
+	key->objectid = atoll(n);
+
+	n = strtok(p, ":");
+	if (n == NULL)
+		return;
+	key->type = atoi(n);
+
+	n = strtok(p, ":");
+	if (n == NULL)
+		return;
+	key->offset = atoll(n);
+}
+
+int main(int argc, char *argv[])
+{
+	char	*mntpnt;
+	int	fdmnt;
+	int	res;
+	struct btrfs_ioctl_reada_args reada_args;
+	u64	tree = BTRFS_EXTENT_TREE_OBJECTID;
+	int	wait = 0;
+	int	trad = 0;
+	struct btrfs_key start = { 0, 0, 0};
+	struct btrfs_key end = { -1LL, -1, -1LL};
+
+	while (1) {
+		int c = getopt(argc, argv, "wth");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'w':
+			wait = 1;
+			break;
+		case 't':
+			trad = 1;
+			break;
+		case 'h':
+		default:
+			usage();
+		}
+	}
+
+	if (optind < argc) {
+		mntpnt = argv[optind++];
+	} else {
+		usage();
+		exit(1);
+	}
+	if (optind < argc) {
+		char *p = argv[optind++];
+		if (strcmp(p, "extent") == 0) {
+			tree = BTRFS_EXTENT_TREE_OBJECTID;
+		} else if (strcmp(p, "csum") == 0) {
+			tree = BTRFS_CSUM_TREE_OBJECTID;
+		} else {
+			tree = atoll(p);
+			if (tree == 0) {
+				printf("inval tree\n");
+				usage();
+			}
+		}
+	}
+	if (optind < argc)
+		parse_key(&start, argv[optind++]);
+	if (optind < argc)
+		parse_key(&end, argv[optind++]);
+
+	fdmnt = open_file_or_dir(mntpnt);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
+		return 12;
+	}
+
+	memset(&reada_args, 0, sizeof(reada_args));
+	reada_args.flags = 0;
+	if (wait)
+		reada_args.flags |= BTRFS_READA_IOC_FLAGS_WAIT;
+	if (trad)
+		reada_args.flags |= BTRFS_READA_IOC_FLAGS_TRAD;
+	reada_args.tree = tree;
+	reada_args.start_objectid = start.objectid;
+	reada_args.start_type = start.type;
+	reada_args.start_offset = start.offset;
+	reada_args.end_objectid = end.objectid;
+	reada_args.end_type = end.type;
+	reada_args.end_offset = end.offset;
+	res = ioctl(fdmnt, BTRFS_IOC_READA_TEST, &reada_args);
+	if (res)
+		printf("ioctl return %d, %s\n", res, strerror(errno));
+
+	return 0;
+}
+
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..0d90edc 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -132,6 +132,20 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+#define BTRFS_READA_IOC_FLAGS_WAIT	1
+#define BTRFS_READA_IOC_FLAGS_TRAD	2
+struct btrfs_ioctl_reada_args {
+	__u64 flags;
+	__u64 tree;
+	__u64 start_objectid;
+	__u8 start_type;
+	__u64 start_offset;
+	__u64 end_objectid;
+	__u8 end_type;
+	__u64 end_offset;
+	__u64 unused[100];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -169,4 +183,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_READA_TEST _IOW(BTRFS_IOCTL_MAGIC, 99, \
+				struct btrfs_ioctl_reada_args)
 #endif
-- 
1.7.3.4

