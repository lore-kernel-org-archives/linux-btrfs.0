Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbcFOCKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 22:10:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v11 01/13] btrfs: dedupe: Introduce dedupe framework and its header
Date: Wed, 15 Jun 2016 10:09:49 +0800
Message-Id: <20160615021001.9588-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce the header for btrfs online(write time) de-duplication
framework and needed header.

The new de-duplication framework is going to support 2 different dedupe
methods and 1 dedupe hash.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h           |   7 +++
 fs/btrfs/dedupe.h          | 149 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c         |   1 +
 include/uapi/linux/btrfs.h |  16 +++++
 4 files changed, 173 insertions(+)
 create mode 100644 fs/btrfs/dedupe.h

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 101c3cf..8f70f53d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1091,6 +1091,13 @@ struct btrfs_fs_info {
 	struct list_head pinned_chunks;
 
 	int creating_free_space_tree;
+
+	/*
+	 * Inband de-duplication related structures
+	 */
+	unsigned long dedupe_enabled:1;
+	struct btrfs_dedupe_info *dedupe_info;
+	struct mutex dedupe_ioctl_lock;
 };
 
 struct btrfs_subvolume_writers {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
new file mode 100644
index 0000000..d7b1a77
--- /dev/null
+++ b/fs/btrfs/dedupe.h
@@ -0,0 +1,149 @@
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
+#ifndef __BTRFS_DEDUPE__
+#define __BTRFS_DEDUPE__
+
+#include <linux/btrfs.h>
+#include <linux/wait.h>
+#include <crypto/hash.h>
+
+static int btrfs_dedupe_sizes[] = { 32 };
+
+/*
+ * For caller outside of dedupe.c
+ *
+ * Different dedupe backends should have their own hash structure
+ */
+struct btrfs_dedupe_hash {
+	u64 bytenr;
+	u32 num_bytes;
+
+	/* last field is a variable length array of dedupe hash */
+	u8 hash[];
+};
+
+struct btrfs_dedupe_info {
+	/* dedupe blocksize */
+	u64 blocksize;
+	u16 backend;
+	u16 hash_type;
+
+	struct crypto_shash *dedupe_driver;
+
+	/*
+	 * Use mutex to portect both backends
+	 * Even for in-memory backends, the rb-tree can be quite large,
+	 * so mutex is better for such use case.
+	 */
+	struct mutex lock;
+
+	/* following members are only used in in-memory backend */
+	struct rb_root hash_root;
+	struct rb_root bytenr_root;
+	struct list_head lru_list;
+	u64 limit_nr;
+	u64 current_nr;
+};
+
+struct btrfs_trans_handle;
+
+static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
+{
+	return (hash && hash->bytenr);
+}
+
+int btrfs_dedupe_hash_size(u16 type);
+struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 type);
+
+/*
+ * Initial inband dedupe info
+ * Called at dedupe enable time.
+ *
+ * Return 0 for success
+ * Return <0 for any error
+ * (from unsupported param to tree creation error for some backends)
+ */
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+			u64 blocksize, u64 limit_nr, u64 limit_mem);
+
+/*
+ * Disable dedupe and invalidate all its dedupe data.
+ * Called at dedupe disable time.
+ *
+ * Return 0 for success
+ * Return <0 for any error
+ * (tree operation error for some backends)
+ */
+int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info);
+
+/*
+ * Calculate hash for dedupe.
+ * Caller must ensure [start, start + dedupe_bs) has valid data.
+ *
+ * Return 0 for success
+ * Return <0 for any error
+ * (error from hash codes)
+ */
+int btrfs_dedupe_calc_hash(struct btrfs_fs_info *fs_info,
+			   struct inode *inode, u64 start,
+			   struct btrfs_dedupe_hash *hash);
+
+/*
+ * Search for duplicated extents by calculated hash
+ * Caller must call btrfs_dedupe_calc_hash() first to get the hash.
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
+ * Return <0 for any error
+ * (tree operation error for some backends)
+ */
+int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedupe_hash *hash);
+
+/*
+ * Add a dedupe hash into dedupe info
+ * Return 0 for success
+ * Return <0 for any error
+ * (tree operation error for some backends)
+ */
+int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info,
+		     struct btrfs_dedupe_hash *hash);
+
+/*
+ * Remove a dedupe hash from dedupe info
+ * Return 0 for success
+ * Return <0 for any error
+ * (tree operation error for some backends)
+ *
+ * NOTE: if hash deletion error is not handled well, it will lead
+ * to corrupted fs, as later dedupe write can points to non-exist or even
+ * wrong extent.
+ */
+int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info, u64 bytenr);
+#endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1142127..dccd608 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2593,6 +2593,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
+	mutex_init(&fs_info->dedupe_ioctl_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 2bdd1e3..1279bf0 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -619,6 +619,22 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/* In-band dedupe related */
+#define BTRFS_DEDUPE_BACKEND_INMEMORY		0
+#define BTRFS_DEDUPE_BACKEND_ONDISK		1
+
+/* Only support inmemory yet, so count is still only 1 */
+#define BTRFS_DEDUPE_BACKEND_COUNT		1
+
+/* Dedup block size limit and default value */
+#define BTRFS_DEDUPE_BLOCKSIZE_MAX	(8 * 1024 * 1024)
+#define BTRFS_DEDUPE_BLOCKSIZE_MIN	(16 * 1024)
+#define BTRFS_DEDUPE_BLOCKSIZE_DEFAULT	(128 * 1024)
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUPE_HASH_SHA256		0
+
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
-- 
2.8.3



