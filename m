Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52182 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaEaANe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 20:13:34 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so2666859wgh.8
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 17:13:33 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: avoid visiting all extent items when cloning a range
Date: Sat, 31 May 2014 02:13:25 +0100
Message-Id: <1401498805-11034-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401469001-26866-1-git-send-email-fdmanana@gmail.com>
References: <1401469001-26866-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cloning a range of a file, we were visiting all the extent items in
the btree that belong to our source inode. We don't need to visit those
extent items that don't overlap the range we are cloning, as doing so only
makes us waste time and do unnecessary btree navigations (btrfs_next_leaf)
for inodes that have a large number of file extent items in the btree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Leave the loop as soon as we process the last extent, to avoid
    one extra and unnecessary btree search.

 fs/btrfs/ioctl.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 603c036..ecf56af 100644
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
@@ -3296,6 +3313,8 @@ process_slot:
 				goto out;
 			}
 			ret = btrfs_end_transaction(trans, root);
+			if (ret || (new_key.offset + datal >= destoff + len))
+				break;
 		}
 		btrfs_release_path(path);
 		key.offset++;
@@ -3303,7 +3322,6 @@ process_slot:
 	ret = 0;
 
 out:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	vfree(buf);
 	return ret;
-- 
1.9.1

