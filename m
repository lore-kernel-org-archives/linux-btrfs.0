Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E59EC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366C42087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Z2l6+vhh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 366C42087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbeJMDHF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34223 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeJMDHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id p6-v6so8369083qkg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=Z2l6+vhhczKihir2zLc0QNqK70PDGxPRriU4KhAWIdz2Ya6oHSY4KRWveoQwVB4+lY
         ++yip40rdI8jNunMS7S9purUs+KIu8HbNdwu37YToap+O77elMDS4i3K2crx/fYLpSri
         QWo0sDKT5JL7CDcO8B48fBGuKfV/npW0LUGRu0duyFMWqaAnWB6u1NnUJUBomWIOwKkH
         vRZN0RyKQSBUOj9VHX2+/4OjRkxDY9/qSXcAJ2ancnwuRpszCRaQclv62wzu+D/5pDAZ
         yQBQfhhHO+B0fj2eBYfyU/PMadOawgVsCiKEzdeHTWtUhfZFYv48W1E7CA47ny7oXnLG
         JtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=tfFE9C7k7gh1kWLEkc4ENKGC2+Xo7BkAHyhw19c/1GykzMhB+Fxbq6HIlRqRCZvqLC
         0vUzEY6Li3fcdGLItZEXsT/2pUPxesswydBSQImPXOImlGL0nX67PcG3c0Eq2aisF2Q0
         GakoHfqq9rWQSlpeuDOURdTxfT5A/k27ZUdwAZfDxRnKs29dzPb++gOW7R2VNnDRyB1N
         xEP+Te/9d4OhbfoUzUeTBC4K3xWHmnoKaRqRWf9UFSA7hlpqOdIoEiwp9qKLadWMJcBk
         k908ONYr2n8mBQVFpBpV+v5t8BAwbsCq1TEvlk7Kb4yiffZ1gCsfluh7JtSvBRx2dHh/
         jfFA==
X-Gm-Message-State: ABuFfogpUuz1OwLFEqAYfZrd4mwiGRnYgXj82uhovobC/AyG4RyG/rns
        lN2FveP2pGHEKPq0x/w/KGJYTgDSrD0=
X-Google-Smtp-Source: ACcGV60WHY5G5NsYES0gRKhfpFeyMjo3YpJKsYdP9ycNmASP31Q8JanCoMG51cvzmE9HDB38j5TFyA==
X-Received: by 2002:ae9:ef11:: with SMTP id d17-v6mr7186828qkg.80.1539372783484;
        Fri, 12 Oct 2018 12:33:03 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y26-v6sm1253675qty.52.2018.10.12.12.33.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:02 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 02/42] btrfs: add cleanup_ref_head_accounting helper
Date:   Fri, 12 Oct 2018 15:32:16 -0400
Message-Id: <20181012193256.13735-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We were missing some quota cleanups in check_ref_cleanup, so break the
ref head accounting cleanup into a helper and call that from both
check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
we don't screw up accounting in the future for other things that we add.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d24a0de4a2e7..a44d55e36e11 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2461,6 +2461,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 	return ret ? ret : 1;
 }
 
+static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
+					struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_delayed_ref_root *delayed_refs =
+		&trans->transaction->delayed_refs;
+
+	if (head->total_ref_mod < 0) {
+		struct btrfs_space_info *space_info;
+		u64 flags;
+
+		if (head->is_data)
+			flags = BTRFS_BLOCK_GROUP_DATA;
+		else if (head->is_system)
+			flags = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			flags = BTRFS_BLOCK_GROUP_METADATA;
+		space_info = __find_space_info(fs_info, flags);
+		ASSERT(space_info);
+		percpu_counter_add_batch(&space_info->total_bytes_pinned,
+				   -head->num_bytes,
+				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
+
+		if (head->is_data) {
+			spin_lock(&delayed_refs->lock);
+			delayed_refs->pending_csums -= head->num_bytes;
+			spin_unlock(&delayed_refs->lock);
+		}
+	}
+
+	/* Also free its reserved qgroup space */
+	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
+				      head->qgroup_reserved);
+}
+
 static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 			    struct btrfs_delayed_ref_head *head)
 {
@@ -2496,31 +2531,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	spin_unlock(&head->lock);
 	spin_unlock(&delayed_refs->lock);
 
-	trace_run_delayed_ref_head(fs_info, head, 0);
-
-	if (head->total_ref_mod < 0) {
-		struct btrfs_space_info *space_info;
-		u64 flags;
-
-		if (head->is_data)
-			flags = BTRFS_BLOCK_GROUP_DATA;
-		else if (head->is_system)
-			flags = BTRFS_BLOCK_GROUP_SYSTEM;
-		else
-			flags = BTRFS_BLOCK_GROUP_METADATA;
-		space_info = __find_space_info(fs_info, flags);
-		ASSERT(space_info);
-		percpu_counter_add_batch(&space_info->total_bytes_pinned,
-				   -head->num_bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
-
-		if (head->is_data) {
-			spin_lock(&delayed_refs->lock);
-			delayed_refs->pending_csums -= head->num_bytes;
-			spin_unlock(&delayed_refs->lock);
-		}
-	}
-
 	if (head->must_insert_reserved) {
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
@@ -2530,9 +2540,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* Also free its reserved qgroup space */
-	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
-				      head->qgroup_reserved);
+	cleanup_ref_head_accounting(trans, head);
+
+	trace_run_delayed_ref_head(fs_info, head, 0);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
 	return 0;
@@ -6991,6 +7001,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (head->must_insert_reserved)
 		ret = 1;
 
+	cleanup_ref_head_accounting(trans, head);
 	mutex_unlock(&head->mutex);
 	btrfs_put_delayed_ref_head(head);
 	return ret;
-- 
2.14.3

