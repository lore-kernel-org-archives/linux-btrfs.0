Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37223 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:13 -0400
Received: by mail-qt0-f196.google.com with SMTP id n6-v6so29179346qtl.4
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 20/36] btrfs: don't use ctl->free_space for max_extent_size
Date: Tue, 11 Sep 2018 13:57:51 -0400
Message-Id: <20180911175807.26181-21-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

max_extent_size is supposed to be the largest contiguous range for the
space info, and ctl->free_space is the total free space in the block
group.  We need to keep track of these separately and _only_ use the
max_free_space if we don't have a max_extent_size, as that means our
original request was too large to search any of the block groups for and
therefore wouldn't have a max_extent_size set.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e43834380ce6..ac7b740be4ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7484,6 +7484,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
+	u64 max_free_space = 0;
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -7779,8 +7780,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			spin_lock(&ctl->tree_lock);
 			if (ctl->free_space <
 			    num_bytes + empty_cluster + empty_size) {
-				if (ctl->free_space > max_extent_size)
-					max_extent_size = ctl->free_space;
+				max_free_space = max(max_free_space,
+						     ctl->free_space);
 				spin_unlock(&ctl->tree_lock);
 				goto loop;
 			}
@@ -7947,6 +7948,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret == -ENOSPC) {
+		if (!max_extent_size)
+			max_extent_size = max_free_space;
 		spin_lock(&space_info->lock);
 		space_info->max_extent_size = max_extent_size;
 		spin_unlock(&space_info->lock);
-- 
2.14.3
