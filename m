Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45770 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755212Ab1K1Tdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:50 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWVIY020787
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:32 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWUMT012396
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:30 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWUG5020339
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:30 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWTFa020338
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:29 -0200
Message-Id: <30ef0d36400d907e98d2c7145de6260d48b6978b.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sat, 26 Nov 2011 21:53:29 -0200
Subject: [PATCH 05/20] Btrfs: start search for new cluster at the beginning
 of the block group
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of starting at zero (offset is always zero), request a cluster
starting at search_start, that denotes the beginning of the current
block group.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bc0f13d..7edb9e6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5287,10 +5287,8 @@ alloc:
 			spin_lock(&last_ptr->refill_lock);
 			if (last_ptr->block_group &&
 			    (last_ptr->block_group->ro ||
-			    !block_group_bits(last_ptr->block_group, data))) {
-				offset = 0;
+			    !block_group_bits(last_ptr->block_group, data)))
 				goto refill_cluster;
-			}
 
 			offset = btrfs_alloc_from_cluster(block_group, last_ptr,
 						 num_bytes, search_start);
@@ -5341,7 +5339,7 @@ refill_cluster:
 			/* allocate a cluster in this block group */
 			ret = btrfs_find_space_cluster(trans, root,
 					       block_group, last_ptr,
-					       offset, num_bytes,
+					       search_start, num_bytes,
 					       empty_cluster + empty_size);
 			if (ret == 0) {
 				/*
-- 
1.7.4.4

