Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB3DC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6493A20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="a85Tl588"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6493A20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbeLCPZG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:06 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42959 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:06 -0500
Received: by mail-yb1-f194.google.com with SMTP id s8so3257300ybe.9
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Dk7Yvr9EVggjdM9t/BJP8axY+xIS+ZF2B97rLLoiB4U=;
        b=a85Tl588eVrs/7przLhnQqwuoh5zb0GAqePTvDvIKfIRNhSe5spN0M8Fmx7oWG+tML
         mxj1ObTyRefAUUnS955wp+LLakWh8bF4dmHSD/oBWG1d48QjNEY9gLB44KNQPcYMYcNR
         DcvudLyarcZh4TxqGwQEjMdQqEOlbwakJ18d37WRN5OMbFR2kjNS4XYsyOMeGITXxRV7
         30RSpNFHpmVGcq7lh7eIScE7xw8lwsWSHtDZU5PmGZs4uqnXdveOHCdSTpw72RvguZ68
         kiYAGG0gIPhGMUyaljCGWhPl6RvN3oNPW482P1v/6hrgDWSP/kMkwLVhAbkDeDd24ZXI
         EaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Dk7Yvr9EVggjdM9t/BJP8axY+xIS+ZF2B97rLLoiB4U=;
        b=qjjqk5vkOjWc5j5y6FoxugZQOjT1R2O+AiR+ygGejEDhI4TXL97QXTQdzKbdVaSN4I
         1D03Svt4VmgFowAc8Tm5JQY3jtAq9qNj3gl7ZCDFqNnSS4p5qLBGm/1szT6d8r7LqRCK
         y8y8GeHIQ4oSMJCRV9750lT028WdQC8AIJ+HFVhXjSs+UpNb3cT8cs24UvAWcufkLYt+
         3BfJXAVZmcywF4ohzf1pPn9tBuW7PUJ6MpKsUEJR6rAGmGJCCyHuRb46+rjqqHMfHmWS
         MbhuEPEC9nSya01fTJXG6u6cM+3V/e0CizDyXLNXpFdNvSh1YUD/81rdrRCS7Tw8yIVa
         KBhw==
X-Gm-Message-State: AA+aEWZQJ5+bAN/llzW58iJnH6oGVaNHKjOXMU4Ed5X7H/GuFs0+KTbt
        IrstHyhNtddTdTdZs4cUohIXcc1932s=
X-Google-Smtp-Source: AFSGD/XDYNuBWw1cKWQr48SOkpwlEbMw0QRQcd/H7Pgu5Xyw3vKWKKPZ8KiP89N5Kht/Ml0KR3s26w==
X-Received: by 2002:a25:b315:: with SMTP id l21mr4581423ybj.191.1543850703709;
        Mon, 03 Dec 2018 07:25:03 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x132sm5793119ywx.27.2018.12.03.07.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:03 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/8] btrfs: check if free bgs for commit
Date:   Mon,  3 Dec 2018 10:24:52 -0500
Message-Id: <20181203152459.21630-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07ef1b8087f7..755eb226d32d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4853,10 +4853,19 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes_needed)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes_needed,
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
+	    __percpu_counter_compare(&space_info->total_bytes_pinned,
+				     bytes_needed,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
 	/*
@@ -4864,7 +4873,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4878,17 +4887,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes_needed -= reclaim_bytes;
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes_needed,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				     bytes_needed,
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

