Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:47662 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbcJGJbB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 05:31:01 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix infinite loop when tree log recovery
Date: Fri,  7 Oct 2016 17:30:47 +0800
Message-Id: <1475832647-14012-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

if log tree like below:
leaf N:
        ...
        item 240 key (282 DIR_LOG_ITEM 0) itemoff 8189 itemsize 8
                dir log end 1275809046
leaf N+1:
        item 0 key (282 DIR_LOG_ITEM 3936149215) itemoff 16275 itemsize 8
                dir log end 18446744073709551615
        ...

when start_ret > 1275809046, but slot[0] never >= nritems,
so never go to next leaf.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/tree-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ef9c55b..e63dd99 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1940,12 +1940,11 @@ static noinline int find_dir_range(struct btrfs_root *root,
 next:
 	/* check the next slot in the tree to see if it is a valid item */
 	nritems = btrfs_header_nritems(path->nodes[0]);
+	path->slots[0]++;
 	if (path->slots[0] >= nritems) {
 		ret = btrfs_next_leaf(root, path);
 		if (ret)
 			goto out;
-	} else {
-		path->slots[0]++;
 	}
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-- 
1.9.1

