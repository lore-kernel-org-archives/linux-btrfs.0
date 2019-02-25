Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF60C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 05:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC43C2087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 05:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfBYFut (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 00:50:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:54224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbfBYFus (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 00:50:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E56D4AE8D
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 05:50:46 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Use struct inode* to replace extent_io_tree::private_data
Date:   Mon, 25 Feb 2019 13:50:43 +0800
Message-Id: <20190225055043.1621-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All users of extent_io_tree::private_data are expecting struct inode*.
So just use struct inode* to replace extent_io_tree::private_data, and
this should provide better type check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 36 +++++++++++++++++-------------------
 fs/btrfs/extent_io.h |  4 ++--
 fs/btrfs/inode.c     |  2 +-
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e0a96f74e81e..2fd78b10830b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -89,7 +89,7 @@ void btrfs_leak_debug_check(void)
 static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 		struct extent_io_tree *tree, u64 start, u64 end)
 {
-	struct inode *inode = tree->private_data;
+	struct inode *inode = tree->inode;
 	u64 isize;
 
 	if (!inode || !is_data_inode(inode))
@@ -201,13 +201,13 @@ void __cold extent_io_exit(void)
 }
 
 void extent_io_tree_init(struct extent_io_tree *tree,
-			 void *private_data)
+			 struct inode *inode)
 {
 	tree->state = RB_ROOT;
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
-	tree->private_data = private_data;
+	tree->inode = inode;
 }
 
 static struct extent_state *alloc_extent_state(gfp_t mask)
@@ -376,9 +376,8 @@ static void merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->end == state->start - 1 &&
 		    other->state == state->state) {
-			if (tree->private_data &&
-			    is_data_inode(tree->private_data))
-				btrfs_merge_delalloc_extent(tree->private_data,
+			if (tree->inode && is_data_inode(tree->inode))
+				btrfs_merge_delalloc_extent(tree->inode,
 							    state, other);
 			state->start = other->start;
 			rb_erase(&other->rb_node, &tree->state);
@@ -391,9 +390,8 @@ static void merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->start == state->end + 1 &&
 		    other->state == state->state) {
-			if (tree->private_data &&
-			    is_data_inode(tree->private_data))
-				btrfs_merge_delalloc_extent(tree->private_data,
+			if (tree->inode && is_data_inode(tree->inode))
+				btrfs_merge_delalloc_extent(tree->inode,
 							    state, other);
 			state->end = other->end;
 			rb_erase(&other->rb_node, &tree->state);
@@ -464,8 +462,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 {
 	struct rb_node *node;
 
-	if (tree->private_data && is_data_inode(tree->private_data))
-		btrfs_split_delalloc_extent(tree->private_data, orig, split);
+	if (tree->inode && is_data_inode(tree->inode))
+		btrfs_split_delalloc_extent(tree->inode, orig, split);
 
 	prealloc->start = orig->start;
 	prealloc->end = split - 1;
@@ -512,8 +510,8 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 		tree->dirty_bytes -= range;
 	}
 
-	if (tree->private_data && is_data_inode(tree->private_data))
-		btrfs_clear_delalloc_extent(tree->private_data, state, bits);
+	if (tree->inode && is_data_inode(tree->inode))
+		btrfs_clear_delalloc_extent(tree->inode, state, bits);
 
 	ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
 	BUG_ON(ret < 0);
@@ -547,7 +545,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
 
 static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
-	struct inode *inode = tree->private_data;
+	struct inode *inode = tree->inode;
 
 	btrfs_panic(btrfs_sb(inode->i_sb), err,
 	"locking error: extent tree was modified by another thread while locked");
@@ -791,8 +789,8 @@ static void set_state_bits(struct extent_io_tree *tree,
 	unsigned bits_to_set = *bits & ~EXTENT_CTLBITS;
 	int ret;
 
-	if (tree->private_data && is_data_inode(tree->private_data))
-		btrfs_set_delalloc_extent(tree->private_data, state, bits);
+	if (tree->inode && is_data_inode(tree->inode))
+		btrfs_set_delalloc_extent(tree->inode, state, bits);
 
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
@@ -2378,8 +2376,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		"Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d",
 		read_mode, failrec->this_mirror, failrec->in_validation);
 
-	status = tree->ops->submit_bio_hook(tree->private_data, bio, failrec->this_mirror,
-					 failrec->bio_flags, 0);
+	status = tree->ops->submit_bio_hook(tree->inode, bio,
+				failrec->this_mirror, failrec->bio_flags, 0);
 	if (status) {
 		free_io_failure(failure_tree, tree, failrec);
 		bio_put(bio);
@@ -2706,7 +2704,7 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	bio->bi_private = NULL;
 
 	if (tree->ops)
-		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
+		ret = tree->ops->submit_bio_hook(tree->inode, bio,
 					   mirror_num, bio_flags, start);
 	else
 		btrfsic_submit_bio(bio);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9673be3f3d1f..b656d65bca83 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -109,7 +109,7 @@ struct extent_io_ops {
 
 struct extent_io_tree {
 	struct rb_root state;
-	void *private_data;
+	struct inode *inode;
 	u64 dirty_bytes;
 	int track_uptodate;
 	spinlock_t lock;
@@ -240,7 +240,7 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 					  u64 start, u64 len,
 					  int create);
 
-void extent_io_tree_init(struct extent_io_tree *tree, void *private_data);
+void extent_io_tree_init(struct extent_io_tree *tree, struct inode *inode);
 int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c349667c761..4fc82f582fa5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10403,7 +10403,7 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	struct inode *inode = tree->private_data;
+	struct inode *inode = tree->inode;
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
 	struct page *page;
-- 
2.20.1

