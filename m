Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660DEC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 259E4215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="P1OLigpH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 259E4215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbeI1Rls (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46768 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rls (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id h22-v6so6088155qtr.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rHTVMCxRLsTEVUkODyGqkPIz399o/p3gyRkwe0nkz4U=;
        b=P1OLigpHvXlqYIeD840SPmwBve5QmtOanrjYfubbm7OPn20+aHWRL3hEBOsL9dn0R1
         UJxvVO5YNji3jVzxb1NuXSln2oaDjPNDpmt5PaI24YEDv1lGRls2Y0hRveya5rgqT38U
         RoqKTUu3s3MY5g6BkFCX6hjBbWZRuigtrAL8+sW59axo8vdzVCfFYwJjPZA61981l1Go
         STZZfZ5NEcmjkZ2L5JZOhQtNTESGlSJLx78+UfngGUZYLX+wlouf/oxvSDQt7uu4NrmK
         0Dd2jnWyz/AC2NTJbfRs5jULi/HuwcZ2LkVlYUHe5IZxDQHJ9Qkw/dSePIiye4UnnqUU
         X2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rHTVMCxRLsTEVUkODyGqkPIz399o/p3gyRkwe0nkz4U=;
        b=RijBZjSLeW8wrcivRlvQCHs2Ssgxz72xwfXvSitWOYI4X80PZKIGJsHlfXmQbz3UFL
         lmepI/1lRSp3JlipDb04wB3yLzROcpKSOl5kqtljCexaj+8wvoa4cvzI/wYM6mIqD6va
         efCoSsQns/Xmp9g8kBvimyKkYvk+wS3LdItvVmiSgnoT2a0j6yMvCTfy6paAwz1sRPmB
         RVP2XFoa7fhB67PooFsi79VGxZMVUxB0NjIFzNPgUHqNNohhwGBMPP/RmUSAXlWmwZbX
         bqisforUpRBP5tFkk7kKB3GwkL8HIf2rtC6eGZAS5K8auZ1kUPv6/4qz32qazoMuXvMU
         lqaQ==
X-Gm-Message-State: ABuFfohlJm/53m/SZBrh4fS6qR957RE6Dw3mAf6+lCoQ060Kc9s8Kll2
        66iJ1OjbkfT9oANuxihC/T9s7ZPp8c4=
X-Google-Smtp-Source: ACcGV60/GtZD4u4eOyrgj7AypzhT53UhAskaQQ+SzVuBXmNLxily1GlY7T4/HImJNcxAsmKKUFxZlw==
X-Received: by 2002:a0c:e205:: with SMTP id q5-v6mr11213749qvl.224.1538133510702;
        Fri, 28 Sep 2018 04:18:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s51-v6sm3212163qta.71.2018.09.28.04.18.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 03/42] btrfs: cleanup extent_op handling
Date:   Fri, 28 Sep 2018 07:17:42 -0400
Message-Id: <20180928111821.24376-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

