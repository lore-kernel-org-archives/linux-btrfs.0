Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63190 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KYDVQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 22:21:16 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so3287965wgg.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 19:21:15 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: try harder to avoid btree node splits
Date: Mon, 25 Nov 2013 03:20:46 +0000
Message-Id: <1385349646-6210-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When attempting to move items from our target leaf to its neighbor
leaves (right and left), we only need to free data_size - free_space
bytes from our leaf in order to add the new item (which has size of
data_size bytes). Therefore attempt to move items to the right and
left leaves if they have at least data_size - free_space bytes free,
instead of data_size bytes free.

After 5 runs of the following test, I got a smaller number of btree
node splits overall:

sysbench --test=fileio --file-num=512 --file-total-size=5G \
  --file-test-mode=seqwr --num-threads=512 \
   --file-block-size=8192 --max-requests=100000 --file-io-mode=sync

Before this change:
* 6171 splits (average of 5 test runs)
* 61.508Mb/sec of throughput (average of 5 test runs)

After this change:
* 6036 splits (average of 5 test runs)
* 63.533Mb/sec of throughput (average of 5 test runs)

An ideal test would not just have multiple threads/processes writing
to a file (insertion of file extent items) but also do other operations
that result in insertion of items with varied sizes, like file/directory
creations, creation of links, symlinks, xattrs, etc.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2262980..11f9a18 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3929,14 +3929,17 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 	int progress = 0;
 	int slot;
 	u32 nritems;
+	int space_needed = data_size;
 
 	slot = path->slots[0];
+	if (slot < btrfs_header_nritems(path->nodes[0]))
+		space_needed -= btrfs_leaf_free_space(root, path->nodes[0]);
 
 	/*
 	 * try to push all the items after our slot into the
 	 * right leaf
 	 */
-	ret = push_leaf_right(trans, root, path, 1, data_size, 0, slot);
+	ret = push_leaf_right(trans, root, path, 1, space_needed, 0, slot);
 	if (ret < 0)
 		return ret;
 
@@ -3956,7 +3959,7 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 
 	/* try to push all the items before our slot into the next leaf */
 	slot = path->slots[0];
-	ret = push_leaf_left(trans, root, path, 1, data_size, 0, slot);
+	ret = push_leaf_left(trans, root, path, 1, space_needed, 0, slot);
 	if (ret < 0)
 		return ret;
 
@@ -4000,13 +4003,18 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 
 	/* first try to make some room by pushing left and right */
 	if (data_size && path->nodes[1]) {
-		wret = push_leaf_right(trans, root, path, data_size,
-				       data_size, 0, 0);
+		int space_needed = data_size;
+
+		if (slot < btrfs_header_nritems(l))
+			space_needed -= btrfs_leaf_free_space(root, l);
+
+		wret = push_leaf_right(trans, root, path, space_needed,
+				       space_needed, 0, 0);
 		if (wret < 0)
 			return wret;
 		if (wret) {
-			wret = push_leaf_left(trans, root, path, data_size,
-					      data_size, 0, (u32)-1);
+			wret = push_leaf_left(trans, root, path, space_needed,
+					      space_needed, 0, (u32)-1);
 			if (wret < 0)
 				return wret;
 		}
-- 
1.7.9.5

