Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64851 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbbG1JRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 05:17:14 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S9FK85022610
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 17:15:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 03/14] btrfs: dedup: Add basic init/free functions for inband dedup.
Date: Tue, 28 Jul 2015 17:14:56 +0800
Message-ID: <9e23934da6517550d02b67571fabbfe9f2e6b55d.1438074833.git.quwenruo@cn.fujitsu.com>
In-Reply-To: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
References: <cover.1438074833.git.quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic data structures and their init/free functions for later inband
dedup implment.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/Makefile  |  2 +-
 fs/btrfs/ctree.h   |  5 ++++
 fs/btrfs/dedup.c   | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h   | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |  7 +++++
 5 files changed, 185 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 6d1d0b9..a8bd917 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o
+	   uuid-tree.o props.o hash.o dedup.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68ffd26..7f37637 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "dedup.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -1788,6 +1789,9 @@ struct btrfs_fs_info {
 	 * and will be latter freed. Protected by fs_info->chunk_mutex.
 	 */
 	struct list_head pinned_chunks;
+
+	/* Inband deduplication stuff */
+	struct btrfs_dedup_root *dedup_root;
 };
 
 struct btrfs_subvolume_writers {
@@ -3685,6 +3689,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
+	btrfs_free_dedup(fs_info);
 	kfree(fs_info);
 }
 
diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
new file mode 100644
index 0000000..41f70f5
--- /dev/null
+++ b/fs/btrfs/dedup.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) 2015 Fujitsu.  All rights reserved.
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
+#include "ctree.h"
+#include "dedup.h"
+
+/* SHA256, 256bits = 32 bytes  */
+static int btrfs_dedup_sizes[] = { 0, 32 };
+
+struct kmem_cache *btrfs_dedup_hash_cachep;
+
+int btrfs_init_dedup(struct btrfs_fs_info *fs_info, u8 dedup_type)
+{
+	struct btrfs_dedup_root *dedup_root;
+	int ret = 0;
+
+	if (dedup_type > ARRAY_SIZE(btrfs_dedup_sizes)) {
+		pr_err("BTRFS: unsopported dedup");
+		return -EINVAL;
+	}
+
+	if (!dedup_type) {
+		fs_info->dedup_root = NULL;
+		return 0;
+	}
+
+	btrfs_dedup_hash_cachep = kmem_cache_create("btrfs_dedup_hash",
+				sizeof(struct btrfs_dedup_hash), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_dedup_hash_cachep) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	fs_info->dedup_root = kzalloc(sizeof(struct btrfs_dedup_root),
+				      GFP_NOFS);
+	if (!fs_info->dedup_root) {
+		ret = -ENOMEM;
+		goto fail_hash_cachep;
+	}
+	dedup_root = fs_info->dedup_root;
+	dedup_root->dedup_type = dedup_type;
+
+	switch (dedup_type) {
+	case BTRFS_DEDUP_HASH_SHA256:
+		dedup_root->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
+		if (IS_ERR(dedup_root->dedup_driver)) {
+			pr_err("BTRFS: Cannot load sha256 driver\n");
+			goto fail_dedup_root;
+		}
+	}
+
+	dedup_root->hash_root = RB_ROOT;
+	dedup_root->bytenr_root = RB_ROOT;
+	INIT_LIST_HEAD(&dedup_root->lru_list);
+	spin_lock_init(&dedup_root->lock);
+	return 0;
+
+fail_dedup_root:
+	kfree(dedup_root);
+fail_hash_cachep:
+	kmem_cache_destroy(btrfs_dedup_hash_cachep);
+fail:
+	return ret;
+}
+
+void btrfs_free_dedup(struct btrfs_fs_info *fs_info)
+{
+	if (!fs_info->dedup_root)
+		return;
+
+	kfree(fs_info->dedup_root);
+	return;
+}
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
new file mode 100644
index 0000000..341ca33
--- /dev/null
+++ b/fs/btrfs/dedup.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2015 Fujitsu.  All rights reserved.
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
+#ifndef __DEDUP__
+#define __DEDUP__
+
+#include <linux/rbtree.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <crypto/hash.h>
+
+#define BTRFS_DEDUP_DISABLED	0
+#define BTRFS_DEDUP_HASH_SHA256	1
+
+/*
+ * As we need to use kmem_cache to speed the super frequent memory alloc,
+ * we can't use variable length array in btrfs_dedup_hash.
+ * So set DEDUP_HASH_SIZE to a fixed size
+ *
+ * The 32 bytes is for SHA256 so far.
+ */
+#define BTRFS_DEDUP_HASH_SIZE	32
+
+extern struct kmem_cache *btrfs_dedup_hash_cachep;
+
+struct btrfs_dedup_hash {
+	/* Hash -> extent(bytenr + offset) search, for dedup search */
+	struct rb_node hash_node;
+
+	/* Extent(bytenr + offset) -> hash search, for free extent */
+	struct rb_node bytenr_node;
+
+	/* LRU list to maintain low memory usage */
+	struct list_head lru_list;
+
+	/* The bytenr of the data extent */
+	u64 bytenr;
+
+	/* The length of the data extent */
+	u64 length;
+
+	/*
+	 * The offset inside the extent
+	 * TODO: Use offset to support compression
+	 */
+	u32 offset;
+
+	/* fixed length for hash, it's OK not to use full of them */
+	char hash[BTRFS_DEDUP_HASH_SIZE];
+};
+
+struct btrfs_dedup_root {
+	struct rb_root hash_root;
+	struct rb_root bytenr_root;
+	struct list_head lru_list;
+
+	spinlock_t lock;
+
+	struct crypto_shash *dedup_driver;
+	u8 dedup_type;
+
+	/* To limit the amount of btrfs_dedup_hash */
+	u32 limit_nr;
+	u32 current_nr;
+};
+
+int btrfs_init_dedup(struct btrfs_fs_info *fs_info, u8 dedup_type);
+void btrfs_free_dedup(struct btrfs_fs_info *fs_info);
+#endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a9aadb2..3997bd9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2633,6 +2634,12 @@ int open_ctree(struct super_block *sb,
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
+	/* TODO: use real dedup type other than 0 */
+	ret = btrfs_init_dedup(fs_info, 0);
+	if (ret) {
+		err = -ret;
+		goto fail_alloc;
+	}
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
-- 
2.4.6

