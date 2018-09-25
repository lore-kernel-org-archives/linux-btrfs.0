Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00683C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECD72086E
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xiIjmt/e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECD72086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbeIYViZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:38:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45668 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbeIYViY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:38:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id l2-v6so13792833qtr.12
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 08:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L4OEsFz3WUjgEGzu73gT/wwAqaCABq/L1QMv8mr7jYM=;
        b=xiIjmt/eWUB4u3fWLkbXc4bB7hWrJjmm0MZsa1qEd8+bOOshROHuBckxZSLE9WOkbC
         9zKp4ykcV/4h1kwVZP20aH6CxmRLsn58jroSPwDyXAsgjo+7GsH/62PBM3emKGgMKl/0
         qJdqIhQn2OffxV0dpEsqgw8TyQwTJyXDv7Yv3w7G70CekvgpufDW8C6byBD+fNwsYA4A
         DRJBi5PieHXCYIfxhAvdvYbKvgIneJRXYt7vM8ZMjtC34i+Jh4XxftG9VtmFNrv4Us80
         4uMNMv/RXjd7aBT+STiW8dQa80NdBOSb8sscF0GIcVME/BtNWK5Nhw/ScCv99l8AUu8p
         AstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L4OEsFz3WUjgEGzu73gT/wwAqaCABq/L1QMv8mr7jYM=;
        b=WvheBixhNEIapV4S+mWuGhoAR4Y0u+c2bQevNP7KwWbU594saRlr1XnTP2guEDjl/v
         t0FITFVwlZR4UMbewyLeV+tX78Nfy9Bf5cCLe2aZi79g8Cr5UqfdJ68u3kJXSNi+Taqv
         XgHOSz2qy3hM4t9wmkkjVS4iM6PLRTk2qoknyAiDX/jpEM3QRUzBisghKBxEphkTrZrn
         Z1nPBlTx0Ryw+u294sx/wl+H9E4YYEOl5WBjzNiFGr/HBQTRcsRLLLeKcxmjNc7zwZzC
         +dDJH6exRd+/yjhTw70olBYRK9ISxEtxCysVfn2LRlVhsnI00HuoakKp/QzyWecbeeXX
         r7Vg==
X-Gm-Message-State: ABuFfog8GCl/LyctjoogGn8kx0KxL0LzOmJc2tdnei7NLwrpL1E4gL1K
        X1pxlXSemfZ1mFra8pMxoeXFkw==
X-Google-Smtp-Source: ACcGV636XzSwKd2meu1Ys5O7v+jQbfQLNsgLIWLK0BCd4sgh4v5i1cNr48zBxWR5cs6Aamdx/459CA==
X-Received: by 2002:a0c:f8ce:: with SMTP id h14-v6mr1158470qvo.201.1537889421997;
        Tue, 25 Sep 2018 08:30:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u184-v6sm1468940qkc.87.2018.09.25.08.30.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Sep 2018 08:30:21 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc:     Johannes Weiner <jweiner@fb.com>
Subject: [PATCH 4/8] mm: drop mmap_sem for swap read IO submission
Date:   Tue, 25 Sep 2018 11:30:07 -0400
Message-Id: <20180925153011.15311-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180925153011.15311-1-josef@toxicpanda.com>
References: <20180925153011.15311-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Weiner <jweiner@fb.com>

We don't need to hold the mmap_sem while we're doing the IO, simply drop
it and retry appropriately.

Signed-off-by: Johannes Weiner <jweiner@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/page_io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index aafd19ec1db4..bf21b56a964e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -365,6 +365,20 @@ int swap_readpage(struct page *page, bool synchronous)
 		goto out;
 	}
 
+	/*
+	 * XXX:
+	 *
+	 * Propagate mm->mmap_sem into this function. Then:
+	 *
+	 * get_file(sis->swap_file)
+	 * up_read(mm->mmap_sem)
+	 * submit io request
+	 * fput
+	 *
+	 * After mmap_sem is dropped, sis is no longer valid. Go
+	 * through swap_file->blah->bdev.
+	 */
+
 	if (sis->flags & SWP_FILE) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
-- 
2.14.3

