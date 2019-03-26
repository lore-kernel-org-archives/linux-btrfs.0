Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D220C10F05
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0884720823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbfCZTDi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:37022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732653AbfCZTDh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6441ADF2;
        Tue, 26 Mar 2019 19:03:35 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 09/15] btrfs: add dax mmap support
Date:   Tue, 26 Mar 2019 14:02:55 -0500
Message-Id: <20190326190301.32365-10-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Add a new vm_operations struct btrfs_dax_vm_ops
specifically for dax files.

Since we will be removing(nulling) readpages/writepages for dax
return ENOEXEC only for non-dax files.

dax_insert_entry() looks ugly. Do you think we should break it
into dax_insert_cow_entry() and dax_insert_entry()?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/dax.c   | 11 +++++++++++
 fs/btrfs/file.c  | 18 ++++++++++++++++--
 fs/dax.c         | 17 ++++++++++-------
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3bcd2a4959c1..0e5060933bde 100644
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
index 49619fe3f94f..927f962d1e88 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -157,4 +157,15 @@ ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *iter)
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
index 3b320d0ab495..196c8f37ff9d 100644
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
diff --git a/fs/dax.c b/fs/dax.c
index 21ee3df6f02c..41061da42771 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -708,14 +708,15 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
  */
 static void *dax_insert_entry(struct xa_state *xas,
 		struct address_space *mapping, struct vm_fault *vmf,
-		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
+		void *entry, pfn_t pfn, unsigned long flags, bool dirty,
+		bool cow)
 {
 	void *new_entry = dax_make_entry(pfn, flags);
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
-	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -732,7 +733,7 @@ static void *dax_insert_entry(struct xa_state *xas,
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 	}
 
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -1031,7 +1032,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+			DAX_ZERO_PAGE, false, false);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1408,7 +1409,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto error_finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
+						 0, write && !sync,
+						(iomap.flags & IOMAP_F_COW) != 0);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1487,7 +1489,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 
 	pfn = page_to_pfn_t(zero_page);
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+			DAX_PMD | DAX_ZERO_PAGE, false, false);
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1610,7 +1612,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
+						DAX_PMD, write && !sync,
+						false);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.16.4

