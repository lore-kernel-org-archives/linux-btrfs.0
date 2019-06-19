Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD5DC31E5B
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 00:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB962085A
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 00:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfFSAfo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Jun 2019 20:35:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:40270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfFSAfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jun 2019 20:35:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80698ABF3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 00:35:43 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs: Evaluate io_tree in find_lock_delalloc_range()
Date:   Tue, 18 Jun 2019 19:35:24 -0500
Message-Id: <20190619003524.32377-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Simplification.
No point passing the tree variable when it can be evaluated
from inode.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/extent_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index db337e53aab3..e9475d7e11bf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1719,10 +1719,10 @@ static noinline int lock_delalloc_pages(struct inode *inode,
  */
 EXPORT_FOR_TESTS
 noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
-				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
 				    u64 *end)
 {
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
 	u64 delalloc_start;
 	u64 delalloc_end;
@@ -3290,7 +3290,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 		struct page *page, struct writeback_control *wbc,
 		u64 delalloc_start, unsigned long *nr_written)
 {
-	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	u64 page_end = delalloc_start + PAGE_SIZE - 1;
 	bool found;
 	u64 delalloc_to_write = 0;
@@ -3300,8 +3299,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 
 
 	while (delalloc_end < page_end) {
-		found = find_lock_delalloc_range(inode, tree,
-					       page,
+		found = find_lock_delalloc_range(inode, page,
 					       &delalloc_start,
 					       &delalloc_end);
 		if (!found) {
-- 
2.16.4

