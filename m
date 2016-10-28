Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1034305AbcJ1Ccw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 02/19] btrfs-progs: raid56: Introduce tables for RAID6 recovery
Date: Fri, 28 Oct 2016 10:31:38 +0800
Message-Id: <20161028023155.27336-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from kernel code with minor modification.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .gitignore  |   2 +
 Makefile.in |  12 ++++-
 mktables.c  | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 raid56.h    |   7 +++
 4 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 mktables.c

diff --git a/.gitignore b/.gitignore
index 214103d..2587661 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,8 @@
 *.static.o
 *.o.d
 tags
+mktables
+tables.c
 .cc-defines.h
 version.h
 version
diff --git a/Makefile.in b/Makefile.in
index 73b2919..a25cda9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -93,7 +93,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o
+	  inode.o file.o find-root.o free-space-tree.o help.o tables.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
@@ -310,6 +310,14 @@ version.h: version.sh version.h.in configure.ac
 	@echo "    [SH]     $@"
 	$(Q)bash ./config.status --silent $@
 
+mktables: mktables.c
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(CFLAGS) $< -o $@
+
+tables.c: mktables
+	@echo "    [TABLE]  $@"
+	$(Q)./mktables > $@ || ($(RM) -f $@ && exit 1)
+
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(LIBBTRFS_LIBS) \
@@ -430,7 +438,7 @@ clean-all: clean clean-doc clean-gen
 
 clean: $(CLEANDIRS)
 	@echo "Cleaning"
-	$(Q)$(RM) -f -- $(progs) cscope.out *.o *.o.d \
+	$(Q)$(RM) -f -- $(progs) cscope.out *.o *.o.d mktables tables.c \
 		kernel-lib/*.o kernel-lib/*.o.d \
 	      dir-test ioctl-test quick-test send-test library-test library-test-static \
 	      btrfs.static mkfs.btrfs.static \
diff --git a/mktables.c b/mktables.c
new file mode 100644
index 0000000..10103f0
--- /dev/null
+++ b/mktables.c
@@ -0,0 +1,142 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * mktables.c
+ *
+ * Make RAID-6 tables.  This is a host user space program to be run at
+ * compile time.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+#include <stdlib.h>
+#include <time.h>
+
+static uint8_t gfmul(uint8_t a, uint8_t b)
+{
+	uint8_t v = 0;
+
+	while (b) {
+		if (b & 1)
+			v ^= a;
+		a = (a << 1) ^ (a & 0x80 ? 0x1d : 0);
+		b >>= 1;
+	}
+
+	return v;
+}
+
+static uint8_t gfpow(uint8_t a, int b)
+{
+	uint8_t v = 1;
+
+	b %= 255;
+	if (b < 0)
+		b += 255;
+
+	while (b) {
+		if (b & 1)
+			v = gfmul(v, a);
+		a = gfmul(a, a);
+		b >>= 1;
+	}
+
+	return v;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, j, k;
+	uint8_t v;
+	uint8_t exptbl[256], invtbl[256];
+
+	printf("#include \"kerncompat.h\"\n");
+
+	/* Compute multiplication table */
+	printf("\nconst u8  __attribute__((aligned(256)))\n"
+		"raid6_gfmul[256][256] =\n"
+		"{\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t{\n");
+		for (j = 0; j < 256; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x,%c", gfmul(i, j + k),
+				       (k == 7) ? '\n' : ' ');
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+
+	/* Compute vector multiplication table */
+	printf("\nconst u8  __attribute__((aligned(256)))\n"
+		"raid6_vgfmul[256][32] =\n"
+		"{\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t{\n");
+		for (j = 0; j < 16; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x,%c", gfmul(i, j + k),
+				       (k == 7) ? '\n' : ' ');
+		}
+		for (j = 0; j < 16; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x,%c", gfmul(i, (j + k) << 4),
+				       (k == 7) ? '\n' : ' ');
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+
+	/* Compute power-of-2 table (exponent) */
+	v = 1;
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+	       "raid6_gfexp[256] =\n" "{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			exptbl[i + j] = v;
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
+			v = gfmul(v, 2);
+			if (v == 1)
+				v = 0;	/* For entry 255, not a real entry */
+		}
+	}
+	printf("};\n");
+
+	/* Compute inverse table x^-1 == x^254 */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+	       "raid6_gfinv[256] =\n" "{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			invtbl[i + j] = v = gfpow(i + j, 254);
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
+		}
+	}
+	printf("};\n");
+
+	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+	       "raid6_gfexi[256] =\n" "{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++)
+			printf("0x%02x,%c", invtbl[exptbl[i + j] ^ 1],
+			       (j == 7) ? '\n' : ' ');
+	}
+	printf("};\n");
+
+	return 0;
+}
diff --git a/raid56.h b/raid56.h
index 54f0cde..a05c14b 100644
--- a/raid56.h
+++ b/raid56.h
@@ -18,3 +18,10 @@
 
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
+
+/* Galois field tables */
+extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
+extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
+extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
-- 
2.10.1



