Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B70BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AEFB20825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AEFB20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbeKIXt2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728683AbeKIXt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09DAAAFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 2/9] btrfs: Remove extent_io_ops::fill_delalloc
Date:   Fri,  9 Nov 2018 16:08:31 +0200
Message-Id: <20181109140838.10457-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is called only from writepage_delalloc which in turn is
guaranteed to be called from the data page writeout path. In the end
there is no reason to have the call to this function to be indrected via
the extent_io_ops structure. This patch removes the callback definition,
exports the function and calls it directly. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ rename to btrfs_run_delalloc_range ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     |  3 +++
 fs/btrfs/extent_io.c | 20 +++++++++-----------
 fs/btrfs/extent_io.h |  5 -----
 fs/btrfs/inode.c     | 15 +++++++--------
 4 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80953528572d..3a92dc6d71c6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3186,6 +3186,9 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    struct btrfs_trans_handle *trans, int mode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
+int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+		u64 start, u64 end, int *page_started, unsigned long *nr_written,
+		struct writeback_control *wbc);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d228f706ff3e..dbc42025b203 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3205,7 +3205,7 @@ static void update_nr_written(struct writeback_control *wbc,
 /*
  * helper for __extent_writepage, doing all of the delayed allocation setup.
  *
- * This returns 1 if our fill_delalloc function did all the work required
+ * This returns 1 if btrfs_run_delalloc_range function did all the work required
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
@@ -3239,18 +3239,16 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		ret = tree->ops->fill_delalloc(inode, page,
-					       delalloc_start,
-					       delalloc_end,
-					       &page_started,
-					       nr_written, wbc);
+		ret = btrfs_run_delalloc_range(inode, page, delalloc_start,
+				delalloc_end, &page_started, nr_written, wbc);
 		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
-			/* fill_delalloc should be return < 0 for error
-			 * but just in case, we use > 0 here meaning the
-			 * IO is started, so we don't want to return > 0
-			 * unless things are going well.
+			/*
+			 * btrfs_run_delalloc_range should return < 0 for error
+			 * but just in case, we use > 0 here meaning the IO is
+			 * started, so we don't want to return > 0 unless
+			 * things are going well.
 			 */
 			ret = ret < 0 ? ret : -EIO;
 			goto done;
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
index e725992615d1..d5529c46e129 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -109,8 +109,8 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of the
- * fill_delalloc() callback already does proper cleanup for the first page of
+ * extent (btrfs_finish_ordered_io()). Also note that the caller of
+ * btrfs_run_delalloc_range already does proper cleanup for the first page of
  * the range, that is, it invokes the callback writepage_end_io_hook() for the
  * range of the first page.
  */
@@ -1576,12 +1576,12 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
 }
 
 /*
- * extent_io.c call back to do delayed allocation processing
+ * Function to process delayed allocation (create CoW) for ranges which are
+ * being touched for the first time.
  */
-static int run_delalloc_range(void *private_data, struct page *locked_page,
-			      u64 start, u64 end, int *page_started,
-			      unsigned long *nr_written,
-			      struct writeback_control *wbc)
+int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+		u64 start, u64 end, int *page_started, unsigned long *nr_written,
+		struct writeback_control *wbc)
 {
 	struct inode *inode = private_data;
 	int ret;
@@ -10514,7 +10514,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.fill_delalloc = run_delalloc_range,
 	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.writepage_start_hook = btrfs_writepage_start_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
-- 
2.17.1

