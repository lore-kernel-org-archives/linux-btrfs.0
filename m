Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664FEC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BB2720835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="A03nV5WI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BB2720835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbeJLDXW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:22 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:37818 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDXW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:22 -0400
Received: by mail-qt1-f170.google.com with SMTP id d14-v6so11349818qto.4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1nvikXF93vBk79skKC0f+gf8yb5S1jfySvhFcqnzF4=;
        b=A03nV5WIDGvK/biQc4opVP5LC4Cb7l/OY0JOVLO7M/6nx99DtP8uj4ZLcauLw3ACHp
         jGrxUafG+6AuO+nNXFcqOHqGyBvYC3ZHj/6jmvDm4MKciK1vhY5gIXxg17jArfzCUicK
         z1tP/deP//UOsVblzzU0UuKyaxQtA9Tfa1w1ViQyD3YgJe5aXYdv1T7+lq4zqBYMlDq1
         DE4CcNNNQdNB1hbilW9dGGH/RpMNRfX58GSckOARewdd0xvu6KZKhpwgPsivo3YoyqCF
         XGsbygr/HUDifoATcAHcaOwEGg/4Y8yiEb45tN7mVFz2UzGa1vLzZ28WwJGsmlVdktji
         B3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1nvikXF93vBk79skKC0f+gf8yb5S1jfySvhFcqnzF4=;
        b=RqrwQL+ES4jwQDyKSPxbhEKBDwVQRUEgLOvtSIoAtpf484gGZGJYY2ZKXtVI3CNgz2
         HNz0C1Dde2v9e9vRGe9OxLx+awKPRl25wRNs42Ojz1k3RkQPjd/cdCDwPNgdxwkU7ynE
         UdGp3ZGphZLQ6T1ROy2AjqrsDCeMQGFd05fE5FoAxs9m/Hwq98K0+4d82hKUZ0IV26X3
         V3UDPnw692a7aW5c+uE3/QiRdNchg/jZIfxaCKjftjx/DcuMitE2yxOXVe/UrMC/Rahv
         3Ec2/h3HYrMVfgWBJnc1WPRmaETjE/l/uFzgofblaF/l4UgM4H2+sYpmq+KepFw816IC
         Uzbw==
X-Gm-Message-State: ABuFfojyPj6qD2e3oLqTXqnnv7RKru54wBGB/eqQH46X9ygs3WmP8+wQ
        pUb9ku2qt88tc14jUyapzkqiXHzfybw=
X-Google-Smtp-Source: ACcGV60msZpBkQXKhLWyp12rOJgN6NCSLK5eCUDbb4OgpwweJkkPIIFXYp0FxdMV+7eITPkzxisyJg==
X-Received: by 2002:a0c:95e6:: with SMTP id t35mr3084144qvt.163.1539287675614;
        Thu, 11 Oct 2018 12:54:35 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r20-v6sm15593994qkl.12.2018.10.11.12.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:34 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 01/42] btrfs: add btrfs_delete_ref_head helper
Date:   Thu, 11 Oct 2018 15:53:50 -0400
Message-Id: <20181011195431.3441-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

