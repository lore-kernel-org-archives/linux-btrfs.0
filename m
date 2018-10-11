Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7826C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A777D20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zA32ceDW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A777D20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbeJLDXZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44912 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDXZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id c56-v6so11326267qtd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rHTVMCxRLsTEVUkODyGqkPIz399o/p3gyRkwe0nkz4U=;
        b=zA32ceDWv1Ij4Z3iHARbZw4p6ITa3KabVq+UWI3qqq4ONN+lr1FDt3tYppYBGZdEiO
         riW9HxX/81Of5AKKIFeCfLVK5Rpj8Ws0ttwad58OMnPGRM7hOwx2ho/ArS0CPReJtEH0
         EFSHedOugCI/Hw8K80JqnIS4s1YA2ZzSgcrxq32MMj8lPT3g7YYMqZIVDJzvWo/pdyqB
         Sla1X+fnY7tEWLsHQXxJqQ3QuB9IgC51ce8xyahJsz4KRIHp+5QDLfJT7LH0CL069IH0
         Lelsusi/TNqvmdDoVpKzZEWtLKV0vtZoReRNtWYgV+oMVGmFopMFi4Hr5TeidqwICogq
         552A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rHTVMCxRLsTEVUkODyGqkPIz399o/p3gyRkwe0nkz4U=;
        b=YVM+zZ4WlUaNJuQ/Hbk2hTVvhEtw1nd1luGu15MoOmn4grOTRhhVO08HGtH2rlglty
         4/Kvr4rlGvpAHN2qHowMm5vhg4fJkygLAOo359Oet/aurtHAWxodyPR/11sHXNekyJkw
         JhmyoNtD+6LaLEyM+ihu5wk1o7FLwUfoLR7Mo5GG24lJTBLew7XzhPmMy4l2XVkKnOBY
         0Ru+3lBZzpFbIMObREnbTLj7Mok/L8JW4vNOH9pZp6wHuelV+CfKbV170+mSWXSU+ms1
         xPmjIBrZkMzlJypJ9UZBkj2BSDr/hFouueTkga+sWiqnyLxoSV7L+TbBPAXKBcrndwlr
         Buhg==
X-Gm-Message-State: ABuFfogLdVSN6EBuPlQNnGX+7Jg82TotBbKgjvKgMGiMcjpiwLWuCR3c
        z2+gE71yui4fWH3r7hSkI0BePw==
X-Google-Smtp-Source: ACcGV61G1B1C9wnJvamlp0IeCN2ZGXxmomXEd4tQochh+kzwlAcED4DlkDGktNd8LrRpHxJHUfo14A==
X-Received: by 2002:a0c:8c86:: with SMTP id p6-v6mr3036751qvb.246.1539287679386;
        Thu, 11 Oct 2018 12:54:39 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j57-v6sm16958692qtj.96.2018.10.11.12.54.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:38 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/42] btrfs: cleanup extent_op handling
Date:   Thu, 11 Oct 2018 15:53:52 -0400
Message-Id: <20181011195431.3441-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

The cleanup_extent_op function actually would run the extent_op if it
needed running, which made the name sort of a misnomer.  Change it to
run_and_cleanup_extent_op, and move the actual cleanup work to
cleanup_extent_op so it can be used by check_ref_cleanup() in order to
unify the extent op handling.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a44d55e36e11..98f36dfeccb0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2442,19 +2442,33 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 	btrfs_delayed_ref_unlock(head);
 }
 
-static int cleanup_extent_op(struct btrfs_trans_handle *trans,
-			     struct btrfs_delayed_ref_head *head)
+static struct btrfs_delayed_extent_op *
+cleanup_extent_op(struct btrfs_trans_handle *trans,
+		  struct btrfs_delayed_ref_head *head)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
-	int ret;
 
 	if (!extent_op)
-		return 0;
-	head->extent_op = NULL;
+		return NULL;
+
 	if (head->must_insert_reserved) {
+		head->extent_op = NULL;
 		btrfs_free_delayed_extent_op(extent_op);
-		return 0;
+		return NULL;
 	}
+	return extent_op;
+}
+
+static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
+				     struct btrfs_delayed_ref_head *head)
+{
+	struct btrfs_delayed_extent_op *extent_op =
+		cleanup_extent_op(trans, head);
+	int ret;
+
+	if (!extent_op)
+		return 0;
+	head->extent_op = NULL;
 	spin_unlock(&head->lock);
 	ret = run_delayed_extent_op(trans, head, extent_op);
 	btrfs_free_delayed_extent_op(extent_op);
@@ -2506,7 +2520,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, head);
+	ret = run_and_cleanup_extent_op(trans, head);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
@@ -6977,12 +6991,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (!RB_EMPTY_ROOT(&head->ref_tree))
 		goto out;
 
-	if (head->extent_op) {
-		if (!head->must_insert_reserved)
-			goto out;
-		btrfs_free_delayed_extent_op(head->extent_op);
-		head->extent_op = NULL;
-	}
+	if (cleanup_extent_op(trans, head) != NULL)
+		goto out;
 
 	/*
 	 * waiting for the lock here would deadlock.  If someone else has it
-- 
2.14.3

