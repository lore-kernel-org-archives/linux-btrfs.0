Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56053 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3FZWiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 18:38:23 -0400
Received: by mail-wi0-f175.google.com with SMTP id m6so2510225wiv.8
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 15:38:22 -0700 (PDT)
Message-ID: <51CB6D5B.70302@gmail.com>
Date: Thu, 27 Jun 2013 00:38:19 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Mark Fasheh <mfasheh@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PROGS PATCH] Import btrfs-extent-same
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally from
https://github.com/markfasheh/duperemove/blob/master/btrfs-extent-same.c

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
---
 .gitignore          |   1 +
 Makefile            |   2 +-
 btrfs-extent-same.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 1 deletion(-)
 create mode 100644 btrfs-extent-same.c

diff --git a/.gitignore b/.gitignore
index a7e1b19..8f0ec54 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,10 +5,11 @@ version.h
 version
 man/*.gz
 btrfs
 btrfs.static
 btrfs-debug-tree
+btrfs-extent-same
 btrfs-map-logical
 btrfs-fragments
 btrfsck
 calc-size
 ioctl-test
diff --git a/Makefile b/Makefile
index da7438e..35cc502 100644
--- a/Makefile
+++ b/Makefile
@@ -43,11 +43,11 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
 progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfstune btrfs-show-super btrfs-extent-same
 
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
 btrfs_convert_libs = -lext2fs -lcom_err
 btrfs_image_libs = -lpthread
diff --git a/btrfs-extent-same.c b/btrfs-extent-same.c
new file mode 100644
index 0000000..acf46b7
--- /dev/null
+++ b/btrfs-extent-same.c
@@ -0,0 +1,145 @@
+/*
+ * btrfs-extent-same.c
+ *
+ * Copyright (C) 2013 SUSE.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#define BTRFS_IOCTL_MAGIC 0x94
+
+#define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+					 struct btrfs_ioctl_same_args)
+
+#define BTRFS_SAME_DATA_DIFFERS	1
+/* For extent-same ioctl */
+struct btrfs_ioctl_same_extent_info {
+	int64_t fd;			/* in - destination file */
+	uint64_t logical_offset;	/* in - start of extent in destination */
+	uint64_t bytes_deduped;		/* out - total # of bytes we
+					 * were able to dedupe from
+					 * this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == BTRFS_SAME_DATA_DIFFERS if data differs
+	 */
+	int32_t status;			/* out - see above description */
+	uint32_t reserved;
+};
+
+struct btrfs_ioctl_same_args {
+	uint64_t logical_offset;	/* in - start of extent in source */
+	uint64_t length;		/* in - length of extent */
+	uint16_t dest_count;		/* in - total elements in info array */
+	uint16_t reserved1;		/* out - number of files that got deduped */
+	uint32_t reserved2;
+	struct btrfs_ioctl_same_extent_info info[0];
+};
+
+static void usage(const char *prog)
+{
+	printf("Usage: %s len file1 loff1 file2 loff2\n", prog);
+}
+
+int main(int argc, char **argv)
+{
+	int ret, src_fd, i, numfiles;
+	char *srcf, *destf;
+	struct btrfs_ioctl_same_args *same;
+	struct btrfs_ioctl_same_extent_info *info;
+	unsigned long long bytes = 0ULL;
+
+	if (argc < 6 || (argc % 2)) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	numfiles = (argc / 2) - 2;
+
+	printf("Deduping %d total files\n", numfiles + 1);
+
+	same = calloc(1,
+		      sizeof(struct btrfs_ioctl_same_args) +
+		      sizeof(struct btrfs_ioctl_same_extent_info) * numfiles);
+	if (!same)
+		return -ENOMEM;
+
+	srcf = argv[2];
+	same->length = atoll(argv[1]);
+	same->logical_offset = atoll(argv[3]);
+	same->dest_count = numfiles;
+
+	ret = open(srcf, O_RDONLY);
+	if (ret < 0) {
+		ret = errno;
+		fprintf(stderr, "Could not open file %s: (%d) %s\n", srcf, ret,
+			strerror(ret));
+		return -ret;
+	}
+	src_fd = ret;
+
+	printf("(%llu, %llu): %s\n", (unsigned long long)same->logical_offset,
+	       (unsigned long long)same->length, srcf);
+
+	for (i = 0; i < same->dest_count; i++) {
+		destf = argv[4 + (i * 2)];
+
+		ret = open(destf, O_RDONLY);
+		if (ret < 0) {
+			ret = errno;
+			fprintf(stderr, "Could not open file %s: (%d) %s\n",
+				destf, ret, strerror(ret));
+			return -ret;
+		}
+
+		same->info[i].fd = ret;
+		same->info[i].logical_offset = atoll(argv[5 + (i * 2)]);
+		printf("(%llu, %llu): %s\n",
+		       (unsigned long long)same->info[i].logical_offset,
+		       (unsigned long long)same->length, destf);
+
+	}
+
+	ret = ioctl(src_fd, BTRFS_IOC_FILE_EXTENT_SAME, same);
+	if (ret < 0) {
+		ret = errno;
+		fprintf(stderr, "btrfs_same returned error: (%d) %s\n", ret,
+			strerror(ret));
+		return -ret;
+	}
+
+	printf("%u files asked to be deduped\n", same->dest_count);
+
+	for (i = 0; i < same->dest_count; i++) {
+		info = &same->info[i];
+
+		printf("i: %d, status: %d, bytes_deduped: %llu\n", i,
+		       info->status, (unsigned long long)info->bytes_deduped);
+
+		bytes += info->bytes_deduped;
+	}
+
+	printf("%llu total bytes deduped in this operation\n", bytes);
+
+	return ret;
+}
-- 
1.8.3.1.588.gb04834f

