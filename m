Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33479 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaDXNPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 09:15:49 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so1037877wgh.35
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 06:15:48 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: use correct key when repeating search for extent item
Date: Thu, 24 Apr 2014 15:15:28 +0100
Message-Id: <1398348929-1827-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If skinny metadata is enabled and our first tree search fails to find a
skinny extent item, we may repeat a tree search for a "fat" extent item
(if the previous item in the leaf is not the "fat" extent we're looking
for). However we were not setting the new key's objectid to the right
value, as we previously used the same key variable to peek at the previous
item in the leaf, which has a different objectid. So just set the right
objectid to avoid modifying/deleting a wrong item if we repeat the tree
search.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1306487..678cb35 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1542,6 +1542,7 @@ again:
 				ret = 0;
 		}
 		if (ret) {
+			key.objectid = bytenr;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = num_bytes;
 			btrfs_release_path(path);
@@ -5719,6 +5720,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 			if (ret > 0 && skinny_metadata) {
 				skinny_metadata = false;
+				key.objectid = bytenr;
 				key.type = BTRFS_EXTENT_ITEM_KEY;
 				key.offset = num_bytes;
 				btrfs_release_path(path);
-- 
1.9.1

