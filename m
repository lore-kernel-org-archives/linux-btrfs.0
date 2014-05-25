Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65149 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYBoF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 21:44:05 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so2564583wiw.9
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 18:44:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, don't error in the presence of subvols/snapshots
Date: Sun, 25 May 2014 03:43:06 +0100
Message-Id: <1400985786-16240-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we are doing an incremental send and the base snapshot has a
directory with name X that doesn't exist anymore in the second
snapshot and a new subvolume/snapshot exists in the second snapshot
that has the same name as the directory (name X), the incremental
send would fail with -ENOENT error. This is because it attempts
to lookup for an inode with a number matching the objectid of a
root, which doesn't exist.

Steps to reproduce:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt

    mkdir /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap1

    rmdir /mnt/testdir
    btrfs subvolume create /mnt/testdir
    btrfs subvolume snapshot -r /mnt /mnt/mysnap2

    btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/send.data

A test case for xfstests follows.

Reported-by: Robert White <rwhite@pobox.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1a65a40..f51525e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1642,7 +1642,8 @@ out:
 static int lookup_dir_item_inode(struct btrfs_root *root,
 				 u64 dir, const char *name, int name_len,
 				 u64 *found_inode,
-				 u8 *found_type)
+				 u8 *found_type,
+				 int *found_is_root)
 {
 	int ret = 0;
 	struct btrfs_dir_item *di;
@@ -1666,6 +1667,8 @@ static int lookup_dir_item_inode(struct btrfs_root *root,
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
 	*found_inode = key.objectid;
 	*found_type = btrfs_dir_type(path->nodes[0], di);
+	if (found_is_root)
+		*found_is_root = (key.type == BTRFS_ROOT_ITEM_KEY);
 
 out:
 	btrfs_free_path(path);
@@ -1816,7 +1819,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	}
 
 	ret = lookup_dir_item_inode(sctx->parent_root, dir, name, name_len,
-			&other_inode, &other_type);
+				    &other_inode, &other_type, NULL);
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	if (ret) {
@@ -1861,6 +1864,7 @@ static int did_overwrite_ref(struct send_ctx *sctx,
 	u64 gen;
 	u64 ow_inode;
 	u8 other_type;
+	int other_is_root = 0;
 
 	if (!sctx->parent_root)
 		goto out;
@@ -1871,10 +1875,10 @@ static int did_overwrite_ref(struct send_ctx *sctx,
 
 	/* check if the ref was overwritten by another ref */
 	ret = lookup_dir_item_inode(sctx->send_root, dir, name, name_len,
-			&ow_inode, &other_type);
+				    &ow_inode, &other_type, &other_is_root);
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
-	if (ret) {
+	if (ret || other_is_root) {
 		/* was never and will never be overwritten */
 		ret = 0;
 		goto out;
-- 
1.9.1

