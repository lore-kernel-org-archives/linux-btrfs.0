Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AACC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294AC20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="O3e1h9Qe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 294AC20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbeJLDYb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45949 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDYb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id e10-v6so11333437qtq.12
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cKf7nfGjyX5ciBrLw5SDFaPPqW28rfuFK6izaRjmL0w=;
        b=O3e1h9QeEZSMKxzl2IioVQNgr9MDFJXM7VNh7ITcvLQI/gGWHgOjANZox0Tma9xyKs
         ZDtyhC1BWsiDePBIPWnAVkkWQdOv5oG5WoKRjWMSWiQ3tPsvIwbXHJk897IPwTFyv1cQ
         ghxqT5uvs0r2S5zxBK4OrFboijrIu+TSj/9ouUCqsJoaG9oqk0M7p+Dfqp0FLcYnfGkb
         gxAh91XNm+uIMD252XTnZAaGrlfp/cLJj99f3K0bAS+LWEcl838P+hX3izAE8Q4kxV/V
         0UazdBcDk/Y4xIFqxsmRmp02lNV0OQZor9lWyXL77sLxhoZEfJ1ED5Ga/I+KhQKnedY3
         LjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cKf7nfGjyX5ciBrLw5SDFaPPqW28rfuFK6izaRjmL0w=;
        b=R65ReoQilgiQC9Ty8I+mPd+cszKyRoLJxU8pgY6nSS9Fll8YgiVbC0Tby/afC5id85
         y25sgi+9qnTSiez2IL3jeovo9zvuXhZHyK5YfEke+EwN5w6EHMMDFZPR7AXGCU/Bd82A
         dDuKmcOQzkTWbI0/awJgTOx58syR+ve049UU4lF4rRN8gCv2B3yxsdF3XbKwgA52EtlE
         Kh9xj2CZuKl0PGF54d7DX79xZpA+DyGKlE+UZIwl/+gvBf8bUoqrUDmvas6XHZ7dgu6X
         yQ73EXWLr0+4mfKuIGapzrLFKA7CKPobCBA4ZtHToYabvQmL+wSoyJnjMQvgA4GtetW/
         QIOw==
X-Gm-Message-State: ABuFfoibS0CQ49YEGdOQyPXVD5c98t41bX6Acchr2XwD4ckzwRmrQGb7
        40LZEoXJMGDm0vgkiK+tYlgiTw==
X-Google-Smtp-Source: ACcGV633GscVhDMaHVSSgp1X4zd8YHjFiaIkipY/lQuo6a7ddT00olXh6GbiEdQkIRDDHaRG6caGSg==
X-Received: by 2002:ac8:2595:: with SMTP id e21-v6mr3006957qte.233.1539287744917;
        Thu, 11 Oct 2018 12:55:44 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z24-v6sm14286162qtg.42.2018.10.11.12.55.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:43 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 38/42] btrfs: be more explicit about allowed flush states
Date:   Thu, 11 Oct 2018 15:54:27 -0400
Message-Id: <20181011195431.3441-39-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 4b74d8a97f7c..be18b40d2d48 100644
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

