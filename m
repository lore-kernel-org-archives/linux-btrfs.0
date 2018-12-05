Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C528C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB702084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB702084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbeLEM25 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:28:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:48450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbeLEM25 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:28:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1BF0ADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:28:54 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 02/10] btrfs: basic dax read
Date:   Wed,  5 Dec 2018 06:28:27 -0600
Message-Id: <20181205122835.19290-3-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/Makefile |  1 +
 fs/btrfs/ctree.h  |  5 ++++
 fs/btrfs/dax.c    | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/file.c   | 13 ++++++++++-
 4 files changed, 86 insertions(+), 1 deletion(-)
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
index 5cc470fa6a40..038d64ecebe5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3685,6 +3685,11 @@ int btrfs_reada_wait(void *handle);
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
index 000000000000..d614bf73bf8e
--- /dev/null
+++ b/fs/btrfs/dax.c
@@ -0,0 +1,68 @@
+#include <linux/dax.h>
+#include <linux/uio.h>
+#include "ctree.h"
+#include "btrfs_inode.h"
+
+static ssize_t em_dax_rw(struct inode *inode, struct extent_map *em, u64 pos,
+		u64 len, struct iov_iter *iter)
+{
+        struct dax_device *dax_dev = fs_dax_get_by_bdev(em->bdev);
+        ssize_t map_len;
+        pgoff_t blk_pg;
+        void *kaddr;
+        sector_t blk_start;
+        unsigned offset = pos & (PAGE_SIZE - 1);
+
+        len = min(len + offset, em->len - (pos - em->start));
+        len = ALIGN(len, PAGE_SIZE);
+        blk_start = (get_start_sect(em->bdev) << 9) + (em->block_start + (pos - em->start));
+        blk_pg = blk_start - offset;
+        map_len = dax_direct_access(dax_dev, PHYS_PFN(blk_pg), PHYS_PFN(len), &kaddr, NULL);
+        map_len = PFN_PHYS(map_len);
+        kaddr += offset;
+        map_len -= offset;
+        if (map_len > len)
+                map_len = len;
+        if (iov_iter_rw(iter) == WRITE)
+                return dax_copy_from_iter(dax_dev, blk_pg, kaddr, map_len, iter);
+        else
+                return dax_copy_to_iter(dax_dev, blk_pg, kaddr, map_len, iter);
+}
+
+ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
+{
+        size_t ret = 0, done = 0, count = iov_iter_count(to);
+        struct extent_map *em;
+        u64 pos = iocb->ki_pos;
+        u64 end = pos + count;
+        struct inode *inode = file_inode(iocb->ki_filp);
+
+        if (!count)
+                return 0;
+
+        end = i_size_read(inode) < end ? i_size_read(inode) : end;
+
+        while (pos < end) {
+                u64 len = end - pos;
+
+                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, len, 0);
+                if (IS_ERR(em)) {
+                        if (!ret)
+                                ret = PTR_ERR(em);
+                        goto out;
+                }
+
+                BUG_ON(em->flags & EXTENT_FLAG_FS_MAPPING);
+
+                ret = em_dax_rw(inode, em, pos, len, to);
+                if (ret < 0)
+                        goto out;
+                pos += ret;
+                done += ret;
+        }
+
+out:
+        iocb->ki_pos += done;
+        return done ? done : ret;
+}
+
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 58e93bce3036..ef6ed93f44d1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3308,9 +3308,20 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 	return generic_file_open(inode, filp);
 }
 
+static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(inode))
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

