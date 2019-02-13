Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F14C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA83121920
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404217AbfBMPx6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 10:53:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:44424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404133AbfBMPxx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 10:53:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38880B121
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 15:53:52 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Remove unused function btrfs_workqueue_owner
Date:   Wed, 13 Feb 2019 17:53:46 +0200
Message-Id: <20190213155348.31338-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213155348.31338-1-nborisov@suse.com>
References: <20190213155348.31338-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It was added as part of cb001095ca70 ("btrfs: plumb fs_info into btrfs_work")
however a user never really materialized so let's just remove it.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/async-thread.c | 6 ------
 fs/btrfs/async-thread.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 122cb97c7909..36775139477a 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -61,12 +61,6 @@ noinline_for_stack void btrfs_##name(struct work_struct *arg)		\
 	normal_work_helper(work);					\
 }
 
-struct btrfs_fs_info *
-btrfs_workqueue_owner(const struct __btrfs_workqueue *wq)
-{
-	return wq->fs_info;
-}
-
 struct btrfs_fs_info *
 btrfs_work_owner(const struct btrfs_work *work)
 {
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 7861c9feba5f..258367051b6d 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -71,7 +71,6 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue *wq);
 void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max);
 void btrfs_set_work_high_priority(struct btrfs_work *work);
 struct btrfs_fs_info *btrfs_work_owner(const struct btrfs_work *work);
-struct btrfs_fs_info *btrfs_workqueue_owner(const struct __btrfs_workqueue *wq);
 bool btrfs_workqueue_normal_congested(const struct btrfs_workqueue *wq);
 
 #endif
-- 
2.17.1

