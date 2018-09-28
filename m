Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BE2C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8131215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="gbRchkiR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8131215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbeI1Rmx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38214 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rmx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id z13-v6so6145420qts.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=RHqXkFYQ/isH8yVGHYsgnjCqUZbpOKGf9EwG0OJglnw=;
        b=gbRchkiRnzH5GMzLrpiJ66VziIn1QNi794B6dLadUzsRNQWLQCG8/tRCDYBDz7WbTn
         D2IpEgcZc43TF+DmFmegjsabopl8HW/74CrqiEWUl4hpRG8JCvKLMiQoKmcKuo/SePTX
         iw1+D1PAf81ei39X8lI1qVvUY4IGaT148VizP4oY2QT19qfts8t/S08TLubXJyI/VXUH
         e0Sfyt4Zd6egwqrnup/pYkBBPzoyXh3tOS5//Rm6zNan+clIDc5bVYWV6gsyKJe+wS0i
         P1SG3LrMLtdgTAXA4Mb1eXKpuZ2eReyF8oWo31kd/7k6dz5x858vyzQGtMA6QUQCDcbx
         anBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=RHqXkFYQ/isH8yVGHYsgnjCqUZbpOKGf9EwG0OJglnw=;
        b=GphcrQ8M4eL93jc4GVjhBRiU3Ad9xqNxwPhGQkONGQfsueIoaHanqoeJmgJ79WZKJa
         YBm224xFjfKJFyixz3z85QUlLKh1kqcQUZbFGeGWwW5OG2s/5mFcJvP2Cj4aqdlFyRP8
         y2BvDRsZxM831ZdQgERvy8aEzsNWvr/j802L+qP9FFK9HZ5/7ZTC8paan83wPRPRf+Hx
         jXpHJEp4byUalSoz5Li6yFfSsTb+MbX6qZbm2JEY24ZGZv6HxRLIBu4RUmjG3JdjZXc9
         f1rzN+zTImvJnbiotF+8Kpc+3nFnliOA7mofd6wQi9LiY4+YwvmF+DAeAwDMHC2VV2Q7
         MnDA==
X-Gm-Message-State: ABuFfogiKYK8mxWZ0UFVaSmgQEwun/QSuj5PQnFzWeFlpMbQZnWu/46w
        uzzLyhqmnQU1y1FNDtn9TaqV9lpcbqU=
X-Google-Smtp-Source: ACcGV61nNfesoSZsZWYhlcPxuO3DsmFwWZ7TAg6HaLyZOlE7zYt562b662N9LqJbv+RFHnBh1/iTvA==
X-Received: by 2002:a0c:f40c:: with SMTP id h12-v6mr6274301qvl.78.1538133575303;
        Fri, 28 Sep 2018 04:19:35 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k185-v6sm2551197qkd.27.2018.09.28.04.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:34 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 38/42] btrfs: be more explicit about allowed flush states
Date:   Fri, 28 Sep 2018 07:18:17 -0400
Message-Id: <20180928111821.24376-39-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For FLUSH_LIMIT flushers we really can only allocate chunks and flush
delayed inode items, everything else is problematic.  I added a bunch of
new states and it lead to weirdness in the FLUSH_LIMIT case because I
forgot about how it worked.  So instead explicitly declare the states
that are ok for flushing with FLUSH_LIMIT and use that for our state
machine.  Then as we add new things that are safe we can just add them
to this list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 262e0f7f2ea1..a7ba0d0e8de1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5110,12 +5110,18 @@ void btrfs_init_async_reclaim_work(struct work_struct *work)
 	INIT_WORK(work, btrfs_async_reclaim_metadata_space);
 }
 
+static const enum btrfs_flush_state priority_flush_states[] = {
+	FLUSH_DELAYED_ITEMS_NR,
+	FLUSH_DELAYED_ITEMS,
+	ALLOC_CHUNK,
+};
+
 static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 					    struct btrfs_space_info *space_info,
 					    struct reserve_ticket *ticket)
 {
 	u64 to_reclaim;
-	int flush_state = FLUSH_DELAYED_ITEMS_NR;
+	int flush_state = 0;
 
 	spin_lock(&space_info->lock);
 	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
@@ -5127,7 +5133,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info, space_info, to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim,
+			    priority_flush_states[flush_state]);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
@@ -5135,15 +5142,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 			return;
 		}
 		spin_unlock(&space_info->lock);
-
-		/*
-		 * Priority flushers can't wait on delalloc without
-		 * deadlocking.
-		 */
-		if (flush_state == FLUSH_DELALLOC ||
-		    flush_state == FLUSH_DELALLOC_WAIT)
-			flush_state = ALLOC_CHUNK;
-	} while (flush_state < COMMIT_TRANS);
+	} while (flush_state < ARRAY_SIZE(priority_flush_states));
 }
 
 static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
-- 
2.14.3

