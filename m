Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53458 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754941AbaJJU5b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:31 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKsF3n012661
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:30 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxmbv8mvn-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:30 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/12] Btrfs-progs: break out rbtree util functions
Date: Fri, 10 Oct 2014 16:57:08 -0400
Message-ID: <1412974637-31334-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These were added to deal with duplicated functionality within btrfs-progs, but
we specifically copied rbtree.c from the kernel, so move these functions out
into their own file.  This will make it easier to keep rbtree.c in sync.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 Makefile        |  2 +-
 btrfs-list.c    |  1 +
 cmds-check.c    |  1 +
 disk-io.c       |  1 +
 extent-cache.c  |  1 +
 qgroup-verify.c |  1 +
 rbtree-utils.c  | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rbtree-utils.h  | 45 +++++++++++++++++++++++++++++++
 rbtree.c        | 63 --------------------------------------------
 rbtree.h        | 22 ----------------
 10 files changed, 133 insertions(+), 86 deletions(-)
 create mode 100644 rbtree-utils.c
 create mode 100644 rbtree-utils.h

diff --git a/Makefile b/Makefile
index f954649..a0afe3b 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
-	  ulist.o qgroup-verify.o backref.o
+	  ulist.o qgroup-verify.o backref.o rbtree-utils.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs-list.c b/btrfs-list.c
index 01ccca9..b6b8493 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -33,6 +33,7 @@
 #include "utils.h"
 #include <uuid/uuid.h>
 #include "btrfs-list.h"
+#include "rbtree-utils.h"
 
 #define BTRFS_LIST_NFILTERS_INCREASE	(2 * BTRFS_LIST_FILTER_MAX)
 #define BTRFS_LIST_NCOMPS_INCREASE	(2 * BTRFS_LIST_COMP_MAX)
diff --git a/cmds-check.c b/cmds-check.c
index a7e0840..ff9c0d5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -39,6 +39,7 @@
 #include "free-space-cache.h"
 #include "btrfsck.h"
 #include "qgroup-verify.h"
+#include "rbtree-utils.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
diff --git a/disk-io.c b/disk-io.c
index 34c0a97..08be53a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -34,6 +34,7 @@
 #include "crc32c.h"
 #include "utils.h"
 #include "print-tree.h"
+#include "rbtree-utils.h"
 
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
diff --git a/extent-cache.c b/extent-cache.c
index 84de87b..7656ab2 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -19,6 +19,7 @@
 #include <stdlib.h>
 #include "kerncompat.h"
 #include "extent-cache.h"
