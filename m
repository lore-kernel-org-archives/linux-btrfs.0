Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52991 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaEGLKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 07:10:50 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so1102454wiw.16
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 04:10:49 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: check, fix csum check in the presence of non-inlined refs
Date: Wed,  7 May 2014 13:09:14 +0100
Message-Id: <1399464554-899-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we have non-inlined extent references, we were failing to find the
corresponding extent item for an existing csum item in the csum tree.

Reproducer:

   mkfs.btrfs -f /dev/sdd
   mount /dev/sdd /mnt

   xfs_io -f -c "falloc 780366 135302" /mnt/foo
   xfs_io -c "falloc 327680 151552" /mnt/foo
   xfs_io -c "pwrite -S 0xff -b 131072 0 131072" /mnt/foo
   sync

   for i in `seq 1 40`; do btrfs subvolume snapshot /mnt /mnt/snap$i ; done
   umount /mnt

   btrfs check /dev/sdd

The check command exited with status 1 and the following output:

   Checking filesystem on /dev/sdd
   UUID: 2416ab5f-9d71-457e-bb13-a27d4f6b399a
   checking extents
   checking free space cache
   checking fs roots
   checking csums
   There are no extents for csum range 12980224-12984320
   Csum exists for 12980224-12984320 but there is no extent record
   found 1388544 bytes used err is 1
   total csum bytes: 132
   total tree bytes: 704512
   total fs tree bytes: 573440
   total extent tree bytes: 16384
   btree space waste bytes: 564479
   file data blocks allocated: 19341312
    referenced 14606336
   Btrfs v3.14.1-94-g80597e7

After this change it no longer erroneously reports a missing extent for the
csum item and exits with a status of 0.

Also added missing btrfs_prev_leaf() return value checks, as we were ignoring
errors and non-existence of left siblings completely.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-check.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 103efc5..18612c8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3650,8 +3650,7 @@ static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = 0;
-
+	key.offset = (u64)-1;
 
 again:
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
@@ -3661,10 +3660,17 @@ again:
 		btrfs_free_path(path);
 		return ret;
 	} else if (ret) {
-		if (path->slots[0])
+		if (path->slots[0] > 0) {
 			path->slots[0]--;
-		else
-			btrfs_prev_leaf(root, path);
+		} else {
+			ret = btrfs_prev_leaf(root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+		}
 	}
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
@@ -3674,13 +3680,22 @@ again:
 	 * bytenr, so walk back one more just in case.  Dear future traveler,
 	 * first congrats on mastering time travel.  Now if it's not too much
 	 * trouble could you go back to 2006 and tell Chris to make the
-	 * BLOCK_GROUP_ITEM_KEY lower than the EXTENT_ITEM_KEY please?
+	 * BLOCK_GROUP_ITEM_KEY (and BTRFS_*_REF_KEY) lower than the
+	 * EXTENT_ITEM_KEY please?
 	 */
-	if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
-		if (path->slots[0])
+	while (key.type > BTRFS_EXTENT_ITEM_KEY) {
+		if (path->slots[0] > 0) {
 			path->slots[0]--;
-		else
-			btrfs_prev_leaf(root, path);
+		} else {
+			ret = btrfs_prev_leaf(root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 	}
 
 	while (num_bytes) {
@@ -3752,7 +3767,8 @@ again:
 	}
 	ret = 0;
 
-	if (num_bytes) {
+out:
+	if (num_bytes && !ret) {
 		fprintf(stderr, "There are no extents for csum range "
 			"%Lu-%Lu\n", bytenr, bytenr+num_bytes);
 		ret = 1;
-- 
1.9.1

