Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A23C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE4D2214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="G/hpkHxm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE4D2214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732044AbeKVFjB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:39:01 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:41571 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFjB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:39:01 -0500
Received: by mail-yb1-f193.google.com with SMTP id t13-v6so2632966ybb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=lp7bdEvyjbTUp1Lft+VnpzABBc7yoSsXgQSZHmgtFxc=;
        b=G/hpkHxmwFwUBya/CW8EQrpDsuXAWJZnYbsvMlKbBht/qaaQYc0G7YQyUlrAZ2xyxg
         VlZjsXCvB9ew/Ux1j5ngUet1w2OyBFvaKFDYS8CYTOhXFG4gOpcZNgyMMe+jino0KQEH
         het0vSVXBYYrrgvfZOE+k03yMXFRl2shGuj1PKYoUjIpTp1b9KzWw8RWchs3KJszlEb4
         gF13+Ww8mgAbn0z5wK19SEPIIBmywxxgcciP577XDQn3PTtcm9UMztJC97sxLOWfPsKY
         ctKo/qWbInM7R+Zm8mFOrk7C/jTYUONEdxs7BnxWdW7sDTX79W+2H0L6y+D/BNrUXnF4
         1IqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=lp7bdEvyjbTUp1Lft+VnpzABBc7yoSsXgQSZHmgtFxc=;
        b=RTdn4PW7GObVlZ5qc2T+kkM4+iJ6mdRlE5oOPbnWAKdk24MnSY4+BWBFOizVpf5fKz
         umUPMcakLNw/0dZk38q0clIuaXbDULXwAUSh8pn/SIA447+FyEErGwa8TjHXJViwUr4e
         LoiPtxB+NCngN39xGl7iQZawOhFxxZAo90FH3/vOPIRp44Uq2hWsxuFIeeTTofO1flI1
         wLJYvhYkTNeeut9V43jgwxM/Mg/BySTD3xxblk0UG3q2nOmWUBtDRPNPjZLMplPVwhhb
         IPi+QyvnTnRsi0IJ86vK/USDDgV6g5Vf00AKdBFLtctKSZRcuIwSp/5v4dTpK8cIUQgX
         oZQA==
X-Gm-Message-State: AA+aEWbam/7ZMH7zY1kUYewyXZlIw4iMHK2OcHqjIeYKx5MosIPWK0y0
        4bYS2K2rOnjAWHwiJ6TrhFgHRKWGv2U=
X-Google-Smtp-Source: AJdET5ep0tsJYgOJ8Un/zcuUsUA6aXJeiPt7paTd6w1pOCdI6rtod+YMiF18l40N+7K1ulOHMbp5SQ==
X-Received: by 2002:a25:1585:: with SMTP id 127-v6mr7680558ybv.208.1542827008239;
        Wed, 21 Nov 2018 11:03:28 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z74sm10851178ywz.51.2018.11.21.11.03.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:27 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 7/8] btrfs: be more explicit about allowed flush states
Date:   Wed, 21 Nov 2018 14:03:12 -0500
Message-Id: <20181121190313.24575-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
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
index 0e9ba77e5316..e31980d451c2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5112,12 +5112,18 @@ void btrfs_init_async_reclaim_work(struct work_struct *work)
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
@@ -5129,7 +5135,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info, space_info, to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim,
+			    priority_flush_states[flush_state]);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
@@ -5137,15 +5144,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
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

