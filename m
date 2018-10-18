Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91117ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 546022098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="UD0ffWno"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 546022098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbeJSE0V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:21 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35981 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbeJSE0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id q184-v6so1614251qkd.3
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Hfe+8/p9IgmtmhKjFsy8lPGB052ph7HB1j0v1iwnQq4=;
        b=UD0ffWnoYdPxKmTAMvZoPxfbJC2KjBM/0Dcke0Ix6eSsVKjz9w7PYY8IK5N/nliLs3
         VKmL8ZilBFRVfgEFj4StsMtMacPmSj9fKdydrrp8MEdxHEBBHTjtfhNByMyaVQ6jmVDG
         3pOD6FCc30sXmTBFxp10qrT6K5mIdQjc9qXJbO+NgJRMatDFX1llMM7vgC1AuDki7ooy
         M/mCG6iBBraimIwkStOhg1t99t6Gzt5NpSpRZA04TD8ixFlnHYQkbB07vorA+vrBGuUD
         J7eeJkEBe3nSSFsS7Uzho/RKCr5AJjLtHSEZQfwKA95Qog8VoemHHVSDUUd3bd6YSpOI
         0YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Hfe+8/p9IgmtmhKjFsy8lPGB052ph7HB1j0v1iwnQq4=;
        b=D8/MgXezc7yn1rhJoiFj6raYe3UVBA3xkzSi4Uy5FwOh2F+Y4J2iFMDoZy9Iyci5pd
         EMpSjRuKGD6AgM+27CZnXYctkq7Urj1a8hBeWe/TejH5mneVITKqy4z4Cy0keT5dSsKy
         lQKWRiTEwqx7Hetme5Doj96TU1OhaBrJT7yALHN74zMvp4nPdv4UiamA8NuSfqqjAJ+6
         B9s/ffEsltlxprCI9LwFX9L7eHYGymZ5bb3uVN0m/zcm/NycWLjCRvyofDqNINSgHEMT
         LA36+DHkxzmy/JOLIfXxa8agoWpdbPs9nIOm78i6B4IZWZHgRLJ5RBbQSJgXw2kbxqLi
         GXLw==
X-Gm-Message-State: ABuFfoj/NR5KvnN+sFq3lcLKmzD+rZn8Yq4sC6EVE0E7A1KT9E+UjP6b
        xVmP0jOUPppErA3GOxkdlIpHGg==
X-Google-Smtp-Source: ACcGV614w/+TGK2yLbQdZinPDCwxR2AIYh2D2xLFqtySMLNCGQJ40gas3jrhoUBZu3wueQSc2xXrgA==
X-Received: by 2002:a37:9ac2:: with SMTP id c185-v6mr29524234qke.162.1539894217991;
        Thu, 18 Oct 2018 13:23:37 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 14-v6sm5525307qki.73.2018.10.18.13.23.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:37 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 6/7] mm: allow ->page_mkwrite to do retries
Date:   Thu, 18 Oct 2018 16:23:17 -0400
Message-Id: <20181018202318.9131-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181018202318.9131-1-josef@toxicpanda.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
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
index 433075f722ea..c5e81edd94f9 100644
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

