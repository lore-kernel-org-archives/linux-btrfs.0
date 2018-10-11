Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D76FC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 537C620835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="yDiT1o+5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 537C620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbeJLDYS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36382 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id u34-v6so11347004qth.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=yDiT1o+5fzw+4rnmqdumVE/VMjvjTp4ow5PoUTlsmN0o7qZhlW/MTuPVoDguXQAzxs
         YCOiDKcDIwy9iSnHEe2PMVcYa91id5G/GEWV+1PF4NjpWW5LKBIAK1vqZ7ubJHndo442
         ZuIkftt79lAAjgyGoHVmjPIP51s2w0L7xIlO3P+XapGM7ETAyEzy44jDyHGrW2KMEtdb
         dxZy4XbKs35rXIT0RQBOUZ05nUjUFPn5jqjFqigT1IWU/e1xD7/zEcBak2iA5H8PWhy5
         vLzyTuKm+aNBc+a6DSQLtSHgII/QSaOa54PoRwxolbszpnE7/4/wbUFN7fEXkqIQQE95
         sTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=WYzW6AmZ92NvXAaJ14T3QJrln8OGxtDvyzfHhhylt29BJNPUKptjqJvPLh/LG4qB3+
         dmxH/CLMruBiwBeyZQEPpnY1IadUKb3PboCmATy/uNV/yhOUwBcBmbiyHgy17TVzUXjS
         jAr7pwX+PVUpDQjxZjHB9pQzPyjqSPCCLRaeQp+Jbh/LhuXpFycEXh5dz4kbpcy1hwb5
         hgLOqhV6ixYPH1laIWdE4BZgCaYGdxyFFRlaOzLOu7TPUroCE6SOzlQhxglU8RSZ4Nq4
         yEGw7BuBpJi0I9Pl1IFWSohqVjuCBxtVfLxYmTKq/GMr4GeYPQ5EedxvEBnICa+B7izI
         3uUg==
X-Gm-Message-State: ABuFfohBbZ+HSg4OeZ1KjKVIare8B+Ounefb8avYEuxhJMRWcIKYPWLf
        QIIU1+rKQkGJSEmD++K0b5r2fw==
X-Google-Smtp-Source: ACcGV61JYMFDZs3W+InRR9hwVp9tkCJEMdYGGqVNw1eEKWNoFhPhWxRrhXQcg+GMCMUoZSNF2/70hQ==
X-Received: by 2002:aed:34e1:: with SMTP id x88-v6mr3074559qtd.156.1539287731904;
        Thu, 11 Oct 2018 12:55:31 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 144-v6sm14006883qkk.63.2018.10.11.12.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:31 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 31/42] btrfs: cleanup pending bgs on transaction abort
Date:   Thu, 11 Oct 2018 15:54:20 -0400
Message-Id: <20181011195431.3441-32-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We may abort the transaction during a commit and not have a chance to
run the pending bgs stuff, which will leave block groups on our list and
cause us accounting issues and leaked memory.  Fix this by running the
pending bgs when we cleanup a transaction.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 46ca775a709e..9168efaca37e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2280,6 +2280,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans);
+	/* This cleans up the pending block groups list properly. */
+	if (!trans->aborted)
+		trans->aborted = ret;
+	btrfs_create_pending_block_groups(trans);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-- 
2.14.3

