Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25006C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7E1320883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbfACIuM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:60106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbfACIuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8D0FAEBC
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/7] btrfs: Refactor shrink_delalloc
Date:   Thu,  3 Jan 2019 10:50:05 +0200
Message-Id: <20190103085005.32053-8-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a couple of comments regarding the logic flow in shrink_delalloc.
Then, cease using max_reclaim as a temporary variable when calculating
nr_pages. Finally give max_reclaim a more becoming name, which
uneqivocally shows at what this variable really holds. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b15afeae16df..615441f4d458 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4743,7 +4743,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
 	u64 delalloc_bytes;
-	u64 max_reclaim;
+	u64 async_pages;
 	u64 items;
 	long time_left;
 	unsigned long nr_pages;
@@ -4768,25 +4768,36 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 
 	loops = 0;
 	while (delalloc_bytes && loops < 3) {
-		max_reclaim = min(delalloc_bytes, to_reclaim);
-		nr_pages = max_reclaim >> PAGE_SHIFT;
+		nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
+
+		/*
+		 * Triggers inode writeback for up to nr_pages. This will invoke
+		 * ->writepages callback and trigger delalloc filling
+		 *  (btrfs_run_delalloc_range()).
+		 */
 		btrfs_writeback_inodes_sb_nr(fs_info, nr_pages, items);
+
 		/*
-		 * We need to wait for the async pages to actually start before
-		 * we do anything.
+		 * We need to wait for the compressed pages to start before
+		 * we continue.
 		 */
-		max_reclaim = atomic_read(&fs_info->async_delalloc_pages);
-		if (!max_reclaim)
+		async_pages = atomic_read(&fs_info->async_delalloc_pages);
+		if (!async_pages)
 			goto skip_async;
 
-		if (max_reclaim <= nr_pages)
-			max_reclaim = 0;
+		/*
+		 * Calculate how many compressed pages we want to be written
+		 * before we continue. I.e if there are more async pages than we
+		 * require wait_event will wait until nr_pages are written.
+		 */
+		if (async_pages <= nr_pages)
+			async_pages = 0;
 		else
-			max_reclaim -= nr_pages;
+			async_pages -= nr_pages;
 
 		wait_event(fs_info->async_submit_wait,
 			   atomic_read(&fs_info->async_delalloc_pages) <=
-			   (int)max_reclaim);
+			   (int)async_pages);
 skip_async:
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets) &&
-- 
2.17.1

