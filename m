Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BEEC43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C2CD2086E
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="QENpwOrr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C2CD2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbeIYVia (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:38:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33693 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbeIYVi3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:38:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id i10-v6so13805731qtp.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 08:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ku7/MRL/ppjtTHGZe2O1XF901LokT9maZEyU9FpjnHE=;
        b=QENpwOrr/7ZhS366ZP7w913/Hs2ElSqyKva/3kYfiaWk0+nhF6n+0Oa0FNzB+IV9Ye
         w8PDsT3mG1ZBqJSQto0v1fNNqZiiuYsf8CdazEuwY8dEGoeye7fn2Mkgzrzd1pmXKusw
         ihZdiUq10sVQ4cocO/MxEM+S/6DBh0Z4tjeMK4z44d/zCWr8qs0/nJDyXikVoXRDdTDk
         mtZ+7pr6nbyNre5aGEML/ZNBB8ndkk8vZSu7Mhd0VOqKcMyDsa5hBcEYJLYdoh4dLmog
         MdEJGU9LhxBcsHxVKFbrTgk52uT33H2FKS0kYhrbYjBC841r9NXAD4ZgSSGqzActbwAG
         2dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ku7/MRL/ppjtTHGZe2O1XF901LokT9maZEyU9FpjnHE=;
        b=ti/ym6j/QLRtZVmDtoWaVL9VxRiZlhwTt5J1tlX1uWMxfSbFxoee47BFGHS+0lFOGQ
         BzRs3MccTxzRevQsVTufojo17I1sYe4mY22R334zoab1RyoOIddULWypKl3wqlrcDkrk
         HSBwGFxlO22UOqCN7l6656Y36dmJQ/iK3e2B/E/mRottnSVFfADcBnBJPHfMww7hQLB9
         P31NiYgDEXFx4t4gMZ1TOvlUOa4K34fFxljz2Qa3P5wDtONptHAHWT0GtTKFCzHDG4nk
         13aDRW6lhB/R+Lhhbkjriv7IvYHWQa233vwBcXmuKar2/sspCtmnptjzw3HDY+dAzqeG
         pTGw==
X-Gm-Message-State: ABuFfojhRqWhJSSGoP7aoBwzMIxCaT3fUWDzl19KHUdCqqT0iX47Vk4L
        NPW+a7NA92oTS4yKca976Vdpaw==
X-Google-Smtp-Source: ACcGV62u48xuG+u6HnDqHjgjSdJBvYRkbiUdmT4B3A/rajjCC8tIPdq/rTHhk6YGPZQGn6+Y1hSAMw==
X-Received: by 2002:a0c:93c1:: with SMTP id g1-v6mr1226748qvg.136.1537889427517;
        Tue, 25 Sep 2018 08:30:27 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l16-v6sm1642913qtk.30.2018.09.25.08.30.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 08:30:26 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 7/8] mm: add a flag to indicate we used a cached page
Date:   Tue, 25 Sep 2018 11:30:10 -0400
Message-Id: <20180925153011.15311-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180925153011.15311-1-josef@toxicpanda.com>
References: <20180925153011.15311-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is preparation for dropping the mmap_sem in page_mkwrite.  We need
to know if we used our cached page so we can be sure it is the page we
already did the page_mkwrite stuff on so we don't have to redo all of
that work.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/mm.h | 6 +++++-
 mm/filemap.c       | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 724514be03b2..10a0118f5485 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -318,6 +318,9 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_USER		0x40	/* The fault originated in userspace */
 #define FAULT_FLAG_REMOTE	0x80	/* faulting for non current tsk/mm */
 #define FAULT_FLAG_INSTRUCTION  0x100	/* The fault was during an instruction fetch */
+#define FAULT_FLAG_USED_CACHED	0x200	/* Our vmf->page was from a previous
+					 * loop through the fault handler.
+					 */
 
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
@@ -328,7 +331,8 @@ extern pgprot_t protection_map[16];
 	{ FAULT_FLAG_TRIED,		"TRIED" }, \
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
-	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }
+	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
+	{ FAULT_FLAG_USED_CACHED,	"USED_CACHED" }
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
diff --git a/mm/filemap.c b/mm/filemap.c
index 49b35293fa95..75a8b252814a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2556,6 +2556,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		if (cached_page->mapping == mapping &&
 		    cached_page->index == offset) {
 			page = cached_page;
+			vmf->flags |= FAULT_FLAG_USED_CACHED;
 			goto have_cached_page;
 		}
 		unlock_page(cached_page);
@@ -2618,8 +2619,10 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
 	 */
-	if (unlikely(!PageUptodate(page)))
+	if (unlikely(!PageUptodate(page))) {
+		vmf->flags &= ~(FAULT_FLAG_USED_CACHED);
 		goto page_not_uptodate;
+	}
 
 	/*
 	 * Found the page and have a reference on it.
-- 
2.14.3

