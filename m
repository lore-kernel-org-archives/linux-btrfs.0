Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384F9C004D1
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8DBE20779
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="tUlEGY8l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8DBE20779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbeI0DXz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 23:23:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39606 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbeI0DXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:23:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id c25-v6so492998qtp.6
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=tUlEGY8l8IgAEzc/SrMWSEhdj/YyihWzeRHQm/F7LSmGImuylO2549hO9a14Megk4C
         S6YLhf0itc2jGfRTXuqZXNNpdLG0n/5fynFIeJx5PCGpk8ve3pr+L3HbN8JwP4oY2vNz
         are7A4iKZfhnLtonNzI92X7P0gMiAtPr5kJ1P1S0JSLRkB3Xy/YRf40h3yYhGpmrIPrO
         fINLLRqmeSOAFFhYx/4ZtRJtKCFIbY1d2A4Q0xJO0lqhVB+uTUigu5Wrre1Gp4Gbx/4Q
         1/2nAOKAeZ6nAdT/3xXt7evr6JQEeAOsDYjieEmH8aGd86QB9tZKXMuOkAackq2qjcjf
         pGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=r2ao7zzDJDJhno+nelDkhPHZhCcpPdTlgZTeY0OM3+4yIvI7FtIWJffx5aHxknPNGX
         +l7lXbZqfzMt1tuR8+WA0tTRGNmFGFotMVD1wuCAbR6jcr+zZvitTIdAsYYFV3+FPgWS
         Bm6T2OipdKsLj525HOQvJfIeUrEqJZ5SZ+liKPgwiZ7lK7p4i49b4FGYDOm3TvH3iLgh
         T7cMZEcGKv6CqmCVikZ5xdeCi6eu0c+bLH1r/x7RCNBDMulhV6+rZCxGYhqZGj1ip4kX
         dL7Ob70T06nZfYvSMzdlhMVNnXPony90wkoXO42onFWGzE+4TOBnCeHVaCotguu96f+E
         nnuQ==
X-Gm-Message-State: ABuFfohDg5ALxZuVRodkKbA4L+0rEL6rYHiSnEp9NbjCQRublyw9t+Xb
        HLbqA125iqEpwTSEVtcS9Wv7eQ==
X-Google-Smtp-Source: ACcGV63m+uEm9iqYhuq6Vvgdg3700+CAAqavam7D27mFj9y+w+xIfARiMWPqtlMjnrw80RLGv5qyZg==
X-Received: by 2002:a0c:f906:: with SMTP id v6-v6mr5821962qvn.86.1537996143023;
        Wed, 26 Sep 2018 14:09:03 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l18-v6sm96163qtb.2.2018.09.26.14.09.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 14:09:02 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] mm: drop mmap_sem for page cache read IO submission
Date:   Wed, 26 Sep 2018 17:08:49 -0400
Message-Id: <20180926210856.7895-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180926210856.7895-1-josef@toxicpanda.com>
References: <20180926210856.7895-1-josef@toxicpanda.com>
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

