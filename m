Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE09DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75282214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="PC6MsU9G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75282214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbeKVFeu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:50 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33779 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFeu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:50 -0500
Received: by mail-yw1-f68.google.com with SMTP id q11so2686274ywa.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pRCx2eP/l80aL+OLubW7i+4YyKvLhkbzZ3rfIZGfT4g=;
        b=PC6MsU9GGKYCBvPzTni2T08qtbYjrV1nOJbslD5VQbKmF/mkzjG+Ah7rYdFr37OlAi
         pKeI7iVryzkzOiaUfoMHJkIi29ipf5/b3cU8u9rFny6MxCEObZSW45ROH+T+Q76/Dz0U
         UICrTMAWJUwtui+aWDG07d3bWRFdlQtTfwXVnC2TZtc1U250HLQOsv5VpuOPESRvS/p5
         Go/wMEMUQtG9BRUFz9nOH3Y3uzB2NwX/ovrpYv6kdM918e/ibB0rzM5yjjqlEP95mZiX
         yJQGCr5qeWFJrj8cCGgsXNhdyn4Js++FoSjyP8nj+Snd8cmU8gF4wwFm5PNR72BC+ecr
         VewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pRCx2eP/l80aL+OLubW7i+4YyKvLhkbzZ3rfIZGfT4g=;
        b=sRJXgCa+LfJ7Hpx4wf7tB/RhJVGGNb5ldgPriM3cQ9K404hLXN7HF6yx05tFVBqZS0
         9H9CcaBkDgp4rLyIyFYxofF/8x63RIQIvdGik4vPstSdEc/BYHCxZx2986oyDPEDYKhm
         E3HhWYoMOxOVeM1hbZHLPQUSx+6CFj3/A+xIwkb8gaB6Za7AYJWkNjDz+8o01ERXvW0U
         CyuKH1xv+iIy38LDJU3PSV5NOhMjgRiY5RClLUT7JGu4p/vinMCgcmooIpqZ0a7A7BXk
         ESZL4mp1jl5AGM0iGMDk8KsI2RGDnB5ymlUXQnIXUEPz+Gzo1szBvNX2BM6vp74j8mKE
         8YEw==
X-Gm-Message-State: AGRZ1gLeaVP3I5kant9rLqVjVvhGqmq3i7nL1hRN3Rw7kIKeuvjLOtMV
        Ym1FRL284qFLJcrs679oRWqy7LvCuz4=
X-Google-Smtp-Source: AJdET5cCmrY9SICiNnZA+GeYiDW05dXu2uLQaJI+CEFmuIeQqeOWZ576SzECtLdNKQ1M0LpdDkCMtw==
X-Received: by 2002:a81:2714:: with SMTP id n20mr7729814ywn.77.1542826757341;
        Wed, 21 Nov 2018 10:59:17 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c140sm26384848ywa.74.2018.11.21.10.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:16 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 1/6] btrfs: add btrfs_delete_ref_head helper
Date:   Wed, 21 Nov 2018 13:59:07 -0500
Message-Id: <20181121185912.24288-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
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
index 9301b3ad9217..b3e4c9fcb664 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -400,6 +400,20 @@ struct btrfs_delayed_ref_head *btrfs_select_ref_head(
 	return head;
 }
 
+void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+			   struct btrfs_delayed_ref_head *head)
+{
+	lockdep_assert_held(&delayed_refs->lock);
+	lockdep_assert_held(&head->lock);
+
+	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
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
index 8e20c5cb5404..d2af974f68a1 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 {
 	mutex_unlock(&head->mutex);
 }
-
+void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
+			   struct btrfs_delayed_ref_head *head);
 
 struct btrfs_delayed_ref_head *btrfs_select_ref_head(
 		struct btrfs_delayed_ref_root *delayed_refs);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d242a1174e50..c36b3a42f2bb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2474,12 +2474,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		spin_unlock(&delayed_refs->lock);
 		return 1;
 	}
-	delayed_refs->num_heads--;
-	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
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
-	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
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

