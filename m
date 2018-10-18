Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59090ECDE44
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 126ED2145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="L5/pCy/g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 126ED2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbeJSE0N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39813 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbeJSE0M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id e22-v6so35856436qto.6
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=L5/pCy/gPsV0ofzn3TUULb+VIWeVJ1YdWREgQOC05qgetxeyc/gooBv0/7P1TprVEK
         zN3AcQkua6WC4y8j+OVVn7h38ObbMlDCmLRGDMONosHbBPAVjdTFsmicgMz49RblXBQs
         IcnthT0aIsVcZyB7Eb40druS3N91WGeYrki035XZGFqCdIWvsh9in2sHO3sBkEm7iiEm
         l7DczhjMfarG3XTGID9ITMRzBXWvJrVDQ9+Ul4n807bdgXABCoMOfrbhGGhPLAAdjBnO
         eoQSrbg/V/JVnhs9nsuAPDj1AfS1d/J+QoPyTfAqdqe912W2H1BZnvXfcbZ4Xy4OfptH
         otrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=Nh4Sve7fBf1/4hCpZwDGrtDg/0LFZXDsSYCMvO9qnTZ2UWjGEsi2fITnTfxbaTe8yY
         Nk0VqV5kE0/IzD+AEQoLdtBMgr2jnI1I1AoXdVHMw90w9qBeMNcES77lhP/XiG2vWEly
         HPF25LiSgAJDl19e6+Ftfl7CQfWDGVDQNERqe8n7YgDsVJ9tiEuKjMbn8kYyiwjzwRy0
         78ljY/1fCC/Hogjn27HIQkNIRWT+LHTJq2ZmxAhppR6V8mc3n18LfKi93N/qI30aqvmz
         o1y+0vLj6Huhhqbw1+aqcjk8m5tTg2dnIvEe47x4SP0UjR0O31yEZVhrgVMTePq2ntwp
         sCGg==
X-Gm-Message-State: ABuFfojoEobktxBkSChcD4tJN5M/p1cpzMlqMMPLG3R7d+hkmoMuMnJQ
        uiaLtQQxE8QnKzudUk3JpVEQ1hHvU+z4Sw==
X-Google-Smtp-Source: ACcGV60gZjzwHJ0OsBPoG+m0NpaS9G+lB3FxI11r5t1/cPnWTBZZDswZrgJkgarGYA3Zn1iwTLsU3g==
X-Received: by 2002:aed:3fb9:: with SMTP id s54-v6mr29909677qth.208.1539894210875;
        Thu, 18 Oct 2018 13:23:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m71-v6sm11781158qke.71.2018.10.18.13.23.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 2/7] mm: drop mmap_sem for page cache read IO submission
Date:   Thu, 18 Oct 2018 16:23:13 -0400
Message-Id: <20181018202318.9131-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181018202318.9131-1-josef@toxicpanda.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Reads can take a long time, and if anybody needs to take a write lock on
the mmap_sem it'll block any subsequent readers to the mmap_sem while
the read is outstanding, which could cause long delays.  Instead drop
the mmap_sem if we do any reads at all.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/filemap.c | 119 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 90 insertions(+), 29 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 52517f28e6f4..1ed35cd99b2c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2366,6 +2366,18 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 EXPORT_SYMBOL(generic_file_read_iter);
 
 #ifdef CONFIG_MMU
+static struct file *maybe_unlock_mmap_for_io(struct vm_area_struct *vma, int flags)
+{
+	if ((flags & (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT)) == FAULT_FLAG_ALLOW_RETRY) {
+		struct file *file;
+
+		file = get_file(vma->vm_file);
+		up_read(&vma->vm_mm->mmap_sem);
+		return file;
+	}
+	return NULL;
+}
+
 /**
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read
@@ -2405,23 +2417,28 @@ static int page_cache_read(struct file *file, pgoff_t offset, gfp_t gfp_mask)
  * Synchronous readahead happens when we don't even find
  * a page in the page cache at all.
  */
-static void do_sync_mmap_readahead(struct vm_area_struct *vma,
-				   struct file_ra_state *ra,
-				   struct file *file,
-				   pgoff_t offset)
+static int do_sync_mmap_readahead(struct vm_area_struct *vma,
+				  struct file_ra_state *ra,
+				  struct file *file,
+				  pgoff_t offset,
+				  int flags)
 {
 	struct address_space *mapping = file->f_mapping;
+	struct file *fpin;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vma->vm_flags & VM_RAND_READ)
-		return;
+		return 0;
 	if (!ra->ra_pages)
-		return;
+		return 0;
 
 	if (vma->vm_flags & VM_SEQ_READ) {
+		fpin = maybe_unlock_mmap_for_io(vma, flags);
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
-		return;
+		if (fpin)
+			fput(fpin);
+		return fpin ? -EAGAIN : 0;
 	}
 
 	/* Avoid banging the cache line if not needed */
@@ -2433,7 +2450,9 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
 	if (ra->mmap_miss > MMAP_LOTSAMISS)
