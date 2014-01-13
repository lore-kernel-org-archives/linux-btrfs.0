Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64941 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaAMTfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 14:35:19 -0500
Received: by mail-wg0-f49.google.com with SMTP id a1so4726650wgh.28
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 11:35:18 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: faster file extent item search in clone ioctl
Date: Mon, 13 Jan 2014 19:35:01 +0000
Message-Id: <1389641701-19162-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1389475828-19339-1-git-send-email-fdmanana@gmail.com>
References: <1389475828-19339-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we are looking for file extent items that intersect the cloning
range, for each one that falls completely outside the range, don't
release the path and do another full tree search - just move on
to the next slot and copy the file extent item into our buffer only
if the item intersects the cloning range.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Set path->leave_spinning to 1.
V3: Reset path->leave_spinning to 0 before path is used by btrfs_drop_extents,
    as that function allocates memory without GFP_ATOMIC and therefore can
    sleep.

 fs/btrfs/ioctl.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3970f32..25301bb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2905,12 +2905,14 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
+		path->leave_spinning = 1;
 		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
 				0, 0);
 		if (ret < 0)
 			goto out;
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
+process_slot:
 		if (path->slots[0] >= nritems) {
 			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
 			if (ret < 0)
@@ -2937,11 +2939,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			u8 comp;
 			u64 endoff;
 
-			size = btrfs_item_size_nr(leaf, slot);
-			read_extent_buffer(leaf, buf,
-					   btrfs_item_ptr_offset(leaf, slot),
-					   size);
-
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
 			comp = btrfs_file_extent_compression(leaf, extent);
@@ -2960,11 +2957,20 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				datal = btrfs_file_extent_ram_bytes(leaf,
 								    extent);
 			}
-			btrfs_release_path(path);
 
 			if (key.offset + datal <= off ||
-			    key.offset >= off + len - 1)
-				goto next;
+			    key.offset >= off + len - 1) {
+				path->slots[0]++;
+				goto process_slot;
+			}
+
+			size = btrfs_item_size_nr(leaf, slot);
+			read_extent_buffer(leaf, buf,
+					   btrfs_item_ptr_offset(leaf, slot),
+					   size);
+
+			btrfs_release_path(path);
+			path->leave_spinning = 0;
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.objectid = btrfs_ino(inode);
@@ -3135,7 +3141,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			}
 			ret = btrfs_end_transaction(trans, root);
 		}
-next:
 		btrfs_release_path(path);
 		key.offset++;
 	}
-- 
1.7.9.5

