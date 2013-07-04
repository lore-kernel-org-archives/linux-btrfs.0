Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54072 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3GDPuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 11:50:12 -0400
Received: by mail-wi0-f181.google.com with SMTP id hq4so1371126wib.14
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 08:50:10 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: fix optimization in btrfs_lookup_extent_info
Date: Thu,  4 Jul 2013 16:48:39 +0100
Message-Id: <1372952919-21010-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372869173-15043-1-git-send-email-fdmanana@gmail.com>
References: <1372869173-15043-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we did a tree search with the goal to find a metadata item
but the search failed with return value 1, we attempt to see
if in the same leaf there's a corresponding extent item, and if
there's one, just use it instead of doing another tree search
for this extent item. The check in the leaf was wrong because
it was seeking for a metadata item instead of an extent item.

This optimization was also being triggered incorrectly, as it
was evaluating path->slots which always evaluates to true. The
goal was to see if the leaf level slot was greater than zero
(i.e. not the first item in the leaf).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..22e6247 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1515,12 +1515,13 @@ again:
 	 * to make sure.
 	 */
 	if (ret > 0 && metadata) {
-		if (path->slots) {
+		if (path->slots[0]) {
 			path->slots[0]--;
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
-			    key.type == BTRFS_METADATA_ITEM_KEY)
+			    key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == root->leafsize)
 				ret = 0;
 		}
 
-- 
1.7.9.5