+#include "rbtree-utils.h"
 
 struct cache_extent_search_range {
 	u64 objectid;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 430f099..c0c61d0 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -28,6 +28,7 @@
 #include "print-tree.h"
 #include "utils.h"
 #include "ulist.h"
+#include "rbtree-utils.h"
 
 #include "qgroup-verify.h"
 
diff --git a/rbtree-utils.c b/rbtree-utils.c
new file mode 100644
index 0000000..7371bbb
--- /dev/null
+++ b/rbtree-utils.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2014 Facebook.  All rights reserved.
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
+#include "rbtree-utils.h"
+
+int rb_insert(struct rb_root *root, struct rb_node *node,
+	      rb_compare_nodes comp)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	while(*p) {
+		parent = *p;
+
+		ret = comp(parent, node);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return 0;
+}
+
+struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
+			  struct rb_node **next_ret)
+{
+	struct rb_node *n = root->rb_node;
+	struct rb_node *parent = NULL;
+	int ret = 0;
+
+	while(n) {
+		parent = n;
+
+		ret = comp(n, key);
+		if (ret < 0)
+			n = n->rb_left;
+		else if (ret > 0)
+			n = n->rb_right;
+		else
+			return n;
+	}
+
+	if (!next_ret)
+		return NULL;
+
+	if (parent && ret > 0)
+		parent = rb_next(parent);
+
+	*next_ret = parent;
+	return NULL;
+}
+
+void rb_free_nodes(struct rb_root *root, rb_free_node free_node)
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(root))) {
+		rb_erase(node, root);
+		free_node(node);
+	}
+}
diff --git a/rbtree-utils.h b/rbtree-utils.h
new file mode 100644
index 0000000..7298c72
--- /dev/null
+++ b/rbtree-utils.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2014 Facebook.  All rights reserved.
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
+#ifndef __RBTREE_UTILS__
+#define __RBTREE_UTILS__
+
+#include "rbtree.h"
+
+/* The common insert/search/free functions */
+typedef int (*rb_compare_nodes)(struct rb_node *node1, struct rb_node *node2);
+typedef int (*rb_compare_keys)(struct rb_node *node, void *key);
+typedef void (*rb_free_node)(struct rb_node *node);
+
+int rb_insert(struct rb_root *root, struct rb_node *node,
+	      rb_compare_nodes comp);
+/*
+ * In some cases, we need return the next node if we don't find the node we
+ * specify. At this time, we can use next_ret.
+ */
+struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
+			  struct rb_node **next_ret);
+void rb_free_nodes(struct rb_root *root, rb_free_node free_node);
+
+#define FREE_RB_BASED_TREE(name, free_func)		\
+static void free_##name##_tree(struct rb_root *root)	\
+{							\
+	rb_free_nodes(root, free_func);			\
+}
+
+#endif
diff --git a/rbtree.c b/rbtree.c
index 4c06b0c..6ad800f 100644
--- a/rbtree.c
+++ b/rbtree.c
@@ -387,66 +387,3 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	/* Copy the pointers/colour from the victim to the replacement */
 	*new = *victim;
 }
-
-int rb_insert(struct rb_root *root, struct rb_node *node,
-	      rb_compare_nodes comp)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	int ret;
-
-	while(*p) {
-		parent = *p;
-
-		ret = comp(parent, node);
-		if (ret < 0)
-			p = &(*p)->rb_left;
-		else if (ret > 0)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
-
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return 0;
-}
-
-struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
-			  struct rb_node **next_ret)
-{
-	struct rb_node *n = root->rb_node;
-	struct rb_node *parent = NULL;
-	int ret = 0;
-
-	while(n) {
-		parent = n;
-
-		ret = comp(n, key);
-		if (ret < 0)
-			n = n->rb_left;
-		else if (ret > 0)
-			n = n->rb_right;
-		else
-			return n;
-	}
-
-	if (!next_ret)
-		return NULL;
-
-	if (parent && ret > 0)
-		parent = rb_next(parent);
-
-	*next_ret = parent;
-	return NULL;
-}
-
-void rb_free_nodes(struct rb_root *root, rb_free_node free_node)
-{
-	struct rb_node *node;
-
-	while ((node = rb_first(root))) {
-		rb_erase(node, root);
-		free_node(node);
-	}
-}
diff --git a/rbtree.h b/rbtree.h
index 48e5157..3add424 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -157,26 +157,4 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 
 	*rb_link = node;
 }
-
-/* The common insert/search/free functions */
-typedef int (*rb_compare_nodes)(struct rb_node *node1, struct rb_node *node2);
-typedef int (*rb_compare_keys)(struct rb_node *node, void *key);
-typedef void (*rb_free_node)(struct rb_node *node);
-
-int rb_insert(struct rb_root *root, struct rb_node *node,
-	      rb_compare_nodes comp);
-/*
- * In some cases, we need return the next node if we don't find the node we
- * specify. At this time, we can use next_ret.
- */
-struct rb_node *rb_search(struct rb_root *root, void *key, rb_compare_keys comp,
-			  struct rb_node **next_ret);
-void rb_free_nodes(struct rb_root *root, rb_free_node free_node);
-
-#define FREE_RB_BASED_TREE(name, free_func)		\
-static void free_##name##_tree(struct rb_root *root)	\
-{							\
-	rb_free_nodes(root, free_func);			\
-}
-
 #endif	/* _LINUX_RBTREE_H */
-- 
1.8.3.1

