Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61665 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3JROnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 10:43:06 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so3879970wgh.14
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 07:43:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: optimize extent item search in run_delayed_extent_op
Date: Fri, 18 Oct 2013 15:42:56 +0100
Message-Id: <1382107376-3290-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of doing another extent tree search if the first search failed
to find a metadata item, check if the previous item in the leaf is an
extent item and use it if it is, otherwise do the second tree search
for an extent item.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9be5e35..7baefe4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2138,15 +2138,28 @@ again:
 	}
 	if (ret > 0) {
 		if (metadata) {
-			btrfs_release_path(path);
-			metadata = 0;
+			if (path->slots[0] > 0) {
+				path->slots[0]--;
+				btrfs_item_key_to_cpu(path->nodes[0], &key,
+						      path->slots[0]);
+				if (key.objectid == node->bytenr &&
+				    key.type == BTRFS_EXTENT_ITEM_KEY &&
+				    key.offset == node->num_bytes)
+					ret = 0;
+			}
+			if (ret > 0) {
+				btrfs_release_path(path);
+				metadata = 0;
 
-			key.offset = node->num_bytes;
-			key.type = BTRFS_EXTENT_ITEM_KEY;
-			goto again;
+				key.objectid = node->bytenr;
+				key.offset = node->num_bytes;
+				key.type = BTRFS_EXTENT_ITEM_KEY;
+				goto again;
+			}
+		} else {
+			err = -EIO;
+			goto out;
 		}
-		err = -EIO;
-		goto out;
 	}
 
 	leaf = path->nodes[0];
-- 
1.7.9.5

