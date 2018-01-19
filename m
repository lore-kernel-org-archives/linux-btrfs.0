Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42121 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753412AbeASFhq (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:46 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 03/16] btrfs-progs: check: Move definitions of lowmem mode to check/lowmem.h
Date: Fri, 19 Jan 2018 13:37:18 +0800
Message-Id: <20180119053731.10795-4-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike original mode, lowmem mode mostly uses normal tree operations, so
no structure definitions, only a lot of random error bits.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/lowmem.h | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 check/main.c   | 39 +-----------------------------------
 2 files changed, 63 insertions(+), 38 deletions(-)
 create mode 100644 check/lowmem.h

diff --git a/check/lowmem.h b/check/lowmem.h
new file mode 100644
index 000000000000..e6ca7634022c
--- /dev/null
+++ b/check/lowmem.h
@@ -0,0 +1,62 @@
+/*
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
+/*
+ * Defines and function declarations for lowmem mode check.
+ */
+#ifndef __BTRFS_CHECK_LOWMEM_H__
+#define __BTRFS_CHECK_LOWMEM_H__
+
+#define ROOT_DIR_ERROR		(1<<1)	/* bad ROOT_DIR */
+#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
+#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
+#define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
+#define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
+#define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
+#define FILE_EXTENT_ERROR	(1<<7)	/* bad FILE_EXTENT */
+#define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM error */
+#define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
+#define LINK_COUNT_ERROR	(1<<10)	/* INODE_ITEM nlink count error */
+#define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
+#define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
+#define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
+#define NO_INODE_ITEM		(1<<14) /* no inode_item */
+#define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
+#define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
+#define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
+#define DIR_INDEX_MISSING       (1<<18) /* INODE_INDEX not found */
+#define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
+#define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
+#define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
+
+/*
+ * Error bit for low memory mode check.
+ *
+ * Currently no caller cares about it yet.  Just internal use for error
+ * classification.
+ */
+#define BACKREF_MISSING		(1 << 0) /* Backref missing in extent tree */
+#define BACKREF_MISMATCH	(1 << 1) /* Backref exists but does not match */
+#define BYTES_UNALIGNED		(1 << 2) /* Some bytes are not aligned */
+#define REFERENCER_MISSING	(1 << 3) /* Referencer not found */
+#define REFERENCER_MISMATCH	(1 << 4) /* Referenceer found but does not match */
+#define CROSSING_STRIPE_BOUNDARY (1 << 4) /* For kernel scrub workaround */
+#define ITEM_SIZE_MISMATCH	(1 << 5) /* Bad item size */
+#define UNKNOWN_TYPE		(1 << 6) /* Unknown type */
+#define ACCOUNTING_MISMATCH	(1 << 7) /* Used space accounting error */
+#define CHUNK_TYPE_MISMATCH	(1 << 8)
+
+#endif
diff --git a/check/main.c b/check/main.c
index c91a949ff7cc..dbd2b755c48f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -44,6 +44,7 @@
 #include "hash.h"
 #include "help.h"
 #include "check/original.h"
+#include "check/lowmem.h"
 
 enum task_position {
 	TASK_EXTENTS,
@@ -85,28 +86,6 @@ enum btrfs_check_mode {
 
 static enum btrfs_check_mode check_mode = CHECK_MODE_DEFAULT;
 
-#define ROOT_DIR_ERROR		(1<<1)	/* bad ROOT_DIR */
-#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
-#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
-#define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
-#define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
-#define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
-#define FILE_EXTENT_ERROR	(1<<7)	/* bad FILE_EXTENT */
-#define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM error */
-#define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
-#define LINK_COUNT_ERROR	(1<<10)	/* INODE_ITEM nlink count error */
-#define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
-#define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
-#define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
-#define NO_INODE_ITEM		(1<<14) /* no inode_item */
-#define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
-#define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
-#define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
-#define DIR_INDEX_MISSING       (1<<18) /* INODE_INDEX not found */
-#define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
-#define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
-#define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
-
 static int compare_data_backref(struct rb_node *node1, struct rb_node *node2)
 {
 	struct extent_backref *ext1 = rb_node_to_extent_backref(node1);
@@ -193,22 +172,6 @@ static int compare_extent_backref(struct rb_node *node1, struct rb_node *node2)
 		return compare_tree_backref(node1, node2);
 }
 
-/*
- * Error bit for low memory mode check.
- *
- * Currently no caller cares about it yet.  Just internal use for error
- * classification.
- */
-#define BACKREF_MISSING		(1 << 0) /* Backref missing in extent tree */
-#define BACKREF_MISMATCH	(1 << 1) /* Backref exists but does not match */
-#define BYTES_UNALIGNED		(1 << 2) /* Some bytes are not aligned */
-#define REFERENCER_MISSING	(1 << 3) /* Referencer not found */
-#define REFERENCER_MISMATCH	(1 << 4) /* Referenceer found but does not match */
-#define CROSSING_STRIPE_BOUNDARY (1 << 4) /* For kernel scrub workaround */
-#define ITEM_SIZE_MISMATCH	(1 << 5) /* Bad item size */
-#define UNKNOWN_TYPE		(1 << 6) /* Unknown type */
-#define ACCOUNTING_MISMATCH	(1 << 7) /* Used space accounting error */
-#define CHUNK_TYPE_MISMATCH	(1 << 8)
 
 static void *print_status_check(void *p)
 {
-- 
2.15.1

