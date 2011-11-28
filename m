Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45764 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755180Ab1K1Tds (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:48 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWXHJ020803
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:34 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWX9T012410
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:33 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWWCl020354
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:32 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWWMb020353
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:32 -0200
Message-Id: <52a707b613e2f12dac7d8f15a9092ed98f46c7d9.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sun, 27 Nov 2011 22:07:11 -0200
Subject: [PATCH 08/20] Btrfs: try to allocate from cluster even at
 LOOP_NO_EMPTY_SIZE
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we reach LOOP_NO_EMPTY_SIZE, we won't even try to use a cluster that
others might have set up.  Odds are that there won't be one, but if
someone else succeeded in setting it up, we might as well use it, even
if we don't try to set up a cluster again.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 24eef3a..9eec362 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5271,15 +5271,10 @@ alloc:
 		spin_unlock(&block_group->free_space_ctl->tree_lock);
 
 		/*
-		 * Ok we want to try and use the cluster allocator, so lets look
-		 * there, unless we are on LOOP_NO_EMPTY_SIZE, since we will
-		 * have tried the cluster allocator plenty of times at this
-		 * point and not have found anything, so we are likely way too
-		 * fragmented for the clustering stuff to find anything, so lets
-		 * just skip it and let the allocator find whatever block it can
-		 * find
+		 * Ok we want to try and use the cluster allocator, so
+		 * lets look there
 		 */
-		if (last_ptr && loop < LOOP_NO_EMPTY_SIZE) {
+		if (last_ptr) {
 			/*
 			 * the refill lock keeps out other
 			 * people trying to start a new cluster
@@ -5328,6 +5323,20 @@ alloc:
 			}
 			spin_unlock(&last_ptr->lock);
 refill_cluster:
+			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
+			 * set up a new clusters, so lets just skip it
+			 * and let the allocator find whatever block
+			 * it can find.  If we reach this point, we
+			 * will have tried the cluster allocator
+			 * plenty of times and not have found
+			 * anything, so we are likely way too
+			 * fragmented for the clustering stuff to find
+			 * anything.  */
+			if (loop >= LOOP_NO_EMPTY_SIZE) {
+				spin_unlock(&last_ptr->refill_lock);
+				goto unclustered_alloc;
+			}
+
 			/*
 			 * this cluster didn't work out, free it and
 			 * start over
@@ -5375,6 +5384,7 @@ refill_cluster:
 			goto loop;
 		}
 
+unclustered_alloc:
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
 		/*
-- 
1.7.4.4

