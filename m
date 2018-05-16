Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752613AbeEPFou (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:44:50 -0400
From: Christoph Hellwig <hch@lst.de>
To: Souptick Joarder <jrdr.linux@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@lists.orangefs.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org, dri-devel@lists.freedesktop.org,
        lustre-devel@lists.lustre.org, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 09/14] ubifs: separate errno from VM_FAULT_* values
Date: Wed, 16 May 2018 07:43:43 +0200
Message-Id: <20180516054348.15950-10-hch@lst.de>
In-Reply-To: <20180516054348.15950-1-hch@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ubifs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 1acb2ff505e6..7c1a2e1c3de5 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1513,7 +1513,7 @@ static int ubifs_releasepage(struct page *page, gfp_t unused_gfp_flags)
  * mmap()d file has taken write protection fault and is being made writable.
  * UBIFS must ensure page is budgeted for.
  */
-static int ubifs_vm_page_mkwrite(struct vm_fault *vmf)
+static vm_fault_t ubifs_vm_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -1521,6 +1521,7 @@ static int ubifs_vm_page_mkwrite(struct vm_fault *vmf)
 	struct timespec now = current_time(inode);
 	struct ubifs_budget_req req = { .new_page = 1 };
 	int err, update_time;
+	vm_fault_t ret = 0;
 
 	dbg_gen("ino %lu, pg %lu, i_size %lld",	inode->i_ino, page->index,
 		i_size_read(inode));
@@ -1601,8 +1602,8 @@ static int ubifs_vm_page_mkwrite(struct vm_fault *vmf)
 	unlock_page(page);
 	ubifs_release_budget(c, &req);
 	if (err)
-		err = VM_FAULT_SIGBUS;
-	return err;
+		ret = VM_FAULT_SIGBUS;
+	return ret;
 }
 
 static const struct vm_operations_struct ubifs_file_vm_ops = {
-- 
2.17.0

