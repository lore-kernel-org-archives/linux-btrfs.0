Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43967 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757933AbaGCKUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s63AKisY013548
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 18:20:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH RESEND 3/9] Btrfs: make defragment work with nodatacow option
Date: Thu, 3 Jul 2014 18:22:07 +0800
Message-ID: <1404382933-26672-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Btrfs defragment will utilize COW feature, which means this
did not work for nodatacow option, this problem was detected
by xfstests generic/018 with nodatacow mount option.

Fix this problem by forcing cow for a extent with state
@EXTETN_DEFRAG setting.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |  6 ++++++
 fs/btrfs/inode.c       | 39 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a0cf3e5..01cfcba 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -127,6 +127,12 @@ struct btrfs_inode {
 	u64 delalloc_bytes;
 
 	/*
+	 * total number of bytes pending defrag, used by stat to check whether
+	 * it needs COW.
+	 */
+	u64 defrag_bytes;
+
+	/*
 	 * the size of the file stored in the metadata on disk.  data=ordered
 	 * means the in-memory i_size might be larger than the size on disk
 	 * because not all the blocks are written yet.
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6b65fab..a616fa4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1425,6 +1425,26 @@ error:
 	return ret;
 }
 
+static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
+{
+
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
+	    !(BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC))
+		return 0;
+
+	/*
+	 * @defrag_bytes is a hint value, no spinlock held here,
+	 * if is not zero, it means the file is defragging.
+	 * Force cow if given extent needs to be defragged.
+	 */
+	if (BTRFS_I(inode)->defrag_bytes &&
+	    test_range_bit(&BTRFS_I(inode)->io_tree, start, end,
+			   EXTENT_DEFRAG, 0, NULL))
+		return 1;
+
+	return 0;
+}
+
 /*
  * extent_io.c call back to do delayed allocation processing
  */
@@ -1434,11 +1454,12 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int force_cow = need_force_cow(inode, start, end);
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
-	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC) {
+	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	} else if (!btrfs_test_opt(root, COMPRESS) &&
@@ -1535,6 +1556,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
 			       struct extent_state *state, unsigned long *bits)
 {
 
+	if ((*bits & EXTENT_DEFRAG) && !(*bits & EXTENT_DELALLOC))
+		WARN_ON(1);
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
 	 * but in this case, we are only testing for the DELALLOC
@@ -1557,6 +1580,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
 				     root->fs_info->delalloc_batch);
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
+		if (*bits & EXTENT_DEFRAG)
+			BTRFS_I(inode)->defrag_bytes += len;
 		if (do_list && !test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
 					 &BTRFS_I(inode)->runtime_flags))
 			btrfs_add_delalloc_inodes(root, inode);
@@ -1571,6 +1596,13 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 				 struct extent_state *state,
 				 unsigned long *bits)
 {
+	u64 len = state->end + 1 - state->start;
+
+	spin_lock(&BTRFS_I(inode)->lock);
+	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
+		BTRFS_I(inode)->defrag_bytes -= len;
+	spin_unlock(&BTRFS_I(inode)->lock);
+
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
 	 * but in this case, we are only testing for the DELALLOC
@@ -1578,7 +1610,6 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 	 */
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
-		u64 len = state->end + 1 - state->start;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
@@ -8089,6 +8120,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
+	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
 	ei->csum_bytes = 0;
@@ -8148,6 +8180,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->csum_bytes);
+	WARN_ON(BTRFS_I(inode)->defrag_bytes);
 
 	/*
 	 * This can happen where we create an inode, but somebody else also
-- 
1.9.3

