Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35925 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3GEWMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 18:12:21 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so2358711wgh.14
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 15:12:20 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: optimize btrfs_lookup_extent_info()
Date: Fri,  5 Jul 2013 23:12:06 +0100
Message-Id: <1373062326-11292-1-git-send-email-fdmanana@gmail.com>
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

V2: updated commit message.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
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

