Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42967 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab3GOQnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 12:43:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AEE2A7C0645
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 10:43:19 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id w5fCi2H2HIfUBk28 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 10:43:08 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix lock leak when resuming snapshot deletion
Date: Mon, 15 Jul 2013 12:43:06 -0400
Message-ID: <1373906586-3271-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't setting path->locks[level] when we resume a snapshot deletion which
means we won't unlock the buffer when we free the path.  This causes deadlocks
if we happen to re-allocate the block before we've evicted the extent buffer
from cache.  Thanks,

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8c204e1..997a5dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7555,6 +7555,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -7570,6 +7571,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
-- 
1.7.7.6

