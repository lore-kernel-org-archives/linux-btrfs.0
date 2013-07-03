Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44581 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3GCMTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 08:19:30 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so53781wgg.32
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 05:19:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: optimize function btrfs_read_chunk_tree
Date: Wed,  3 Jul 2013 13:19:16 +0100
Message-Id: <1372853956-10569-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading all device items from the chunk tree, don't
exit the loop and then navigate down the tree again to find
the chunk items. Instead, if while reading the device items
we find a chunk item in the leaf keep iterating over the leaf
and process the chunk items - at the moment chunk items always
follow immediately the device items in the chunk tree, and if
this fact changes in the future, revert back to previous
behaviour of exiting the loop and navigate down the tree again
to search for chunk items, but use BTRFS_FIRST_CHUNK_TREE_OBJECTID
as the object id for the search key, as any chunk item has a
key that has this object id.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/volumes.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b2d1eac..4e969db 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5668,8 +5668,13 @@ again:
 		}
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 		if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-			if (found_key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
+			if (found_key.objectid != BTRFS_DEV_ITEMS_OBJECTID) {
+				if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
+					key.objectid = found_key.objectid;
+					continue;
+				}
 				break;
+			}
 			if (found_key.type == BTRFS_DEV_ITEM_KEY) {
 				struct btrfs_dev_item *dev_item;
 				dev_item = btrfs_item_ptr(leaf, slot,
@@ -5688,7 +5693,7 @@ again:
 		path->slots[0]++;
 	}
 	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-		key.objectid = 0;
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 		btrfs_release_path(path);
 		goto again;
 	}
-- 
1.7.9.5

