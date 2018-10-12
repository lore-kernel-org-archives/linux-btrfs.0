Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE29C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06D692087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="pYbfImKs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06D692087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbeJMDHO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43414 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id 12-v6so8329507qkj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Q7Ot7S7niLzFArpknfZ6fBkmt7T9NBBADarihIFw9qo=;
        b=pYbfImKs0nrP2vdJMti+2NI1xWgIksINAgmFQcFaKhUSRvZe0nmkRlC4bWGOb1luu2
         wdR50fhQ9RBZg7RJUf1VUrYES8mJ7AYclq7EUE/fesAoLAe+oTU8vPKzeS94e9MlaIxK
         FqaY6b0n1QDcw1pJQJwC76gr/6wCJp0RPm2cNke9sNnCUn3fys3uRbBSidePXAQlii2C
         vKglbi7FZ6o91COZI4i5CFIWhe8FjnEdC0B/PVb1k3S67cyqBLRHzw0i+3SQD2lPUs+d
         T9KisnxwuXbOmp+RduuT0hXUVqapWH8VOX/2pj9TaYEZkrSTeyIDNQUsVSqX7dWovcPG
         K2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Q7Ot7S7niLzFArpknfZ6fBkmt7T9NBBADarihIFw9qo=;
        b=kyzNrGKa9NeuVkftgwQsybVW7fWEVNlZhYw/LEceUcvfpjdO5BHR9aOv9MM2drMz2g
         G0YcSTqtesPJBJUwmqwlEETU5A+BqqCFOz7FbW8WvQxdzRcGtJUX4B+W7l5DfGkKOU4a
         DH8S7ZKvVVJI5hu3HtcfTs0e+QT1ZrQDS+cJr06p6LrLvjnEo7Ap5pSpH9zT1/AFUOK5
         bJyyNeO3dHzp9KZQMGgYzkspRi6PCzhwVlkXt1xVBuL9l9I26zUA3WRshtceaFjG70P0
         GR5QMgOyo4VFTmVuBRYRroAI14pLvrJzaB902yeDsq2rLP/zICZl95yCwtkxkaFFxyoO
         jpiA==
X-Gm-Message-State: ABuFfogg5BaTqR3fxbuA/IMEs5cNIg8gmpqXLj6IYs4Br8z/WAPDF3XH
        VZgTOJuNGgiJ8aurjFYY2P7ng+/49QQ=
X-Google-Smtp-Source: ACcGV61EBaa6geU/jmH/zVicwere7gx0iGPzs8NiAO4a8ijPU8orPFTUoILCMAMuEEuw0gymZnIoLg==
X-Received: by 2002:a37:7006:: with SMTP id l6-v6mr6643785qkc.243.1539372792888;
        Fri, 12 Oct 2018 12:33:12 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g34-v6sm1700735qta.79.2018.10.12.12.33.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:11 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 07/42] btrfs: check if free bgs for commit
Date:   Fri, 12 Oct 2018 15:32:21 -0400
Message-Id: <20181012193256.13735-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

may_commit_transaction will skip committing the transaction if we don't
have enough pinned space or if we're trying to find space for a SYSTEM
chunk.  However if we have pending free block groups in this transaction
we still want to commit as we may be able to allocate a chunk to make
our reservation.  So instead of just returning ENOSPC, check if we have
free block groups pending, and if so commit the transaction to allow us
to use that free space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1213f573eea2..4aab49debfc3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	/*
+	 * See if there is enough pinned space to make this reservation, or if
+	 * we have bg's that are going to be freed, allowing us to possibly do a
+	 * chunk allocation the next loop through.
+	 */
+	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags) ||
+	    __percpu_counter_compare(&space_info->total_bytes_pinned, bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
 	/*
@@ -4841,7 +4849,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4855,17 +4863,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes -= reclaim_bytes;
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				     bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
+		goto enospc;
 commit:
-	trans = btrfs_join_transaction(fs_info->extent_root);
-	if (IS_ERR(trans))
-		return -ENOSPC;
-
 	return btrfs_commit_transaction(trans);
+enospc:
+	btrfs_end_transaction(trans);
+	return -ENOSPC;
 }
 
 /*
-- 
2.14.3

