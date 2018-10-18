Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B9DC67863
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B618821476
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 20:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sYnIKpWZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B618821476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbeJSE0S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 00:26:18 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33575 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbeJSE0R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 00:26:17 -0400
Received: by mail-qk1-f196.google.com with SMTP id 84-v6so19682072qkf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=rRSaxONrZWxSfcObSyXaZynV5IrpMUJ0BUHUIDN5YaE=;
        b=sYnIKpWZb0ethNv7ygrSHuJM9bQ6yfODonTwuNpvn0aI3FJoNvgjPlgWfQoMmpR9gd
         7KRCq4lfipETSrHqyEqxuaddeM6zru6h3oAj8UJ5ykK1EBWDbIiAodZcibkyhUoAeBGy
         rD+gE3mR4nq06NrFz1vZrWP4WHOoRZjdK/HfW9puyW+5LilQXWGBL+cwUrZMBQBx5Dmb
         TaT/v+QFKp3TUaOn357uQhnB8TbIpUsCjB7mfJY97nZyBVWA317u1+V2sumi31QG+D3Q
         gNSmWotTbFD1mmUwlAeAibeuaiBJgKswHrw7ri/QJqkOO2D1moAu7/MGP0weNtMfSGzd
         YYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=rRSaxONrZWxSfcObSyXaZynV5IrpMUJ0BUHUIDN5YaE=;
        b=cVVWCblhr5zYt3+QTWElVQS64xZ6chH7y4HgxNfbJznI2kj1ikT0s0MIdbGtxnPY0m
         GO+WIwM+w2Jc0VUdmcqEie28hCIY9JpkIIfpo65H52zqb+AurCiodzVRNx7l9+35FzSj
         YAGUibk+qIUXnxfe/B07YRvs9xnxG7FAx7OK8cwgDKAyj3tyuV+CO2jv2BwoRNHK8VIH
         AoWYnDeHL6fE3khoSvV5YRRoNPMhZWlwK1Jewtdao4FIPt9SltbotgaGvGINHy9ArDu4
         vRBYLJTZ8uNGhjbrJ2Shd4Cj5vKBjYORGQjyFghWeMKLQLXEMVqJxRGiaQAsQ4eW+u0W
         Z1gA==
X-Gm-Message-State: ABuFfogjEX2Sc3yiKDP3rykCyZkJQ5z32L1H1DWqPqlaXny6+pmcQvk0
        FptpideBK/mJOUIb7tEKpIU5sw==
X-Google-Smtp-Source: ACcGV62G7ya4wMwJkdmFy96WMrqdf+XZFz2cKbWI2in4JRemu28Kc13+O7n5qHte247QRx/a8tgXUA==
X-Received: by 2002:a37:4dc5:: with SMTP id a188-v6mr30144112qkb.326.1539894216216;
        Thu, 18 Oct 2018 13:23:36 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a13-v6sm13703972qkg.94.2018.10.18.13.23.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 13:23:35 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, david@fromorbit.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, riel@fb.com, linux-mm@kvack.org
Subject: [PATCH 5/7] mm: add a flag to indicate we used a cached page
Date:   Thu, 18 Oct 2018 16:23:16 -0400
Message-Id: <20181018202318.9131-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181018202318.9131-1-josef@toxicpanda.com>
References: <20181018202318.9131-1-josef@toxicpanda.com>
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

