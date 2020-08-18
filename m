Return-Path: <SRS0=WNKx=B4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC708C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD02F20738
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHRGa6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 02:30:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:34498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgHRGa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Aug 2020 02:30:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D9819AE35;
        Tue, 18 Aug 2020 06:31:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Merge inode_can_compress in inode_need_compress
Date:   Tue, 18 Aug 2020 09:30:56 +0300
Message-Id: <20200818063056.9094-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The latter is the only caller of the former. Just open code can_compress
into need_compress and also remove the warning since it's made redundant
by this change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15dc8b6871ac..19e1918bad5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -410,17 +410,6 @@ static noinline int add_async_extent(struct async_chunk *cow,
 	return 0;
 }
 
-/*
- * Check if the inode has flags compatible with compression
- */
-static inline bool inode_can_compress(struct btrfs_inode *inode)
-{
-	if (inode->flags & BTRFS_INODE_NODATACOW ||
-	    inode->flags & BTRFS_INODE_NODATASUM)
-		return false;
-	return true;
-}
-
 /*
  * Check if the inode needs to be submitted to compression, based on mount
  * options, defragmentation, properties or heuristics.
@@ -430,12 +419,9 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	if (!inode_can_compress(inode)) {
-		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
-			KERN_ERR "BTRFS: unexpected compression for ino %llu\n",
-			btrfs_ino(inode));
+	if (inode->flags & BTRFS_INODE_NODATACOW ||
+	    inode->flags & BTRFS_INODE_NODATASUM)
 		return 0;
-	}
 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
@@ -1833,8 +1819,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 	} else if (inode->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_can_compress(inode) ||
-		   !inode_need_compress(inode, start, end)) {
+	} else if (!inode_need_compress(inode, start, end)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				     page_started, nr_written, 1);
 	} else {
-- 
2.17.1

