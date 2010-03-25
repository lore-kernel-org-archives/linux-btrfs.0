From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 16/18] btrfs: add NULL check for do_walk_down()
Date: Thu, 25 Mar 2010 20:37:12 +0800
Message-ID: <4BAB58F8.4060301@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

btrfs_find_create_tree_block() may return NULL, so we must check the returned
value, or we will access a NULL pointer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1727b26..503a18e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5205,6 +5205,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	next = btrfs_find_tree_block(root, bytenr, blocksize);
 	if (!next) {
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
+		if (!next)
+			return -ENOMEM;
 		reada = 1;
 	}
 	btrfs_tree_lock(next);
@@ -5417,7 +5419,8 @@ static noinline int walk_down_tree(struct btrfs_trans_handle *trans,
 		if (ret > 0) {
 			path->slots[level]++;
 			continue;
-		}
+		} else if (ret < 0)
+			return ret;
 		level = wc->level;
 	}
 	return 0;
-- 
1.6.5.2


