From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 07/18] btrfs: generic data structure to build unique lists
Date: Thu,  6 Oct 2011 17:54:17 +0200
Message-ID: <3a697c3e44dd5955c167f2f548ee4ced1e3dabef.1317915010.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

ulist is a generic data structures to hold a collection of unique u64
values. The only operations it supports is adding to the list and
enumerating it.
It is possible to store an auxiliary value along with the key.
The implementation is preliminary and can probably be sped up
significantly.
It is used by subvolume quota to translate recursions into iterative
loops.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/Makefile |    3 +-
 fs/btrfs/ulist.c  |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ulist.h  |   59 +++++++++++++++++++++++++
 3 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 40e6ac0..9ff560b 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,6 +7,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
-	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o
+	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
+	   ulist.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
new file mode 100644
index 0000000..756a937
--- /dev/null
+++ b/fs/btrfs/ulist.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2011 STRATO.  All rights reserved.
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
+#include <linux/sched.h>
+#include <linux/rbtree.h>
+#include <linux/slab.h>
+
+#include "ulist.h"
+
+void ulist_init(struct ulist *ulist, unsigned long gfp_mask)
+{
+	ulist->nnodes = 0;
+	ulist->gfp_mask = gfp_mask;
+	ulist->nodes = ulist->int_nodes;
+	ulist->nodes_alloced = ULIST_SIZE;
+}
+
+void ulist_fini(struct ulist *ulist)
+{
+	if (ulist->nodes_alloced > ULIST_SIZE)
+		kfree(ulist->nodes);
+}
+
+void ulist_reinit(struct ulist *ulist)
+{
+	ulist_fini(ulist);
+	ulist_init(ulist, ulist->gfp_mask);
+}
+
+struct ulist *ulist_alloc(unsigned long gfp_mask)
+{
+	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
+
+	if (!ulist)
+		return NULL;
+
+	ulist_init(ulist, gfp_mask);
+
+	return ulist;
+}
+
+void ulist_free(struct ulist *ulist)
+{
+	if (!ulist)
+		return;
+	ulist_fini(ulist);
+	kfree(ulist);
+}
+
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux)
+{
+	u64 i;
+
+	for (i = 0; i < ulist->nnodes; ++i) {
+		if (ulist->nodes[i].val == val)
+			return 0;
+	}
+
+	if (ulist->nnodes > ulist->nodes_alloced) {
+		u64 new_alloced = ulist->nodes_alloced + 128;
+		struct ulist_node *new_nodes = kmalloc(sizeof(*new_nodes) *
+					       new_alloced, ulist->gfp_mask);
+
+		if (!new_nodes)
+			return -ENOMEM;
+		memcpy(new_nodes, ulist->nodes,
+		       sizeof(*new_nodes) * ulist->nnodes);
+		if (ulist->nodes_alloced > ULIST_SIZE)
+			kfree(ulist->nodes);
+		ulist->nodes = new_nodes;
+		ulist->nodes_alloced = new_alloced;
+	}
+	ulist->nodes[ulist->nnodes].val = val;
+	ulist->nodes[ulist->nnodes].aux = aux;
+	ulist->nodes[ulist->nnodes].next = ulist->nnodes + 1;
+	++ulist->nnodes;
+
+	return 1;
+}
+
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
+{
+	if (ulist->nnodes == 0)
+		return NULL;
+
+	if (!prev)
+		return &ulist->nodes[0];
+
+	if (prev->next < 0 || prev->next >= ulist->nnodes)
+		return NULL;
+
+	return &ulist->nodes[prev->next];
+}
+
+int ulist_merge(struct ulist *dst, struct ulist *src)
+{
+	struct ulist_node *node = NULL;
+	int ret;
+
+	while ((node = ulist_next(src, node))) {
+		ret = ulist_add(dst, node->val, node->aux);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
new file mode 100644
index 0000000..2eb7e9d
--- /dev/null
+++ b/fs/btrfs/ulist.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2011 STRATO.  All rights reserved.
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
+#ifndef __BTRFS_ULIST__
+#define __BTRFS_ULIST__
+
+#include "ulist.h"
+
+#define ULIST_SIZE 16
+
+/*
+ * ulist is a generic data structures to hold a collection of unique u64
+ * values. The only operations it supports is adding to the list and
+ * enumerating it.
+ * It is possible to store an auxiliary value along with the key.
+ * The implementation is preliminary and can probably be sped up significantly.
+ */
+struct ulist_node {
+	u64 val;
+	unsigned long aux;
+	unsigned long next;
+};
+
+struct ulist {
+	unsigned long nnodes;
+	unsigned long gfp_mask;
+	struct ulist_node *nodes;
+	unsigned long nodes_alloced;
+	struct ulist_node int_nodes[ULIST_SIZE];
+};
+
+void ulist_init(struct ulist *ulist, unsigned long gfp_mask);
+void ulist_fini(struct ulist *ulist);
+void ulist_reinit(struct ulist *ulist);
+struct ulist *ulist_alloc(unsigned long gfp_mask);
+void ulist_free(struct ulist *ulist);
+
+/* returns < 0 on error, 0 on duplicate, 1 on insert */
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux);
+
+struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
+int ulist_merge(struct ulist *dst, struct ulist *src);
+
+#endif
-- 
1.7.3.4

