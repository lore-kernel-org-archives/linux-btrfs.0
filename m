Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FBFC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C8152087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BH2HhYNn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C8152087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbeJMDIG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42093 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbeJMDIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id g20-v6so8335755qke.9
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=A9aQdPUEOSexy0JQIA2ztVH7gL7ZKLlpRHnZdfmk2Vo=;
        b=BH2HhYNnD8+XxYt96UgUrhL8Wctors+vRNGGi56OZyXBWZu3s8tb2/T0HKVXbqZa8c
         S5xsdYWJfhMcRBIoUS9mK1bl5ebdzS+yL9zTgkGe3fUAJjA3FkCRVbYzOc5ZH4Lh9H+6
         IWQOYT0JHuo7i5hzFWgs2OM4EVQsFbifJfr6hwbF8cd5mlJqqMJ9jpteuQjyFj8N0mAS
         gQTf6rpDyoqIJbX660ksSl51fkC813c/yt1GYYpS8XvXh4FIVheURGWXy70+eD16RiEA
         roz15uERls5dkqWMp/5+lr4u2ipUgRiirQDH7eulVhJtVeGE45o9fVmnApwdWH3M7CPP
         gzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=A9aQdPUEOSexy0JQIA2ztVH7gL7ZKLlpRHnZdfmk2Vo=;
        b=hHooHYJ/73KKDoZ90f9/+AQfyPmNUtFfgJSy58GG6+SHjQRQGGu+oKdVtQm/LdldWw
         K9gFKWtZWRAtz2sBGuYUzXB9frEjfVp8oV1Fu1SYh04FAZy/kB8LMb9GYX9Gn0ve/40H
         lmmpt8005NukglYv/dvtVBUFQv/Riga0aaUvmHOwcIV3eT+Kzpsegc0FtwlDKV4ZNr/Z
         YGKgS4+Pfl8+++2leNMB6R+jD1J7pwGthMPAwlxhoWjFEDNbedZpXYkTTJKTzItOZvmg
         GFk/R4RTfJ64lgwxbDvHmbNrEgAayJIF/UEA8AvpRQNL8aF8DJI8+dH+6/ROyJBvokDA
         Z5iw==
X-Gm-Message-State: ABuFfohC6rtazBsbiX+l7rQ1OcTigOJVGwp172M148muKYiK+s2RPTJf
        JqJd+CMWL9pKGH+WA6EMuqXEkglDX84=
X-Google-Smtp-Source: ACcGV61k+eHoVAQVkco+4vAyUnZRxrwYQcLTXrBQ0phQsUP/KkN5HzEA0+f1e1YjtMP4o3hYy20r1Q==
X-Received: by 2002:ae9:ef11:: with SMTP id d17-v6mr7189519qkg.80.1539372844520;
        Fri, 12 Oct 2018 12:34:04 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 140-v6sm1461573qkj.13.2018.10.12.12.34.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:03 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 29/42] btrfs: call btrfs_create_pending_block_groups unconditionally
Date:   Fri, 12 Oct 2018 15:32:43 -0400
Message-Id: <20181012193256.13735-30-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first thing we do is loop through the list, this

if (!list_empty())
	btrfs_create_pending_block_groups();

thing is just wasted space.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5b5a28b69fa9..14495c030301 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2978,8 +2978,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 	if (run_all) {
-		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans);
+		btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first(&delayed_refs->href_root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 39a2bddb0b29..46ca775a709e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -846,8 +846,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1934,8 +1933,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cur_trans->delayed_refs.flushing = 1;
 	smp_wmb();
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
-- 
2.14.3

