Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33128 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaG1Rhq (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 28 Jul 2014 13:37:46 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: avoid unnecessary switch of path locks to blocking mode
Date: Mon, 28 Jul 2014 19:37:17 +0100
Message-Id: <1406572637-13766-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we need to cow a node, increase the write lock level and retry the
tree search, there's no point of changing the node locks in our path
to blocking mode, as we only waste time and unnecessarily wake up other
tasks waiting on the spinning locks (just to block them again shortly
after) because we release our path before repeating the tree search.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index bd0ae3e..783ea3b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2792,8 +2792,6 @@ again:
 			if (!should_cow_block(trans, root, b))
 				goto cow_done;
 
-			btrfs_set_path_blocking(p);
-
 			/*
 			 * must have write locks on this node and the
 			 * parent
@@ -2807,6 +2805,7 @@ again:
 				goto again;
 			}
 
+			btrfs_set_path_blocking(p);
 			err = btrfs_cow_block(trans, root, b,
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
-- 
1.9.1

