Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC7C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F88920835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="lZe+Djg1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F88920835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbeJLDXY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41260 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDXX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id 23-v6so6256421qkh.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=lZe+Djg158/nt16yQMD+e+o+2rIoTZQQieIhDC+EQixoQtoHHaixmp3/sZjAlG1jTz
         WycVJCfBl3o+SMhoZM2B8+pTe9IGElaaXdKQO4ST9z7pRtoM71G6XpcBcZ52tcgC6u/q
         ibdNE1M2azMsDlTjn3sVi7ZXtu+OYt0S6RmjIPJivaChEC+yoctVA6BbFvmrohUPYzYT
         9m869Ytkk3W9na0i6oLa5qMpBbXe/n58igRgnCQ0mGWAb1knaRWLEiMB2WedO3iu5ZMI
         AJ6/3NHV1sGc5Ph9xBAxts6vGfo7SmTseZYjirQzMFDOR8FJhD0uDR1uScOSv9nQdPd/
         +VhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/1YdvlrrEVlQm7E7WHAhXkpqC+TBu9F+Y13pNbn/ob8=;
        b=MrF1IaX0HIHxRX9yATCrD7Qwx1Sr/NlnfODTORrOoT7YpW41YfkaP3Xmp5DtLwvclI
         bYuMVHK6PWawU4bk2oH7Psz9+wgsULZdNOGlqtCy8ZewSKhTpNI0Ipg5s6YrUCg+ev09
         EoXEMXR8Kts1Mc/QtVAJi/AyC6YF67Cz0AHhFkfPhggr97+RU428wHnOUslHvgiltKWa
         xZlPUxdClkjfeo9cYIqJqJf4T9/G7FOxqTgpE3h2GJ0Be51Yi2TQwHG9CmvxcNOXfIqA
         CaC2W8ef7UyijwmWqyXM0nTQ+wqEskK+san8F/ob4p2LIkPq2tYO23T/o2qtH1nvlgYU
         B2Dw==
X-Gm-Message-State: ABuFfoiNX82N9yJBfVlfgOTQhZCQYVDKhDO5Zh9k6og3xogYJS9m35Jl
        OzdgVycHRWNSGLzObzHfshsHNA==
X-Google-Smtp-Source: ACcGV60gRH0OVRGFbKAmD4+0dQoDCX9gjgt+Jidi6kf+eP+4l0YE7KvP6kP2Hz07JaUWFp+3AAwtVA==
X-Received: by 2002:a37:8b46:: with SMTP id n67-v6mr2958885qkd.262.1539287677453;
        Thu, 11 Oct 2018 12:54:37 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y7-v6sm11909357qkf.38.2018.10.11.12.54.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:36 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 02/42] btrfs: add cleanup_ref_head_accounting helper
Date:   Thu, 11 Oct 2018 15:53:51 -0400
Message-Id: <20181011195431.3441-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

