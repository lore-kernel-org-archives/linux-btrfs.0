Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13663C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B479220652
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NSXsHzI/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B479220652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbeI0DYB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 23:24:01 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:42819 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbeI0DYB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:24:01 -0400
Received: by mail-qt1-f174.google.com with SMTP id z8-v6so470595qto.9
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hGTHjPlv3HOhn5TB2Ipo9k7piqoFCis94sG3VyiCA5k=;
        b=NSXsHzI/XYShoNL8eGn0laEEoasfKJMhCPMQwHJ2Yvq8bwk04MyKO9oggPZ3BkE18j
         olp6YBCPQkeZXNp6oFQ9wE8pCqCakgzN1+c7Yf+qmYZnyq8kxdmoMhi8XJ6C2WRQrGQy
         nRoPCsn5CexUjHhSeDaxBU9NGB0VSELXL9DK0C6Xgh9Ttpe1SYyyAjXUFByg3xAEnsQR
         o3wyXeLFBnMiBJl6O7+7dZtJdtDKFbvgEAqm2FnuF2w27uQ/bdPH0KQypM/fZS0r/kzB
         YsM3KwlXFUWsqcyPrPhoIeoekAN5UBtpHcpIjSVtC5HZe9iiYCCrMpVAVC43s00HglYC
         UBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hGTHjPlv3HOhn5TB2Ipo9k7piqoFCis94sG3VyiCA5k=;
        b=n8mXlIbjdy7oAUBVjZu2Bge4EJzwCrHjmMyUE6r8FgHe9d12ycmWAemRZZI263w2Dp
         +/A1Kr59l52vpspLwrVuPQMGMgXNqrDdhz2yktIGUVA70V6dsciCCne08AOoDTTXN2sN
         lHbCicmXr8XLvas2QbNVG43UsD9o8ecHoGTIbg0qQaLMYoMxYrIZzPy2gHpkI5rIx9HB
         XNbPMsvun1ekE8TDOhEmiXzGXq3YEwqyKYwquLvTpzuiNldjhJbpQJlMWtdSDmYJyNE8
         z9AY5rGdDVAyDbp0EOBlOPBbhTGrB18UVIzkHyTAVMT1V7DuVSATcgKSN2sWgIXXQ9ab
         24MA==
X-Gm-Message-State: ABuFfogTVoPzvkVAGjRPLFDoI6GtKbnUIuPgekcJ5+jJqaIDDM45ObUw
        J5TnSa/iVhhmbxDc0gh7+Zpntg==
X-Google-Smtp-Source: ACcGV63X6GJlDkWL3trIfKsJDYg6xMkxeDmRSldNmGu6BvcZd3OT+4MyGR7tfq+GMXsjHNWbVQwYBQ==
X-Received: by 2002:ac8:2672:: with SMTP id v47-v6mr5865520qtv.287.1537996150087;
        Wed, 26 Sep 2018 14:09:10 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y143-v6sm33940qky.95.2018.09.26.14.09.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 14:09:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] mm: use the cached page for filemap_fault
Date:   Wed, 26 Sep 2018 17:08:53 -0400
Message-Id: <20180926210856.7895-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180926210856.7895-1-josef@toxicpanda.com>
References: <20180926210856.7895-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we drop the mmap_sem we have to redo the vma lookup which requires
redoing the fault handler.  Chances are we will just come back to the
same page, so save this page in our vmf->cached_page and reuse it in the
next loop through the fault handler.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/filemap.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 65395ee132a0..5212ab637832 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2530,13 +2530,38 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	pgoff_t offset = vmf->pgoff;
 	int flags = vmf->flags;
 	pgoff_t max_off;
-	struct page *page;
+	struct page *page = NULL;
+	struct page *cached_page = vmf->cached_page;
 	vm_fault_t ret = 0;
 
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(offset >= max_off))
 		return VM_FAULT_SIGBUS;
 
+	/*
+	 * We may have read in the page already and have a page from an earlier
+	 * loop.  If so we need to see if this page is still valid, and if not
+	 * do the whole dance over again.
+	 */
+	if (cached_page) {
+		if (flags & FAULT_FLAG_KILLABLE) {
+			error = lock_page_killable(cached_page);
+			if (error) {
+				up_read(&mm->mmap_sem);
+				goto out_retry;
+			}
+		} else
+			lock_page(cached_page);
+		vmf->cached_page = NULL;
+		if (cached_page->mapping == mapping &&
+		    cached_page->index == offset) {
+			page = cached_page;
+			goto have_cached_page;
+		}
+		unlock_page(cached_page);
+		put_page(cached_page);
+	}
+
 	/*
 	 * Do we have something in the page cache already?
 	 */
@@ -2587,6 +2612,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		put_page(page);
 		goto retry_find;
 	}
+have_cached_page:
 	VM_BUG_ON_PAGE(page->index != offset, page);
 
 	/*
@@ -2677,7 +2703,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	if (fpin)
 		fput(fpin);
 	if (page)
-		put_page(page);
+		vmf->cached_page = page;
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);
-- 
2.14.3

