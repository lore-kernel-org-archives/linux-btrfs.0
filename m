Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A11FC10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7196C206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbfDPQmZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfDPQmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23E6EB0BE;
        Tue, 16 Apr 2019 16:42:23 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 08/18] dax: memcpy page in case of IOMAP_DAX_COW for mmap faults
Date:   Tue, 16 Apr 2019 11:41:44 -0500
Message-Id: <20190416164154.30390-9-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Change dax_iomap_pfn to return the address as well in order to
use it for performing a memcpy in case the type is IOMAP_DAX_COW.

Question:
The sequence of bdev_dax_pgoff() and dax_direct_access() is
used multiple times to calculate address and pfn's. Would it make
sense to call it while calculating address as well to reduce code?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4b4ac51fbd16..45fc2e18969a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -983,7 +983,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 }
 
 static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+			 pfn_t *pfnp, void **addr)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
@@ -995,7 +995,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+				   addr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
@@ -1280,6 +1280,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
+	void *addr;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
@@ -1369,16 +1370,23 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	sync = dax_fault_is_synchronous(flags, vma, &iomap);
 
 	switch (iomap.type) {
+	case IOMAP_DAX_COW:
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, &addr);
 		if (error < 0)
 			goto error_finish_iomap;
 
+		if (iomap.type == IOMAP_DAX_COW) {
+			if (iomap.inline_data)
+				memcpy(addr, iomap.inline_data, PAGE_SIZE);
+			else
+				memset(addr, 0, PAGE_SIZE);
+		}
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						 0, write && !sync);
 
@@ -1577,7 +1585,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);
 		if (error < 0)
 			goto finish_iomap;
 
-- 
2.16.4