-		return;
+		return 0;
+
+	fpin = maybe_unlock_mmap_for_io(vma, flags);
 
 	/*
 	 * mmap read-around
@@ -2442,28 +2461,40 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
 	ra->size = ra->ra_pages;
 	ra->async_size = ra->ra_pages / 4;
 	ra_submit(ra, mapping, file);
+
+	if (fpin)
+		fput(fpin);
+
+	return fpin ? -EAGAIN : 0;
 }
 
 /*
  * Asynchronous readahead happens when we find the page and PG_readahead,
  * so we want to possibly extend the readahead further..
  */
-static void do_async_mmap_readahead(struct vm_area_struct *vma,
-				    struct file_ra_state *ra,
-				    struct file *file,
-				    struct page *page,
-				    pgoff_t offset)
+static int do_async_mmap_readahead(struct vm_area_struct *vma,
+				   struct file_ra_state *ra,
+				   struct file *file,
+				   struct page *page,
+				   pgoff_t offset,
+				   int flags)
 {
 	struct address_space *mapping = file->f_mapping;
+	struct file *fpin;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vma->vm_flags & VM_RAND_READ)
-		return;
+		return 0;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
-	if (PageReadahead(page))
-		page_cache_async_readahead(mapping, ra, file,
-					   page, offset, ra->ra_pages);
+	if (!PageReadahead(page))
+		return 0;
+	fpin = maybe_unlock_mmap_for_io(vma, flags);
+	page_cache_async_readahead(mapping, ra, file,
+				   page, offset, ra->ra_pages);
+	if (fpin)
+		fput(fpin);
+	return fpin ? -EAGAIN : 0;
 }
 
 /**
@@ -2479,10 +2510,8 @@ static void do_async_mmap_readahead(struct vm_area_struct *vma,
  *
  * vma->vm_mm->mmap_sem must be held on entry.
  *
- * If our return value has VM_FAULT_RETRY set, it's because
- * lock_page_or_retry() returned 0.
- * The mmap_sem has usually been released in this case.
- * See __lock_page_or_retry() for the exception.
+ * If our return value has VM_FAULT_RETRY set, the mmap_sem has
+ * usually been released.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_sem
  * has not been released.
@@ -2492,11 +2521,13 @@ static void do_async_mmap_readahead(struct vm_area_struct *vma,
 vm_fault_t filemap_fault(struct vm_fault *vmf)
 {
 	int error;
+	struct mm_struct *mm = vmf->vma->vm_mm;
 	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
+	int flags = vmf->flags;
 	pgoff_t max_off;
 	struct page *page;
 	vm_fault_t ret = 0;
@@ -2509,27 +2540,44 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 * Do we have something in the page cache already?
 	 */
 	page = find_get_page(mapping, offset);
-	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
+	if (likely(page) && !(flags & FAULT_FLAG_TRIED)) {
 		/*
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
-		do_async_mmap_readahead(vmf->vma, ra, file, page, offset);
+		error = do_async_mmap_readahead(vmf->vma, ra, file, page, offset, vmf->flags);
+		if (error == -EAGAIN)
+			goto out_retry_wait;
 	} else if (!page) {
 		/* No page in the page cache at all */
-		do_sync_mmap_readahead(vmf->vma, ra, file, offset);
-		count_vm_event(PGMAJFAULT);
-		count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
+		count_vm_event(PGMAJFAULT);
+		count_memcg_event_mm(mm, PGMAJFAULT);
+		error = do_sync_mmap_readahead(vmf->vma, ra, file, offset, vmf->flags);
+		if (error == -EAGAIN)
+			goto out_retry_wait;
 retry_find:
 		page = find_get_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
 	}
 
-	if (!lock_page_or_retry(page, vmf->vma->vm_mm, vmf->flags)) {
-		put_page(page);
-		return ret | VM_FAULT_RETRY;
+	if (!trylock_page(page)) {
+		if (flags & FAULT_FLAG_ALLOW_RETRY) {
+			if (flags & FAULT_FLAG_RETRY_NOWAIT)
+				goto out_retry;
+			up_read(&mm->mmap_sem);
+			goto out_retry_wait;
+		}
+		if (flags & FAULT_FLAG_KILLABLE) {
+			int ret = __lock_page_killable(page);
+
+			if (ret) {
+				up_read(&mm->mmap_sem);
+				goto out_retry;
+			}
+		} else
+			__lock_page(page);
 	}
 
 	/* Did it get truncated? */
@@ -2607,6 +2655,19 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	/* Things didn't work out. Return zero to tell the mm layer so. */
 	shrink_readahead_size_eio(file, ra);
 	return VM_FAULT_SIGBUS;
+
+out_retry_wait:
+	if (page) {
+		if (flags & FAULT_FLAG_KILLABLE)
+			wait_on_page_locked_killable(page);
+		else
+			wait_on_page_locked(page);
+	}
+
+out_retry:
+	if (page)
+		put_page(page);
+	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);
 
-- 
2.14.3

