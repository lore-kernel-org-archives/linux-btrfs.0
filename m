Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF7CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F07A6214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="nlUJHKDk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F07A6214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbeKVFi6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:58 -0500
Received: from mail-yw1-f48.google.com ([209.85.161.48]:43291 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFi5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:57 -0500
Received: by mail-yw1-f48.google.com with SMTP id l200so2670232ywe.10
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=590qDmUnB326tQzkd/+1OymhYv+QHhCcRR/OCakP6Ok=;
        b=nlUJHKDkxzQc8oc19Js5/CtTCf2WOqSJp169/0rdFOdmV7PW3oru8CuQnjs4VUR6QV
         vVCZVLavx8PbuRkcFQZseQcXa+wyYGLdBFHldyKVcvDw9fg6xkuMR1Sbnxf6iSHGyd/o
         a5X/1gNq4+BPGcPPuO5JBSZde+AO9XB7w4fgcKF3AxZYY8xDtBSzeniA9YsCaXmZfuxG
         X8j8k6i5m6qJf+wOirM0E3y41qs3DjwVVw1GwKIck1qa8Shbnneh+jz01hLu2wKoaioY
         1oZOLV2SqvRVzm5supSqTr6ezdrqX20VTcJ99RSL4dr/0f3lfcVVAIrLgsSgLmK/MDAD
         m2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=590qDmUnB326tQzkd/+1OymhYv+QHhCcRR/OCakP6Ok=;
        b=iqtl39a+c6b0Es+i1/H6vR9H+3pby1Cytdl8JZpxsad1bYg/qitPKC2Pq1DeInQrsT
         qPwXmu7l1l4warNHxWxePX0ZAtANzOk65dq3mqrZtMf4auBCb8dSvJmHZ0i1neoYp15X
         bcFYV74eR+od29VFaKkOgplpfv63nFoGDLaS2KDsnMPognkCXO481AIatCGkqQP21Qs3
         L2yID4FlYopd3ED+502n1AniVoWGZCfKHRilgq2+Zx4ifQCf9uVmKbx0r3kPbcZD1aHx
         Vwo1iF1F6G9rSdOfZ5mFCbCgvLRavk1+3OHrHskwOXi2F0wqGHHOSA9DZZltzuZN7A/a
         yWmA==
X-Gm-Message-State: AGRZ1gL6WUGIq9J+A2yg+u7yxxrFhKkfRPAqDPkfVAICGAj2rl4/VUT1
        oe9fl6iURWiCs7wPQPOVUe8UMOQsk3s=
X-Google-Smtp-Source: AJdET5et3uGHpryETHJRzi7COTgcmo/haYsoIaybkDlZv9TqXafiaSRWBHVRSO3h+W+sXp84cYIm3Q==
X-Received: by 2002:a81:5683:: with SMTP id k125mr7333556ywb.436.1542827004900;
        Wed, 21 Nov 2018 11:03:24 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d85sm2417327ywd.22.2018.11.21.11.03.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:24 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 5/8] btrfs: don't enospc all tickets on flush failure
