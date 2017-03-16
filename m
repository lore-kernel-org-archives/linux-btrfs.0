Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33546 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751185AbdCPH7T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.2 01/16] btrfs: improve inode's outstanding_extents computation
Date: Thu, 16 Mar 2017 15:58:39 +0800
Message-ID: <20170316075854.15788-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

This issue was revealed by modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB,
When modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often
gets these warnings from btrfs_destroy_inode():
	WARN_ON(BTRFS_I(inode)->outstanding_extents);
	WARN_ON(BTRFS_I(inode)->reserved_extents);

Simple test program below can reproduce this issue steadily.
Note: you need to modify BTRFS_MAX_EXTENT_SIZE to 64KB to have test,
otherwise there won't be such WARNING.
	#include <string.h>
	#include <unistd.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>

	int main(void)
	{
		int fd;
		char buf[68 *1024];

		memset(buf, 0, 68 * 1024);
		fd = open("testfile", O_CREAT | O_EXCL | O_RDWR);
		pwrite(fd, buf, 68 * 1024, 64 * 1024);
		return;
	}

When BTRFS_MAX_EXTENT_SIZE is 64KB, and buffered data range is:
64KB						128K		132KB
|-----------------------------------------------|---------------|
                         64 + 4KB

1) for above data range, btrfs_delalloc_reserve_metadata() will reserve
metadata and set BTRFS_I(inode)->outstanding_extents to 2.
(68KB + 64KB - 1) / 64KB == 2

Outstanding_extents: 2

2) then btrfs_dirty_page() will be called to dirty pages and set
EXTENT_DELALLOC flag. In this case, btrfs_set_bit_hook() will be called
twice.
The 1st set_bit_hook() call will set DEALLOC flag for the first 64K.
64KB						128KB
|-----------------------------------------------|
	64KB DELALLOC
Outstanding_extents: 2

Set_bit_hooks() uses FIRST_DELALLOC flag to avoid re-increase
outstanding_extents counter.
So for 1st set_bit_hooks() call, it won't modify outstanding_extents,
it's still 2.

Then FIRST_DELALLOC flag is *CLEARED*.

3) 2nd btrfs_set_bit_hook() call.
Because FIRST_DELALLOC have been cleared by previous set_bit_hook(),
btrfs_set_bit_hook() will increase BTRFS_I(inode)->outstanding_extents by
one, so now BTRFS_I(inode)->outstanding_extents is 3.
64KB                                            128KB            132KB
|-----------------------------------------------|----------------|
	64K DELALLOC				   4K DELALLOC
Outstanding_extents: 3

But the correct outstanding_extents number should be 2, not 3.
The 2nd btrfs_set_bit_hook() call just screwed up this, and leads to the
WARN_ON().

Normally, we can solve it by only increasing outstanding_extents in
set_bit_hook().
But the problem is for delalloc_reserve/release_metadata(), we only have
a 'length' parameter, and calculate in-accurate outstanding_extents.
If we only rely on set_bit_hook() release_metadata() will crew things up
as it will decrease inaccurate number.

So the fix we use is:
1) Increase *INACCURATE* outstanding_extents at delalloc_reserve_meta
   Just as a place holder.
2) Increase *accurate* outstanding_extents at set_bit_hooks()
   This is the real increaser.
3) Decrease *INACCURATE* outstanding_extents before returning
   This makes outstanding_extents to correct value.

For 128M BTRFS_MAX_EXTENT_SIZE, due to limitation of
__btrfs_buffered_write(), each iteration will only handle about 2MB
data.
So btrfs_dirty_pages() won't need to handle cases cross 2 extents.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/inode.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c |  6 ++----
 3 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc28c607..73612ca10fd5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3148,6 +3148,8 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			       int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state, int dedupe);
+int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
+			    struct extent_state **cached_state);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c40060cc481f..c7bcb658e891 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1521,6 +1521,9 @@ static void btrfs_split_extent_hook(struct inode *inode,
 	if (!(orig->state & EXTENT_DELALLOC))
 		return;
 
+	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
+		return;
+
 	size = orig->end - orig->start + 1;
 	if (size > BTRFS_MAX_EXTENT_SIZE) {
 		u32 num_extents;
@@ -1560,6 +1563,9 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
+	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
+		return;
+
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
 	else
@@ -1655,7 +1661,6 @@ static void btrfs_del_delalloc_inode(struct btrfs_root *root,
 static void btrfs_set_bit_hook(struct inode *inode,
 			       struct extent_state *state, unsigned *bits)
 {
-
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
 	if ((*bits & EXTENT_DEFRAG) && !(*bits & EXTENT_DELALLOC))
@@ -1668,13 +1673,16 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
+		u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
+					    BTRFS_MAX_EXTENT_SIZE);
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
-		if (*bits & EXTENT_FIRST_DELALLOC) {
+		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
-		} else {
+
+		if (do_list) {
 			spin_lock(&BTRFS_I(inode)->lock);
-			BTRFS_I(inode)->outstanding_extents++;
+			BTRFS_I(inode)->outstanding_extents += num_extents;
 			spin_unlock(&BTRFS_I(inode)->lock);
 		}
 
@@ -1920,9 +1928,52 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state, int dedupe)
 {
+	int ret;
+	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
+				    BTRFS_MAX_EXTENT_SIZE);
+
+	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
+	ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
+				  cached_state);
+
+	/*
+	 * btrfs_delalloc_reserve_metadata() will first add number of
+	 * outstanding extents according to data length, which is inaccurate
+	 * for case like dirtying already dirty pages.
+	 * so here we will decrease such inaccurate numbers, to make
+	 * outstanding_extents only rely on the correct values added by
+	 * set_bit_hook()
+	 *
+	 * Also, we skipped the metadata space reserve for space cache inodes,
+	 * so don't modify the outstanding_extents value.
+	 */
+	if (ret == 0 && !btrfs_is_free_space_inode(BTRFS_I(inode))) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents -= num_extents;
+		spin_unlock(&BTRFS_I(inode)->lock);
+	}
+
+	return ret;
+}
+
+int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
+			    struct extent_state **cached_state)
+{
+	int ret;
+	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
+				    BTRFS_MAX_EXTENT_SIZE);
+
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
-	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   cached_state);
+	ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
+				cached_state);
+
+	if (ret == 0 && !btrfs_is_free_space_inode(BTRFS_I(inode))) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents -= num_extents;
+		spin_unlock(&BTRFS_I(inode)->lock);
+	}
+
+	return ret;
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dabfc7ac48a6..cc7382ec820f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1231,10 +1231,8 @@ static int cluster_pages_for_defrag(struct inode *inode,
 				(page_cnt - i_done) << PAGE_SHIFT);
 	}
 
-
-	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
-			  &cached_state);
-
+	btrfs_set_extent_defrag(inode, page_start,
+				page_end - 1, &cached_state);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
 			     GFP_NOFS);
-- 
2.12.0



