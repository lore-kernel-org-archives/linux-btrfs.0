Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32890 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3JNXNL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 19:13:11 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so5271635wgg.8
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 16:13:09 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix btrfs_prev_leaf() previous key computation
Date: Tue, 15 Oct 2013 00:12:27 +0100
Message-Id: <1381792347-32504-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we decrement the key type, we must reset its offset to the largest
possible offset (u64)-1. If we decrement the key's objectid, then we
must reset the key's type and offset to their largest possible values,
(u8)-1 and (u64)-1 respectively. Not doing so can make us miss an
items in the tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 33e9dbd..6d426b2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4827,14 +4827,18 @@ static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, 0);
 
-	if (key.offset > 0)
+	if (key.offset > 0) {
 		key.offset--;
-	else if (key.type > 0)
+	} else if (key.type > 0) {
 		key.type--;
-	else if (key.objectid > 0)
+		key.offset = (u64)-1;
+	} else if (key.objectid > 0) {
 		key.objectid--;
-	else
+		key.type = (u8)-1;
+		key.offset = (u64)-1;
+	} else {
 		return 1;
+	}
 
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-- 
1.7.9.5

