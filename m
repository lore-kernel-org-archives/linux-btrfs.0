From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 1/3] Btrfs: add the Probabilistic Skiplist
Date: Thu, 5 Jan 2012 17:30:20 +0800
Message-ID: <1325755822-13147-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1325755822-13147-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>, <dave@jikos.cz>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325755822-13147-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The Probabilistic Skiplist is a O(lgn) data structure, and
we want to apply this for later use, mainly for RCU-skiplist.

Note:
a) The skiplist is probabilistic, and it is the distribution of node sizes
   that is maintained, but the strict order is not required[1].

b) This skiplist cannot be resized once it is created,
   so here is a level limit 16 and an associated (and fixed) probability 0.25
   that determines the distribution of nodes[1].

c) The level limit may need to be adjusted.
   I know it is a magic number, but now for simplicity we just keep it at 16,
   and then each skiplist is able to contain (2^32-1)/3 nodes at most.

[1] http://www.csee.umbc.edu/courses/undergraduate/341/fall01/Lectures/SkipLists/skip_lists/skip_lists.html

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/Makefile   |    2 +-
 fs/btrfs/skiplist.c |   98 ++++++++++++++++++++++++
 fs/btrfs/skiplist.h |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 309 insertions(+), 1 deletions(-)
 create mode 100644 fs/btrfs/skiplist.c
 create mode 100644 fs/btrfs/skiplist.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index c0ddfd2..3284462 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,6 +8,6 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o
