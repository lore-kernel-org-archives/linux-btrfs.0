Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35515 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754565AbdHYJTL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 05:19:11 -0400
Received: by mail-wr0-f194.google.com with SMTP id a47so1117256wra.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 02:19:10 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v7 1/6] Btrfs: heuristic make use compression workspaces
Date: Fri, 25 Aug 2017 12:18:40 +0300
Message-Id: <20170825091845.4120-2-nefelim4ag@gmail.com>
In-Reply-To: <20170825091845.4120-1-nefelim4ag@gmail.com>
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move heuristic to external file
Implement compression workspaces support for
heuristic resources

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/Makefile      |  2 +-
 fs/btrfs/compression.c | 18 +++++--------
 fs/btrfs/compression.h |  7 ++++-
 fs/btrfs/heuristic.c   | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 13 deletions(-)
 create mode 100644 fs/btrfs/heuristic.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17a80b0..6fa8479dff43 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o
+	   uuid-tree.o props.o hash.o free-space-tree.o heuristic.o

 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 883ecc58fd0d..f0aaf27bcc95 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -704,6 +704,7 @@ static struct {
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_heuristic,
 };

 void __init btrfs_init_compress(void)
@@ -1065,18 +1066,13 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	u64 index = start >> PAGE_SHIFT;
-	u64 end_index = end >> PAGE_SHIFT;
-	struct page *page;
-	int ret = 1;
+	int ret;
+	enum btrfs_compression_type type = BTRFS_HEURISTIC;
+	struct list_head *workspace = find_workspace(type);

-	while (index <= end_index) {
-		page = find_get_page(inode->i_mapping, index);
-		kmap(page);
-		kunmap(page);
-		put_page(page);
-		index++;
-	}
+	ret = btrfs_compress_op[type-1]->heuristic(workspace, inode,
+						   start, end);

+	free_workspace(type, workspace);
 	return ret;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 3b1b0ac15fdc..10e9ffa6dfa4 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -99,7 +99,8 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
+	BTRFS_HEURISTIC = 3,
+	BTRFS_COMPRESS_TYPES = 3,
 };

 struct btrfs_compress_op {
@@ -123,10 +124,14 @@ struct btrfs_compress_op {
 			  struct page *dest_page,
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
+
+	int (*heuristic)(struct list_head *workspace,
+			 struct inode *inode, u64 start, u64 end);
 };

 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
+extern const struct btrfs_compress_op btrfs_heuristic;

 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);

diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
new file mode 100644
index 000000000000..92f9335bafd4
--- /dev/null
+++ b/fs/btrfs/heuristic.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2017
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/sizes.h>
+#include <linux/pagemap.h>
+#include <linux/string.h>
+#include <linux/bio.h>
+#include "compression.h"
+
+struct workspace {
+	struct list_head list;
+};
+
+static void heuristic_free_workspace(struct list_head *ws)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	kfree(workspace);
+}
+
+static struct list_head *heuristic_alloc_workspace(void)
+{
+	struct workspace *workspace;
+
+	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
+	if (!workspace)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&workspace->list);
+
+	return &workspace->list;
+}
+
+static int heuristic(struct list_head *ws, struct inode *inode,
+		     u64 start, u64 end)
+{
+	struct page *page;
+	u64 index, index_end;
+
+	index = start >> PAGE_SHIFT;
+	index_end = end >> PAGE_SHIFT;
+
+	/* Don't miss unaligned end */
+	if (!IS_ALIGNED(end, PAGE_SIZE))
+		index_end++;
+
+	for (; index < index_end; index++) {
+		page = find_get_page(inode->i_mapping, index);
+		kmap(page);
+		kunmap(page);
+		put_page(page);
+	}
+
+	return 1;
+}
+
+const struct btrfs_compress_op btrfs_heuristic = {
+	.alloc_workspace	= heuristic_alloc_workspace,
+	.free_workspace		= heuristic_free_workspace,
+	.heuristic              = heuristic,
+};
--
2.14.1
