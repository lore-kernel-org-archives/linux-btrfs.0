Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09324C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB8ED20652
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 21:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cMCnruOr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB8ED20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbeI0DYC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 23:24:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38285 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbeI0DYC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 23:24:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id z13-v6so501652qts.5
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=rRSaxONrZWxSfcObSyXaZynV5IrpMUJ0BUHUIDN5YaE=;
        b=cMCnruOrfxbswXpQ+LzDNW4YBVLUWDQs7bq7X5QQbmFe7IBXo+BpnpXZ5nYL+NtYUu
         UmQOdRfXvT1X04/qw5qRpxkrQHPA9jdosXRIjLUl63CsIpykwMRlwwk/l9e21291y+Il
         RTMGa1o+lcurVhm+IrAgprHHyRMmR9Q34XHI1p9+jyEySWWfd0/sGQRtQ0sm1r1/OTYR
         Jn4qDuTHXr1vCpWOEV5xBltDo+2f4ntWFKOsFfmgVmZN08cvjpw0dJcEIgDceEBJqAxt
         /zQ0Z7X8q4v+RVYpOm8Cnq8jVqw7E/fQDxH+bhVROQZiPF3i35ff81yOhbZzjGw05Nmr
         vLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=rRSaxONrZWxSfcObSyXaZynV5IrpMUJ0BUHUIDN5YaE=;
        b=b4zqRDAha9X18JqGoGuHFNmn5h70Ixs7oEvJ/g6yOGFUp6FeQZdAbVxDvZer2IHTbA
         a5d1yLIZIZy/Yzm6IlgopmtdsDSaJuxsSR3z6XjT6Ba7Z1hbY5eI3SvJ3BO+f4vjLAO7
         pYKVNcgeOhr3VzJPEx0h8GujdmsApmPys5NHjOGLQh7Hm6qljB+EHVRnliRTHaWvdMYq
         q3IhZBjRu46to+O4hhwE3pdBX3FlUB68I2DYO3OhemaqK8aRT8H0yQlqAfCu8kxhj6rx
         Vqp2nLIS9I75T5ETsxM2KYvJKEO4kfGQx5MSVOuOzFHOsHfZlF2zbxyrNK+0qZ+3CaKX
         BHUw==
X-Gm-Message-State: ABuFfohyuUWkvGPz6AtOOoZkyURAb3YQjXz4X/CEtXQyBz0xDlgrXw11
        HBLipcvucEbhQZDiT73lShRM4ZTjoiY=
X-Google-Smtp-Source: ACcGV63nJY6gaLc/Nzii08FEPUVIkCZuTe+OVlkmq03gRhXyS5p+AaMCVfImTqMIHfOrrPvVJ2Pfgg==
X-Received: by 2002:ac8:2a81:: with SMTP id b1-v6mr6223154qta.286.1537996151881;
        Wed, 26 Sep 2018 14:09:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u3-v6sm59038qku.46.2018.09.26.14.09.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 14:09:10 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] mm: add a flag to indicate we used a cached page
Date:   Wed, 26 Sep 2018 17:08:54 -0400
Message-Id: <20180926210856.7895-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180926210856.7895-1-josef@toxicpanda.com>
References: <20180926210856.7895-1-josef@toxicpanda.com>
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
index 4a84ec976dfc..a7305d193c71 100644
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
index 5212ab637832..e9cb44bd35aa 100644
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
@@ -2619,8 +2620,10 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
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

