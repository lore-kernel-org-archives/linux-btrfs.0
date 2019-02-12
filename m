Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC53DC282CA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D2F222C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfBLRQ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:16:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:46010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731756AbfBLRQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 12:16:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B2B3B049;
        Tue, 12 Feb 2019 17:16:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8FCF9DA84E; Tue, 12 Feb 2019 18:15:42 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: scrub: add assertions for worker pointers
Date:   Tue, 12 Feb 2019 18:15:40 +0100
Message-Id: <20190212171540.11518-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The scrub worker pointers are not NULL iff the scrub is running, so
reset them back once the last reference is dropped. Add assertions to
the initial phase of scrub to verify that.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 4 ++++
 fs/btrfs/scrub.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7efa1edb30cd..f92f97304e69 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1075,6 +1075,10 @@ struct btrfs_fs_info {
 	atomic_t scrubs_paused;
 	atomic_t scrub_cancel_req;
 	wait_queue_head_t scrub_pause_wait;
+	/*
+	 * The worker pointers are NULL iff the refcount is 0, ie. scrub is not
+	 * running.
+	 */
 	refcount_t scrub_workers_refcnt;
 	struct btrfs_workqueue *scrub_workers;
 	struct btrfs_workqueue *scrub_wr_completion_workers;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d20150d68a90..669bedfec4a9 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3744,17 +3744,20 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	lockdep_assert_held(&fs_info->scrub_lock);
 
 	if (refcount_read(&fs_info->scrub_workers_refcnt) == 0) {
+		ASSERT(fs_info->scrub_workers == NULL);
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
 		if (!fs_info->scrub_workers)
 			goto fail_scrub_workers;
 
+		ASSERT(fs_info->scrub_wr_completion_workers == NULL);
 		fs_info->scrub_wr_completion_workers =
 			btrfs_alloc_workqueue(fs_info, "scrubwrc", flags,
 					      max_active, 2);
 		if (!fs_info->scrub_wr_completion_workers)
 			goto fail_scrub_wr_completion_workers;
 
+		ASSERT(fs_info->scrub_parity_workers == NULL);
 		fs_info->scrub_parity_workers =
 			btrfs_alloc_workqueue(fs_info, "scrubparity", flags,
 					      max_active, 2);
@@ -3934,6 +3937,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		scrub_workers = fs_info->scrub_workers;
 		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
 		scrub_parity = fs_info->scrub_parity_workers;
+
+		fs_info->scrub_workers = NULL;
+		fs_info->scrub_wr_completion_workers = NULL;
+		fs_info->scrub_parity_workers = NULL;
 	}
 	mutex_unlock(&fs_info->scrub_lock);
 
-- 
2.20.1

