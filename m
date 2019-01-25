Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF6BC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE55B218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfAYFJs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:56208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbfAYFJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9377DAE03
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:46 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 09/12] btrfs: extent_io: Kill the BUG_ON() in lock_extent_buffer_for_io()
Date:   Fri, 25 Jan 2019 13:09:22 +0800
Message-Id: <20190125050925.30754-10-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function needs some extra check on locked pages and eb.

For error handling we need to unlock locked pages and the eb.

Also add comment for possible return values of lock_extent_buffer_for_io().

There is a rare >0 return value branch, where all pages get locked
while write bio is not flushed.

Thankfully it's handled by the only caller, btree_write_cache_pages(),
as later write_one_eb() call will trigger submit_one_bio().
So there shouldn't be any problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fba5d4a0b194..52c1b0ce6bfd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3509,19 +3509,25 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 		       TASK_UNINTERRUPTIBLE);
 }
 
+/*
+ * Return 0 if nothing went wrong, its pages get locked and submitted.
+ * Return >0 is mostly the same as 0, except bio is not submitted.
+ * Return <0 if something went wrong, no page get locked.
+ */
 static noinline_for_stack int
 lock_extent_buffer_for_io(struct extent_buffer *eb,
 			  struct btrfs_fs_info *fs_info,
 			  struct extent_page_data *epd)
 {
-	int i, num_pages;
+	int i, num_pages, failed_page_nr;
 	int flush = 0;
 	int ret = 0;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
-		flush = 1;
 		ret = flush_write_bio(epd);
-		BUG_ON(ret < 0);
+		if (ret < 0)
+			return ret;
+		flush = 1;
 		btrfs_tree_lock(eb);
 	}
 
@@ -3531,7 +3537,8 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 			return 0;
 		if (!flush) {
 			ret = flush_write_bio(epd);
-			BUG_ON(ret < 0);
+			if (ret < 0)
+				return ret;
 			flush = 1;
 		}
 		while (1) {
@@ -3573,7 +3580,10 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		if (!trylock_page(p)) {
 			if (!flush) {
 				ret = flush_write_bio(epd);
-				BUG_ON(ret < 0);
+				if (ret < 0) {
+					failed_page_nr = i;
+					goto err_unlock;
+				}
 				flush = 1;
 			}
 			lock_page(p);
@@ -3581,6 +3591,11 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	}
 
 	return ret;
+err_unlock:
+	/* Unlock these already locked pages */
+	for (i = 0; i < failed_page_nr; i++)
+		unlock_page(eb->pages[i]);
+	return ret;
 }
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
-- 
2.20.1

