Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38135 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeH3VqS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:18 -0400
Received: by mail-qt0-f193.google.com with SMTP id x7-v6so11304685qtk.5
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:43:03 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 19/35] btrfs: don't use ctl->free_space for max_extent_size
Date: Thu, 30 Aug 2018 13:42:09 -0400
Message-Id: <20180830174225.2200-20-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
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
index 664b867ae499..ca98c39308f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7460,6 +7460,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
+	u64 max_free_space = 0;
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -7755,8 +7756,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
@@ -7923,6 +7924,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
