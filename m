Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E31FC43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F098E20C0A
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="r16xab4q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F098E20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbeIYViV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:38:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43866 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbeIYViU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:38:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id l16-v6so13297705qtq.10
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=r16xab4qK/GzMbIKCC4aw7lZg+2OpxVn3pFK0xbG14epU4FWUX0WIYOooStDmiuVVb
         jmhFEufRVcbUZ2OoeF40N3YypUdzdZ1ia5oDwZCXIde/v6HqBftP06QnHMNA2ZJno/+B
         SYw/AUihAab2IaqYl/p0ewxnh0qA4X3QfakWuQeq1oTT1kfliaUBXI2ydTr/Mp/t0j6z
         xnmcy10agWziYzmo8+goSXT2aAcs4+hIbOYUgatNHnmOQ7uRNkiWWN3dcSakM6wlwFww
         dYSdbD5qXQm+P48pjM9uRaYlf8q0UQ7mO49yjpXx73aoepDGbMOGQFggb9W5c3HXNfck
         Tpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=FY4PvfFFgkG4rCGf8NvSi/OKKAo2xpKioHzicQvhcOI=;
        b=IbHbiItNa6zUtSGdO+y75tpUiQwqCulAoN4X1YkbUJ+lvjmrbbgJAUR4WVakk8G/iU
         QvQLj1wA4nRlMfH5iScaHm7FFsqvLHjQ+vuPlx1bOVJtpx4e79YCOwpAhDAEb9gSrqeR
         lIh2bG9SHpRt9jmJ7Mer43tCjFBZTcE6GjV5oXeeJ20WzdfwdnWokdd+2YWvmTDgz9O+
         xotr9VZ1xt2djoxNJIesHSXtqgpeB57XfCRCRkNOjRH10YJXiq4z3kQ8Sx5uz6C5nVsz
         xI6WZKwNtPupbfS9zH3Jg+mkOGXU838FtYyxYzPy/GiiqdKIVPEfVSokOKfjxEdSED0/
         orUw==
X-Gm-Message-State: ABuFfoj33Z5FLAklj6+vyNwbi2r6IaMTw9+IUC9zrKQTj2yJ6IgJsiZD
        9ZSmPRJ6A8NzSJPWcZAxVPuNQA==
X-Google-Smtp-Source: ACcGV61vPNw252mdhbHuhSVRmWvA1VPrladnxlDA+gQ/uZwGukOs4HjONukkbRdqx0ZKC/CD1V+FFg==
X-Received: by 2002:ac8:39c5:: with SMTP id v63-v6mr1176759qte.273.1537889418468;
        Tue, 25 Sep 2018 08:30:18 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y205-v6sm1507950qkb.56.2018.09.25.08.30.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 08:30:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/8] mm: drop mmap_sem for page cache read IO submission
Date:   Tue, 25 Sep 2018 11:30:05 -0400
Message-Id: <20180925153011.15311-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180925153011.15311-1-josef@toxicpanda.com>
References: <20180925153011.15311-1-josef@toxicpanda.com>
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

