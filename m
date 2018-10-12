Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0B9C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C5A21470
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="UVY+Z6BS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3C5A21470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbeJMDIB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39068 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJMDIA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:00 -0400
Received: by mail-qk1-f194.google.com with SMTP id q5-v6so8349318qki.6
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=UVY+Z6BSGBlz2keV5PZRsp4zE6xgRVvxNUpCgpc/Rs1R3hBacFcoeW9Yiz+F04ir6E
         mDQJq5J3gvlmeWxqIt4uq5zIn81+rEAIsS5XoNDcpf9I2N28j7d+GegKwM1UTFF7MzWT
         Fb0xT8qbqvskIWmF8tTzkE7pZmuPdUTOYmNc1xWa9lXzdOrFTpuwMXdsnsj1IeQeej9U
         BIFt+HYOLi33Jiaxdy5HfQXdDWKXoCG/mG81YRfxWMVQOPfk10BqP6E9DsTc+pPP2Pqo
         4qvjXuF/3BURi3e1zKhjAOBYGHgCYbVTxuBcIYTRiWdqCdhSaIn+nWMYX14lNRuQD7GR
         +iFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=HxNY5MJqG7v3J5b5AFefJpNVWpEcNZMF117mizY+RBxNX1fASEhzBNOxTqdVkdNGJP
         lJjumzNybA5V0+LmJ9iRVP0vQYy64wC6E1gHTrI4jWNYXHCSYyHFVMdlsNVZaUvPaCRW
         58UK04g90OaGKqC6YAgST609Oy911XF2hNGwcU0412GlumIHxrK5DaDsNBPFwv8y/EVr
         y/un4L8wCDxUC1IEz+4gxGn2TCCOzjaPYi4gdMHAlKSTMUOWl82gCMTjVIWMkJti+zqr
         jTMqKUjDQjHtuw+n+G49x5V1r4q/wMs3yJmrCTuUdrh+bxhUmLeh7btwtWKr6XH+cRs1
         NvCg==
X-Gm-Message-State: ABuFfoijhg5N98pkTUw0jtVlmQ/IkZNnvgvOgYuKrkHe9s6wD8GdANLF
        xt/YcIAnRyLnhk7zMd0VsLKqv73Z1rQ=
X-Google-Smtp-Source: ACcGV63nrzeSYSF/n1xVDQS3N45THNLMSLzcXtG2AFb3BB+ZnnFacwVYpS67NUByxFBFfnZRMrIumA==
X-Received: by 2002:a37:8d83:: with SMTP id p125-v6mr6985486qkd.97.1539372838539;
        Fri, 12 Oct 2018 12:33:58 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a68-v6sm1459249qka.54.2018.10.12.12.33.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:57 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 26/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
Date:   Fri, 12 Oct 2018 15:32:40 -0400
Message-Id: <20181012193256.13735-27-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have this open coded in btrfs_destroy_delayed_refs, use the helper
instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 39bd158466cd..121ab180a78a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4214,16 +4214,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
-		if (!mutex_trylock(&head->mutex)) {
-			refcount_inc(&head->refs);
-			spin_unlock(&delayed_refs->lock);
-
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref_head(head);
-			spin_lock(&delayed_refs->lock);
+		if (btrfs_delayed_ref_lock(delayed_refs, head))
 			continue;
-		}
+
 		spin_lock(&head->lock);
 		while ((n = rb_first(&head->ref_tree)) != NULL) {
 			ref = rb_entry(n, struct btrfs_delayed_ref_node,
-- 
2.14.3

