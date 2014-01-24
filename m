Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63680 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaAXRma (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 12:42:30 -0500
Received: by mail-we0-f169.google.com with SMTP id u57so3046643wes.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 09:42:29 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: make send's file extent item search more efficient
Date: Fri, 24 Jan 2014 17:42:09 +0000
Message-Id: <1390585329-11627-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of looking for a file extent item, process it, release the path
and do a btree search for the next file extent item, just process all
file extent items in a leaf without intermediate btree searches. This way
we save cpu and we're not blocking other tasks or affecting concurrency on
the btree, because send's paths use the commit root and skip btree node/leaf
locking.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 78aba99..306f9a9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4569,17 +4569,25 @@ static int process_all_extents(struct send_ctx *sctx)
 	key.objectid = sctx->cmp_key->objectid;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
-	while (1) {
-		ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
-		if (ret < 0)
-			goto out;
-		if (ret) {
-			ret = 0;
-			goto out;
-		}
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
 
+	while (1) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
+
+		if (slot >= btrfs_header_nritems(eb)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			continue;
+		}
+
 		btrfs_item_key_to_cpu(eb, &found_key, slot);
 
 		if (found_key.objectid != key.objectid ||
@@ -4592,8 +4600,7 @@ static int process_all_extents(struct send_ctx *sctx)
 		if (ret < 0)
 			goto out;
 
-		btrfs_release_path(path);
-		key.offset = found_key.offset + 1;
+		path->slots[0]++;
 	}
 
 out:
-- 
1.7.9.5

