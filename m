Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15682 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752134AbdLLEf1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 23:35:27 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v14.5 04/14] btrfs: dedupe: Introduce function to initialize dedupe info
Date: Tue, 12 Dec 2017 12:34:03 +0800
Message-ID: <20171212043413.16637-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171212043413.16637-1-lufq.fnst@cn.fujitsu.com>
References: <20171212043413.16637-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add generic function to initialize dedupe info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/Makefile          |   2 +-
 fs/btrfs/dedupe.c          | 181 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h          |  13 +++-
 include/uapi/linux/btrfs.h |   4 +-
 4 files changed, 196 insertions(+), 4 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 6fe881d5cb38..7242759f1df1 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -10,7 +10,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o zstd.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o tree-checker.o
+	   uuid-tree.o props.o hash.o free-space-tree.o tree-checker.o dedupe.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
new file mode 100644
index 000000000000..fbb2121c3736
--- /dev/null
+++ b/fs/btrfs/dedupe.c
@@ -0,0 +1,181 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+#include "ctree.h"
+#include "dedupe.h"
+#include "btrfs_inode.h"
+#include "transaction.h"
+#include "delayed-ref.h"
+
+struct inmem_hash {
+	struct rb_node hash_node;
+	struct rb_node bytenr_node;
+	struct list_head lru_list;
+
+	u64 bytenr;
+	u32 num_bytes;
+
+	u8 hash[];
+};
+
+static int init_dedupe_info(struct btrfs_dedupe_info **ret_info,
+			    struct btrfs_ioctl_dedupe_args *dargs)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+
+	dedupe_info = kzalloc(sizeof(*dedupe_info), GFP_NOFS);
+	if (!dedupe_info)
+		return -ENOMEM;
+
+	dedupe_info->hash_algo = dargs->hash_algo;
+	dedupe_info->backend = dargs->backend;
+	dedupe_info->blocksize = dargs->blocksize;
+	dedupe_info->limit_nr = dargs->limit_nr;
+
+	/* only support SHA256 yet */
+	dedupe_info->dedupe_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedupe_info->dedupe_driver)) {
+		int ret;
+
+		ret = PTR_ERR(dedupe_info->dedupe_driver);
+		kfree(dedupe_info);
+		return ret;
+	}
+
+	dedupe_info->hash_root = RB_ROOT;
+	dedupe_info->bytenr_root = RB_ROOT;
+	dedupe_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedupe_info->lru_list);
+	mutex_init(&dedupe_info->lock);
+
+	*ret_info = dedupe_info;
+	return 0;
+}
+
+/*
+ * Helper to check if parameters are valid.
+ * The first invalid field will be set to (-1), to info user which parameter
+ * is invalid.
+ * Except dargs->limit_nr or dargs->limit_mem, in that case, 0 will returned
+ * to info user, since user can specify any value to limit, except 0.
+ */
+static int check_dedupe_parameter(struct btrfs_fs_info *fs_info,
+				  struct btrfs_ioctl_dedupe_args *dargs)
+{
+	u64 blocksize = dargs->blocksize;
+	u64 limit_nr = dargs->limit_nr;
+	u64 limit_mem = dargs->limit_mem;
+	u16 hash_algo = dargs->hash_algo;
+	u8 backend = dargs->backend;
+
+	/*
+	 * Set all reserved fields to -1, allow user to detect
+	 * unsupported optional parameters.
+	 */
+	memset(dargs->__unused, -1, sizeof(dargs->__unused));
+	if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
+	    blocksize < fs_info->sectorsize ||
+	    !is_power_of_2(blocksize) ||
+	    blocksize < PAGE_SIZE) {
+		dargs->blocksize = (u64)-1;
+		return -EINVAL;
+	}
+	if (hash_algo >= ARRAY_SIZE(btrfs_hash_sizes)) {
+		dargs->hash_algo = (u16)-1;
+		return -EINVAL;
+	}
+	if (backend >= BTRFS_DEDUPE_BACKEND_COUNT) {
+		dargs->backend = (u8)-1;
+		return -EINVAL;
+	}
+
+	/* Backend specific check */
+	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		/* only one limit is accepted for enable*/
+		if (dargs->limit_nr && dargs->limit_mem) {
+			dargs->limit_nr = 0;
+			dargs->limit_mem = 0;
+			return -EINVAL;
+		}
+
+		if (!limit_nr && !limit_mem)
+			dargs->limit_nr = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
+		else {
+			u64 tmp = (u64)-1;
+
+			if (limit_mem) {
+				tmp = limit_mem / (sizeof(struct inmem_hash) +
+					btrfs_hash_sizes[hash_algo]);
+				/* Too small limit_mem to fill a hash item */
+				if (!tmp) {
+					dargs->limit_mem = 0;
+					dargs->limit_nr = 0;
+					return -EINVAL;
+				}
+			}
+			if (!limit_nr)
+				limit_nr = (u64)-1;
+
+			dargs->limit_nr = min(tmp, limit_nr);
+		}
+	}
+	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		dargs->limit_nr = 0;
+
+	return 0;
+}
+
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
+			struct btrfs_ioctl_dedupe_args *dargs)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	int ret = 0;
+
+	ret = check_dedupe_parameter(fs_info, dargs);
+	if (ret < 0)
+		return ret;
+
+	dedupe_info = fs_info->dedupe_info;
+	if (dedupe_info) {
+		/* Check if we are re-enable for different dedupe config */
+		if (dedupe_info->blocksize != dargs->blocksize ||
+		    dedupe_info->hash_algo != dargs->hash_algo ||
+		    dedupe_info->backend != dargs->backend) {
+			btrfs_dedupe_disable(fs_info);
+			goto enable;
+		}
+
+		/* On-fly limit change is OK */
+		mutex_lock(&dedupe_info->lock);
+		fs_info->dedupe_info->limit_nr = dargs->limit_nr;
+		mutex_unlock(&dedupe_info->lock);
+		return 0;
+	}
+
+enable:
+	ret = init_dedupe_info(&dedupe_info, dargs);
+	if (ret < 0)
+		return ret;
+	fs_info->dedupe_info = dedupe_info;
+	/* We must ensure dedupe_bs is modified after dedupe_info */
+	smp_wmb();
+	fs_info->dedupe_enabled = 1;
+	return ret;
+}
+
+int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
+{
+	/* Place holder for bisect, will be implemented in later patches */
+	return 0;
+}
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 5ecc32179a9c..8311ee13ca83 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -68,8 +68,17 @@ static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 	return (hash && hash->bytenr);
 }
 
-int btrfs_dedupe_hash_size(u16 algo);
-struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 algo);
+static inline int btrfs_dedupe_hash_size(u16 algo)
+{
+	if (WARN_ON(algo >= ARRAY_SIZE(btrfs_hash_sizes)))
+		return -EINVAL;
+	return sizeof(struct btrfs_dedupe_hash) + btrfs_hash_sizes[algo];
+}
+
+static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 algo)
+{
+	return kzalloc(btrfs_dedupe_hash_size(algo), GFP_NOFS);
+}
 
 /*
  * Initial inband dedupe info
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index f4ffc9d6665c..4a925ae4b086 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -666,6 +666,9 @@ struct btrfs_ioctl_get_dev_stats {
 /* Hash algorithm, only support SHA256 yet */
 #define BTRFS_DEDUPE_HASH_SHA256		0
 
+/* Default dedupe limit on number of hash */
+#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
+
 /*
  * This structure is used for dedupe enable/disable/configure
  * and status ioctl.
@@ -684,7 +687,6 @@ struct btrfs_ioctl_dedupe_args {
 	u8 __unused[472];	/* Pad to 512 bytes */
 };
 
-
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
-- 
2.15.1



