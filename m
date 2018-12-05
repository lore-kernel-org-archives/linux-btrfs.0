Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46310C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139AC2084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 139AC2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbeLEM3K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:48528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbeLEM3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4BDAAEB9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:07 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 08/10] btrfs: dax add read mmap path
Date:   Wed,  5 Dec 2018 06:28:33 -0600
Message-Id: <20181205122835.19290-9-rgoldwyn@suse.de>
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
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/dax.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/file.c  | 12 +++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d91ff283a966..33648121ca52 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3694,6 +3694,7 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
 /* dax.c */
 ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
 ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
+vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
 #endif /* CONFIG_FS_DAX */
 
 static inline int is_fstree(u64 rootid)
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 4000259a426c..88017f8799d1 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -190,5 +190,48 @@ ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 				count - done, true);
 	extent_changeset_free(data_reserved);
         return done ? done : ret;
+}
+
+/* As copied from dax_iomap_pte_fault() */
+vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
+{
+	pfn_t pfn;
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
+	struct inode *inode = mapping->host;
+	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
+	void *entry = NULL;
+	vm_fault_t ret = 0;
+
+	if (pos > i_size_read(inode)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
 
+	entry = grab_mapping_entry(&xas, mapping, 0);
+	if (IS_ERR(entry)) {
+		ret = dax_fault_return(PTR_ERR(entry));
+		goto out;
+	}
+
+	if (!vmf->cow_page) {
+        	sector_t sector;
+		struct extent_map *em;
+                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, PAGE_SIZE, 0);
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			ret = dax_load_hole(&xas, mapping, entry, vmf);
+			goto out;
+		}
+	        sector = ((get_start_sect(em->bdev) << 9) +
+			  (em->block_start + (pos - em->start))) >> 9;
+		ret = dax_pfn(fs_dax_get_by_bdev(em->bdev), em->bdev, sector, PAGE_SIZE, &pfn);
+		if (ret)
+			goto out;
+		dax_insert_entry(&xas, mapping, vmf, entry, pfn, 0, false);
+		ret = vmf_insert_mixed(vmf->vma, vmf->address, pfn);
+	}
+out:
+	if (entry)
+		dax_unlock_entry(&xas, entry);
+	return ret;
 }
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 29a3b12e6660..38b494686fb2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2227,8 +2227,18 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret > 0 ? -EIO : ret;
 }
 
+static vm_fault_t btrfs_fault(struct vm_fault *vmf)
+{
+	struct inode *inode = vmf->vma->vm_file->f_mapping->host;
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(inode))
+		return btrfs_dax_fault(vmf);
+#endif
+	return filemap_fault(vmf);
+}
+
 static const struct vm_operations_struct btrfs_file_vm_ops = {
-	.fault		= filemap_fault,
+	.fault		= btrfs_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= btrfs_page_mkwrite,
 };
-- 
2.16.4

