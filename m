Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842C8C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CC22173D
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="F6Xi0Z4G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44CC22173D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbeI1RmM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:12 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35851 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:11 -0400
Received: by mail-qk1-f194.google.com with SMTP id a85-v6so3577780qkg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=SV6VzMZmuQU6kRBrptnXRYkuIetlbfVghoSBpsgva9M=;
        b=F6Xi0Z4GI/Scnb46KjxSZzGz7LC20OMYxyOXJ/idyIpV2nscaMRiCJYKcAkA3pTZA2
         aPQMMDxW8lZo09PaBFcwwnGK+RIzmRKTLP6BErtlL3oqNpz+2KY0iJpwL2ex1fTRKndm
         6adRZxderLNOLWbgNCoORJ8IyMYtUv6L98gEBBaBrvBVi20ckZcThxils0YS8k1FcMOb
         c1rw3QuJbNIJQMU7R3zj1ApZhTmfOvm48SCFusYVRWQ5congmMIknCXUofLA90CeooFr
         SkHQGTY4xJXWshedqJxDXXhkwg6Sz2xiNVIVoxxBJmD/qdTEGPE31dQcts9FP0icTGnc
         Z/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=SV6VzMZmuQU6kRBrptnXRYkuIetlbfVghoSBpsgva9M=;
        b=SC8Y/b1pXIzMM8qbJOgQ3BXggNSuVSfwk44U1wDEP856TT8JZiQfjyFxjjnmPKUqh+
         bn5Cy96DY+5Mnohc4LOH4RPnAxJ30Q2xJDu+WRhjpeC8Nl70JFq5xbLgLtagXjKvyMkv
         BP+U/Ps9kPKVMcpX2qfgAJA3fF0WsIuZ9q4ULGFJnkR0/FPQr2FHSuzP63NGHyW7zsKk
         iHiqf/LZ5eZFgcw9BBUz5CGHptvQRsVHFgZgrMrU6rrdE0zf/AIqSCsxmDp0i2/OBoDg
         UQJIsbpmlwk1pbxL3fveTvUZ4Yivd7tpSr/Iw4PFTN5y4sNmoVdjdNJZe9oBHxBwrnGs
         tYjQ==
X-Gm-Message-State: ABuFfog2HYudH3BnRUZ0Nr9yBjmw1mjcEnEFsOE1VLviHNna7NXee1NK
        zSk6LKyPk/iGqumrBxdBtmwSCoOB/2A=
X-Google-Smtp-Source: ACcGV613RtOAzqvKRYNFH7H0Q2Z8EdpRwrXn/eLWv92RPUoFCeZ949/zbzLT/7QsFEfdQ+f5JzfkEQ==
X-Received: by 2002:a37:a48d:: with SMTP id n135-v6mr4707404qke.160.1538133533373;
        Fri, 28 Sep 2018 04:18:53 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 23-v6sm2711992qkn.11.2018.09.28.04.18.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:52 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 15/42] btrfs: don't enospc all tickets on flush failure
Date:   Fri, 28 Sep 2018 07:17:54 -0400
Message-Id: <20180928111821.24376-16-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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
index f84537a1d7eb..7a53f6a29ebc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4779,6 +4779,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 }
 
 struct reserve_ticket {
+	u64 orig_bytes;
 	u64 bytes;
 	int error;
 	struct list_head list;
@@ -5000,7 +5001,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
-static void wake_all_tickets(struct list_head *head)
+static bool wake_all_tickets(struct list_head *head)
 {
 	struct reserve_ticket *ticket;
 
@@ -5009,7 +5010,10 @@ static void wake_all_tickets(struct list_head *head)
 		list_del_init(&ticket->list);
 		ticket->error = -ENOSPC;
 		wake_up(&ticket->wait);
+		if (ticket->bytes != ticket->orig_bytes)
+			return true;
 	}
+	return false;
 }
 
 /*
@@ -5077,8 +5081,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
@@ -5130,10 +5138,11 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 
 static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 			       struct btrfs_space_info *space_info,
-			       struct reserve_ticket *ticket, u64 orig_bytes)
+			       struct reserve_ticket *ticket)
 
 {
 	DEFINE_WAIT(wait);
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	spin_lock(&space_info->lock);
@@ -5154,14 +5163,12 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 		ret = ticket->error;
 	if (!list_empty(&ticket->list))
 		list_del_init(&ticket->list);
-	if (ticket->bytes && ticket->bytes < orig_bytes) {
-		u64 num_bytes = orig_bytes - ticket->bytes;
-		space_info->bytes_may_use -= num_bytes;
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
 
@@ -5187,6 +5194,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket ticket;
 	u64 used;
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	ASSERT(orig_bytes);
@@ -5222,6 +5230,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * the list and we will do our own flushing further down.
 	 */
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
+		ticket.orig_bytes = orig_bytes;
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		init_waitqueue_head(&ticket.wait);
@@ -5262,25 +5271,21 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
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
-			space_info->bytes_may_use -= num_bytes;
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

