Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60396 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934182AbdERNSu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 09:18:50 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 11/15] fs-writeback: move wbc_to_write_flags out of line
Date: Thu, 18 May 2017 15:18:08 +0200
Message-Id: <20170518131812.22956-12-hch@lst.de>
In-Reply-To: <20170518131812.22956-1-hch@lst.de>
References: <20170518131812.22956-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This way writeback.h doesn't need to pull in blk_types.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c         | 13 +++++++++++++
 include/linux/writeback.h | 11 +----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 63ee2940775c..51b65591afe1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -59,6 +59,19 @@ struct wb_writeback_work {
 	struct wb_completion *done;	/* set if the caller waits */
 };
 
+#ifdef CONFIG_BLOCK
+int wbc_to_write_flags(struct writeback_control *wbc)
+{
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		return REQ_SYNC;
+	else if (wbc->for_kupdate || wbc->for_background)
+		return REQ_BACKGROUND;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wbc_to_write_flags);
+#endif
+
 /*
  * If one wants to wait for one or more wb_writeback_works, each work's
  * ->done should be set to a wb_completion defined using the following
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d5815794416c..c5ae6ef9b317 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -9,7 +9,6 @@
 #include <linux/fs.h>
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
-#include <linux/blk_types.h>
 
 struct bio;
 
@@ -103,15 +102,7 @@ struct writeback_control {
 #endif
 };
 
-static inline int wbc_to_write_flags(struct writeback_control *wbc)
-{
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		return REQ_SYNC;
-	else if (wbc->for_kupdate || wbc->for_background)
-		return REQ_BACKGROUND;
-
-	return 0;
-}
+int wbc_to_write_flags(struct writeback_control *wbc);
 
 /*
  * A wb_domain represents a domain that wb's (bdi_writeback's) belong to
-- 
2.11.0

