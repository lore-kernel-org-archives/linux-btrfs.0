Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC78C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 903FF20820
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 903FF20820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbeKAVMj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:45980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728345AbeKAVMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CDC5AC11
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:56 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/8] btrfs: Remove extent_io_ops::fill_delalloc
Date:   Thu,  1 Nov 2018 14:09:46 +0200
Message-Id: <1541074194-22227-2-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is called only from writepage_delalloc which in turn
is guaranteed to be called from the data page writeout path. In the end
there is no reason to have the call to this function to be indrected
via the extent_io_ops structure. This patch removes the callback
definition, exports the function and calls it directly. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     |  3 +++
 fs/btrfs/extent_io.c | 14 ++++++--------
 fs/btrfs/extent_io.h |  5 -----
 fs/btrfs/inode.c     | 10 +++++-----
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68ca41dbbef3..dbeb5b2486d5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3186,6 +3186,9 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    struct btrfs_trans_handle *trans, int mode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
+int run_delalloc_range(void *private_data, struct page *locked_page, u64 start,
+		       u64 end, int *page_started, unsigned long *nr_written,
+		       struct writeback_control *wbc);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6877a74c7469..2e6191aa25f3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3205,7 +3205,7 @@ static void update_nr_written(struct writeback_control *wbc,
 /*
  * helper for __extent_writepage, doing all of the delayed allocation setup.
  *
- * This returns 1 if our fill_delalloc function did all the work required
+ * This returns 1 if run_delalloc_range function did all the work required
  * to write the page (copy into inline extent).  In this case the IO has
  * been started and the page is already unlocked.
  *
@@ -3226,7 +3226,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 	int ret;
 	int page_started = 0;
 
-	if (epd->extent_locked || !tree->ops || !tree->ops->fill_delalloc)
+	if (epd->extent_locked)
 		return 0;
 
 	while (delalloc_end < page_end) {
@@ -3239,15 +3239,13 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		ret = tree->ops->fill_delalloc(inode, page,
-					       delalloc_start,
-					       delalloc_end,
-					       &page_started,
-					       nr_written, wbc);
+		ret = run_delalloc_range(inode, page, delalloc_start,
+					 delalloc_end, &page_started,
+					 nr_written, wbc);
 		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
-			/* fill_delalloc should be return < 0 for error
+			/* run_delalloc_range should return < 0 for error
 			 * but just in case, we use > 0 here meaning the
 			 * IO is started, so we don't want to return > 0
 			 * unless things are going well.
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 369daa5d4f73..ca48187b86ba 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,11 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	int (*fill_delalloc)(void *private_data, struct page *locked_page,
-			     u64 start, u64 end, int *page_started,
-			     unsigned long *nr_written,
-			     struct writeback_control *wbc);
-
 	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f4d31fd62eed..aa6d6b64a70a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -109,8 +109,8 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of the
- * fill_delalloc() callback already does proper cleanup for the first page of
+ * extent (btrfs_finish_ordered_io()). Also note that the caller of
+ * run_delalloc_range already does proper cleanup for the first page of
  * the range, that is, it invokes the callback writepage_end_io_hook() for the
  * range of the first page.
  */
@@ -1577,9 +1577,10 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
 }
 
 /*
- * extent_io.c call back to do delayed allocation processing
+ * Function to process delayed allocation (create CoW) for ranges which are
+ * being touched for the first time.
  */
-static int run_delalloc_range(void *private_data, struct page *locked_page,
+int run_delalloc_range(void *private_data, struct page *locked_page,
 			      u64 start, u64 end, int *page_started,
 			      unsigned long *nr_written,
 			      struct writeback_control *wbc)
@@ -10521,7 +10522,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.fill_delalloc = run_delalloc_range,
 	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.writepage_start_hook = btrfs_writepage_start_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
-- 
2.7.4

