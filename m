Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbcCDNq1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 08:46:27 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 883A86317B
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Mar 2016 13:46:26 +0000 (UTC)
From: Ondrej Kozina <okozina@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] btrfs-progs: libbtrfs: remove max/min macros from API
Date: Fri,  4 Mar 2016 14:46:11 +0100
Message-Id: <1457099171-24095-2-git-send-email-okozina@redhat.com>
In-Reply-To: <1457099171-24095-1-git-send-email-okozina@redhat.com>
References: <1457099171-24095-1-git-send-email-okozina@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kerncompat.h header file is part of libbtrfs API. min/max macros cause
conflict while building projects dependant on libbtrfs. Moving those
macros to btrfs-progs internal header file fixes the conflict.

Signed-of-by: Ondrej Kozina <okozina@redhat.com>
---
 backref.c          |  1 +
 ctree.c            |  1 +
 extent_io.c        |  1 +
 file-item.c        |  1 +
 free-space-cache.c |  1 +
 inode-map.c        |  1 +
 internal.h         | 42 ++++++++++++++++++++++++++++++++++++++++++
 kerncompat.h       | 20 --------------------
 utils.h            |  1 +
 9 files changed, 49 insertions(+), 20 deletions(-)
 create mode 100644 internal.h

diff --git a/backref.c b/backref.c
index 8f41f82..7578e92 100644
--- a/backref.c
+++ b/backref.c
@@ -22,6 +22,7 @@
 #include "backref.h"
 #include "ulist.h"
 #include "transaction.h"
+#include "internal.h"
 
 #define pr_debug(...) do { } while (0)
 
diff --git a/ctree.c b/ctree.c
index 04cc476..1f938d7 100644
--- a/ctree.c
+++ b/ctree.c
@@ -20,6 +20,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "repair.h"
+#include "internal.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
diff --git a/extent_io.c b/extent_io.c
index 88e9273..bdaecc0 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -27,6 +27,7 @@
 #include "list.h"
 #include "ctree.h"
 #include "volumes.h"
+#include "internal.h"
 
 void extent_io_tree_init(struct extent_io_tree *tree)
 {
diff --git a/file-item.c b/file-item.c
index b46d7f1..7a3bbf3 100644
--- a/file-item.c
+++ b/file-item.c
@@ -25,6 +25,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "crc32c.h"
+#include "internal.h"
 
 #define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
 			       sizeof(struct btrfs_item) * 2) / \
diff --git a/free-space-cache.c b/free-space-cache.c
index d10a5f5..357d69e 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -24,6 +24,7 @@
 #include "extent_io.h"
 #include "crc32c.h"
 #include "bitops.h"
+#include "internal.h"
 
 /*
  * Kernel always uses PAGE_CACHE_SIZE for sectorsize, but we don't have
diff --git a/inode-map.c b/inode-map.c
index 346952b..9e4dcd3 100644
--- a/inode-map.c
+++ b/inode-map.c
@@ -19,6 +19,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "internal.h"
 
 /*
  * walks the btree of allocated inodes and find a hole.
diff --git a/internal.h b/internal.h
new file mode 100644
index 0000000..d5ea998
--- /dev/null
+++ b/internal.h
@@ -0,0 +1,42 @@
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
+#ifndef __INTERNAL_H__
+#define __INTERNAL_H__
+
+/*
+ * max/min macro
+ */
+#define min(x,y) ({ \
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void) (&_x == &_y);		\
+	_x < _y ? _x : _y; })
+
+#define max(x,y) ({ \
+	typeof(x) _x = (x);	\
+	typeof(y) _y = (y);	\
+	(void) (&_x == &_y);		\
+	_x > _y ? _x : _y; })
+
+#define min_t(type,x,y) \
+	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
+#define max_t(type,x,y) \
+	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
+
+#endif
diff --git a/kerncompat.h b/kerncompat.h
index 0f207b7..ee65aa7 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -241,26 +241,6 @@ static inline long IS_ERR(const void *ptr)
 }
 
 /*
- * max/min macro
- */
-#define min(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x < _y ? _x : _y; })
-
-#define max(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x > _y ? _x : _y; })
-
-#define min_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
-#define max_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
-
-/*
  * This looks more complex than it should be. But we need to
  * get the type for the ~ right in round_down (it needs to be
  * as wide as the result!), and we want to evaluate the macro
diff --git a/utils.h b/utils.h
index d53357a..a4e55bf 100644
--- a/utils.h
+++ b/utils.h
@@ -23,6 +23,7 @@
 #include "ctree.h"
 #include <dirent.h>
 #include <stdarg.h>
+#include "internal.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
