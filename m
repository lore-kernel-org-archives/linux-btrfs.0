Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C995C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 03:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9AC206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 03:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF9AC206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbeK2Ohn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 09:37:43 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57488 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727098AbeK2Ohn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 09:37:43 -0500
X-IronPort-AV: E=Sophos;i="5.56,292,1539619200"; 
   d="scan'208";a="48809483"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Nov 2018 11:33:48 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EEBF94B7348C;
        Thu, 29 Nov 2018 11:33:44 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 29 Nov
 2018 11:33:51 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <nborisov@suse.com>
Subject: [PATCH v2 1/3] btrfs: remove always true if branch in find_delalloc_range
Date:   Thu, 29 Nov 2018 11:33:38 +0800
Message-ID: <20181129033338.2647-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: EEBF94B7348C.AB1D8
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The @found is always false when it comes to the if branch. Besides, the
bool type is more suitable for @found. Change the return value of the
function and its caller to bool as well.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c             | 31 +++++++++++++++----------------
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/tests/extent-io-tests.c |  2 +-
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2769e92b556..4b6b87e63b4a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1452,16 +1452,16 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
  * find a contiguous range of bytes in the file marked as delalloc, not
  * more than 'max_bytes'.  start and end are used to return the range,
  *
- * 1 is returned if we find something, 0 if nothing was in the tree
+ * true is returned if we find something, false if nothing was in the tree
  */
-static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
+static noinline bool find_delalloc_range(struct extent_io_tree *tree,
 					u64 *start, u64 *end, u64 max_bytes,
 					struct extent_state **cached_state)
 {
 	struct rb_node *node;
 	struct extent_state *state;
 	u64 cur_start = *start;
-	u64 found = 0;
+	bool found = false;
 	u64 total_bytes = 0;
 
 	spin_lock(&tree->lock);
@@ -1472,8 +1472,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	 */
 	node = tree_search(tree, cur_start);
 	if (!node) {
-		if (!found)
-			*end = (u64)-1;
+		*end = (u64)-1;
 		goto out;
 	}
 
@@ -1493,7 +1492,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 			*cached_state = state;
 			refcount_inc(&state->refs);
 		}
-		found++;
+		found = true;
 		*end = state->end;
 		cur_start = state->end + 1;
 		node = rb_next(node);
@@ -1551,13 +1550,13 @@ static noinline int lock_delalloc_pages(struct inode *inode,
 }
 
 /*
- * find a contiguous range of bytes in the file marked as delalloc, not
- * more than 'max_bytes'.  start and end are used to return the range,
+ * find and lock a contiguous range of bytes in the file marked as delalloc,
+ * not more than 'max_bytes'.  start and end are used to return the range,
  *
- * 1 is returned if we find something, 0 if nothing was in the tree
+ * true is returned if we find something, false if nothing was in the tree
  */
 EXPORT_FOR_TESTS
-noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
+noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
 				    u64 *end)
@@ -1565,7 +1564,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
 	u64 delalloc_start;
 	u64 delalloc_end;
-	u64 found;
+	bool found;
 	struct extent_state *cached_state = NULL;
 	int ret;
 	int loops = 0;
@@ -1580,7 +1579,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 		*start = delalloc_start;
 		*end = delalloc_end;
 		free_extent_state(cached_state);
-		return 0;
+		return false;
 	}
 
 	/*
@@ -1612,7 +1611,7 @@ noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 			loops = 1;
 			goto again;
 		} else {
-			found = 0;
+			found = false;
 			goto out_failed;
 		}
 	}
@@ -3195,7 +3194,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 {
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	u64 page_end = delalloc_start + PAGE_SIZE - 1;
-	u64 nr_delalloc;
+	bool found;
 	u64 delalloc_to_write = 0;
 	u64 delalloc_end = 0;
 	int ret;
@@ -3203,11 +3202,11 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 
 
 	while (delalloc_end < page_end) {
-		nr_delalloc = find_lock_delalloc_range(inode, tree,
+		found = find_lock_delalloc_range(inode, tree,
 					       page,
 					       &delalloc_start,
 					       &delalloc_end);
-		if (nr_delalloc == 0) {
+		if (!found) {
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a1d3ea5a0d32..67881bca15fe 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -521,7 +521,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
 		    struct extent_io_tree *io_tree,
 		    struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-u64 find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
+bool find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
 			     struct page *locked_page, u64 *start,
 			     u64 *end);
 #endif
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d33f9a95bce1..3c46d7f23456 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -66,7 +66,7 @@ static int test_find_delalloc(u32 sectorsize)
 	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
 	u64 total_dirty = 2 * max_bytes;
 	u64 start, end, test_start;
-	u64 found;
+	bool found;
 	int ret = -EINVAL;
 
 	test_msg("running find delalloc tests");
-- 
2.19.2



