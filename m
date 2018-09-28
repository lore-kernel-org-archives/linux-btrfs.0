Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3FBC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CA3215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ZPXTzPaE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89CA3215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbeI1Rlr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:47 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41521 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:46 -0400
Received: by mail-qk1-f194.google.com with SMTP id n3-v6so3553727qkn.8
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=ZPXTzPaEV5RZSSoz70DOWlnUZQryPC+fWLI7dgyW6DKSQYeyjUeBn4ap7tr+wkCBw6
         3yANyBWwMCGivBwVTV0KSP1KYfj//QTZU0FsNLLlwgU00kQcb+4Ro+ZUPVcEsMBLUETy
         KeoPs1OCeq4AtNPaD+kzt3eg2f+/bKHdVCBYcWYdh+rQUI+7hNFT7ndV6oHY5/WjPXTb
         WCrElZ8YgVYCEBqvy5GSYfR59HWK1EViy2VWwsbTyW1jDV+ffXoSMppRYGKrz9IVaEfu
         IG++T6FrGrQsZI+3PzZ0LHldS7bmVQVJ6jOu9Zb3mAdEBB7r94w5RB0k1PUMdr1CWKN2
         An9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=XEKKJ8RX+8nA2rhBZ4DHQyY6tG5LjbUfNpqXvMraeRs9afnqBLcy8kr/HvivhmPwr7
         T2DYL9LBED+qNEWiGtWZx5oAIda8iDirRZo8MPi5P2sVkq623ixpV59zXZQvwDVdkjvf
         bszsPVG8rA+uyXxh0VFdi9Q/LCb9zuEOjteUuAYuLsPtJNL3yrCwDd/dNabUT7qilqob
         9m4Y0iMhntD/+etV9RNc9tUBBpZsSq4iRi4coOGeFh5Jh1L8Qv2eEyXdPYVorgOIq9Tc
         RAjDVUk3+eVQX0F/LYxBACI8BAEImNMp1LUFLhCkRZAlAxZ40gubqgg5ybN8gbWNz3gI
         zvdw==
X-Gm-Message-State: ABuFfogkEIn45dTWIwPkFYJT1VxCDqos3bNSqTaYOIiCzvPQqFRRf3Iv
        27k3kKZm/DbMAuMiQR/Umbj3Q745YSg=
X-Google-Smtp-Source: ACcGV601YtEqtC5St3I08nwDTzyDonSSwUedHIE48N1SocE8zD/4CCdAic5kC004c8Je0f398+ZOXw==
X-Received: by 2002:a37:f8c:: with SMTP id 12-v6mr11476719qkp.224.1538133508660;
        Fri, 28 Sep 2018 04:18:28 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u36-v6sm2926725qtc.46.2018.09.28.04.18.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 02/42] btrfs: add cleanup_ref_head_accounting helper
Date:   Fri, 28 Sep 2018 07:17:41 -0400
Message-Id: <20180928111821.24376-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

