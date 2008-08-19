From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Switch btrfs_name_hash() to crc32c
Date: Tue, 19 Aug 2008 19:26:32 +0100
Message-ID: <1219170392.2988.9.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Using a 64-bit hash as the readdir cookie is just asking for trouble.
And gets it, when we try to export the file system by NFS.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
(Corresponding patch for btrfs-progs in the repo at
git://git.infradead.org/users/dwmw2/btrfs-progs-unstable.git )


 Makefile |    2 +-
 hash.c   |  112 --------------------------------------------------------------
 hash.h   |    7 +++-
 3 files changed, 7 insertions(+), 114 deletions(-)
 delete mode 100644 hash.c

diff --git a/Makefile b/Makefile
index 75f8818..8213bba 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ ifneq ($(KERNELRELEASE),)
 
 obj-m  := btrfs.o
 btrfs-y := super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
-	   hash.o file-item.o inode-item.o inode-map.o disk-io.o \
+	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
diff --git a/hash.c b/hash.c
deleted file mode 100644
index 21037cf..0000000
--- a/hash.c
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
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
-/*
- *  Original copy from:
- *  linux/fs/ext3/hash.c
- *
- * Copyright (C) 2002 by Theodore Ts'o
- *
- * This file is released under the GPL v2.
- *
- * This file may be redistributed under the terms of the GNU Public
- * License.
- */
-
-#include <linux/types.h>
-#include "hash.h"
-#define DELTA 0x9E3779B9
-
-static void TEA_transform(__u32 buf[2], __u32 const in[])
-{
-	__u32	sum = 0;
-	__u32	b0 = buf[0], b1 = buf[1];
-	__u32	a = in[0], b = in[1], c = in[2], d = in[3];
-	int	n = 16;
-
-	do {
-		sum += DELTA;
-		b0 += ((b1 << 4)+a) ^ (b1+sum) ^ ((b1 >> 5)+b);
-		b1 += ((b0 << 4)+c) ^ (b0+sum) ^ ((b0 >> 5)+d);
-	} while(--n);
-
-	buf[0] += b0;
-	buf[1] += b1;
-}
-
-static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
-{
-	__u32	pad, val;
-	int	i;
-
-	pad = (__u32)len | ((__u32)len << 8);
-	pad |= pad << 16;
-
-	val = pad;
-	if (len > num*4)
-		len = num * 4;
-	for (i=0; i < len; i++) {
-		if ((i % 4) == 0)
-			val = pad;
-		val = msg[i] + (val << 8);
-		if ((i % 4) == 3) {
-			*buf++ = val;
-			val = pad;
-			num--;
-		}
-	}
-	if (--num >= 0)
-		*buf++ = val;
-	while (--num >= 0)
-		*buf++ = pad;
-}
-
-u64 btrfs_name_hash(const char *name, int len)
-{
-	__u32	hash;
-	__u32	minor_hash = 0;
-	const char	*p;
-	__u32		in[8], buf[4];
-	u64		hash_result;
-
-	if (len == 1 && *name == '.') {
-		return 1;
-	} else if (len == 2 && name[0] == '.' && name[1] == '.') {
-		return 2;
-	}
-
-	/* Initialize the default seed for the hash checksum functions */
-	buf[0] = 0x67452301;
-	buf[1] = 0xefcdab89;
-	buf[2] = 0x98badcfe;
-	buf[3] = 0x10325476;
-
-	p = name;
-	while (len > 0) {
-		str2hashbuf(p, len, in, 4);
-		TEA_transform(buf, in);
-		len -= 16;
-		p += 16;
-	}
-	hash = buf[0];
-	minor_hash = buf[1];
-	hash_result = buf[0];
-	hash_result <<= 32;
-	hash_result |= buf[1];
-	return hash_result;
-}
diff --git a/hash.h b/hash.h
index 868ee17..2a020b2 100644
--- a/hash.h
+++ b/hash.h
@@ -18,5 +18,10 @@
 
 #ifndef __HASH__
 #define __HASH__
-u64 btrfs_name_hash(const char *name, int len);
+
+#include "crc32c.h"
+static inline u64 btrfs_name_hash(const char *name, int len)
+{
+	return btrfs_crc32c((u32)~1, name, len);
+}
 #endif
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



