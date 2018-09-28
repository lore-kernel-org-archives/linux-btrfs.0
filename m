Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27672C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA13A215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="GVKNiXf7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA13A215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbeI1RmQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41990 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id z8-v6so6115544qto.9
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=BgDRhtJ88t7ugG2XXq1rTUKV8IL4k8Uo9zOi0L9ZWBs=;
        b=GVKNiXf7Dyb6kVr8XMTZ46QsYZdt3MUXWXMYt7JLIARzq0vR3EdNgTR9Sh9/a90dFw
         X3JkIQyCcfhI4S588z4UTlWT3ffz4Sr4Lkio7Dzf8PT+cb8K/+GwRxASK1wYoFOafPeC
         8D4Dnfu0oHFnXyOUFYo+iKUxKGRHty3w+2NvEik6BOGd4ngXLP31uBKey7fEvkZh6Psn
         dM/K3nAKqLcU5Bl8Jx7Ay2xZgRcJt2rdnx4l7UdLoL3Wg0ttxfWw0S0Yvt1nk8h7JDyA
         /XxVjt9AlPknHH77ricXLpmml/EwTBQPL42T7qhmhnapHfFvwsVaC2TdEgL04IGEPcj3
         LNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=BgDRhtJ88t7ugG2XXq1rTUKV8IL4k8Uo9zOi0L9ZWBs=;
        b=cGSyq+FNRyWIyiU1Pk93sryNvnkSL7J44i+56vEZ2vFIMML3LVt3DEnSBgCdDEZbqd
         dekSKvjyc2uVDFuuhAcbn7WXcjU88EhHrMILtELU3KfVNQ5TyX1UdwtBuVnzuVZefjOw
         K+kW45YbtLG5NmYPm2t7zVQfNXtMR59PpNWLXZrvHDgMI2Bt7ielg4zuo32aQaEKK7HN
         08Ro0a2Vc0qQp6YOfrD5CqAhYNsfcOWUcC+0uDRitWp1UEilvKqBPqBiC9TVq8DUsZZG
         foLPGWd8jHeexNSwQstI5LzKWSK4iaM/6fSPoKBhyQOvFdOnhThg9I73ZRakdNXawlsk
         UsVA==
X-Gm-Message-State: ABuFfoi0EPA1iyKQOQOuwowjEehUNTVYeVtPKQhM1iB6d06TEHPe9TFI
        SCvzr7GQlCLuJ4ZDzUPjByYhqFCPnXs=
X-Google-Smtp-Source: ACcGV62sJzU/nEYkf6mMibqzRJA3N0pXGpgu/fPep9SHkuU7m5j5+UjS2ce67zjo4stgkXZ5DRRsWw==
X-Received: by 2002:aed:20f1:: with SMTP id 104-v6mr12402380qtb.81.1538133538685;
        Fri, 28 Sep 2018 04:18:58 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y143-v6sm2650738qky.95.2018.09.28.04.18.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:57 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 18/42] btrfs: move the dio_sem higher up the callchain
Date:   Fri, 28 Sep 2018 07:17:57 -0400
Message-Id: <20180928111821.24376-19-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're getting a lockdep splat because we take the dio_sem under the
log_mutex.  What we really need is to protect fsync() from logging an
extent map for an extent we never waited on higher up, so just guard the
whole thing with dio_sem.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/file.c     | 12 ++++++++++++
 fs/btrfs/tree-log.c |  2 --
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 095f0bb86bb7..c07110edb9de 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2079,6 +2079,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 
 	inode_lock(inode);
+
+	/*
+	 * We take the dio_sem here because the tree log stuff can race with
+	 * lockless dio writes and get an extent map logged for an extent we
+	 * never waited on.  We need it this high up for lockdep reasons.
+	 */
+	down_write(&BTRFS_I(inode)->dio_sem);
+
 	atomic_inc(&root->log_batch);
 
 	/*
@@ -2087,6 +2095,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2110,6 +2119,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		 * checked called fsync.
 		 */
 		ret = filemap_check_wb_err(inode->i_mapping, file->f_wb_err);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2128,6 +2138,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2149,6 +2160,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
+	up_write(&BTRFS_I(inode)->dio_sem);
 	inode_unlock(inode);
 
 	/*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1650dc44a5e3..66b7e059b765 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&extents);
 
-	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
 	logged_start = start;
@@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	if (!ret)
-- 
2.14.3

