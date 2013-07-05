Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54543 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3GEWXm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 18:23:42 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2298192wgh.11
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 15:23:41 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: optimize function btrfs_read_chunk_tree
Date: Fri,  5 Jul 2013 23:23:04 +0100
Message-Id: <1373062984-12641-1-git-send-email-fdmanana@gmail.com>
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

This is a port of the corresponding kernel patch to keep both
kernel and btrfs-progs identical:

https://patchwork.kernel.org/patch/2816401/

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 volumes.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 0ff2283..22d0f31 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1740,8 +1740,13 @@ again:
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
@@ -1758,7 +1763,7 @@ again:
 		path->slots[0]++;
 	}
 	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-		key.objectid = 0;
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 		btrfs_release_path(root, path);
 		goto again;
 	}
-- 
1.7.9.5

