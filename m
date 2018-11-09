Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40A3C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B10320825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B10320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbeKIXta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:49824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728520AbeKIXta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E979EAFF5
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 8/9] btrfs: Remove extent_io_ops::merge_extent_hook callback
Date:   Fri,  9 Nov 2018 16:08:37 +0200
Message-Id: <20181109140838.10457-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is used only for data and free space inodes. Such inodes
are guaranteed to have their extent_io_tree::private_data set to the
inode struct. Exploit this fact to directly call the function. Also give
it a more descriptive name. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/extent_io.c | 17 ++++++++---------
 fs/btrfs/extent_io.h |  3 ---
 fs/btrfs/inode.c     | 16 ++++++----------
 4 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ca38bb8e7bf2..ba5c5bfbb4fe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3154,6 +3154,8 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 			       unsigned *bits);
 void btrfs_clear_delalloc_extent(struct inode *inode,
 				 struct extent_state *state, unsigned *bits);
+void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
+				 struct extent_state *other);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b9aadbf1a9f9..861a087025a9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -353,13 +353,6 @@ static inline struct rb_node *tree_search(struct extent_io_tree *tree,
 	return tree_search_for_insert(tree, offset, NULL, NULL);
 }
 
-static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
-		     struct extent_state *other)
-{
-	if (tree->ops && tree->ops->merge_extent_hook)
-		tree->ops->merge_extent_hook(tree->private_data, new, other);
-}
-
 /*
  * utility function to look for merge candidates inside a given range.
  * Any extents with matching state are merged together into a single
@@ -383,7 +376,10 @@ static void merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->end == state->start - 1 &&
 		    other->state == state->state) {
-			merge_cb(tree, state, other);
+			if (tree->private_data &&
+			    is_data_inode(tree->private_data))
+				btrfs_merge_delalloc_extent(tree->private_data,
+							    state, other);
 			state->start = other->start;
 			rb_erase(&other->rb_node, &tree->state);
 			RB_CLEAR_NODE(&other->rb_node);
@@ -395,7 +391,10 @@ static void merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->start == state->end + 1 &&
 		    other->state == state->state) {
-			merge_cb(tree, state, other);
+			if (tree->private_data &&
+			    is_data_inode(tree->private_data))
+				btrfs_merge_delalloc_extent(tree->private_data,
+							    state, other);
 			state->end = other->end;
 			rb_erase(&other->rb_node, &tree->state);
 			RB_CLEAR_NODE(&other->rb_node);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a3a3302f3625..7d181a378d90 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,9 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	void (*merge_extent_hook)(void *private_data,
-				  struct extent_state *new,
-				  struct extent_state *other);
 	void (*split_extent_hook)(void *private_data,
 				  struct extent_state *orig, u64 split);
 };
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5de0885bf8a8..7e8579787655 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1625,7 +1625,7 @@ static void btrfs_split_extent_hook(void *private_data,
 		u64 new_size;
 
 		/*
-		 * See the explanation in btrfs_merge_extent_hook, the same
+		 * See the explanation in btrfs_merge_delalloc_extent, the same
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
@@ -1642,16 +1642,13 @@ static void btrfs_split_extent_hook(void *private_data,
 }
 
 /*
- * extent_io.c merge_extent_hook, used to track merged delayed allocation
- * extents so we can keep track of new extents that are just merged onto old
- * extents, such as when we are doing sequential writes, so we can properly
- * account for the metadata space we'll need.
+ * Handle merged delayed allocation extents so we can keep track of new extents
+ * that are just merged onto old extents, such as when we are doing sequential
+ * writes, so we can properly account for the metadata space we'll need.
  */
-static void btrfs_merge_extent_hook(void *private_data,
-				    struct extent_state *new,
-				    struct extent_state *other)
+void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
+				 struct extent_state *other)
 {
-	struct inode *inode = private_data;
 	u64 new_size, old_size;
 	u32 num_extents;
 
@@ -10497,7 +10494,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
 };
 
-- 
2.17.1

