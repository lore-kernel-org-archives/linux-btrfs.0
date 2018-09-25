Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84238C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C3F2086E
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="RcPALi8D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33C3F2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbeIYVij (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:38:39 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46217 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729917AbeIYVic (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:38:32 -0400
Received: by mail-qt1-f170.google.com with SMTP id h22-v6so5829012qtr.13
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 08:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=PDnxzeo4ARamvsNmFxpuCNGpSh/SMf2cCcJx4Y/RGR0=;
        b=RcPALi8D6dfVSo4xlu/KTA8lljnTkd1vaQFvFipLTjLvG09gFvjKaaFuI0ye5YqtBx
         BxcYU2VyL+jWgQDY/mGmPNWPqTHSsHHmhlyn8HaVvjneIHJOhoPxMoU+VHmEoLpRbl80
         mqOXzcjI5sYECZ+o4wIo+CdYrB0TZomSBH3PzILJLrxNGIL+Dy2drfy3EBceaDkJHJ1V
         csTrCXoaSVtLpjiOY36WUxEiVCWeh7OQaPu7y9B0kOotkyxI7LCryd1SauR9HEZhtL9/
         3LaK5Y8GtZQg8eQXFUN3uqPhM/YTK7BVZR948YXEisThS+mck3zoXYBcZtgIbxV0sVa/
         0lSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=PDnxzeo4ARamvsNmFxpuCNGpSh/SMf2cCcJx4Y/RGR0=;
        b=ddHTlqZl4xj+LeIwntMLhGfCdYTJcE3DDx/8i0RVDAJcr7WbT4Ts+7+bJDcpG0EDeb
         Fa68bLJEgU2ntLb1edmFAkDt/hU0aYUt3coZLpkU07v11gLrMD7grxf+Lz3uF5VNUJwx
         hv2mBzVglgTH1nESjC8qYbyFKulrsfXUwzlU3RtjLiCPxaeXqotKVKWyrwVoeHJmW8BU
         E25zaq4HoJCpRHob2aBmD29fZVF3ZNjQ1WU6mHx4VDxDhlIJC2EAYEoU70ATCcZaJbbx
         A3qqvlRxlEAo5ZLpKZWy6TSnh/ByEHTyirLXj9R46TV3gaP01cVG4wfCwblV1os6YmKp
         Q1FA==
X-Gm-Message-State: ABuFfogrlbNLhIlPMb3PRZnZ3Y2wRNve/l/H+1sms4sBbA2FITegOB1j
        R4I4ehoqACMKc0D7udBSD1kdeA==
X-Google-Smtp-Source: ACcGV63k5igT7ioJSNQTT0X9VogsRs/dXZ8zQ0Qp02y7wE62ew2v7c+iNBaCvHz97xuiRcH27KC+dw==
X-Received: by 2002:a0c:93c1:: with SMTP id g1-v6mr1226889qvg.136.1537889430118;
        Tue, 25 Sep 2018 08:30:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e65-v6sm1371245qkf.39.2018.09.25.08.30.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 08:30:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 8/8] btrfs: drop mmap_sem in mkwrite for btrfs
Date:   Tue, 25 Sep 2018 11:30:11 -0400
Message-Id: <20180925153011.15311-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180925153011.15311-1-josef@toxicpanda.com>
References: <20180925153011.15311-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

->page_mkwrite is extremely expensive in btrfs.  We have to reserve
space, which can take 6 lifetimes, and we could possibly have to wait on
writeback on the page, another several lifetimes.  To avoid this simply
drop the mmap_sem if we didn't have the cached page and do all of our
work and return the appropriate retry error.  If we have the cached page
we know we did all the right things to set this page up and we can just
carry on.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c   | 40 ++++++++++++++++++++++++++++++++++++++--
 include/linux/mm.h | 14 ++++++++++++++
 mm/filemap.c       |  3 ++-
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..34c33b96d335 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8809,7 +8809,9 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct file *file = vmf->vma->vm_file, *fpin;
+	struct mm_struct *mm = vmf->vma->vm_mm;
+	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
@@ -8828,6 +8830,29 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	reserved_space = PAGE_SIZE;
 
