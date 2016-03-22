Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbcCVBin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 02/27] btrfs: dedupe: Introduce function to initialize dedupe info
Date: Tue, 22 Mar 2016 09:35:27 +0800
Message-Id: <1458610552-9845-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add generic function to initialize dedupe info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/Makefile |  2 +-
 fs/btrfs/dedupe.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h | 16 +++++++--
 3 files changed, 112 insertions(+), 3 deletions(-)
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
index 0000000..9a0e03b
--- /dev/null
+++ b/fs/btrfs/dedupe.c
@@ -0,0 +1,97 @@
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
+int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
+			u64 blocksize, u64 limit_nr)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	u64 limit = limit_nr;
+	int ret = 0;
+
+	/* Sanity check */
+	if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
+	    blocksize < fs_info->tree_root->sectorsize ||
+	    !is_power_of_2(blocksize))
+		return -EINVAL;
+	if (type >= ARRAY_SIZE(btrfs_dedupe_sizes))
+		return -EINVAL;
+	if (backend >= BTRFS_DEDUPE_BACKEND_COUNT)
+		return -EINVAL;
+
+	if (backend == BTRFS_DEDUPE_BACKEND_INMEMORY && limit_nr == 0)
+		limit = BTRFS_DEDUPE_LIMIT_NR_DEFAULT;
+	if (backend == BTRFS_DEDUPE_BACKEND_ONDISK && limit_nr != 0)
+		limit = 0;
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
+	dedupe_info = kzalloc(sizeof(*dedupe_info), GFP_NOFS);
+	if (dedupe_info)
+		return -ENOMEM;
+
+	dedupe_info->hash_type = type;
+	dedupe_info->backend = backend;
+	dedupe_info->blocksize = blocksize;
+	dedupe_info->limit_nr = limit;
+
+	/* Only support SHA256 yet */
+	dedupe_info->dedupe_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(dedupe_info->dedupe_driver)) {
+		btrfs_err(fs_info, "failed to init sha256 driver");
+		ret = PTR_ERR(dedupe_info->dedupe_driver);
+		goto out;
+	}
+
+	dedupe_info->hash_root = RB_ROOT;
+	dedupe_info->bytenr_root = RB_ROOT;
+	dedupe_info->current_nr = 0;
+	INIT_LIST_HEAD(&dedupe_info->lru_list);
+	mutex_init(&dedupe_info->lock);
+
+	fs_info->dedupe_info = dedupe_info;
+	/* We must ensure dedupe_enabled is modified after dedupe_info */
+	smp_wmb();
+	fs_info->dedupe_enabled = 1;
+
+out:
+	if (ret < 0)
+		kfree(dedupe_info);
+	return ret;
+}
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 916039c..ab1aef7 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -37,6 +37,9 @@
 #define BTRFS_DEDUPE_BLOCKSIZE_MIN	(16 * 1024)
 #define BTRFS_DEDUPE_BLOCKSIZE_DEFAULT	(128 * 1024)
 
+/* Default dedupe limit on number of hash */
+#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
+
 /* Hash algorithm, only support SHA256 yet */
 #define BTRFS_DEDUPE_HASH_SHA256		0
 
@@ -79,8 +82,17 @@ static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
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
-- 
2.7.3



