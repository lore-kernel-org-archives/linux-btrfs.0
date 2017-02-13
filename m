Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34813 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdBMXn2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 18:43:28 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: try to avoid acquiring free space ctl's lock
Date: Mon, 13 Feb 2017 15:42:30 -0800
Message-Id: <1487029350-13037-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to take the lock if the block group has not been cached.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b2b0b82..6832047 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7715,18 +7715,19 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 			last_ptr->fragmented = 1;
 			spin_unlock(&last_ptr->lock);
 		}
-		spin_lock(&block_group->free_space_ctl->tree_lock);
-		if (cached &&
-		    block_group->free_space_ctl->free_space <
-		    num_bytes + empty_cluster + empty_size) {
-			if (block_group->free_space_ctl->free_space >
-			    max_extent_size)
-				max_extent_size =
-					block_group->free_space_ctl->free_space;
-			spin_unlock(&block_group->free_space_ctl->tree_lock);
-			goto loop;
+		if (cached) {
+			struct btrfs_free_space_ctl *ctl =
+				block_group->free_space_ctl;
+			spin_lock(&ctl->tree_lock);
+			if (ctl->free_space <
+			    num_bytes + empty_cluster + empty_size) {
+				if (ctl->free_space > max_extent_size)
+					max_extent_size = ctl->free_space;
+				spin_unlock(&ctl->tree_lock);
+				goto loop;
+			}
+			spin_unlock(&ctl->tree_lock);
 		}
-		spin_unlock(&block_group->free_space_ctl->tree_lock);
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size,
-- 
2.5.5

