Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbcANGAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:08 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 3E85A418917E
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:37 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v4 02/18] btrfs: dedup: Introduce function to initialize dedup info
Date: Thu, 14 Jan 2016 13:57:18 +0800
Message-ID: <1452751054-2365-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add generic function to initialize dedup info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/Makefile |  2 +-
 fs/btrfs/dedup.c  | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h  | 14 ++++++--
 3 files changed, 109 insertions(+), 3 deletions(-)
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
index 0000000..10a1db4
--- /dev/null
+++ b/fs/btrfs/dedup.c
@@ -0,0 +1,96 @@
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
+		       u64 blocksize, u64 limit)
+{
+	struct btrfs_dedup_info *dedup_info;
+	int ret = 0;
+
+	/* Sanity check */
+	if (blocksize > BTRFS_DEDUP_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUP_BLOCKSIZE_MIN ||
+	    blocksize < fs_info->tree_root->sectorsize ||
+	    !is_power_of_2(blocksize))
+		return -EINVAL;
+	if (type > ARRAY_SIZE(btrfs_dedup_sizes))
+		return -EINVAL;
+	if (backend >= BTRFS_DEDUP_BACKEND_LAST)
+		return -EINVAL;
+	if (backend == BTRFS_DEDUP_BACKEND_INMEMORY && limit == 0)
+		limit = 4096; /* default value */
+	if (backend == BTRFS_DEDUP_BACKEND_ONDISK && limit != 0)
+		limit = 0;
+
+	if (fs_info->dedup_info) {
+		dedup_info = fs_info->dedup_info;
+
+		/* Check if we are re-enable for different dedup config */
+		if (dedup_info->blocksize != blocksize ||
+		    dedup_info->hash_type != type ||
+		    dedup_info->backend != backend) {
+			btrfs_dedup_disable(fs_info);
+			goto enable;
+		}
+
+		/* On-fly limit change is OK */
+		mutex_lock(&dedup_info->lock);
+		fs_info->dedup_info->limit_nr = limit;
+		mutex_unlock(&dedup_info->lock);
+		return 0;
+	}
+
+enable:
+	fs_info->dedup_info = kzalloc(sizeof(*dedup_info), GFP_NOFS);
+	if (!fs_info->dedup_info)
+		return -ENOMEM;
+
+	dedup_info = fs_info->dedup_info;
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
+
+	fs_info->dedup_info = dedup_info;
+out:
+	if (ret < 0) {
+		kfree(dedup_info);
+		fs_info->dedup_info = NULL;
+	}
+	return ret;
+}
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index f0edc76..a859ad8 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -73,8 +73,18 @@ struct btrfs_dedup_info {
 
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



