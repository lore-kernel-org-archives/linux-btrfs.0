Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3IQPZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:25:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2ABC5A535B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 17:24:56 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: add list_sort and use it to sort devices by id
Date: Tue, 17 Sep 2013 17:24:53 +0200
Message-Id: <1379431493-30646-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The devices in 'btrfs filesystem show' are now sorted by the device id,
currently the order was undefined.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile          |   2 +-
 cmds-filesystem.c |  19 ++++++-
 list_sort.c       | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 list_sort.h       |  14 ++++++
 4 files changed, 176 insertions(+), 3 deletions(-)
 create mode 100644 list_sort.c
 create mode 100644 list_sort.h

diff --git a/Makefile b/Makefile
index 3d715d8..8678b5c 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o uuid-tree.o
+	  qgroup.o raid6.o free-space-cache.o uuid-tree.o list_sort.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 815d59a..93fd0eb 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -28,10 +28,9 @@
 #include "ioctl.h"
 #include "utils.h"
 #include "volumes.h"
-
 #include "version.h"
-
 #include "commands.h"
+#include "list_sort.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -183,6 +182,21 @@ static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 	return 0;
 }
 
+/*
+ * Sort devices by devid, ascending
+ */
+static int cmp_device_id(void *priv, struct list_head *a,
+		struct list_head *b)
+{
+	const struct btrfs_device *da = list_entry(a, struct btrfs_device,
+			dev_list);
+	const struct btrfs_device *db = list_entry(b, struct btrfs_device,
+			dev_list);
+
+	return da->devid < db->devid ? -1 :
+		da->devid > db->devid ? 1 : 0;
+}
+
 static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 {
 	char uuidbuf[37];
@@ -205,6 +219,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	       (unsigned long long)total,
 	       pretty_size(device->super_bytes_used));
 
+	list_sort(NULL, &fs_devices->devices, cmp_device_id);
 	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 
diff --git a/list_sort.c b/list_sort.c
new file mode 100644
index 0000000..f526b40
--- /dev/null
+++ b/list_sort.c
@@ -0,0 +1,144 @@
+/*
+ * taken from linux kernel lib/list_sort.c, removed uneeded code and adapted
+ * for btrfsprogs
+ */
+
+#include "kerncompat.h"
+#include "list_sort.h"
+#include "list.h"
+
+#define MAX_LIST_LENGTH_BITS 20
+
+/*
+ * Returns a list organized in an intermediate format suited
+ * to chaining of merge() calls: null-terminated, no reserved or
+ * sentinel head node, "prev" links not maintained.
+ */
+static struct list_head *merge(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+/*
+ * Combine final list merge with restoration of standard doubly-linked
+ * list structure.  This approach duplicates code from merge(), but
+ * runs faster than the tidier alternatives of either a separate final
+ * prev-link restoration pass, or maintaining the prev links
+ * throughout.
+ */
+static void merge_and_restore_back_links(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *head,
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head *tail = head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a->prev = tail;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b->prev = tail;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a ? : b;
+
+	do {
+		/*
+		 * In worst cases this loop may run many iterations.
+		 * Continue callbacks to the client even though no
+		 * element comparison is needed, so the client's cmp()
+		 * routine can invoke cond_resched() periodically.
+		 */
+		(*cmp)(priv, tail->next, tail->next);
+
+		tail->next->prev = tail;
+		tail = tail->next;
+	} while (tail->next);
+
+	tail->next = head;
+	head->prev = tail;
+}
+
+/**
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
+ *
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
+ */
+void list_sort(void *priv, struct list_head *head,
+		int (*cmp)(void *priv, struct list_head *a,
+			struct list_head *b))
+{
+	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
+						-- last slot is a sentinel */
+	int lev;  /* index into part[] */
+	int max_lev = 0;
+	struct list_head *list;
+
+	if (list_empty(head))
+		return;
+
+	memset(part, 0, sizeof(part));
+
+	head->prev->next = NULL;
+	list = head->next;
+
+	while (list) {
+		struct list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (lev >= ARRAY_SIZE(part)-1) {
+				printf("list_sort: list passed to"
+					" list_sort() too long for"
+					" efficiency\n");
+				lev--;
+			}
+			max_lev = lev;
+		}
+		part[lev] = cur;
+	}
+
+	for (lev = 0; lev < max_lev; lev++)
+		if (part[lev])
+			list = merge(priv, cmp, part[lev], list);
+
+	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+}
diff --git a/list_sort.h b/list_sort.h
new file mode 100644
index 0000000..987cd5c
--- /dev/null
+++ b/list_sort.h
@@ -0,0 +1,14 @@
+/*
+ * taken from linux kernel include/list_sort.h
+ */
+#ifndef _LINUX_LIST_SORT_H
+#define _LINUX_LIST_SORT_H
+
+#include "kerncompat.h"
+
+struct list_head;
+
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
+#endif
-- 
1.8.3.1

