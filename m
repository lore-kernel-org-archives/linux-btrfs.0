Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:41172 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3G2SgC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 14:36:02 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so4286833wes.20
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 11:36:00 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: optimize function btrfs_read_chunk_tree
Date: Mon, 29 Jul 2013 19:35:49 +0100
Message-Id: <1375122949-6596-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373062984-12641-1-git-send-email-fdmanana@gmail.com>
References: <1373062984-12641-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading all device items from the chunk tree, don't
exit the loop and then navigate down the tree again to find
the chunk items. Instead just read all device items and
chunk items with a single tree search. This is possible
because all device items are found before any chunk item in
the chunks tree.

This is a port of the corresponding kernel patch to keep both
kernel and btrfs-progs identical:

https://patchwork.kernel.org/patch/2835105/

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simplified logic inside the loop
    (suggested by Josef Bacik on irc).

 volumes.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/volumes.c b/volumes.c
index 0ff2283..2c69f28 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1718,14 +1718,13 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
-	/* first we search for all of the device items, and then we
-	 * read in all of the chunk items.  This way we can create chunk
-	 * mappings that reference all of the devices that are afound
-	 */
+	/* Read all device items, and then all the chunk items. All
+	   device items are found before any chunk item (their object id
+	   is smaller than the lowest possible object id for a chunk
+	   item - BTRFS_FIRST_CHUNK_TREE_OBJECTID). */
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.offset = 0;
 	key.type = 0;
-again:
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	while(1) {
 		leaf = path->nodes[0];
@@ -1739,16 +1738,12 @@ again:
 			break;
 		}
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
-		if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-			if (found_key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
-				break;
-			if (found_key.type == BTRFS_DEV_ITEM_KEY) {
-				struct btrfs_dev_item *dev_item;
-				dev_item = btrfs_item_ptr(leaf, slot,
+		if (found_key.type == BTRFS_DEV_ITEM_KEY) {
+			struct btrfs_dev_item *dev_item;
+			dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
-				ret = read_one_dev(root, leaf, dev_item);
-				BUG_ON(ret);
-			}
+			ret = read_one_dev(root, leaf, dev_item);
+			BUG_ON(ret);
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
@@ -1757,11 +1752,6 @@ again:
 		}
 		path->slots[0]++;
 	}
-	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-		key.objectid = 0;
-		btrfs_release_path(root, path);
-		goto again;
-	}
 
 	ret = 0;
 error:
-- 
1.7.9.5

