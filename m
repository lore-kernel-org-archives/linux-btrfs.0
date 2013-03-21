Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:25290 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933903Ab3CUQCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 12:02:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH] Btrfs-progs: add btrfs-crc tool
Date: Thu, 21 Mar 2013 17:02:40 +0100
Message-Id: <1363881760-22108-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This tool can be used to compute btrfs' style crc32c checksums for filenames
as done by the kernel. Additionally, there is -c mode to do a brute force
search for file names with a given checksum.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 Makefile    |    4 ++
 btrfs-crc.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 btrfs-crc.c

diff --git a/Makefile b/Makefile
index 9c195b3..145e2ea 100644
--- a/Makefile
+++ b/Makefile
@@ -184,6 +184,10 @@ btrfs-image: $(objects) $(libs) btrfs-image.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
 
+btrfs-crc: btrfs-crc.o $(libs)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-crc btrfs-crc.o $(LDFLAGS) $(LIBS)
+
 dir-test: $(objects) $(libs) dir-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
diff --git a/btrfs-crc.c b/btrfs-crc.c
new file mode 100644
index 0000000..6e21a0e
--- /dev/null
+++ b/btrfs-crc.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2013 STRATO.  All rights reserved.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "crc32c.h"
+
+void usage(void)
+{
+	printf("usage: btrfs-crc filename\n");
+	printf("    print out the btrfs crc for \"filename\"\n");
+	printf("usage: btrfs-crc filename -c crc [-s seed] [-l length]\n");
+	printf("    brute force search for file names with the given crc\n");
+	printf("      -s seed    the random seed (default: random)\n");
+	printf("      -l length  the length of the file names (default: 10)\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	char c;
+	unsigned long checksum = 0;
+	char *str;
+	char *buf;
+	int length = 10;
+	int seed = getpid() ^ getppid();
+	int loop = 0;
+	int i;
+
+	while ((c = getopt(argc, argv, "l:c:s:h")) != -1) {
+		switch (c) {
+		case 'l':
+			length = atol(optarg);
+			break;
+		case 'c':
+			checksum = atol(optarg);
+			loop = 1;
+			break;
+		case 's':
+			seed = atol(optarg);
+			break;
+		case 'h':
+			usage();
+		case '?':
+			return 255;
+		}
+	}
+
+	str = argv[optind];
+
+	if (!loop) {
+		if (optind >= argc) {
+			fprintf(stderr, "not enough arguments\n");
+			return 255;
+		}
+		printf("%12u - %s\n", crc32c(~1, str, strlen(str)), str);
+		return 0;
+	}
+
+	buf = malloc(length);
+	if (!buf)
+		return -ENOMEM;
+	srand(seed);
+
+	while (1) {
+		for (i = 0; i < length; i++)
+			buf[i] = rand() % 94 + 33;
+		if (crc32c(~1, buf, length) == checksum)
+			printf("%12lu - %.*s\n", checksum, length, buf);
+	}
+
+	return 0;
+}
-- 
1.7.1

