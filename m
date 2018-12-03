Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1560C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8C3920834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="AyGkikfr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8C3920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbeLCPZP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:15 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:38208 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:15 -0500
Received: by mail-yb1-f194.google.com with SMTP id u103-v6so5421209ybi.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=A48AQMFr5DBnXE/nGsp2LMt27dgid9EJUFgSDarR5cE=;
        b=AyGkikfrJRxmCRifR8TGbCrYj3Y3lER7s0LjLboUWMUaD1YmDMS91bK38A386sov6v
         rmdaKNi9KapyIebtwqdN8lt2B8jKMZlxnFZMBa+dXNiwvXq65vRzCUuuLwbr+1bdSXHI
         ebkjFDGABaDJRfD3jIkgE+jUE5VhDEO9X18Kc3mhRAPhJUbrz+Cm/Y+4oRCmhmcjZG8u
         ga9JvRy5ZDavIARDt6HbcdthJkpsjTXLuzgdYP07ZdLfbVKyQNb9SuDlvk0OhNnjclnq
         3cZ8rU655s0WivG9ccunGrl3hq1fz2g7sGedmhrLp9/0SMhpwfHH1tIFTf7lPHzKsceh
         uO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=A48AQMFr5DBnXE/nGsp2LMt27dgid9EJUFgSDarR5cE=;
        b=Y51/4iT8Fhg+eMPF0FWZMI3C6J/qZa+vNMjNfs1n549V7dPkSyjPbQ9x7BrHnOCVIV
         jqETVxUa0YEyqSDYXk0z0yV461GjCTEvji5S6mnG2mFR7eC0toC+qDd9h/7IPaTcYnC3
         6lHS7SRVR8utNPDeUUYx5DcLfCUGa0CVd0PIsn0JYh0qRs3PXuYO5q3U+0Oh9W8tEMAt
         4s9sjx9OLSL5o/5VyYCNSe0smvGj8Zb0z8RRr/nqQDMq/MIRz0Mq/byIPNhNtVBlo7J0
         yASCqgR3A0h9XyJ/ZiEiNMvEns+xmFk1ja497YNBgsBG6Cl5XybOAOJBNDFArmcL/UTT
         ZA4g==
X-Gm-Message-State: AA+aEWYrkshIcodCkycx8JvL9Pzey2sXfrrPi9bg4UuVb86iHA8zY5sS
        bDDp9AtyXoY/fJbHsTyVU57m+8QGs5I=
X-Google-Smtp-Source: AFSGD/WQayFKIX3fdaN1HuPhBUQaoATHqBwmhds9mlX8fbm44Iq1VmG7FiCGKrR3a4kpmHsIrOUElQ==
X-Received: by 2002:a25:be85:: with SMTP id i5-v6mr16000530ybk.463.1543850713223;
        Mon, 03 Dec 2018 07:25:13 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i21sm11394940ywg.5.2018.12.03.07.25.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:12 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 7/8] btrfs: be more explicit about allowed flush states
Date:   Mon,  3 Dec 2018 10:24:58 -0500
Message-Id: <20181203152459.21630-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For FLUSH_LIMIT flushers (think evict, truncate) we can deadlock when
running delalloc because we may be holding a tree lock.  We can also
deadlock with delayed refs rsv's that are running via the committing
mechanism.  The only safe operations for FLUSH_LIMIT is to run the
delayed operations and to allocate chunks, everything else has the
potential to deadlock.  Future proof this by explicitly specifying the
states that FLUSH_LIMIT is allowed to use.  This will keep us from
introducing bugs later on when adding new flush states.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0e1a499035ac..ab9d915d9289 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5123,12 +5123,18 @@ void btrfs_init_async_reclaim_work(struct work_struct *work)
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
@@ -5140,7 +5146,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info, space_info, to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim,
+			    priority_flush_states[flush_state]);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
@@ -5148,15 +5155,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
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

