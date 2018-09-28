Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C13C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82C0215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Oese1BH9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C82C0215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbeI1Rmk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44809 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:40 -0400
Received: by mail-qt1-f195.google.com with SMTP id c56-v6so1241450qtd.11
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=Oese1BH95QAWz361InMKFeP7xWkTBwxNBbYSicJAaQ8ykWpj8wdyXebyoQYNsRtqwd
         P7S/NIrBjLSYPh18EQShviSJ3y4kCRGqUTgTS/qq6vb41ZZXxmwoOjdj7b0cniGYzUVQ
         eJthzNje4j9Z+gRmKUc5fbgklzixkD6E3qM7r2cK78aCctON7+wGl/53jpSVLlOQGi2E
         FYx/pBZUz/W67TRSK7b3mQshz1xqXl732sGWH5WRl5P1siv2iEih5UeQCWJEEZ5WY/vC
         v7f8rdAaDLurlb6KPOp1FX7TzNku8Zqk6Rr6nx4uHecFq9Lj3MDMxHyrleLBSm76HPmA
         q6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=esyabqCBu+9iDj6gymgoZZfIo7W+xlWCseOBiKeoQzQ=;
        b=c18p8F7PK3mIf0ysOqkadYKjMaBGZwjy99lBncJCaAJnYvO4X/YrRudTHGU7NRklI6
         jVfJIyNHIXxKSEsi7CzIU2BVIizQpoY5KIOwYlGNjNsBnQ08r4ebvhhNJPbtjkBccmxX
         1mIPzKMEbUZSg4MlY+GItYirEoIdW1JuX1JqBwVEnWD1VRtRIefRcAvgd1CSMpu+Js+l
         +dUM50bIE3jTkxVFzIhhND/2LD7Bwz/KnnUsvAvrRzPvns1AK4TPmwP7ZTZ5lAfWpRpp
         Qs/njrI6F6cpCFhQ0kDjy4BouFpM7YZoLHgkRrskf9/G/+t5YcYa8V1QBGXZ3u4SqwMU
         5dTg==
X-Gm-Message-State: ABuFfohSfaQcoBrt11FDJSn6IMBmyyVDcCchnkcjb2SObxg1xjia2xPV
        KuIQ9zxKKNz8kFgf2XuGFJocHg==
X-Google-Smtp-Source: ACcGV62o+RfiMAWSwQ6LXQGAIF8UW7BLjXCJ0CjodJkoiHYZjdTkEcTr8sqtPam6QeVglyhn7KPcRg==
X-Received: by 2002:a0c:83c4:: with SMTP id k62-v6mr11502062qva.88.1538133562704;
        Fri, 28 Sep 2018 04:19:22 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b9-v6sm2416140qtp.79.2018.09.28.04.19.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:21 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 31/42] btrfs: cleanup pending bgs on transaction abort
Date:   Fri, 28 Sep 2018 07:18:10 -0400
Message-Id: <20180928111821.24376-32-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

