Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DB3C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C79920834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="o3sYFDYu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C79920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeLCPZN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:13 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:39894 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:13 -0500
Received: by mail-yb1-f171.google.com with SMTP id w17-v6so5419359ybl.6
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=tQ2XEVCtD9xTcjbtKeQrluLUcHv+AIzTWiQLZooJnfw=;
        b=o3sYFDYuOuE4TpctyjpJgin2I5AZLn+x04YARa+aLW3Pev3MqNAopHkcPSWpqvrVhm
         GGte5KcRp0M9l7JOIoNzgWf8L8QtaUqUnY3IJxtdZgCmaNFM7egFkPcdH4s9EJXWjHIT
         vULtKXUjeWjFnOA36vDYoQgcwkPi4x6yphPx6DGLmvIJ+9lvRpcajaJGiq+Elr2YduNI
         1273oo6p4Lq7ItGPtDEKEa5OLSr1+RxlhJtEdihS7nWevEQkCIfMQT3CLTauge4jLF26
         gNzgjgLmFlnrXhqs2qB/cWW7ewwUQFwVWsQrigHTcrWlHJJ3bdstKHXspNCreEr4Xx/p
         Wafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=tQ2XEVCtD9xTcjbtKeQrluLUcHv+AIzTWiQLZooJnfw=;
        b=V5NpPby1Ys9a5w+tNaIU6dXsRXvYJONaWS1MiMaDScTgqWNdoOOW0p5//DjTq99sTX
         BhPYHa/wnBa+WgFXyfxtO1v3gFN0LiRxFbzg5vacugJE9A9HqPYd+GdHuiJhypl9xnNd
         hNEyDef+nCcf5IGjVY6fe9vykcX8kU0BUljCxnRyOZOvBu9w/88rkjOVA/Ssitmcqhi/
         KDiF2w0fVkROPuvbfKrVJYjNafOAuavDf5lJkmaLt3rwD9nW0RNzrde++Q21nJ3lgGaw
         oTzzzqqUiilGpNXbOFznbuSSe1Rg6RdefGPyaPwgTCUG/JovoXq+p+0h4itC8lCgjxX2
         CPfw==
X-Gm-Message-State: AA+aEWbUltZYw1lpJFNVkpXa1WpqFiHRxrn1A9IXsKdc8Z8KCFBWNuyl
        1G4VenQQIlzLKKoDbGnHuZhYp6v736w=
X-Google-Smtp-Source: AFSGD/WR6nvZxDtFO0od5eTCyG8oQTw56MXjTjFpAG1TSjcP8bMxqNrFNLARx8CLYssLW71/srDvwg==
X-Received: by 2002:a25:1b42:: with SMTP id b63-v6mr15299597ybb.98.1543850709993;
        Mon, 03 Dec 2018 07:25:09 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x135-v6sm5108934ywg.68.2018.12.03.07.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:09 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 5/8] btrfs: don't enospc all tickets on flush failure
Date:   Mon,  3 Dec 2018 10:24:56 -0500
Message-Id: <20181203152459.21630-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
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
index 2d0dd70570ca..0ee77a98f867 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4801,6 +4801,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 }
 
 struct reserve_ticket {
+	u64 orig_bytes;
 	u64 bytes;
 	int error;
 	struct list_head list;
@@ -5023,7 +5024,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
-static void wake_all_tickets(struct list_head *head)
+static bool wake_all_tickets(struct list_head *head)
 {
 	struct reserve_ticket *ticket;
 
@@ -5032,7 +5033,10 @@ static void wake_all_tickets(struct list_head *head)
 		list_del_init(&ticket->list);
 		ticket->error = -ENOSPC;
 		wake_up(&ticket->wait);
+		if (ticket->bytes != ticket->orig_bytes)
+			return true;
 	}
+	return false;
 }
 
 /*
@@ -5100,8 +5104,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
@@ -5153,10 +5161,11 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 
 static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 			       struct btrfs_space_info *space_info,
-			       struct reserve_ticket *ticket, u64 orig_bytes)
+			       struct reserve_ticket *ticket)
 
 {
 	DEFINE_WAIT(wait);
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	spin_lock(&space_info->lock);
@@ -5177,14 +5186,12 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
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
 
@@ -5210,6 +5217,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket ticket;
 	u64 used;
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	ASSERT(orig_bytes);
@@ -5245,6 +5253,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * the list and we will do our own flushing further down.
 	 */
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
+		ticket.orig_bytes = orig_bytes;
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		init_waitqueue_head(&ticket.wait);
@@ -5285,25 +5294,21 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
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

