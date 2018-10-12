Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A1C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E132087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wujtVS+U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36E132087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbeJMDI3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36878 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDI3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:29 -0400
Received: by mail-qk1-f193.google.com with SMTP id x8-v6so8356848qka.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=DGKAE6OrSG2VtkUO5QHGUrYV9YOGfUXps164Bg2g4BM=;
        b=wujtVS+Uwn4ajp7Jr5YHSOhIlNDmw9g3cUmzLaIdNI3wSRo0mEWf6a9xwf13/Ar+/v
         ehHW/jTzUk3EivGPoXGlAiS8G2u95z5FdVaTAt20hTQQbrulBJNVTJxIJxkkArkQmb0J
         jz65UL/KlTAONjDa5YjrUPFEzcYbX+zivaekAmqS0JF2juobyadW1rjZ1Wz4Df1Qsz5D
         lwBC5jqDZHTJ3Xarv5T+9Pk+5yp4wzM90nVl4KFM8Wmu0fN/xwx/WxNBM4S7DDgii/qp
         S44MWrii52PV3o0WV//70XBNcvr+Y8kp5cbK8MiaL4A45/pRjtFCalQ0Mf3iN/0c4R+w
         WZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=DGKAE6OrSG2VtkUO5QHGUrYV9YOGfUXps164Bg2g4BM=;
        b=PFi67itHg0DIMzVnrfMbFDzVCjzeVzTpoVrUBdqYPAGtXrloMbU+pGAOMxfnoNKfuN
         ogDRz/PvEiWbB50vMmHNSlDHoA0D3ByyFcWcECFraBYQAjD+rhS+lDtFMrD571y1eafN
         Odx3VLhpMWzBhVimkmh66MzfLDClmOqMhwiRAxYf86teg5ErqYAFCPE/4bJa+VsRl/Pq
         LshFrY+octG/kmlzuUTXUMtqbj0M3URtEz99wxYKrNNKJg5FiJRUFi+fvCr47+Xa78li
         O9LzSSwMRf7l6ockRG60w3Y8Fr7EVH1ofzcNaWqB1Ui18cOju6czIN3MpI1K/Q3rcE53
         RieA==
X-Gm-Message-State: ABuFfohILjT1KadBF1tE/uDPIV/xIQlU8gDaRiWdrZ22d+HJDtluRW+2
        CmDGxcG5iUe21Sk1au8D9VLRcQddfFE=
X-Google-Smtp-Source: ACcGV62lbdepFizHwVOYuqF2NK0zwNeHCkR/B1+iz1Ktg/481viUmsyoXtHLeCp073F6x54IsAowAw==
X-Received: by 2002:a37:d413:: with SMTP id l19-v6mr6797439qki.21.1539372867467;
        Fri, 12 Oct 2018 12:34:27 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i27-v6sm1805191qti.57.2018.10.12.12.34.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:26 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 38/42] btrfs: be more explicit about allowed flush states
Date:   Fri, 12 Oct 2018 15:32:52 -0400
Message-Id: <20181012193256.13735-39-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 4bacb5042d08..2056d5d37dfe 100644
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

