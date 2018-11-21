Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC0CC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923AE214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MwUeNlKu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 923AE214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbeKVFev (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:51 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35217 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFev (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:51 -0500
Received: by mail-yb1-f195.google.com with SMTP id z2-v6so2638115ybj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GhTGuLJR3TTmW9f1Z2iNY5zzX2M92cRLSuapIejz8FE=;
        b=MwUeNlKubbYXOf4onCnZCV9geWStQgqPKgmWDlxlZ4OeonR1FLHFxlnjiOTtNpDOyj
         qdNqWHQne7iZUWtRrmMaNG/LhKOV/uphxsreRQJY4I6x0K1i+Hb/y8wDLrMcg5tPPhc5
         8EJ8x1gZujxpfauy4y1Ys2RPMUmhamgPtoFsBIbm5GCr/IiV7U7ts7bMLIM3ssNKKI9s
         7KQMBNfbNPZUIoIsnIO5Au04dW0/CW5xVKD1IGtFsc9IlVBoXKmXGjo42KavzXIqoZhk
         l/jEGJ1ClwvmbJkmT/7ovtF2t6EpqRR0ISSDDde7Fe6vdOzvceEox0y7fH7iZFua3BIS
         UZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GhTGuLJR3TTmW9f1Z2iNY5zzX2M92cRLSuapIejz8FE=;
        b=sW/gOwN7Pj/eXj+fwSwYE5JjLNQgP0GVFqTqr1SznXPTMK6yyQC47kdDqi08WlUTXH
         LmKxpx+1Oqcq7inCH1HqkfgPNXntRsc3pfIMVGdntafyJ6tPi5wVLwQHZSyYx8+vKtpW
         qa/v5C5RsObKBFndC5EKEGGt9c1G6PJR7Z8Z7cQ9b64JDwLLK5PQ91E+Ss5EYliDjFSR
         /k6bc3cHgI8OCkOOFkrIUt3630azIoN4zrK4Gj/Gfc2NY7eB9cOrvXZDLQmHPmCQWLIo
         G91XJuxtWmIUUmc2q04dxysOk4Kc+kFSunguIOVfLwWLpfz3TFiCWPZAt5QydbH0wwDf
         Cvkg==
X-Gm-Message-State: AA+aEWbCP3jngKFGNaMMZkXsXt/y4O9fgUFReIHXCOP91pDvJXb5AE3d
        6AVv04+USOcA9jvJKMaazcfer0+wbdU=
X-Google-Smtp-Source: AFSGD/XXB3p2dWPe/BOV+m3pVMrMiVnENBVvyaUv9ObB7x48s2NQbeR2kRxHd/cj06dpFH9UAZyQYg==
X-Received: by 2002:a25:d304:: with SMTP id e4-v6mr3646713ybf.392.1542826759029;
        Wed, 21 Nov 2018 10:59:19 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d18-v6sm11538834ywa.38.2018.11.21.10.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:18 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 2/6] btrfs: add cleanup_ref_head_accounting helper
Date:   Wed, 21 Nov 2018 13:59:08 -0500
Message-Id: <20181121185912.24288-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
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
index c36b3a42f2bb..e3ed3507018d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2443,6 +2443,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
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
@@ -2478,31 +2513,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
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
@@ -2512,9 +2522,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
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

