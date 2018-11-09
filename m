Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D64CC43610
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02D9620825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02D9620825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbeKIXtc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:49814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728707AbeKIXtc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D9B2AF80
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 9/9] btrfs: Remove extent_io_ops::split_extent_hook callback
Date:   Fri,  9 Nov 2018 16:08:38 +0200
Message-Id: <20181109140838.10457-10-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the counterpart to merge_extent_hook, similarly, it's used only
for data/freespace inodes so let's remove it, rename it and call it
directly where necessary. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/extent_io.c | 10 ++--------
 fs/btrfs/extent_io.h |  6 ------
 fs/btrfs/inode.c     |  8 ++------
 4 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ba5c5bfbb4fe..a1f6334011b9 100644
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
index 861a087025a9..160efb201ef3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -445,13 +445,6 @@ static int insert_state(struct extent_io_tree *tree,
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
@@ -471,7 +464,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 {
 	struct rb_node *node;
 
-	split_cb(tree, orig, split);
+	if (tree->private_data && is_data_inode(tree->private_data))
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
index 7e8579787655..700b7d2fa6c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1609,10 +1609,9 @@ int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
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
@@ -10492,9 +10491,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
-
-	/* optional callbacks */
-	.split_extent_hook = btrfs_split_extent_hook,
 };
 
 /*
-- 
2.17.1

