Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59329 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3G3LDQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 07:03:16 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so6005327wgg.24
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 04:03:15 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: optimize function btrfs_read_chunk_tree
Date: Tue, 30 Jul 2013 12:03:04 +0100
Message-Id: <1375182184-30490-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372853956-10569-1-git-send-email-fdmanana@gmail.com>
References: <1372853956-10569-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading all device items from the chunk tree, don't
exit the loop and then navigate down the tree again to find
the chunk items. Instead just read all device items and
chunk items with a single tree search. This is possible
because all device items are found before any chunk item in
the chunks tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Simplified logic inside the loop
    (suggested by Josef Bacik on irc).
V3: Updated comment to comply with kernel coding style.

 fs/btrfs/volumes.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 090f57c..125a60e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5676,14 +5676,15 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	mutex_lock(&uuid_mutex);
 	lock_chunks(root);
 
-	/* first we search for all of the device items, and then we
-	 * read in all of the chunk items.  This way we can create chunk
-	 * mappings that reference all of the devices that are afound
+	/*
+	 * Read all device items, and then all the chunk items. All
+	 * device items are found before any chunk item (their object id
+	 * is smaller than the lowest possible object id for a chunk
+	 * item - BTRFS_FIRST_CHUNK_TREE_OBJECTID).
 	 */
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.offset = 0;
 	key.type = 0;
-again:
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto error;
@@ -5699,17 +5700,13 @@ again:
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
-				if (ret)
-					goto error;
-			}
+			ret = read_one_dev(root, leaf, dev_item);
+			if (ret)
+				goto error;
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
@@ -5719,11 +5716,6 @@ again:
 		}
 		path->slots[0]++;
 	}
-	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
-		key.objectid = 0;
-		btrfs_release_path(path);
-		goto again;
-	}
 	ret = 0;
 error:
 	unlock_chunks(root);
-- 
1.7.9.5

