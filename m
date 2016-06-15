Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbcFOCKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 22:10:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v11 02/13] btrfs: dedupe: Introduce function to initialize dedupe info
Date: Wed, 15 Jun 2016 10:09:50 +0800
Message-Id: <20160615021001.9588-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add generic function to initialize dedupe info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/Makefile          |   2 +-
 fs/btrfs/dedupe.c          | 160 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h          |  13 +++-
 include/uapi/linux/btrfs.h |   2 +
 4 files changed, 174 insertions(+), 3 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17..1b8c627 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o
+	   uuid-tree.o props.o hash.o free-space-tree.o dedupe.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
new file mode 100644
index 0000000..941ee37
--- /dev/null
+++ b/fs/btrfs/dedupe.c
@@ -0,0 +1,160 @@
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
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
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
+static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
+			    u16 backend, u64 blocksize, u64 limit)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+
+	dedupe_info = kzalloc(sizeof(*dedupe_info), GFP_NOFS);
+	if (!dedupe_info)
+		return -ENOMEM;
+
+	dedupe_info->hash_type = type;
+	dedupe_info->backend = backend;
+	dedupe_info->blocksize = blocksize;
+	dedupe_info->limit_nr = limit;
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
+static int check_dedupe_parameter(struct btrfs_fs_info *fs_info, u16 hash_type,
+				  u16 backend, u64 blocksize, u64 limit_nr,
+				  u64 limit_mem, u64 *ret_limit)
+{
+	if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
+	    blocksize < fs_info->tree_root->sectorsize ||
+	    !is_power_of_2(blocksize))
+		return -EINVAL;
+	/*
+	 * For new backend and hash type, we return special return code
+	 * as they can be easily expended.
+	 */
+	if (hash_type >= ARRAY_SIZE(btrfs_dedupe_sizes))
+		return -EOPNOTSUPP;
+	if (backend >= BTRFS_DEDUPE_BACKEND_COUNT)
+		return -EOPNOTSUPP;
+
+	/* Backend specific check */
+	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		if (!limit_nr && !limit_mem)
+			*ret_limit = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
+		else {
+			u64 tmp = (u64)-1;
+
+			if (limit_mem) {
+				tmp = limit_mem / (sizeof(struct inmem_hash) +
+					btrfs_dedupe_hash_size(hash_type));
+				/* Too small limit_mem to fill a hash item */
+				if (!tmp)
+					return -EINVAL;
+			}
+			if (!limit_nr)
+				limit_nr = (u64)-1;
+
+			*ret_limit = min(tmp, limit_nr);
+		}
+	}
+	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		*ret_limit = 0;
+	return 0;
+}
+
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+			u64 blocksize, u64 limit_nr, u64 limit_mem)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	u64 limit = 0;
+	int ret = 0;
+
+	/* only one limit is accepted for enable*/
+	if (limit_nr && limit_mem)
+		return -EINVAL;
+
+	ret = check_dedupe_parameter(fs_info, type, backend, blocksize,
+				     limit_nr, limit_mem, &limit);
+	if (ret < 0)
+		return ret;
+
+	dedupe_info = fs_info->dedupe_info;
+	if (dedupe_info) {
+		/* Check if we are re-enable for different dedupe config */
+		if (dedupe_info->blocksize != blocksize ||
+		    dedupe_info->hash_type != type ||
+		    dedupe_info->backend != backend) {
+			btrfs_dedupe_disable(fs_info);
+			goto enable;
+		}
+
+		/* On-fly limit change is OK */
+		mutex_lock(&dedupe_info->lock);
+		fs_info->dedupe_info->limit_nr = limit;
+		mutex_unlock(&dedupe_info->lock);
+		return 0;
+	}
+
+enable:
+	ret = init_dedupe_info(&dedupe_info, type, backend, blocksize, limit);
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
index d7b1a77..9162d2c 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -68,8 +68,17 @@ static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 	return (hash && hash->bytenr);
 }
 
-int btrfs_dedupe_hash_size(u16 type);
-struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 type);
+static inline int btrfs_dedupe_hash_size(u16 type)
+{
+	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedupe_sizes)))
+		return -EINVAL;
+	return sizeof(struct btrfs_dedupe_hash) + btrfs_dedupe_sizes[type];
+}
+
+static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 type)
+{
+	return kzalloc(btrfs_dedupe_hash_size(type), GFP_NOFS);
+}
 
 /*
  * Initial inband dedupe info
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1279bf0..bc3416e 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -634,6 +634,8 @@ struct btrfs_ioctl_get_dev_stats {
 /* Hash algorithm, only support SHA256 yet */
 #define BTRFS_DEDUPE_HASH_SHA256		0
 
+/* Default dedupe limit on number of hash */
+#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
 
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
-- 
2.8.3



