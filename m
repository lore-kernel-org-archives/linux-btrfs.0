Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5606CC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D700205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D700205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbeJZUUM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:33552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727582AbeJZUUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D16CB039
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Sink find_lock_delalloc_range's 'max_bytes' argument
Date:   Fri, 26 Oct 2018 14:43:20 +0300
Message-Id: <1540554201-11305-5-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All callers of this function pass BTRFS_MAX_EXTENT_SIZE (128M) so let's
reduce the argument count and make that a local variable. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c             | 11 +++++------
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6877a74c7469..1a9a521aefe5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1566,8 +1566,9 @@ static noinline int lock_delalloc_pages(struct inode *inode,
 static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
-				    u64 *end, u64 max_bytes)
+				    u64 *end)
 {
+	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
 	u64 delalloc_start;
 	u64 delalloc_end;
 	u64 found;
@@ -1647,10 +1648,9 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 u64 btrfs_find_lock_delalloc_range(struct inode *inode,
 				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
-				    u64 *end, u64 max_bytes)
+				    u64 *end)
 {
-	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
-			max_bytes);
+	return find_lock_delalloc_range(inode, tree, locked_page, start, end);
 }
 #endif
 
@@ -3233,8 +3233,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 		nr_delalloc = find_lock_delalloc_range(inode, tree,
 					       page,
 					       &delalloc_start,
-					       &delalloc_end,
-					       BTRFS_MAX_EXTENT_SIZE);
+					       &delalloc_end);
 		if (nr_delalloc == 0) {
 			delalloc_start = delalloc_end + 1;
 			continue;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 369daa5d4f73..7ec4f93caf78 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -549,7 +549,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
 u64 btrfs_find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
 				      struct page *locked_page, u64 *start,
-				      u64 *end, u64 max_bytes);
+				      u64 *end);
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					       u64 start);
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 9e0f4a01be14..8ea8c2aa6696 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -107,7 +107,7 @@ static int test_find_delalloc(u32 sectorsize)
 	start = 0;
 	end = 0;
 	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-					 &end, max_bytes);
+					 &end);
 	if (!found) {
 		test_err("should have found at least one delalloc");
 		goto out_bits;
@@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
 	start = test_start;
 	end = 0;
 	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-					 &end, max_bytes);
+					 &end);
 	if (!found) {
 		test_err("couldn't find delalloc in our range");
 		goto out_bits;
@@ -172,7 +172,7 @@ static int test_find_delalloc(u32 sectorsize)
 	start = test_start;
 	end = 0;
 	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-					 &end, max_bytes);
+					 &end);
 	if (found) {
 		test_err("found range when we shouldn't have");
 		goto out_bits;
@@ -193,7 +193,7 @@ static int test_find_delalloc(u32 sectorsize)
 	start = test_start;
 	end = 0;
 	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-					 &end, max_bytes);
+					 &end);
 	if (!found) {
 		test_err("didn't find our range");
 		goto out_bits;
@@ -234,7 +234,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * tests expected behavior.
 	 */
 	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
-					 &end, max_bytes);
+					 &end);
 	if (!found) {
 		test_err("didn't find our range");
 		goto out_bits;
-- 
2.7.4

