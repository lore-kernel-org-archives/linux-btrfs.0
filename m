Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C81C65BAE
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD3E520867
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="OkMbq44o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD3E520867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbeLAECP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:02:15 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38552 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbeLAECO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:02:14 -0500
Received: by mail-yb1-f196.google.com with SMTP id u103-v6so2464965ybi.5
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 08:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4MrXXWbMNZESoo3DTjd4Y1kveRLZLRLiOpanXwnI+7I=;
        b=OkMbq44oadO+5O8MvVvfMNTxUFp021l5OiNoQJLM9GYrR+X4/BOdter1XUCLligIFm
         VUxV6oHOLZFiPmXBXCSIVg6wKbvdu8EmXZC4eekvaFUpZX5Oa8IVRpQYLgyq7gSjTIGE
         +w7V0c/+/LMmRWtlVMvg6l5H2r0XnyFjdJQmKVkkKKAQamAVReCS/YgoHfmuGrkGVLFP
         XGm7Iyef7Du1KYEBO8y7Z+Do4xMgmcWE+fwuoTJkzb/xxT9nyml6F1ndNJj0oXZH0Q4r
         Jst6CdFFMS7YeMHZVkWec6xX3kqTG78OzCCkOCDGebYENxnhdhrISH+tpM1CDuOrx8US
         6lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4MrXXWbMNZESoo3DTjd4Y1kveRLZLRLiOpanXwnI+7I=;
        b=gDyNhFxBj4ec4NotG0a/yo+JNyM3vsB8/2Wr9QXgkLaK2FIDD2VZRmZ8iA/I7NtPQp
         grPi4bc3HY///caBUULjuucvh1HVyw1nkX2Ih3jx1QkznA0XolqH/o5gzEJYir65R0az
         Ju3K9U2K/7lpJsxKt+s3MBd6QM5tK9CNfQ9dVBTPBY2zZiTXhaGnaw9DwdLqeVDarthW
         Na3x4bzlDCM/CeZsUvUxAYUj5/xic+UJbcMoPGZEp9KpYL6jeY2TAVN/tzGSxvfrHI5j
         Sa09WP3XN9nVE1oTzoZGyRSdBJMncnDXMRmFQLrMhN/8j/+1m1vJL+LpKqbHK8iZ2RTu
         hfUQ==
X-Gm-Message-State: AA+aEWaDv3Z9wW9HxAu2okj76cXATUOSWy4LcykWLS0S2PVVF1vjkzNi
        QpZ3D9HMnaiXHCOqJkboEF/zM6t3xvw=
X-Google-Smtp-Source: AFSGD/WT3Ur1JWp02+qCIUv6e4wflHfymDY0EzyEtdO13lweUkw5qftI5cE0arc7lm4UA4tyil4GGg==
X-Received: by 2002:a25:be85:: with SMTP id i5-v6mr6285144ybk.463.1543596739013;
        Fri, 30 Nov 2018 08:52:19 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w2sm1773811ywe.62.2018.11.30.08.52.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Nov 2018 08:52:18 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 1/2] btrfs: catch cow on deleting snapshots
Date:   Fri, 30 Nov 2018 11:52:13 -0500
Message-Id: <20181130165214.17883-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181130165214.17883-1-josef@toxicpanda.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

When debugging some weird extent reference bug I suspected that we were
changing a snapshot while we were deleting it, which could explain my
bug.  This was indeed what was happening, and this patch helped me
verify my theory.  It is never correct to modify the snapshot once it's
being deleted, so mark the root when we are deleting it and make sure we
complain about it when it happens.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.c       | 3 +++
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/extent-tree.c | 9 +++++++++
 3 files changed, 13 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5912a97b07a6..5f82f86085e8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	u64 search_start;
 	int ret;
 
+	if (test_bit(BTRFS_ROOT_DELETING, &root->state))
+		WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\n");
+
 	if (trans->transaction != fs_info->running_transaction)
 		WARN(1, KERN_CRIT "trans %llu running %llu\n",
 		       trans->transid,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index facde70c15ed..5a3a94ccb65c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1199,6 +1199,7 @@ enum {
 	BTRFS_ROOT_FORCE_COW,
 	BTRFS_ROOT_MULTI_LOG_TASKS,
 	BTRFS_ROOT_DIRTY,
+	BTRFS_ROOT_DELETING,
 };
 
 /*
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 581c2a0b2945..dcb699dd57f3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9333,6 +9333,15 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	if (block_rsv)
 		trans->block_rsv = block_rsv;
 
+	/*
+	 * This will help us catch people modifying the fs tree while we're
+	 * dropping it.  It is unsafe to mess with the fs tree while it's being
+	 * dropped as we unlock the root node and parent nodes as we walk down
+	 * the tree, assuming nothing will change.  If something does change
+	 * then we'll have stale information and drop references to blocks we've
+	 * already dropped.
+	 */
+	set_bit(BTRFS_ROOT_DELETING, &root->state);
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
-- 
2.14.3

