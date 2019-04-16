Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7B2C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59CB3206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfDPQmc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:36406 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfDPQmb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EAD35B0D7;
        Tue, 16 Apr 2019 16:42:29 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 11/18] btrfs: add dax mmap support
Date:   Tue, 16 Apr 2019 11:41:47 -0500
Message-Id: <20190416164154.30390-12-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Add a new vm_operations struct btrfs_dax_vm_ops
specifically for dax files.

Since we will be removing(nulling) readpages/writepages for dax
return ENOEXEC only for non-dax files.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/dax.c   | 13 ++++++++++++-
 fs/btrfs/file.c  | 18 ++++++++++++++++--
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eec01eb92f33..2b7bdabb44f8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3802,6 +3802,7 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
 /* dax.c */
 ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
 ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
+vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
 #else
 static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 {
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index f5cc9bcdbf14..de957d681e16 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -139,7 +139,7 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 
 	iomap->addr = em->block_start + diff;
 	/* Check if we really need to copy data from old extent */
-	if (bi && !bi->nocow && (offset || pos + length < bi->end)) {
+	if (bi && !bi->nocow && (offset || pos + length < bi->end || flags & IOMAP_FAULT)) {
 		iomap->type = IOMAP_DAX_COW;
 		if (srcblk) {
 			sector_t sector = (srcblk + (pos & PAGE_MASK) -
@@ -216,4 +216,15 @@ ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *iter)
 	}
 	return ret;
 }
+
+vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
+{
+	vm_fault_t ret;
+	pfn_t pfn;
+	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &pfn, NULL, &btrfs_iomap_ops);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, PE_SIZE_PTE, pfn);
+
+	return ret;
+}
 #endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a795023e26ca..9d5a3c99a6b9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2214,15 +2214,29 @@ static const struct vm_operations_struct btrfs_file_vm_ops = {
 	.page_mkwrite	= btrfs_page_mkwrite,
 };
 
+#ifdef CONFIG_FS_DAX
+static const struct vm_operations_struct btrfs_dax_vm_ops = {
+	.fault          = btrfs_dax_fault,
+	.page_mkwrite   = btrfs_dax_fault,
+	.pfn_mkwrite    = btrfs_dax_fault,
+};
+#else
+#define btrfs_dax_vm_ops btrfs_file_vm_ops
+#endif
+
 static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 {
 	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = file_inode(filp);
 
-	if (!mapping->a_ops->readpage)
+	if (!IS_DAX(inode) && !mapping->a_ops->readpage)
 		return -ENOEXEC;
 
 	file_accessed(filp);
-	vma->vm_ops = &btrfs_file_vm_ops;
+	if (IS_DAX(inode))
+		vma->vm_ops = &btrfs_dax_vm_ops;
+	else
+		vma->vm_ops = &btrfs_file_vm_ops;
 
 	return 0;
 }
-- 
2.16.4

