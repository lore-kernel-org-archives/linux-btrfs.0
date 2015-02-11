Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4805 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100AbbBKB7W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 20:59:22 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix 2 extent buffer leak in btrfs-debug-tree.
Date: Wed, 11 Feb 2015 09:57:17 +0800
Message-ID: <1423619837-24073-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are 2 known extent buffer:
1) With -t option.
-t option will skip other tree roots, but it will read the root node
first and then skip it.
Where it forgets to free the tree block it read.

2) with -b option.
It forgets to free the tree block it read.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-debug-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index ce7a792..610624e 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -221,6 +221,7 @@ int main(int ac, char **av)
 			goto close_root;
 		}
 		btrfs_print_tree(root, leaf, 0);
+		free_extent_buffer(leaf);
 		goto close_root;
 	}
 
@@ -284,8 +285,10 @@ again:
 					      0);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
-			if (tree_id && found_key.objectid != tree_id)
+			if (tree_id && found_key.objectid != tree_id) {
+				free_extent_buffer(buf);
 				goto next;
+			}
 
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
-- 
2.3.0

