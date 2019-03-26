Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F641C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E44D20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732505AbfCZTDZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732204AbfCZTDY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3231ADF2;
        Tue, 26 Mar 2019 19:03:22 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 03/15] btrfs: basic dax read
Date:   Tue, 26 Mar 2019 14:02:49 -0500
Message-Id: <20190326190301.32365-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Perform a basic read using iomap support. The btrfs_iomap_begin()
finds the extent at the position and fills the iomap data
structure with the values.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/Makefile |  1 +
 fs/btrfs/ctree.h  |  5 +++++
 fs/btrfs/dax.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/file.c   | 12 +++++++++++-
 4 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/dax.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index ca693dd554e9..1fa77b875ae9 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -12,6 +12,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
 	   uuid-tree.o props.o free-space-tree.o tree-checker.o
 
+btrfs-$(CONFIG_FS_DAX) += dax.o
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9512f49262dd..b7bbe5130a3b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3795,6 +3795,11 @@ int btrfs_reada_wait(void *handle);
 void btrfs_reada_detach(void *handle);
 int btree_readahead_hook(struct extent_buffer *eb, int err);
 
+#ifdef CONFIG_FS_DAX
+/* dax.c */
+ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
+#endif /* CONFIG_FS_DAX */
+
 static inline int is_fstree(u64 rootid)
 {
 	if (rootid == BTRFS_FS_TREE_OBJECTID ||
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
new file mode 100644
index 000000000000..bf3d46b0acb6
--- /dev/null
+++ b/fs/btrfs/dax.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAX support for BTRFS
+ *
+ * Copyright (c) 2019  SUSE Linux
+ * Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
+ */
+
+#ifdef CONFIG_FS_DAX
+#include <linux/dax.h>
+#include <linux/iomap.h>
+#include "ctree.h"
+#include "btrfs_inode.h"
+
+static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
+		loff_t length, unsigned flags, struct iomap *iomap)
+{
+	struct extent_map *em;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
+	if (em->block_start == EXTENT_MAP_HOLE) {
+		iomap->type = IOMAP_HOLE;
+		return 0;
+	}
+	iomap->type = IOMAP_MAPPED;
+	iomap->bdev = em->bdev;
+	iomap->dax_dev = fs_info->dax_dev;
+	iomap->offset = em->start;
+	iomap->length = em->len;
+	iomap->addr = em->block_start;
+	return 0;
+}
+
+static const struct iomap_ops btrfs_iomap_ops = {
+	.iomap_begin		= btrfs_iomap_begin,
+};
+
+ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
+{
+	ssize_t ret;
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	inode_lock_shared(inode);
+	ret = dax_iomap_rw(iocb, to, &btrfs_iomap_ops);
+	inode_unlock_shared(inode);
+
+	return ret;
+}
+#endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 34fe8a58b0e9..b620f4e718b2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3288,9 +3288,19 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 	return generic_file_open(inode, filp);
 }
 
+static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+#ifdef CONFIG_FS_DAX
+	struct inode *inode = file_inode(iocb->ki_filp);
+	if (IS_DAX(file_inode(iocb->ki_filp)))
+		return btrfs_file_dax_read(iocb, to);
+#endif
+	return generic_file_read_iter(iocb, to);
+}
+
 const struct file_operations btrfs_file_operations = {
 	.llseek		= btrfs_file_llseek,
-	.read_iter      = generic_file_read_iter,
+	.read_iter      = btrfs_file_read_iter,
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
-- 
2.16.4

