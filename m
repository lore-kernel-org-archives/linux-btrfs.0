Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13217 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932181AbdC3GV0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:26 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5B22A47EE21B
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:19 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 01/19] btrfs-progs: raid56: Introduce raid56 header for later recovery usage
Date: Thu, 30 Mar 2017 14:20:57 +0800
Message-ID: <20170330062116.14379-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new header, kernel-lib/raid56.h, for later raid56 works.

It contains 2 functions, from original btrfs-progs code:
void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);

Will be expanded later and some part of it(RAID6 recover part) may keep
sync with kernel later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile            |  4 ++--
 disk-io.h           |  4 ----
 kernel-lib/raid56.h | 28 ++++++++++++++++++++++++++++
 volumes.c           |  1 +
 4 files changed, 31 insertions(+), 6 deletions(-)
 create mode 100644 kernel-lib/raid56.h

diff --git a/Makefile b/Makefile
index fdc63c3a..cbb2eb8f 100644
--- a/Makefile
+++ b/Makefile
@@ -108,8 +108,8 @@ libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
 	       kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
-	       kernel-lib/radix-tree.h kernel-lib/sizes.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
+	       kernel-lib/radix-tree.h kernel-lib/sizes.h kernel-lib/raid56.h \
+	       extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
 convert_objects = convert/main.o convert/common.o convert/source-fs.o \
 		  convert/source-ext2.o
 mkfs_objects = mkfs/main.o mkfs/common.o
diff --git a/disk-io.h b/disk-io.h
index cd4fe929..ad8efb43 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -201,8 +201,4 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct extent_buffer *eb);
 int write_and_map_eb(struct btrfs_root *root, struct extent_buffer *eb);
 
-/* raid56.c */
-void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
-int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
-
 #endif
diff --git a/kernel-lib/raid56.h b/kernel-lib/raid56.h
new file mode 100644
index 00000000..fa8fa260
--- /dev/null
+++ b/kernel-lib/raid56.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
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
+#ifndef _BTRFS_PROGS_RAID56_H
+#define _BTRFS_PROGS_RAID56_H
+/*
+ * Headers for RAID5/6 operations.
+ * Original headers from original RAID5/6 codes, not from kernel header.
+ */
+
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
+#endif
diff --git a/volumes.c b/volumes.c
index b350e259..8c2ffd92 100644
--- a/volumes.c
+++ b/volumes.c
@@ -28,6 +28,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "utils.h"
+#include "kernel-lib/raid56.h"
 
 struct stripe {
 	struct btrfs_device *dev;
-- 
2.12.1



