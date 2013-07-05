Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43406 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3GEUc3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 16:32:29 -0400
Received: by mail-wg0-f45.google.com with SMTP id j13so2311062wgh.12
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 13:32:28 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: optimize btrfs_lookup_extent_info()
Date: Fri,  5 Jul 2013 21:32:05 +0100
Message-Id: <1373056325-622-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're looking for a metadata item in the tree and the
search fails with return value of 1, and the slot doesn't
point to the first item in the leaf, check if the previous
item in the leaf corresponds to an extent item for the same
object id - if it does, then don't do another tree search
to get it.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..dd8c7f3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -771,10 +771,22 @@ again:
 		goto out_free;
 
 	if (ret > 0 && metadata && key.type == BTRFS_METADATA_ITEM_KEY) {
-		key.type = BTRFS_EXTENT_ITEM_KEY;
-		key.offset = root->leafsize;
-		btrfs_release_path(path);
-		goto again;
+		if (path->slots[0]) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == root->leafsize)
+				ret = 0;
+		}
+		if (ret) {
+			key.objectid = bytenr;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = root->leafsize;
+			btrfs_release_path(path);
+			goto again;
+		}
 	}
 
 	if (ret == 0) {
-- 
1.7.9.5

