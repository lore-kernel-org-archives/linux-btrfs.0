Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E225CECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E2E2098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="nT39Y/I3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0E2E2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbeJSE0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40144 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbeJSE0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id b4-v6so35835183qtc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hGTHjPlv3HOhn5TB2Ipo9k7piqoFCis94sG3VyiCA5k=;
        b=nT39Y/I3v+R7DJdgx+w05J/2Y+m3MDiWnk1nL7t4/7+CM7XiPVYhj3l2z9w5ARkDux
         SFUAlxO8JdvxirqMmPZTGRvyXzf/F1gf27MRw/gbTBAQeYjmUZFp91y8pO5oLUh9paj3
         4Mg/pRVwYZoQ+VQkybYJi/38gUFMY+wk3NRr5cxlCblJoaTeZtKimCERIJSs/YPNhsQw
         Yj4RoxkBR9WrEqUR55b9S912+TOdECaPpCVpoCo8EWzHw4uHPszCM0G+xVZCMip+v2kq
         ZdJGjXwHzmN0UQp67pYVQo+e1u4jv2h70jkcXBy0hGhY7XII8xnk9N7bqGUI5ApV7HA9
         xy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hGTHjPlv3HOhn5TB2Ipo9k7piqoFCis94sG3VyiCA5k=;
        b=AxBzGVZjhMW1wcFf54qgYmLIyD2WaoSJQ/fNC4vKSKcq6Tb6Imz+7S0QK8hkB+u5Pa
         y88Bx6iIyEZPhFDKmyR0cLGG6HwK5HJ2E/I6+ztlTVx64PyMmXXzEhe/701bcniHlF9x
         4fI9OGpDKaGoWYLTUdperD93qx8FXm5irHxItGxiYWdEsIvkQB0GkWvgqljrtdeK3ULC
         T1RcnMgCRlXLIMxrrbQ8nJN3Nfu8yxlLyUvrjIHE+mLUxeWTfUMr5fFrDLAkggvbsX3T
         fHau/5wSKqGD8EPoRHe/JMqEVxYOK1Las3eVOLZWTxfi68Svv9DRDWa5hyy3+TWaqbgw
         dyUg==
X-Gm-Message-State: ABuFfoiNsh/XKJyIrc0r73iKS/BEsY+YT2j64m5ffpmFIItrj4BS9TU/
        kLv5P9MZ9/ujnZERxeJykGwKcQ==
X-Google-Smtp-Source: ACcGV60ajb9VJhgqek0PPLPRGAIgXrsXiS83GVhmSwgELdoGf1qud/rSb0MUwUUr9Cw3VlbImR7Ugg==
X-Received: by 2002:a0c:b137:: with SMTP id q52mr11208025qvc.58.1539894214457;
        Thu, 18 Oct 2018 13:23:34 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i79-v6sm14094657qke.17.2018.10.18.13.23.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:33 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 4/7] mm: use the cached page for filemap_fault
Date:   Thu, 18 Oct 2018 16:23:15 -0400
Message-Id: <20181018202318.9131-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181018202318.9131-1-josef@toxicpanda.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
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

