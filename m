Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91706C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B99520657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B99520657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbeKAVMl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:46022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728369AbeKAVMl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3062AAFBB
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:58 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/8] btrfs: Remove extent_io_ops::split_extent_hook callback
Date:   Thu,  1 Nov 2018 14:09:53 +0200
Message-Id: <1541074194-22227-9-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the counterpart to merge_extent_hook, similarly, it's used only
for data/freespace inodes so let's remove it, rename it and call it
directly where necessary. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/extent_io.c | 10 ++--------
 fs/btrfs/extent_io.h |  6 ------
 fs/btrfs/inode.c     |  8 ++------
 4 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1f0025a0268b..c20ef001f9af 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3156,6 +3156,8 @@ void btrfs_clear_delalloc_extent(struct inode *inode,
 				 struct extent_state *state, unsigned *bits);
 void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 				 struct extent_state *other);
+void btrfs_split_delalloc_extent(struct inode *inode,
+				 struct extent_state *orig, u64 split);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ee7e6ec3878d..8c9073f28f6f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -443,13 +443,6 @@ static int insert_state(struct extent_io_tree *tree,
 	return 0;
 }
 
-static void split_cb(struct extent_io_tree *tree, struct extent_state *orig,
-		     u64 split)
-{
-	if (tree->ops && tree->ops->split_extent_hook)
-		tree->ops->split_extent_hook(tree->private_data, orig, split);
-}
-
 /*
  * split a given extent state struct in two, inserting the preallocated
  * struct 'prealloc' as the newly created second half.  'split' indicates an
@@ -469,7 +462,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 {
 	struct rb_node *node;
 
-	split_cb(tree, orig, split);
+	if (tree->private_data)
+		btrfs_split_delalloc_extent(tree->private_data, orig, split);
 
 	prealloc->start = orig->start;
 	prealloc->end = split - 1;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7d181a378d90..d96fd534f144 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -102,12 +102,6 @@ struct extent_io_ops {
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-
-	/*
-	 * Optional hooks, called if the pointer is not NULL
-	 */
-	void (*split_extent_hook)(void *private_data,
-				  struct extent_state *orig, u64 split);
 };
 
 struct extent_io_tree {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 448fad3a8b74..c38733c44b98 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1611,10 +1611,9 @@ int run_delalloc_range(void *private_data, struct page *locked_page,
 	return ret;
 }
 
-static void btrfs_split_extent_hook(void *private_data,
-				    struct extent_state *orig, u64 split)
+void btrfs_split_delalloc_extent(struct inode *inode,
+				 struct extent_state *orig, u64 split)
 {
-	struct inode *inode = private_data;
 	u64 size;
 
 	/* not delalloc, ignore it */
@@ -10500,9 +10499,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
-
-	/* optional callbacks */
-	.split_extent_hook = btrfs_split_extent_hook,
 };
 
 /*
-- 
2.7.4

