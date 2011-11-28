Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45765 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755187Ab1K1Tdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:49 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWhpl020827
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:44 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWgXU012445
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:43 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWgqd020444
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:42 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWd6w020407
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:39 -0200
Message-Id: <d78be8bb80741815a02f2c1c0217c644aef988dd.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 00:04:33 -0200
Subject: [PATCH 15/20] Btrfs: activate allocation debugging
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Activate various messages that help track down clustered allocation
problems, that are disabled and optimized out by default.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 823ab22..66edda2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5216,7 +5216,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		allowed_chunk_alloc = 1;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
-		/* debug = 1; */
+		debug = 1;
 		debugid = atomic_inc_return(&debugcnt);
 		last_ptr = &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
@@ -5393,7 +5393,7 @@ alloc:
 				goto checks;
 			}
 
-			/* debug = 2; */
+			debug = 2;
 			if (debug > 1)
 				printk(KERN_DEBUG "btrfs %x.%i: failed cluster alloc\n",
 				       debugid, loop);
@@ -5446,7 +5446,7 @@ refill_cluster:
 			 * this cluster didn't work out, free it and
 			 * start over
 			 */
-			/* debug = 2; */
+			debug = 2;
 			if ((debug > 1 || (debug && last_ptr->block_group)) && last_ptr->window_start)
 				btrfs_dump_cluster(KERN_DEBUG, debugid, loop, 0, "drop", last_ptr);
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
-- 
1.7.4.4

