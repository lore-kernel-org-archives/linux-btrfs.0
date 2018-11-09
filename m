Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A58FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCE220825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BCE220825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbeKIXta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:49830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728696AbeKIXta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6E84AFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:43 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6/9] btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
Date:   Fri,  9 Nov 2018 16:08:35 +0200
Message-Id: <20181109140838.10457-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is used to properly account delalloc extents for data
inodes (ordinary file inodes and freespace v1 inodes). Those can be
easily identified since they have their extent_io trees ->private_data
member point to the inode. Let's exploit this fact to remove the
needless indirection through extent_io_hooks and directly call the
function. Also give the function a name which reflects its purpose -
btrfs_set_delalloc_extent.

This patch also modified test_find_delalloc so that the extent_io_tree
used for testing doesn't have its ->private_data set which would have
caused a crash in btrfs_set_delalloc_extent due to the btrfs_inode->root
member not being initialised. The old version of the code also didn't
call set_bit_hook since the extent_io ops weren't set for the inode.  No
functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h                 |  2 ++
 fs/btrfs/extent_io.c             | 11 +++--------
 fs/btrfs/extent_io.h             |  2 --
 fs/btrfs/inode.c                 | 12 ++++--------
 fs/btrfs/tests/extent-io-tests.c |  2 +-
 5 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f7df6bc8b8a8..071a6144d2eb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3150,6 +3150,8 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
 			     u64 new_dirid);
+void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
+			       unsigned *bits);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c63334c6b008..1678adae7963 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -404,13 +404,6 @@ static void merge_state(struct extent_io_tree *tree,
 	}
 }
 
-static void set_state_cb(struct extent_io_tree *tree,
-			 struct extent_state *state, unsigned *bits)
-{
-	if (tree->ops && tree->ops->set_bit_hook)
-		tree->ops->set_bit_hook(tree->private_data, state, bits);
-}
-
 static void clear_state_cb(struct extent_io_tree *tree,
 			   struct extent_state *state, unsigned *bits)
 {
@@ -809,7 +802,9 @@ static void set_state_bits(struct extent_io_tree *tree,
 	unsigned bits_to_set = *bits & ~EXTENT_CTLBITS;
 	int ret;
 
-	set_state_cb(tree, state, bits);
+	if (tree->private_data && is_data_inode(tree->private_data))
+		btrfs_set_delalloc_extent(tree->private_data, state, bits);
+
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		tree->dirty_bytes += range;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3cb84a0fbaab..b3235d46b5c3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,8 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	void (*set_bit_hook)(void *private_data, struct extent_state *state,
-			     unsigned *bits);
 	void (*clear_bit_hook)(void *private_data,
 			struct extent_state *state,
 			unsigned *bits);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbe956e1a50f..1a17f88b73df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1755,15 +1755,12 @@ static void btrfs_del_delalloc_inode(struct btrfs_root *root,
 }
 
 /*
- * extent_io.c set_bit_hook, used to track delayed allocation
- * bytes in this file, and to maintain the list of inodes that
- * have pending delalloc work to be done.
+ * Properly track delayed allocation bytes in the inode and to maintain the
+ * list of inodes that have pending delalloc work to be done.
  */
-static void btrfs_set_bit_hook(void *private_data,
-			       struct extent_state *state, unsigned *bits)
+void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
+			       unsigned *bits)
 {
-	struct inode *inode = private_data;
-
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
 	if ((*bits & EXTENT_DEFRAG) && !(*bits & EXTENT_DELALLOC))
@@ -10500,7 +10497,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 9e0f4a01be14..ac8b5e35797d 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -76,7 +76,7 @@ static int test_find_delalloc(u32 sectorsize)
 		return -ENOMEM;
 	}
 
-	extent_io_tree_init(&tmp, inode);
+	extent_io_tree_init(&tmp, NULL);
 
 	/*
 	 * First go through and create and mark all of our pages dirty, we pin
-- 
2.17.1

