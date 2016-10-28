Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S938630AbcJ1CcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 01/19] btrfs-progs: raid56: Introduce raid56 header for later recovery usage
Date: Fri, 28 Oct 2016 10:31:37 +0800
Message-Id: <20161028023155.27336-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although there is only 2 function in raid56 header, later recovery will
introduce a lot of tables, so split it from disk-io.h.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in |  2 +-
 disk-io.h   |  4 ----
 raid56.h    | 20 ++++++++++++++++++++
 volumes.c   |  1 +
 4 files changed, 22 insertions(+), 5 deletions(-)
 create mode 100644 raid56.h

diff --git a/Makefile.in b/Makefile.in
index fe3218c..73b2919 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -106,7 +106,7 @@ libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
 	       kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
 	       kernel-lib/radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
+	       extent_io.h ioctl.h ctree.h btrfsck.h raid56.h version.h
 TESTS = fsck-tests.sh convert-tests.sh
 
 udev_rules = 64-btrfs-dm.rules
diff --git a/disk-io.h b/disk-io.h
index 245626c..6efd75b 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -190,8 +190,4 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb);
 
-/* raid56.c */
-void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
-int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
-
 #endif
diff --git a/raid56.h b/raid56.h
new file mode 100644
index 0000000..54f0cde
--- /dev/null
+++ b/raid56.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
diff --git a/volumes.c b/volumes.c
index 6d7adef..f8c50d9 100644
--- a/volumes.c
+++ b/volumes.c
@@ -28,6 +28,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "utils.h"
+#include "raid56.h"
 
 struct stripe {
 	struct btrfs_device *dev;
-- 
2.10.1