+	/*
+	 * We have our cached page from a previous mkwrite, check it to make
+	 * sure it's still dirty and our file size matches when we ran mkwrite
+	 * the last time.  If everything is OK then return VM_FAULT_LOCKED,
+	 * otherwise do the mkwrite again.
+	 */
+	if (vmf->flags & FAULT_FLAG_USED_CACHED) {
+		lock_page(page);
+		if (vmf->cached_size == i_size_read(inode) &&
+		    PageDirty(page))
+			return VM_FAULT_LOCKED;
+		unlock_page(page);
+	}
+
+	/*
+	 * mkwrite is extremely expensive, and we are holding the mmap_sem
+	 * during this, which means we can starve out anybody trying to
+	 * down_write(mmap_sem) for a long while, especially if we throw cgroups
+	 * into the mix.  So just drop the mmap_sem and do all of our work,
+	 * we'll loop back through and verify everything is ok the next time and
+	 * hopefully avoid doing the work twice.
+	 */
+	fpin = maybe_unlock_mmap_for_io(vmf->vma, vmf->flags);
 	sb_start_pagefault(inode->i_sb);
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_SIZE - 1;
@@ -8844,7 +8869,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	ret2 = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   reserved_space);
 	if (!ret2) {
-		ret2 = file_update_time(vmf->vma->vm_file);
+		ret2 = file_update_time(file);
 		reserved = 1;
 	}
 	if (ret2) {
@@ -8943,6 +8968,13 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
+		if (fpin) {
+			unlock_page(page);
+			fput(fpin);
+			vmf->cached_size = size;
+			down_read(&mm->mmap_sem);
+			return VM_FAULT_RETRY;
+		}
 		return VM_FAULT_LOCKED;
 	}
 
@@ -8955,6 +8987,10 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_free(data_reserved);
+	if (fpin) {
+		fput(fpin);
+		down_read(&mm->mmap_sem);
+	}
 	return ret;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 10a0118f5485..b9ad6cb3de84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -370,6 +370,13 @@ struct vm_fault {
 					 * next time we loop through the fault
 					 * handler for faster lookup.
 					 */
+	loff_t cached_size;		/* ->page_mkwrite handlers may drop
+					 * the mmap_sem to avoid starvation, in
+					 * which case they need to save the
+					 * i_size in order to verify the cached
+					 * page we're using the next loop
+					 * through hasn't changed under us.
+					 */
 	/* These three entries are valid only while holding ptl lock */
 	pte_t *pte;			/* Pointer to pte entry matching
 					 * the 'address'. NULL if the page
@@ -1435,6 +1442,8 @@ extern vm_fault_t handle_mm_fault(struct vm_fault *vmf);
 extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
+extern struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma,
+					     int flags);
 void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows);
 void unmap_mapping_range(struct address_space *mapping,
@@ -1454,6 +1463,11 @@ static inline int fixup_user_fault(struct task_struct *tsk,
 	BUG();
 	return -EFAULT;
 }
+stiatc inline struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma,
+						    int flags)
+{
+	return NULL;
+}
 static inline void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows) { }
 static inline void unmap_mapping_range(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 75a8b252814a..748c696d23af 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2366,7 +2366,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 EXPORT_SYMBOL(generic_file_read_iter);
 
 #ifdef CONFIG_MMU
-static struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma, int flags)
+struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma, int flags)
 {
 	if ((flags & (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT)) == FAULT_FLAG_ALLOW_RETRY) {
 		struct file *file;
@@ -2377,6 +2377,7 @@ static struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma, int fla
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(maybe_unlock_mmap_for_io);
 
 /**
  * page_cache_read - adds requested page to the page cache if not already there
-- 
2.14.3

