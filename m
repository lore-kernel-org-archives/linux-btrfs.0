Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45766 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755192Ab1K1Tdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:50 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWa9V020808
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:37 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWYXO012415
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:34 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWXRa020359
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:33 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWXgN020358
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:33 -0200
Message-Id: <215228eef80c9bd7e268a9f7a98c87573a15d005.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sun, 27 Nov 2011 00:05:09 -0200
Subject: [PATCH 09/20] Btrfs: skip allocation attempt from empty cluster
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we don't have a cluster, don't bother trying to allocate from it,
jumping right away to the attempt to allocate a new cluster.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9eec362..92e640b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5280,9 +5280,9 @@ alloc:
 			 * people trying to start a new cluster
 			 */
 			spin_lock(&last_ptr->refill_lock);
-			if (last_ptr->block_group &&
-			    (last_ptr->block_group->ro ||
-			    !block_group_bits(last_ptr->block_group, data)))
+			if (!last_ptr->block_group ||
+			    last_ptr->block_group->ro ||
+			    !block_group_bits(last_ptr->block_group, data))
 				goto refill_cluster;
 
 			offset = btrfs_alloc_from_cluster(block_group, last_ptr,
-- 
1.7.4.4

