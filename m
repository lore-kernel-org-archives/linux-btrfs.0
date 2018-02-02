Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:42666 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbeBBITo (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Feb 2018 03:19:44 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 6/7] btrfs-progs: kernel-lib: Port kernel sort() to btrfs-progs
Date: Fri,  2 Feb 2018 16:19:28 +0800
Message-Id: <20180202081929.15162-7-wqu@suse.com>
In-Reply-To: <20180202081929.15162-1-wqu@suse.com>
References: <20180202081929.15162-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Used by later btrfs_alloc_chunk() rework.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile          |   3 +-
 kernel-lib/sort.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel-lib/sort.h |  16 +++++++++
 3 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100644 kernel-lib/sort.c
 create mode 100644 kernel-lib/sort.h

diff --git a/Makefile b/Makefile
index 327cdfa08eba..3db7bbe04662 100644
--- a/Makefile
+++ b/Makefile
@@ -106,7 +106,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o \
+	  kernel-lib/sort.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
diff --git a/kernel-lib/sort.c b/kernel-lib/sort.c
new file mode 100644
index 000000000000..70ae3dbe2852
--- /dev/null
+++ b/kernel-lib/sort.c
@@ -0,0 +1,104 @@
+/*
+ * taken from linux kernel lib/sort.c, removed kernel config code and adapted
+ * for btrfsprogs
+ */
+
+#include "sort.h"
+
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A fast, small, non-recursive O(nlog n) sort for the Linux kernel
+ *
+ * Jan 23 2005  Matt Mackall <mpm@selenic.com>
+ */
+
+static int alignment_ok(const void *base, int align)
+{
+	return ((unsigned long)base & (align - 1)) == 0;
+}
+
+static void u32_swap(void *a, void *b, int size)
+{
+	u32 t = *(u32 *)a;
+	*(u32 *)a = *(u32 *)b;
+	*(u32 *)b = t;
+}
+
+static void u64_swap(void *a, void *b, int size)
+{
+	u64 t = *(u64 *)a;
+	*(u64 *)a = *(u64 *)b;
+	*(u64 *)b = t;
+}
+
+static void generic_swap(void *a, void *b, int size)
+{
+	char t;
+
+	do {
+		t = *(char *)a;
+		*(char *)a++ = *(char *)b;
+		*(char *)b++ = t;
+	} while (--size > 0);
+}
+
+/**
+ * sort - sort an array of elements
+ * @base: pointer to data to sort
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp_func: pointer to comparison function
+ * @swap_func: pointer to swap function or NULL
+ *
+ * This function does a heapsort on the given array. You may provide a
+ * swap_func function optimized to your element type.
+ *
+ * Sorting time is O(n log n) both on average and worst-case. While
+ * qsort is about 20% faster on average, it suffers from exploitable
+ * O(n*n) worst-case behavior and extra memory requirements that make
+ * it less suitable for kernel use.
+ */
+
+void sort(void *base, size_t num, size_t size,
+	  int (*cmp_func)(const void *, const void *),
+	  void (*swap_func)(void *, void *, int size))
+{
+	/* pre-scale counters for performance */
+	int i = (num/2 - 1) * size, n = num * size, c, r;
+
+	if (!swap_func) {
+		if (size == 4 && alignment_ok(base, 4))
+			swap_func = u32_swap;
+		else if (size == 8 && alignment_ok(base, 8))
+			swap_func = u64_swap;
+		else
+			swap_func = generic_swap;
+	}
+
+	/* heapify */
+	for ( ; i >= 0; i -= size) {
+		for (r = i; r * 2 + size < n; r  = c) {
+			c = r * 2 + size;
+			if (c < n - size &&
+					cmp_func(base + c, base + c + size) < 0)
+				c += size;
+			if (cmp_func(base + r, base + c) >= 0)
+				break;
+			swap_func(base + r, base + c, size);
+		}
+	}
+
+	/* sort */
+	for (i = n - size; i > 0; i -= size) {
+		swap_func(base, base + i, size);
+		for (r = 0; r * 2 + size < i; r = c) {
+			c = r * 2 + size;
+			if (c < i - size &&
+					cmp_func(base + c, base + c + size) < 0)
+				c += size;
+			if (cmp_func(base + r, base + c) >= 0)
+				break;
+			swap_func(base + r, base + c, size);
+		}
+	}
+}
diff --git a/kernel-lib/sort.h b/kernel-lib/sort.h
new file mode 100644
index 000000000000..9355e01248f2
--- /dev/null
+++ b/kernel-lib/sort.h
@@ -0,0 +1,16 @@
+/*
+ * taken from linux kernel include/list_sort.h
+ * changed include to kerncompat.h
+ */
+
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SORT_H
+#define _LINUX_SORT_H
+
+#include "kerncompat.h"
+
+void sort(void *base, size_t num, size_t size,
+	  int (*cmp)(const void *, const void *),
+	  void (*swap)(void *, void *, int));
+
+#endif
-- 
2.16.1

