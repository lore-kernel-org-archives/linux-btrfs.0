Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7891 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbcBBDIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:09 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 02/19] btrfs: dedup: Introduce function to initialize dedup info
Date: Tue,  2 Feb 2016 11:05:34 +0800
Message-Id: <1454382351-31775-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add generic function to initialize dedup info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/Makefile |   2 +-
 fs/btrfs/dedup.c  | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h  |  17 ++++++++--
 3 files changed, 116 insertions(+), 3 deletions(-)
 create mode 100644 fs/btrfs/dedup.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17..a6207ff 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o
+	   uuid-tree.o props.o hash.o free-space-tree.o dedup.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
new file mode 100644
index 0000000..b37db50
--- /dev/null
+++ b/fs/btrfs/dedup.c
@@ -0,0 +1,100 @@
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
+#include "ctree.h"
+#include "dedup.h"
+#include "btrfs_inode.h"
+#include "transaction.h"
+#include "delayed-ref.h"
+
+int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+		       u64 blocksize, u64 limit_nr)
+{
+	struct btrfs_dedup_info *dedup_info;
+	u64 limit = limit_nr;
+	int ret = 0;
+
+	/* Sanity check */
+	if (blocksize > BTRFS_DEDUP_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUP_BLOCKSIZE_MIN ||
+	    blocksize < fs_info->tree_root->sectorsize ||
+	    !is_power_of_2(blocksize))
+		return -EINVAL;
+	if (type >= ARRAY_SIZE(btrfs_dedup_sizes))
+		return -EINVAL;
+	if (backend >= BTRFS_DEDUP_BACKEND_LAST)
+		return -EINVAL;
+
+	if (backend == BTRFS_DEDUP_BACKEND_INMEMORY && limit_nr == 0)
+		limit = 4096; /* default value */
+	if (backend == BTRFS_DEDUP_BACKEND_ONDISK && limit_nr != 0)
+		limit = 0;
+
+	dedup_info = btrfs_dedup_get_info(fs_info);
+	if (dedup_info) {
+
+		/* Check if we are re-enable for different dedup config */
+		if (dedup_info->blocksize != blocksize ||
+		    dedup_info->hash_type != type ||
+		    dedup_info->backend != backend) {
+			btrfs_dedup_put_info(dedup_info);
+			btrfs_dedup_disable(fs_info);
+			goto enable;
+		}
+
+		/* On-fly limit change is OK */
+		mutex_lock(&dedup_info->lock);
+		fs_info->dedup_info->limit_nr = limit;
+		mutex_unlock(&dedup_info->lock);
+		btrfs_dedup_put_info(dedup_info);
+		return 0;
+	}
+
+enable:
+	dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
+	if (dedup_info)
+		return -ENOMEM;
+
+	dedup_info->hash_type = type;
+	dedup_info->backend = backend;
+	dedup_info->blocksize = blocksize;
+	dedup_info->limit_nr = limit;
+
+	/* Only support SHA256 yet */
+	dedup_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedup_info->dedup_driver)) {
+		btrfs_err(fs_info, "failed to init sha256 driver");
+		ret = PTR_ERR(dedup_info->dedup_driver);
+		goto out;
+	}
+
+	dedup_info->hash_root = RB_ROOT;
+	dedup_info->bytenr_root = RB_ROOT;
+	dedup_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedup_info->lru_list);
+	mutex_init(&dedup_info->lock);
+	init_waitqueue_head(&dedup_info->refs_wq);
+	atomic_set(&dedup_info->refs, 0);
+
+	spin_lock(&fs_info->dedup_ref_lock);
+	fs_info->dedup_info = dedup_info;
+	spin_unlock(&fs_info->dedup_ref_lock);
+out:
+	if (ret < 0)
+		kfree(dedup_info);
+	return ret;
+}
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index d4f072d..8fed1ce 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -37,6 +37,9 @@
 #define BTRFS_DEDUP_BLOCKSIZE_MIN	(16 * 1024)
 #define BTRFS_DEDUP_BLOCKSIZE_DEFAULT	(128 * 1024)
 
+/* Default dedup limit on number of hash */
+#define BTRFS_DEDUP_LIMIT_NR_DEFAULT	(32 * 1024)
+
 /* Hash algorithm, only support SHA256 yet */
 #define BTRFS_DEDUP_HASH_SHA256		0
 
@@ -78,8 +81,18 @@ struct btrfs_dedup_info {
 
 struct btrfs_trans_handle;
 
-int btrfs_dedup_hash_size(u16 type);
-struct btrfs_dedup_hash *btrfs_dedup_alloc_hash(u16 type);
+static inline int btrfs_dedup_hash_size(u16 type)
+{
+	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedup_sizes)))
+		return -EINVAL;
+	return sizeof(struct btrfs_dedup_hash) + btrfs_dedup_sizes[type];
+}
+
+static inline struct btrfs_dedup_hash *btrfs_dedup_alloc_hash(u16 type)
+{
+	return kzalloc(btrfs_dedup_hash_size(type), GFP_NOFS);
+}
+
 
 /*
  * Initial inband dedup info
-- 
2.7.0