Date:   Wed, 21 Nov 2018 14:03:10 -0500
Message-Id: <20181121190313.24575-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With the introduction of the per-inode block_rsv it became possible to
have really really large reservation requests made because of data
fragmentation.  Since the ticket stuff assumed that we'd always have
relatively small reservation requests it just killed all tickets if we
were unable to satisfy the current request.  However this is generally
not the case anymore.  So fix this logic to instead see if we had a
ticket that we were able to give some reservation to, and if we were
continue the flushing loop again.  Likewise we make the tickets use the
space_info_add_old_bytes() method of returning what reservation they did
receive in hopes that it could satisfy reservations down the line.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e6bb6ce23c84..983d086fa768 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4791,6 +4791,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 }
 
 struct reserve_ticket {
+	u64 orig_bytes;
 	u64 bytes;
 	int error;
 	struct list_head list;
@@ -5012,7 +5013,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
-static void wake_all_tickets(struct list_head *head)
+static bool wake_all_tickets(struct list_head *head)
 {
 	struct reserve_ticket *ticket;
 
@@ -5021,7 +5022,10 @@ static void wake_all_tickets(struct list_head *head)
 		list_del_init(&ticket->list);
 		ticket->error = -ENOSPC;
 		wake_up(&ticket->wait);
+		if (ticket->bytes != ticket->orig_bytes)
+			return true;
 	}
+	return false;
 }
 
 /*
@@ -5089,8 +5093,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		if (flush_state > COMMIT_TRANS) {
 			commit_cycles++;
 			if (commit_cycles > 2) {
-				wake_all_tickets(&space_info->tickets);
-				space_info->flush = 0;
+				if (wake_all_tickets(&space_info->tickets)) {
+					flush_state = FLUSH_DELAYED_ITEMS_NR;
+					commit_cycles--;
+				} else {
+					space_info->flush = 0;
+				}
 			} else {
 				flush_state = FLUSH_DELAYED_ITEMS_NR;
 			}
@@ -5142,10 +5150,11 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 
 static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 			       struct btrfs_space_info *space_info,
-			       struct reserve_ticket *ticket, u64 orig_bytes)
+			       struct reserve_ticket *ticket)
 
 {
 	DEFINE_WAIT(wait);
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	spin_lock(&space_info->lock);
@@ -5166,14 +5175,12 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 		ret = ticket->error;
 	if (!list_empty(&ticket->list))
 		list_del_init(&ticket->list);
-	if (ticket->bytes && ticket->bytes < orig_bytes) {
-		u64 num_bytes = orig_bytes - ticket->bytes;
-		update_bytes_may_use(space_info, -num_bytes);
-		trace_btrfs_space_reservation(fs_info, "space_info",
-					      space_info->flags, num_bytes, 0);
-	}
+	if (ticket->bytes && ticket->bytes < ticket->orig_bytes)
+		reclaim_bytes = ticket->orig_bytes - ticket->bytes;
 	spin_unlock(&space_info->lock);
 
+	if (reclaim_bytes)
+		space_info_add_old_bytes(fs_info, space_info, reclaim_bytes);
 	return ret;
 }
 
@@ -5199,6 +5206,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket ticket;
 	u64 used;
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	ASSERT(orig_bytes);
@@ -5234,6 +5242,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * the list and we will do our own flushing further down.
 	 */
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
+		ticket.orig_bytes = orig_bytes;
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		init_waitqueue_head(&ticket.wait);
@@ -5274,25 +5283,21 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 		return ret;
 
 	if (flush == BTRFS_RESERVE_FLUSH_ALL)
-		return wait_reserve_ticket(fs_info, space_info, &ticket,
-					   orig_bytes);
+		return wait_reserve_ticket(fs_info, space_info, &ticket);
 
 	ret = 0;
 	priority_reclaim_metadata_space(fs_info, space_info, &ticket);
 	spin_lock(&space_info->lock);
 	if (ticket.bytes) {
-		if (ticket.bytes < orig_bytes) {
-			u64 num_bytes = orig_bytes - ticket.bytes;
-			update_bytes_may_use(space_info, -num_bytes);
-			trace_btrfs_space_reservation(fs_info, "space_info",
-						      space_info->flags,
-						      num_bytes, 0);
-
-		}
+		if (ticket.bytes < orig_bytes)
+			reclaim_bytes = orig_bytes - ticket.bytes;
 		list_del_init(&ticket.list);
 		ret = -ENOSPC;
 	}
 	spin_unlock(&space_info->lock);
+
+	if (reclaim_bytes)
+		space_info_add_old_bytes(fs_info, space_info, reclaim_bytes);
 	ASSERT(list_empty(&ticket.list));
 	return ret;
 }
-- 
2.14.3

