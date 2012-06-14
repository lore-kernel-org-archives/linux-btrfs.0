Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:44050 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab2FNRQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: remove call to btrfs_header_nritems with no effect
Date: Thu, 14 Jun 2012 19:16:33 +0200
Message-Id: <1339694198-13388-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a leftover from cleanup patch 559af821. Before the cleanup,
btrfs_header_nritems was called inside an if condition. As it has no side
effects we need to preserve here, it should simply be dropped.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d7a96cf..836e4e0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1650,8 +1650,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	btrfs_header_nritems(mid);
-
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
 		btrfs_tree_lock(left);
@@ -1681,7 +1679,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		wret = push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret = wret;
-		btrfs_header_nritems(mid);
 	}
 
 	/*
-- 
1.7.3.4

