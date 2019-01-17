Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3704C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 16:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9BD320652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 16:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfAQQPr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:15:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:48426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728947AbfAQQPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 11:15:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65BB7ACB1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 16:15:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D1EF0DA83D; Thu, 17 Jan 2019 17:15:12 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove unused workqueue helpers
Date:   Thu, 17 Jan 2019 17:15:12 +0100
Message-Id: <20190117161512.24101-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The _owner helpers havent' been used since its introduction in
cb001095ca705dcd95 ("btrfs: plumb fs_info into btrfs_work"), there are
no external users of the private wq::fs_info pointer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/async-thread.c | 12 ------------
 fs/btrfs/async-thread.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d522494698fa..44a7942f0457 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -61,18 +61,6 @@ noinline_for_stack void btrfs_##name(struct work_struct *arg)		\
 	normal_work_helper(work);					\
 }
 
-struct btrfs_fs_info *
-btrfs_workqueue_owner(const struct __btrfs_workqueue *wq)
-{
-	return wq->fs_info;
-}
-
-struct btrfs_fs_info *
-btrfs_work_owner(const struct btrfs_work *work)
-{
-	return work->wq->fs_info;
-}
-
 bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq)
 {
 	/*
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 7861c9feba5f..3aceb2e6373a 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -70,8 +70,6 @@ void btrfs_queue_work(struct btrfs_workqueue *wq,
 void btrfs_destroy_workqueue(struct btrfs_workqueue *wq);
 void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max);
 void btrfs_set_work_high_priority(struct btrfs_work *work);
-struct btrfs_fs_info *btrfs_work_owner(const struct btrfs_work *work);
-struct btrfs_fs_info *btrfs_workqueue_owner(const struct __btrfs_workqueue *wq);
 bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq);
 
 #endif
-- 
2.20.1

