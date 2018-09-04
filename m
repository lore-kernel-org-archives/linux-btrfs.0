Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38902 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726041AbeIDLXk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:23:40 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15 01/13] btrfs: dedupe: Introduce dedupe framework and its header
Date: Tue, 4 Sep 2018 14:59:30 +0800
Message-ID: <20180904065942.3621-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
References: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce the header for btrfs in-band(write time) de-duplication
framework and needed header.

The new de-duplication framework is going to support 2 different dedupe
methods and 1 dedupe hash.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h           |   7 ++
 fs/btrfs/dedupe.h          | 128 ++++++++++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.c         |   1 +
 include/uapi/linux/btrfs.h |  34 ++++++++++
 4 files changed, 168 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..741ef21a6185 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1125,6 +1125,13 @@ struct btrfs_fs_info {
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
 #endif
+
+	/*
+	 * Inband de-duplication related structures
+	 */
+	unsigned long dedupe_enabled:1;
+	struct btrfs_dedupe_info *dedupe_info;
+	struct mutex dedupe_ioctl_lock;
 };
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 90281a7a35a8..222ce7b4d827 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -6,7 +6,131 @@
 #ifndef BTRFS_DEDUPE_H
 #define BTRFS_DEDUPE_H
 
-/* later in-band dedupe will expand this struct */
-struct btrfs_dedupe_hash;
+#include <crypto/hash.h>
 
+/* 32 bytes for SHA256 */
+static const int btrfs_hash_sizes[] = { 32 };
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
+	u16 hash_algo;
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
+static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
+{
+	return (hash && hash->bytenr);
+}
+
+/*
+ * Initial inband dedupe info
+ * Called at dedupe enable time.
+ *
+ * Return 0 for success
+ * Return <0 for any error
+ * (from unsupported param to tree creation error for some backends)
+ */
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_dedupe_args *dargs);
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
+ * Get current dedupe status.
+ * Return 0 for success
+ * No possible error yet
+ */
+void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
+			 struct btrfs_ioctl_dedupe_args *dargs);
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
+int btrfs_dedupe_add(struct btrfs_fs_info *fs_info,
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
+int btrfs_dedupe_del(struct btrfs_fs_info *fs_info, u64 bytenr);
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5124c15705ce..06683b3f2f0b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2678,6 +2678,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
+	mutex_init(&fs_info->dedupe_ioctl_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..9cd15d2a40aa 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -20,6 +20,7 @@
 #ifndef _UAPI_LINUX_BTRFS_H
 #define _UAPI_LINUX_BTRFS_H
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <linux/ioctl.h>
 
 #define BTRFS_IOCTL_MAGIC 0x94
@@ -667,6 +668,39 @@ struct btrfs_ioctl_get_dev_stats {
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
+#define BTRFS_DEDUPE_BLOCKSIZE_MAX	SZ_8M
+#define BTRFS_DEDUPE_BLOCKSIZE_MIN	SZ_16K
+#define BTRFS_DEDUPE_BLOCKSIZE_DEFAULT	SZ_128K
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUPE_HASH_SHA256		0
+
+/*
+ * This structure is used for dedupe enable/disable/configure
+ * and status ioctl.
+ * Reserved range should be set to 0xff.
+ */
+struct btrfs_ioctl_dedupe_args {
+	__u16 cmd;		/* In: command */
+	__u64 blocksize;	/* In/Out: blocksize */
+	__u64 limit_nr;		/* In/Out: limit nr for inmem backend */
+	__u64 limit_mem;	/* In/Out: limit mem for inmem backend */
+	__u64 current_nr;	/* Out: current hash nr */
+	__u16 backend;		/* In/Out: current backend */
+	__u16 hash_algo;	/* In/Out: hash algorithm */
+	u8 status;		/* Out: enabled or disabled */
+	u8 flags;		/* In: special flags for ioctl */
+	u8 __unused[472];	/* Pad to 512 bytes */
+};
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
-- 
2.18.0
