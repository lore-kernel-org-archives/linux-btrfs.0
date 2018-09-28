Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE4CC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C869215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wWUsjHTV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C869215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbeI1Rlo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:44 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39798 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id q5-v6so594343qki.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1nvikXF93vBk79skKC0f+gf8yb5S1jfySvhFcqnzF4=;
        b=wWUsjHTVUEDPQWaWG3bewmxCA68ELsH9XNmeh40ax8g0ZaqTd97KgwN+HShQ418sB8
         1RBWOmVA2e0jP1NoVpj7PBBDEJbKgAfcErLwO5vNHd9ij9WSIDCE830CPKpbVoJXFEVf
         yzpZ5zJ7pNYa9WK5PxKig/hOMG9nPY6+myBlOyQdyfwDWrDLtMOshIkjmluiAsGro48O
         eIxNj7mLZ7I7iTWFmH767+wKhDq+TSwwBhX9ecyDno3UEJLENlhtKfH0CMZUwg3ADYa1
         GV1JZ449mAguIOtSnrxubqZlrZnj1M93aP0BTHgM9aK8CAXYs2YF9b//hUIisQEGrh6f
         +mEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1nvikXF93vBk79skKC0f+gf8yb5S1jfySvhFcqnzF4=;
        b=M3gutYRsfLMLL2rMLERrbyi0dknXSN0JOXt5g2K0b3j793QNClh9kOpVo8Km84zRgM
         S0wJcR8YfP/sU9ch4GazGJ4IY6Jx9WFzawbLy6UNt26hdtFlHjtRTPn6hGpIZNOBFLG0
         VYEAxUCQqhYmif4Q6+kyVXjQLlwU/zKgQlT9BgxNFcpgXx/PrvoX96GDEkSK6WQHvXSo
         VZBPc2dq/4gEZJ33kePH5Pj7t2pfWSi9jMFaNDZ1z+sJr5JXAskrHChXFL7BPcaUBn3H
         M/ZXHWKt3BtSveukeJpGycLjr31c+G+XNRyfQTD5IYFBVlxPTYWTF8NPhyxipNK7vxw3
         gY3w==
X-Gm-Message-State: ABuFfojXLp/LoE1gxzi5HI6DEotCSNQsD5CzlLV48voYWChEyjcRqww7
        ewLw3lLtB/fgfqwOXSPKZTMpfA==
X-Google-Smtp-Source: ACcGV61bW8cet4Ah/UC0zzu1+TOj4IjOM5QUBA7xwkcwUM6HGjm1AATxRXdOJqKd9h/QW4MX0zqwhA==
X-Received: by 2002:a37:9d82:: with SMTP id g124-v6mr11001895qke.19.1538133506926;
        Fri, 28 Sep 2018 04:18:26 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j5-v6sm2856722qtb.34.2018.09.28.04.18.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:25 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 01/42] btrfs: add btrfs_delete_ref_head helper
Date:   Fri, 28 Sep 2018 07:17:40 -0400
Message-Id: <20180928111821.24376-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We do this dance in cleanup_ref_head and check_ref_cleanup, unify it
into a helper and cleanup the calling functions.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/delayed-ref.c | 14 ++++++++++++++
 fs/btrfs/delayed-ref.h |  3 ++-
 fs/btrfs/extent-tree.c | 22 +++-------------------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 62ff545ba1f7..3a9e4ac21794 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -393,6 +393,20 @@ btrfs_select_ref_head(struct btrfs_trans_handle *trans)
 	return head;
 }
 
+void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+			   struct btrfs_delayed_ref_head *head)
+{
+	lockdep_assert_held(&delayed_refs->lock);
+	lockdep_assert_held(&head->lock);
+
+	rb_erase(&head->href_node, &delayed_refs->href_root);
+	RB_CLEAR_NODE(&head->href_node);
+	atomic_dec(&delayed_refs->num_entries);
+	delayed_refs->num_heads--;
+	if (head->processing == 0)
+		delayed_refs->num_heads_ready--;
+}
+
 /*
  * Helper to insert the ref_node to the tail or merge with tail.
  *
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d9f2a4ebd5db..7769177b489e 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 {
 	mutex_unlock(&head->mutex);
 }
-
+void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+			   struct btrfs_delayed_ref_head *head);
 
 struct btrfs_delayed_ref_head *
 btrfs_select_ref_head(struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f77226d8020a..d24a0de4a2e7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2492,12 +2492,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		spin_unlock(&delayed_refs->lock);
 		return 1;
 	}
-	delayed_refs->num_heads--;
-	rb_erase(&head->href_node, &delayed_refs->href_root);
-	RB_CLEAR_NODE(&head->href_node);
+	btrfs_delete_ref_head(delayed_refs, head);
 	spin_unlock(&head->lock);
 	spin_unlock(&delayed_refs->lock);
-	atomic_dec(&delayed_refs->num_entries);
 
 	trace_run_delayed_ref_head(fs_info, head, 0);
 
@@ -6984,22 +6981,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	if (!mutex_trylock(&head->mutex))
 		goto out;
 
-	/*
-	 * at this point we have a head with no other entries.  Go
-	 * ahead and process it.
-	 */
-	rb_erase(&head->href_node, &delayed_refs->href_root);
-	RB_CLEAR_NODE(&head->href_node);
-	atomic_dec(&delayed_refs->num_entries);
-
-	/*
-	 * we don't take a ref on the node because we're removing it from the
-	 * tree, so we just steal the ref the tree was holding.
-	 */
-	delayed_refs->num_heads--;
-	if (head->processing == 0)
-		delayed_refs->num_heads_ready--;
+	btrfs_delete_ref_head(delayed_refs, head);
 	head->processing = 0;
+
 	spin_unlock(&head->lock);
 	spin_unlock(&delayed_refs->lock);
 
-- 
2.14.3

