Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2GFJVY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 05:21:24 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q669LHXV009993
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Jul 2012 17:21:18 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4 v2] Btrfs: fix a bug of writting free space cache during balance
Date: Fri, 6 Jul 2012 17:31:34 +0800
Message-Id: <1341567096-30304-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the whole story:
1)
A free space cache consists of two parts:
o  free space cache inode, which is special becase it's stored in root tree.
o  free space info, which is stored as the above inode's file data.

But we only build up another new inode and does not flush its free space info
onto disk when we _clear and setup_ free space cache, and this ends up with
that the block group cache's cache_state remains DC_SETUP instead of DC_WRITTEN.

And holding DC_SETUP means that we will not truncate this free space cache inode,
which means the disk offset of its file extent will remain _unchanged_ at least
until next transaction finishes committing itself.

2)
We can set a block group readonly when we relocate the block group.

However,
if the readonly block group covers the disk offset where our free space cache
inode is going to write, it will force the free space cache inode into
cow_file_range() and it'll end up hitting a BUG_ON.

3)
Due to the above analysis, we fix this bug by adding the missing dirty flag.

4)
However, it's not over, there is still another case, nospace_cache.

With nospace_cache, we do not want to set dirty flag, instead we just truncate
free space cache inode and bail out with setting cache state DC_WRITTEN.

We can benifit from it since it saves us another 'pre-allocation' part which
usually costs a lot.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
v1->v2: figure out the real deep cause of this bug and keep free space cache
        logic reasonable.

 fs/btrfs/extent-tree.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0469398..ae01bc8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2903,8 +2903,13 @@ again:
 	}
 
 	spin_lock(&block_group->lock);
-	if (block_group->cached != BTRFS_CACHE_FINISHED) {
-		/* We're not cached, don't bother trying to write stuff out */
+	if (block_group->cached != BTRFS_CACHE_FINISHED ||
+	    !btrfs_test_opt(root, SPACE_CACHE)) {
+		/*
+		 * don't bother trying to write stuff out _if_
+		 * a) we're not cached,
+		 * b) we're with nospace_cache mount option.
+		 */
 		dcs = BTRFS_DC_WRITTEN;
 		spin_unlock(&block_group->lock);
 		goto out_put;
@@ -7643,8 +7648,21 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
 
-		if (need_clear)
+		if (need_clear) {
+			/*
+			 * When we mount with old space cache, we need to
+			 * set BTRFS_DC_CLEAR and set dirty flag.
+			 *
+			 * a) Setting 'BTRFS_DC_CLEAR' makes sure that we
+			 *    truncate the old free space cache inode and
+			 *    setup a new one.
+			 * b) Setting 'dirty flag' makes sure that we flush
+			 *    the new space cache info onto disk.
+			 */
 			cache->disk_cache_state = BTRFS_DC_CLEAR;
+			if (btrfs_test_opt(root, SPACE_CACHE))
+				cache->dirty = 1;
+		}
 
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
-- 
1.6.5.2

