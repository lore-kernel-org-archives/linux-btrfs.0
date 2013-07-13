Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54427 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3GMNPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 09:15:17 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so1523957wiv.3
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jul 2013 06:15:15 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: optimize btrfs_lookup_extent_info()
Date: Sat, 13 Jul 2013 14:14:46 +0100
Message-Id: <1373721286-11665-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373056325-622-1-git-send-email-fdmanana@gmail.com>
References: <1373056325-622-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're looking for a metadata item in the tree and the
search fails with return value of 1, and the slot doesn't
point to the first item in the leaf, check if the previous
item in the leaf corresponds to an extent item for the same
object id - if it does, then don't do another tree search
to get it.

This optimization is already done by btrfs-progs.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: updated commit message to mention this is already done in
    btrfs-progs.
V3: moved version information out of the commit message, as
    David Sterba notified me this is the correct way of
    adding patch version information.

 fs/btrfs/extent-tree.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..4b19c88 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -771,10 +771,23 @@ again:
 		goto out_free;
 
 	if (ret > 0 && metadata && key.type == BTRFS_METADATA_ITEM_KEY) {
-		key.type = BTRFS_EXTENT_ITEM_KEY;
-		key.offset = root->leafsize;
-		btrfs_release_path(path);
-		goto again;
+		metadata = 0;
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

