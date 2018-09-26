Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C103AC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E20E20652
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="E+IkZtxW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E20E20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbeI0DYF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 23:24:05 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32972 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbeI0DYE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:24:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id i10-v6so537670qtp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=uNw1SEfuNh5muyIlKMjO8zXN2XjQ0Df1a1ZQWi9S3hE=;
        b=E+IkZtxWnldcnfnVAFchZ1hWE504qBGKdX2eijVXxr7G+Yns/Lw/m0dK3zwPRS5BR7
         NPhHdsbYsqv7Rk+GL8cmQXek2L9S55HKsJVPA0JzSGx8F5+cBMI0QQ9EHQtfNLwA7i4t
         sC3pLwKemV+y20kKGmmL7K6hBp6n0IfS+xlPMNJ1jxbDFLwniUzBbzgyaLZ1K5mkWh7P
         eg9pTRdVcxR0Iz8T8p0VWPa/8okeH8kK+cdMZva7oNTlzpExw4ukGzcJj8CVcUfue3GZ
         UYlI0UuSGIZmFrnbVaBQ6nzmTHAXCMDv3kggv8aYdCPINTF/+3uSSqUkA/HIfFou9+kA
         XliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=uNw1SEfuNh5muyIlKMjO8zXN2XjQ0Df1a1ZQWi9S3hE=;
        b=af29TQyyzWULFTCAZO8fZ1yMKQLWnOKEDz0f9C5VcmgDimd2N/jx9f2uoCiomZGV/k
         0YhtbdjUZBnhR1ahtYXRKjGr5lkiUDviqgWgLQt/+VTTvlTzANm/sBNz3bqZApmehjzV
         mcv0K5XhorwQBSj2dUoEDn9ZvO8O8JD2835NsvnvAgW22FXgKJ74+TXiT6efzKRJy1Ey
         rQ/U+LOLXDfXSvkIxm3I8hOaUzTW0Ah01KeWRooSRAdQj/pSDgK0W5B1CH1tiq7vX66o
         BP/RSip3vEnsIIHgqjNhXbneqpe7c/rgfs+9Tq4cqc9weJXCUtWKDxurIGFp05VRAqiK
         EN7A==
X-Gm-Message-State: ABuFfogngIT3uydGtVV0w49VRYd1N4ITAzbyT33MiNh5fzcW2yvuKC/P
        44b+abGiiGk4qgSH2hoq/CsSYA==
X-Google-Smtp-Source: ACcGV62nU0p/SpQCuwEhccw6FtSj8cKf4zvclsHPNrLrKJb3VdwuIBbYKgcnnrv2S2qANr8nkWYi+g==
X-Received: by 2002:ac8:39a1:: with SMTP id v30-v6mr5494082qte.58.1537996153608;
        Wed, 26 Sep 2018 14:09:13 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r9-v6sm37064qta.87.2018.09.26.14.09.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 14:09:12 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] mm: allow ->page_mkwrite to do retries
Date:   Wed, 26 Sep 2018 17:08:55 -0400
Message-Id: <20180926210856.7895-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180926210856.7895-1-josef@toxicpanda.com>
References: <20180926210856.7895-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Before we didn't set the retry flag on our vm_fault.  We want to allow
file systems to drop the mmap_sem if they so choose, so set this flag
and deal with VM_FAULT_RETRY appropriately.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/memory.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6f8abde84986..821435855177 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,11 +2384,13 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
 	unsigned int old_flags = vmf->flags;
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
+	vmf->flags |= old_flags & FAULT_FLAG_ALLOW_RETRY;
 
 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
 	/* Restore original flags so that caller is not surprised */
 	vmf->flags = old_flags;
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
+			    VM_FAULT_RETRY)))
 		return ret;
 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
 		lock_page(page);
@@ -2683,7 +2685,8 @@ static vm_fault_t wp_page_shared(struct vm_fault *vmf)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp || (tmp &
-				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
+				       VM_FAULT_RETRY)))) {
 			put_page(vmf->page);
 			return tmp;
 		}
@@ -3716,7 +3719,8 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 		unlock_page(vmf->page);
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp ||
-				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
+					VM_FAULT_RETRY)))) {
 			put_page(vmf->page);
 			return tmp;
 		}
-- 
2.14.3

