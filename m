Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65384 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaE3P4w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 11:56:52 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so2165844wgh.17
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 08:56:50 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: avoid visiting all extent items when cloning a range
Date: Fri, 30 May 2014 17:56:41 +0100
Message-Id: <1401469001-26866-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cloning a range of a file, we were visiting all the extent items in
the btree that belong to our source inode. We don't need to visit those
extent items that don't overlap the range we are cloning, as doing so only
makes us waste time and do unnecessary btree navigations (btrfs_next_leaf)
for inodes that have a large number of file extent items in the btree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 603c036..f20d91d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3025,7 +3025,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	/* clone data */
 	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
-	key.offset = 0;
+	key.offset = off;
 
 	while (1) {
 		/*
@@ -3037,6 +3037,17 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				0, 0);
 		if (ret < 0)
 			goto out;
+		/*
+		 * First search, if no extent item that starts at offset off was
+		 * found but the previous item is an extent item, it's possible
+		 * it might overlap our target range, therefore process it.
+		 */
+		if (key.offset == off && ret > 0 && path->slots[0] > 0) {
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0] - 1);
+			if (key.type == BTRFS_EXTENT_DATA_KEY)
+				path->slots[0]--;
+		}
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
 process_slot:
@@ -3086,10 +3097,16 @@ process_slot:
 								    extent);
 			}
 
-			if (key.offset + datal <= off ||
-			    key.offset >= off + len - 1) {
+			/*
+			 * The first search might have left us at an extent
+			 * item that ends before our target range's start, can
+			 * happen if we have holes and NO_HOLES feature enabled.
+			 */
+			if (key.offset + datal <= off) {
 				path->slots[0]++;
 				goto process_slot;
+			} else if (key.offset >= off + len) {
+				break;
 			}
 
 			size = btrfs_item_size_nr(leaf, slot);
-- 
1.9.1

