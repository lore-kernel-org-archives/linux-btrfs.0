Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487D9C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0767A20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="QWKP7MoO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0767A20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbeLCPUt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:49 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45272 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPUt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:49 -0500
Received: by mail-yw1-f68.google.com with SMTP id d190so5507157ywd.12
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bGA7flS0OJ7Wj4K/89zBSRUCCCpY4sVo2fIC68LsQr0=;
        b=QWKP7MoOy1DTuibmfMmvFNuWLKrDxfOPNphh3dK3VyGDFyUC2JZJLsHfLU+E7VGpT/
         MPS2Sqpzn5f9YLfM2MNK8AwMUxNpgxJQgLcfP3BKz1sCMtw4/rrWFTIAJ94rjxmWPkiu
         7Zk3R12WsH1Gp+Jibo9IxBhLuG1Cs1+O5oKWb4w/GvxdlwqFpZp5bZKUA8eNHfsylTy4
         cuZas/9dNljeExDnGswcvjFqmQiGCNaBZL0SO/IlnbJ1gvNmM2YUsGeFk6bfq3/XU5kx
         cuR+aWpXavKbPYVwm79WE3MeyUM30/TXrvckKSlYwhd2A0OLZhtVvfBXzKy264dkP/es
         9FGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bGA7flS0OJ7Wj4K/89zBSRUCCCpY4sVo2fIC68LsQr0=;
        b=jt7R+E8mybSrXbHl3eaoXF7H+jtXe/FL9TusECIuiv7EPTaCbDiZqq3I55EznUoVzq
         5XaJ4a/VUNmDe6YwAab51IbFLkrgTDnqn/i2BNMju59xuN9kIp8DepWaXLYjE68+bMVt
         CJROgDZZdpORZ5T6OM3nn9FE5+q2LQ0FEaK1fAFzEF5e9cq7natFQXHwGBjFj8E/qxRR
         Oz84z1oxxWvU6ghSCvCSJ+zO17M/4HQSAQhmqezdfUX6X0auEZYKNFPT4teBHOZbB4Bb
         N3OCkD0XhtZCGHROGKT6h+8DZIsPOsd2WlTEmeL2GYwjYl7zjK/ltc2T2RQEcVlJOF5M
         6+Lw==
X-Gm-Message-State: AA+aEWbnjDYEUMceghY3sAsfK8BWn/WXa3DK14wy0zlCiHcYJ4lkPuth
        05htCP5GbPvzgBin6sJM6uoY7+kbk2o=
X-Google-Smtp-Source: AFSGD/WBb099OZQAPI0SNhTxrH/hjVO6jQp3uSPwWwLFNVzleQGpRrJsxBUS60qgt1VaZkaE/HZ06g==
X-Received: by 2002:a81:417:: with SMTP id 23mr16120588ywe.471.1543850447405;
        Mon, 03 Dec 2018 07:20:47 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u2sm5519915ywe.84.2018.12.03.07.20.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:46 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/10] btrfs: cleanup extent_op handling
Date:   Mon,  3 Dec 2018 10:20:31 -0500
Message-Id: <20181203152038.21388-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
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

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e3ed3507018d..9f169f3c5fdb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2424,19 +2424,32 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 	btrfs_delayed_ref_unlock(head);
 }
 
-static int cleanup_extent_op(struct btrfs_trans_handle *trans,
-			     struct btrfs_delayed_ref_head *head)
+static struct btrfs_delayed_extent_op *cleanup_extent_op(
+				struct btrfs_delayed_ref_head *head)
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
+	struct btrfs_delayed_extent_op *extent_op;
+	int ret;
+
+	extent_op = cleanup_extent_op(head);
+	if (!extent_op)
+		return 0;
+	head->extent_op = NULL;
 	spin_unlock(&head->lock);
 	ret = run_delayed_extent_op(trans, head, extent_op);
 	btrfs_free_delayed_extent_op(extent_op);
@@ -2488,7 +2501,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, head);
+	ret = run_and_cleanup_extent_op(trans, head);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
@@ -6977,12 +6990,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (!RB_EMPTY_ROOT(&head->ref_tree.rb_root))
 		goto out;
 
-	if (head->extent_op) {
-		if (!head->must_insert_reserved)
-			goto out;
-		btrfs_free_delayed_extent_op(head->extent_op);
-		head->extent_op = NULL;
-	}
+	if (cleanup_extent_op(head) != NULL)
+		goto out;
 
 	/*
 	 * waiting for the lock here would deadlock.  If someone else has it
-- 
2.14.3

