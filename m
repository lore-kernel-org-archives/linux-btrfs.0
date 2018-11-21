Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FBBC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2AF8214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="L6Us1HdA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2AF8214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbeKVFex (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:53 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46929 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:53 -0500
Received: by mail-yb1-f194.google.com with SMTP id i17-v6so2619239ybp.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gGGul1TTCJiRU2r9y3Jxyt0Nld5OT9z9f/TFrcQeZmk=;
        b=L6Us1HdAR3dVQM/fxQAAUDV9YDMqyopLgX8Fqjmsmw9+Lw+sRg4fEPMlPGfc6JW408
         OfNKMReI0H5Z00l8c9hnvG5us6xLu4t0SVuceYwGYT/9L/ngTeLCxMGPELs6dfqBTXkK
         wiZRpl9mStDeZwc0TmUuXRjVGk/0+R0V7PHeJdtac9v08DXqdTJAN0dQo79xxq3i7lvc
         +sFugichdzJqCSvJzLbPegizGauUd1eE7JuQhXACDjhmBKsiBIdBAuwLwqhROJu78qYM
         0KbApuexs9b1e7RBUl7iBMwFwfJexTRjYMrpehQiskSY2poCs51/BENuFtzfn1hw6ZKV
         256w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gGGul1TTCJiRU2r9y3Jxyt0Nld5OT9z9f/TFrcQeZmk=;
        b=rJ8AHqH9PjcSjCEuSUmpV8luyqupDWvmdCO4HjNmv6c3aYtrOrpQxKrie7ztYupC5o
         AOqUOFo3I4BVrvjKnn6DlSWuuuY0PbHYVNnWLgYurCc4s6j/40y++nQWpgfvHjR7XTHE
         5jN1CmELx2me07sTZS9VMZl1HV5E1ecNmg9esF3829FRZJ5+YSkOUj26v97edccdqVmi
         2gI8xHBB1gpqXSOIutsb7M0APPCCFQz+oVIUKkNlCDQmVRwEe6JH72NPJPkjrazCLU32
         PvJGPoEjj2pZevBnnWCQ+nFkrjy1Wmn+fKVOpHIRIeLvis2sf9Mi1v8mH4n5zuGeBfRB
         5T9A==
X-Gm-Message-State: AA+aEWZIpTOAKzJvHCuQqAVIX4IQ4LcvFPc/KrWMnkrfi9ps+JcVlf+C
        uE9JVGSDNwR0dihk2p8oAPuv6gRaHE0=
X-Google-Smtp-Source: AFSGD/U/SgRg7mfI8EA5UJJ0qmJqNgt7wQGmpw1bZb6Cz+vH7Rp7OVho4SxrqLpCbVeZpa64hueeXw==
X-Received: by 2002:a5b:708:: with SMTP id g8-v6mr7561057ybq.331.1542826760682;
        Wed, 21 Nov 2018 10:59:20 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z74sm10835567ywz.51.2018.11.21.10.59.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:20 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 3/6] btrfs: cleanup extent_op handling
Date:   Wed, 21 Nov 2018 13:59:09 -0500
Message-Id: <20181121185912.24288-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
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
index e3ed3507018d..8a776dc9cb38 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2424,19 +2424,33 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
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
@@ -2488,7 +2502,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, head);
+	ret = run_and_cleanup_extent_op(trans, head);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
@@ -6977,12 +6991,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (!RB_EMPTY_ROOT(&head->ref_tree.rb_root))
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

