Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbcBEBY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:59 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 01/19] btrfs: dedup: Introduce dedup framework and its header
Date: Fri,  5 Feb 2016 09:22:21 +0800
Message-Id: <1454635359-10013-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce the header for btrfs online(write time) de-duplication
framework and needed header.

The new de-duplication framework is going to support 2 different dedup
method and 1 dedup hash.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |   5 +++
 fs/btrfs/dedup.h   | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c |   1 +
 3 files changed, 133 insertions(+)
 create mode 100644 fs/btrfs/dedup.h

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a949664..7de2ddb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1860,6 +1860,11 @@ struct btrfs_fs_info {
 	struct list_head pinned_chunks;
 
 	int creating_free_space_tree;
+
+	/* Inband de-duplication related structures*/
+	unsigned int dedup_enabled:1;
+	struct btrfs_dedup_info *dedup_info;
+	struct mutex dedup_ioctl_lock;
 };
 
 struct btrfs_subvolume_writers {
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
new file mode 100644
index 0000000..8e1ff03
--- /dev/null
+++ b/fs/btrfs/dedup.h
@@ -0,0 +1,127 @@
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
+#ifndef __BTRFS_DEDUP__
+#define __BTRFS_DEDUP__
+
+#include <linux/btrfs.h>
+#include <linux/wait.h>
+#include <crypto/hash.h>
+
+/*
+ * Dedup storage backend
+ * On disk is persist storage but overhead is large
+ * In memory is fast but will lose all its hash on umount
+ */
+#define BTRFS_DEDUP_BACKEND_INMEMORY		0
+#define BTRFS_DEDUP_BACKEND_ONDISK		1
+#define BTRFS_DEDUP_BACKEND_LAST		2
+
+/* Dedup block size limit and default value */
+#define BTRFS_DEDUP_BLOCKSIZE_MAX	(8 * 1024 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_MIN	(16 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_DEFAULT	(128 * 1024)
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUP_HASH_SHA256		0
+
+static int btrfs_dedup_sizes[] = { 32 };
+
+/*
+ * For caller outside of dedup.c
+ *
+ * Different dedup backends should have their own hash structure
+ */
+struct btrfs_dedup_hash {
+	u64 bytenr;
+	u32 num_bytes;
+
+	/* last field is a variable length array of dedup hash */
+	u8 hash[];
+};
+
+struct btrfs_dedup_info {
+	/* dedup blocksize */
+	u64 blocksize;
+	u16 backend;
+	u16 hash_type;
+
+	struct crypto_shash *dedup_driver;
+	struct mutex lock;
+
+	/* following members are only used in in-memory dedup mode */
+	struct rb_root hash_root;
+	struct rb_root bytenr_root;
+	struct list_head lru_list;
+	u64 limit_nr;
+	u64 current_nr;
+};
+
+struct btrfs_trans_handle;
+
+int btrfs_dedup_hash_size(u16 type);
+struct btrfs_dedup_hash *btrfs_dedup_alloc_hash(u16 type);
+
+/*
+ * Initial inband dedup info
+ * Called at dedup enable time.
+ */
+int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+		       u64 blocksize, u64 limit_nr);
+
+/*
+ * Disable dedup and invalidate all its dedup data.
+ * Called at dedup disable time.
+ */
+int btrfs_dedup_disable(struct btrfs_fs_info *fs_info);
+
+/*
+ * Calculate hash for dedup.
+ * Caller must ensure [start, start + dedup_bs) has valid data.
+ */
+int btrfs_dedup_calc_hash(struct btrfs_fs_info *fs_info,
+			  struct inode *inode, u64 start,
+			  struct btrfs_dedup_hash *hash);
+
+/*
+ * Search for duplicated extents by calculated hash
+ * Caller must call btrfs_dedup_calc_hash() first to get the hash.
+ *
+ * @inode: the inode for we are writing
+ * @file_pos: offset inside the inode
+ * As we will increase extent ref immediately after a hash match,
+ * we need @file_pos and @inode in this case.
+ *
+ * Return > 0 for a hash match, and the extent ref will be
+ * *INCREASED*, and hash->bytenr/num_bytes will record the existing
+ * extent data.
+ * Return 0 for a hash miss. Nothing is done
+ */
+int btrfs_dedup_search(struct btrfs_fs_info *fs_info,
+		       struct inode *inode, u64 file_pos,
+		       struct btrfs_dedup_hash *hash);
+
+/* Add a dedup hash into dedup info */
+int btrfs_dedup_add(struct btrfs_trans_handle *trans,
+		    struct btrfs_fs_info *fs_info,
+		    struct btrfs_dedup_hash *hash);
+
+/* Remove a dedup hash from dedup info */
+int btrfs_dedup_del(struct btrfs_trans_handle *trans,
+		    struct btrfs_fs_info *fs_info, u64 bytenr);
+#endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 50bed6c..d1d59ad 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2581,6 +2581,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
+	mutex_init(&fs_info->dedup_ioctl_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
-- 
2.7.0



