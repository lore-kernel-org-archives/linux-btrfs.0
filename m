Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:39196 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3GDQYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 12:24:18 -0400
Received: by mail-we0-f182.google.com with SMTP id p60so1260894wes.41
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 09:24:17 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: fix optimization in btrfs_lookup_extent_info
Date: Thu,  4 Jul 2013 17:24:09 +0100
Message-Id: <1372955049-5051-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372952919-21010-1-git-send-email-fdmanana@gmail.com>
References: <1372952919-21010-1-git-send-email-fdmanana@gmail.com>
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

V2: If previous leaf item is for a different object, ensure the
search key has the target object id.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..875dea9 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1515,17 +1515,19 @@ again:
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
 
 		if (ret) {
 			btrfs_release_path(root, path);
+			key.objectid = bytenr;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = root->leafsize;
 			metadata = 0;
-- 
1.7.9.5

