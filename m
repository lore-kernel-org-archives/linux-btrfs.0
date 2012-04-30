From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: remove call to btrfs_header_nritems with no effect
Date: Mon, 30 Apr 2012 11:23:48 +0200
Message-ID: <1335777828-23746-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a leftover from cleanup patch 559af821. Before the cleanup,
btrfs_header_nritems was called inside an if condition. As it has no side
effects we need to preserve here, it should simply be dropped.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e801f22..e93319d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -994,8 +994,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	btrfs_header_nritems(mid);
-
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
 		btrfs_tree_lock(left);
@@ -1025,7 +1023,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		wret = push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret = wret;
-		btrfs_header_nritems(mid);
 	}
 
 	/*
-- 
1.7.3.4

