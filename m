Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F94EC04E87
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2686215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sH5tldjs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2686215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbeI1Rlz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41434 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729359AbeI1Rlz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15-v6so6125384qtp.8
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Ayf4FJ5WuWBTP9J+ecILAGKV0NvK3Tj5jK4kHqTh68A=;
        b=sH5tldjsYgRDJQhZKcyM5klkN5PxKDtIOEA8AVPa8xwbT5/D3kr8/tnScj8mgtZ0qw
         gOvQPEx2tUdSp4H6GnINE4cnAVGJPJ5O2GeU3lJeZ5At14ius4Da16N07MvO+MgX5B7V
         edBFLpOqzGz6dJu9N5LxQ6OoswkqQzv2A4IiOLjGW3c/reMbc3lwEdRKmSspgeFfnJDw
         vw0l19wOyR27RYMrQ7fiIX7N0FvhPEWbWTUfghyPJlrCAlQQtc/FBPWDEnkZeE35b7MS
         qsu2ZJ6NuZo5r9ujDPfiiaGsrzPtxx69O3bNx5bmLqAh7bYgDgG9Djy2NQCAFZ0B8d3w
         +KIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Ayf4FJ5WuWBTP9J+ecILAGKV0NvK3Tj5jK4kHqTh68A=;
        b=PbGvgPSUSLI2A6zfHZY4iDNVBLVWJuhLSlwOE7o19KQYfJD3gdvfveHgKU6hOd+N6k
         edX77M0g2Or+eC8fKg2JIPNRrdKQpix+zSRz5vXYqFicJnKd7yvUvwcU6s7LQvtqkLDT
         +dJXMx7J395sB4UAievGfIrakicMkEOiRf6tG0AyjOWHKY2eROTFkyE/mK3lZnLugCcp
         ZYIwPT8P8iiB+f7q80U7/iTO07DQpUmTyVoeqoM5s7iEt8Azvxh3CTCSOnRP73XqqLaj
         Z7ZGokCbMLsORJW9L5rqZnqEYwN1Y/jch9vy8CD4DdLtomLmfcr9J35prCLwDUuQqUn/
         MGMQ==
X-Gm-Message-State: ABuFfoiUZwYpBumxSzqm5oxxBkq8PMK6dSk7GiQbzi38GKdnZlo8vLf2
        UZFoVF5UWuTV3DkLkmvf112v0g==
X-Google-Smtp-Source: ACcGV60wSmwj2Dve0nAhGYuza+mjs6ePYMg8Ti5WMqzXTOKh+MvwcKnhArQDj/z+3wqznx6b10nmXA==
X-Received: by 2002:a0c:962e:: with SMTP id 43-v6mr11784158qvx.129.1538133518160;
        Fri, 28 Sep 2018 04:18:38 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c2-v6sm3216185qkj.79.2018.09.28.04.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:37 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 07/42] btrfs: check if free bgs for commit
Date:   Fri, 28 Sep 2018 07:17:46 -0400
Message-Id: <20180928111821.24376-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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
index 1213f573eea2..da73b3e5bc39 100644
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
+		return -ENOSPC;
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