+	   reada.o backref.o skiplist.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
diff --git a/fs/btrfs/skiplist.c b/fs/btrfs/skiplist.c
new file mode 100644
index 0000000..c803478
--- /dev/null
+++ b/fs/btrfs/skiplist.c
@@ -0,0 +1,98 @@
+/*
+  The Probabilistic Skiplist
+  (C) 2011  Liu Bo <liubo2009@cn.fujitsu.com>
+
+  Based on the skiplist experiments of Con Kolivas <kernel@kolivas.org>
+  for BFS cpu scheduler.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include <linux/random.h>
+#include <linux/slab.h>
+#include "skiplist.h"
+
+inline int sl_fill_node(struct sl_node *node, int level, gfp_t mask)
+{
+	struct sl_node **p;
+	struct sl_node **q;
+	int num;
+
+	BUG_ON(level > MAXLEVEL);
+
+	num = level + 1;
+	p = kmalloc(sizeof(*p) * num, mask);
+	BUG_ON(!p);
+	if (!p)
+		return -ENOMEM;
+	q = kmalloc(sizeof(*q) * num, mask);
+	BUG_ON(!q);
+	if (!q) {
+		kfree(p);
+		return -ENOMEM;
+	}
+
+	node->next = p;
+	node->prev = q;
+	node->level = level;
+	return 0;
+}
+
+inline void sl_link_node(struct sl_node *node, struct sl_node **backlook,
+			 int level)
+{
+	struct sl_node *p, *q;
+	int i = 0;
+
+	do {
+		p = backlook[i];
+		q = p->next[i];
+
+		node->next[i] = q;
+		node->prev[i] = p;
+		p->next[i] = node;
+		q->prev[i] = node;
+
+		i++;
+	} while (i <= level);
+}
+
+void sl_erase(struct sl_node *node, struct sl_list *list)
+{
+	struct sl_node *prev, *next;
+	struct sl_node *head;
+	int level;
+	int i;
+
+	level = node->level;
+
+	for (i = 0; i <= level; i++) {
+		prev = node->prev[i];
+		next = node->next[i];
+
+		prev->next[i] = next;
+		next->prev[i] = prev;
+		node->next[i] = node;
+		node->prev[i] = node;
+	}
+
+	head = list->head;
+	if (level == list->level) {
+		while (head->next[level] == head &&
+		       head->prev[level] == head && level > 0)
+			level--;
+		list->level = level;
+	}
+}
diff --git a/fs/btrfs/skiplist.h b/fs/btrfs/skiplist.h
new file mode 100644
index 0000000..3e414b5
--- /dev/null
+++ b/fs/btrfs/skiplist.h
@@ -0,0 +1,210 @@
+/*
+  The Probabilistic Skiplist
+  (C) 2011  Liu Bo <liubo2009@cn.fujitsu.com>
+
+  Based on the skiplist experiments of Con Kolivas <kernel@kolivas.org>
+  for BFS cpu scheduler.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  To use skiplist you'll have to implement your own insert and search cores to
+  aviod us to use callbacks and to drop drammatically perfromances.
+
+  Here is some examples of insert and search:
+
+-------------------------------------------------------------------------------
+static inline
+struct extent_map *next_entry(struct sl_node *p, int l, struct sl_node **q)
+{
+	struct extent_map *ret;
+	struct sl_node *next;
+
+	next = p->next[l];
+	ret = sl_entry(next, struct extent_map, sl_node);
+	*q = next;
+	return ret;
+}
+
+static inline
+struct sl_node *sl_search(struct sl_list *list, u64 offset)
+{
+	struct sl_node *p, *q;
+	struct extent_map *entry;
+	int level;
+
+	level = list->level;
+	p = list->head;
+	do {
+		while (entry = next_entry(p, level, &q), entry->off <= offset)
+			p = q;
+
+		entry = sl_entry(p, struct sl_node, sl_node);
+		if (entry->off == offset)
+			return p;
+
+		level--;
+	} while (level >= 0);
+	return NULL;
+}
+
+static
+struct sl_node *sl_insert_node(struct sl_list *list, u64 offset,
+			       struct sl_node *node)
+{
+	struct extent_map *entry;
+	struct sl_node *backlook[MAXLEVEL], *p, *q;
+	u64 randseed;
+	int level;
+	int ret;
+
+	level = list->level;
+	p = list->head;
+	do {
+		while (entry = next_entry(p, level, &q), entry->off <= offset)
+			p = q;
+
+		entry = sl_entry(p, struct sl_node, sl_node);
+		if (entry->off == offset)
+			return p;
+
+		level--;
+	} while (level >= 0);
+
+	get_random_bytes(&randseed, sizeof(u64));
+	level = generate_node_level(randseed);
+	if (level > list->level) {
+		list->level++;
+		level = list->level;
+		backlook[level] = list->head;
+	}
+
+	if (ret = sl_fill_node(node, level, GFP_ATOMIC))
+		return ERR_PTR(ret);
+	sl_link_node(node, backlook, level);
+	return NULL;
+}
+-------------------------------------------------------------------------------
+*/
+
+#ifndef _SKIPLIST_H
+#define _SKIPLIST_H
+
+#include <linux/random.h>
+
+#define MAXLEVEL 16
+/* double p = 0.25; */
+
+struct sl_node {
+	struct sl_node **next;
+	struct sl_node **prev;
+	unsigned int level;
+	unsigned int head:1;
+};
+
+struct sl_list {
+	struct sl_node *head;
+	struct sl_node *h_next[MAXLEVEL];
+	struct sl_node *h_prev[MAXLEVEL];
+	unsigned int level;
+};
+
+#define sl_entry(ptr, type, member) container_of(ptr, type, member)
+
+static inline int sl_empty(const struct sl_node *head)
+{
+	return head->next[0] == head;
+}
+
+static inline struct sl_node *__sl_next_with_level(struct sl_node *node,
+						   int level)
+{
+	return node->next[level];
+}
+
+static inline struct sl_node *__sl_prev_with_level(struct sl_node *node,
+						   int level)
+{
+	return node->prev[level];
+}
+
+static inline struct sl_node *sl_next(struct sl_node *node)
+{
+	struct sl_node *ret;
+
+	ret = __sl_next_with_level(node, 0);
+	if (ret->head)
+		return NULL;
+
+	return ret;
+}
+
+static inline struct sl_node *sl_prev(struct sl_node *node)
+{
+	struct sl_node *ret;
+
+	ret = __sl_prev_with_level(node, 0);
+	if (ret->head)
+		return NULL;
+
+	return ret;
+}
+
+static inline void sl_init_list(struct sl_list *list, struct sl_node *head)
+{
+	int i;
+
+	list->head = head;
+	list->level = 0;
+	for (i = 0; i < MAXLEVEL; i++)
+		list->h_next[i] = list->h_prev[i] = list->head;
+
+	head->next = list->h_next;
+	head->prev = list->h_prev;
+	head->head = 1;
+}
+
+static inline void sl_init_node(struct sl_node *node)
+{
+	node->head = 0;
+	node->level = 0;
+	node->next = NULL;
+	node->prev = NULL;
+}
+
+static inline void sl_free_node(struct sl_node *node)
+{
+	kfree(node->next);
+	kfree(node->prev);
+}
+
+static inline int generate_node_level(u64 randseed)
+{
+	int level = 0;
+
+	while (randseed && !(randseed & 3)) {
+		randseed >>= 2;
+		level++;
+	}
+
+	return (level > MAXLEVEL ? MAXLEVEL : level);
+}
+
+
+inline int sl_fill_node(struct sl_node *node, int level, gfp_t mask);
+inline void sl_link_node(struct sl_node *node, struct sl_node **backlook,
+			 int level);
+void sl_erase(struct sl_node *node, struct sl_list *list);
+
+#endif /* _SKIPLIST_H */
-- 
1.6.5.2

