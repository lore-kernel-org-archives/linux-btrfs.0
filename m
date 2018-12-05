Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC76C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FD512084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FD512084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbeLEM3J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:48516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727778AbeLEM3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 777C3ADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:05 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 07/10] dax: export functions for use with btrfs
Date:   Wed,  5 Dec 2018 06:28:32 -0600
Message-Id: <20181205122835.19290-8-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

These functions are required for btrfs dax support.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c            | 35 ++++++++++++++++++++++++-----------
 include/linux/dax.h | 16 ++++++++++++++++
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9bcce89ea18e..4578640af631 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -244,7 +244,7 @@ static void put_unlocked_entry(struct xa_state *xas, void *entry)
  * dropped the xa_lock, so we know the xa_state is stale and must be reset
  * before use.
  */
-static void dax_unlock_entry(struct xa_state *xas, void *entry)
+void dax_unlock_entry(struct xa_state *xas, void *entry)
 {
 	void *old;
 
@@ -256,6 +256,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
 	BUG_ON(!dax_is_locked(old));
 	dax_wake_entry(xas, entry, false);
 }
+EXPORT_SYMBOL(dax_unlock_entry);
 
 /*
  * Return: The entry stored at this location before it was locked.
@@ -448,7 +449,7 @@ void dax_unlock_mapping_entry(struct page *page)
  * a VM_FAULT code, encoded as an xarray internal entry.  The ERR_PTR values
  * overlap with xarray value entries.
  */
-static void *grab_mapping_entry(struct xa_state *xas,
+void *grab_mapping_entry(struct xa_state *xas,
 		struct address_space *mapping, unsigned long size_flag)
 {
 	unsigned long index = xas->xa_index;
@@ -531,6 +532,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	xas_unlock_irq(xas);
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
+EXPORT_SYMBOL(grab_mapping_entry);
 
 /**
  * dax_layout_busy_page - find first pinned page in @mapping
@@ -654,7 +656,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_entry(mapping, index, false);
 }
 
-static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
+int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
 {
@@ -679,6 +681,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 	dax_read_unlock(id);
 	return 0;
 }
+EXPORT_SYMBOL(copy_user_dax);
 
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
@@ -687,7 +690,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
  * already in the tree, we will skip the insertion and just dirty the PMD as
  * appropriate.
  */
-static void *dax_insert_entry(struct xa_state *xas,
+void *dax_insert_entry(struct xa_state *xas,
 		struct address_space *mapping, struct vm_fault *vmf,
 		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
 {
@@ -736,6 +739,7 @@ static void *dax_insert_entry(struct xa_state *xas,
 	xas_unlock_irq(xas);
 	return entry;
 }
+EXPORT_SYMBOL(dax_insert_entry);
 
 static inline
 unsigned long pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
@@ -962,19 +966,18 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
 
-static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+int dax_pfn(struct dax_device *dax_dev, struct block_device *bdev,
+	    const sector_t sector, size_t size, pfn_t *pfnp)
 {
-	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
 	int id, rc;
 	long length;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
+	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
 	if (rc)
 		return rc;
 	id = dax_read_lock();
-	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
+	length = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
 				   NULL, pfnp);
 	if (length < 0) {
 		rc = length;
@@ -993,6 +996,14 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	dax_read_unlock(id);
 	return rc;
 }
+EXPORT_SYMBOL(dax_pfn);
+
+static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
+			 pfn_t *pfnp)
+{
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	return dax_pfn(iomap->dax_dev, iomap->bdev, sector, size, pfnp);
+}
 
 /*
  * The user has performed a load from a hole in the file.  Allocating a new
@@ -1001,7 +1012,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
  * If this page is ever written to we will re-fault and change the mapping to
  * point to real DAX storage instead.
  */
-static vm_fault_t dax_load_hole(struct xa_state *xas,
+vm_fault_t dax_load_hole(struct xa_state *xas,
 		struct address_space *mapping, void **entry,
 		struct vm_fault *vmf)
 {
@@ -1017,6 +1028,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
+EXPORT_SYMBOL(dax_load_hole);
 
 static bool dax_range_is_aligned(struct block_device *bdev,
 				 unsigned int offset, unsigned int length)
@@ -1195,7 +1207,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(dax_iomap_rw);
 
-static vm_fault_t dax_fault_return(int error)
+vm_fault_t dax_fault_return(int error)
 {
 	if (error == 0)
 		return VM_FAULT_NOPAGE;
@@ -1203,6 +1215,7 @@ static vm_fault_t dax_fault_return(int error)
 		return VM_FAULT_OOM;
 	return VM_FAULT_SIGBUS;
 }
+EXPORT_SYMBOL(dax_fault_return);
 
 /*
  * MAP_SYNC on a dax mapping guarantees dirty metadata is
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 450b28db9533..72f0a1e85ab5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -155,6 +155,22 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int dax_pfn(struct dax_device *dax_dev, struct block_device *bdev,
+	    const sector_t sector, size_t size, pfn_t *pfn);
+void *dax_insert_entry(struct xa_state *xas,
+	               struct address_space *mapping, struct vm_fault *vmf,
+	               void *entry, pfn_t pfn, unsigned long flags, bool dirty);
+void *grab_mapping_entry(struct xa_state *xas,
+	                 struct address_space *mapping,
+			 unsigned long size_flag);
+void dax_unlock_entry(struct xa_state *xas, void *entry);
+vm_fault_t dax_load_hole(struct xa_state *xas,
+			 struct address_space *mapping, void **entry,
+			 struct vm_fault *vmf);
+vm_fault_t dax_fault_return(int error);
+int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
+		sector_t sector, size_t size, struct page *to,
+		unsigned long vaddr);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
-- 
2.16.4

