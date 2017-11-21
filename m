Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49382 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdKUFzF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 21 Nov 2017 00:55:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: extent-tree: Use round up to replace align macro
Date: Tue, 21 Nov 2017 13:54:45 +0800
Message-Id: <20171121055445.13972-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To save reader seconds before checking if it's rounding up or down.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 309a109069f1..8ab18e25cb91 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2054,7 +2054,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 {
 	int j, ret = 0;
 	u64 bytes_left, end;
-	u64 aligned_start = ALIGN(start, 1 << 9);
+	u64 aligned_start = round_up(start, 1 << 9);
 
 	if (WARN_ON(start != aligned_start)) {
 		len -= aligned_start - start;
@@ -4266,7 +4266,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 	int have_pinned_space;
 
 	/* make sure bytes are sectorsize aligned */
-	bytes = ALIGN(bytes, fs_info->sectorsize);
+	bytes = round_up(bytes, fs_info->sectorsize);
 
 	if (btrfs_is_free_space_inode(inode)) {
 		need_commit = 0;
@@ -6080,7 +6080,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	if (delalloc_lock)
 		mutex_lock(&inode->delalloc_mutex);
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
+	num_bytes = round_up(num_bytes, fs_info->sectorsize);
 
 	/* Add our new extents and calculate the new rsv size. */
 	spin_lock(&inode->lock);
@@ -6135,7 +6135,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
+	num_bytes = round_up(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
 	inode->csum_bytes -= num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -7818,7 +7818,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			goto loop;
 		}
 checks:
-		search_start = ALIGN(offset, fs_info->stripesize);
+		search_start = round_up(offset, fs_info->stripesize);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
-- 
2.15.0

