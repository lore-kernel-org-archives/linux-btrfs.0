Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C22C282DA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53BEA206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfDPQmb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:36366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730045AbfDPQm3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA0B1B0BF;
        Tue, 16 Apr 2019 16:42:27 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 10/18] dax: replace mmap entry in case of CoW
Date:   Tue, 16 Apr 2019 11:41:46 -0500
Message-Id: <20190416164154.30390-11-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We replace the existing entry to the newly allocated one
in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
so writeback marks this entry as writeprotected. This
helps us snapshots so new write pagefaults after snapshots
trigger a CoW.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 45fc2e18969a..d5100cbe8bd2 100644
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
@@ -727,12 +728,12 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+	if (cow || (dax_entry_size(entry) != dax_entry_size(new_entry))) {
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 	}
 
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -752,6 +753,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
@@ -1031,7 +1035,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+			DAX_ZERO_PAGE, false, false);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1388,7 +1392,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 				memset(addr, 0, PAGE_SIZE);
 		}
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
+						 0, write && !sync,
+						 iomap.type == IOMAP_DAX_COW);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1467,7 +1472,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 
 	pfn = page_to_pfn_t(zero_page);
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+			DAX_PMD | DAX_ZERO_PAGE, false,
+			iomap->type == IOMAP_DAX_COW);
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1590,7 +1596,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			goto finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
+						DAX_PMD, write && !sync,
+						false);
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.16.4

