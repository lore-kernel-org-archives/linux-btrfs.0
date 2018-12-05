Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A094C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C0BF2084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C0BF2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbeLEM3M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:48534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbeLEM3L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D0057ADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:09 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 09/10] btrfs: dax support for cow_page/mmap_private and shared
Date:   Wed,  5 Dec 2018 06:28:34 -0600
Message-Id: <20181205122835.19290-10-rgoldwyn@suse.de>
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
 fs/btrfs/dax.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 88017f8799d1..6d68d39cc5da 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -198,10 +198,13 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 	pfn_t pfn;
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
+	unsigned long vaddr = vmf->address;
 	struct inode *inode = mapping->host;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	void *entry = NULL;
 	vm_fault_t ret = 0;
+	struct extent_map *em;
+	struct dax_device *dax_dev;
 
 	if (pos > i_size_read(inode)) {
 		ret = VM_FAULT_SIGBUS;
@@ -214,21 +217,33 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 		goto out;
 	}
 
-	if (!vmf->cow_page) {
+        em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, PAGE_SIZE, 0);
+	if (em->block_start != EXTENT_MAP_HOLE)
+		dax_dev = fs_dax_get_by_bdev(em->bdev);
+
+	if (vmf->cow_page) {
+		sector_t sector;
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			clear_user_highpage(vmf->cow_page, vaddr);
+			goto out;
+		}
+        	sector = (get_start_sect(em->bdev) << 9) + (em->block_start + (pos - em->start));
+		sector >>= 9;
+		ret = copy_user_dax(em->bdev, dax_dev, sector, PAGE_SIZE, vmf->cow_page, vaddr);
+		goto out;
+	} else {
         	sector_t sector;
-		struct extent_map *em;
-                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, PAGE_SIZE, 0);
 		if (em->block_start == EXTENT_MAP_HOLE) {
 			ret = dax_load_hole(&xas, mapping, entry, vmf);
 			goto out;
 		}
 	        sector = ((get_start_sect(em->bdev) << 9) +
 			  (em->block_start + (pos - em->start))) >> 9;
-		ret = dax_pfn(fs_dax_get_by_bdev(em->bdev), em->bdev, sector, PAGE_SIZE, &pfn);
+		ret = dax_pfn(dax_dev, em->bdev, sector, PAGE_SIZE, &pfn);
 		if (ret)
 			goto out;
 		dax_insert_entry(&xas, mapping, vmf, entry, pfn, 0, false);
-		ret = vmf_insert_mixed(vmf->vma, vmf->address, pfn);
+		ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	}
 out:
 	if (entry)
-- 
2.16.4

