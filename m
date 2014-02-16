Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41722 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaBPNnp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 08:43:45 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so1640514wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 05:43:44 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: incremental send, fix invalid path after dir rename
Date: Sun, 16 Feb 2014 13:43:11 +0000
Message-Id: <1392558191-14475-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes yet one more case not caught by the commit titled:

   Btrfs: fix infinite path build loops in incremental send

In this case, even before the initial full send, we have a directory
which is a child of a directory with a higher inode number. Then we
perform the initial send, and after we rename both the child and the
parent, without moving them around. After doing these 2 renames, an
incremental send sent a rename instruction for the child directory
which contained an invalid "from" path (referenced the parent's old
name, not the new one), which made the btrfs receive command fail.

Steps to reproduce:

    $ mkfs.btrfs -f /dev/sdb3
    $ mount /dev/sdb3 /mnt/btrfs
    $ mkdir -p /mnt/btrfs/a/b
    $ mkdir /mnt/btrfs/d
    $ mkdir /mnt/btrfs/a/b/c
    $ mv /mnt/btrfs/d /mnt/btrfs/a/b/c
    $ btrfs subvolume snapshot -r /mnt/btrfs /mnt/btrfs/snap1
    $ btrfs send /mnt/btrfs/snap1 -f /tmp/base.send
    $ mv /mnt/btrfs/a/b/c /mnt/btrfs/a/b/x
    $ mv /mnt/btrfs/a/b/x/d /mnt/btrfs/a/b/x/y
    $ btrfs subvolume snapshot -r /mnt/btrfs /mnt/btrfs/snap2
    $ btrfs send -p /mnt/btrfs/snap1 /mnt/btrfs/snap2 -f /tmp/incremental.send

    $ umout /mnt/btrfs
    $ mkfs.btrfs -f /dev/sdb3
    $ mount /dev/sdb3 /mnt/btrfs
    $ btrfs receive /mnt/btrfs -f /tmp/base.send
    $ btrfs receive /mnt/btrfs -f /tmp/incremental.send

The second btrfs receive command failed with:
  "ERROR: rename a/b/c/d -> a/b/x/y failed. No such file or directory"

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b6d416c..7dbed58 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2847,19 +2847,48 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 {
 	struct fs_path *from_path = NULL;
 	struct fs_path *to_path = NULL;
+	struct fs_path *name = NULL;
 	u64 orig_progress = sctx->send_progress;
 	struct recorded_ref *cur;
+	u64 parent_ino, parent_gen;
 	int ret;
 
+	name = fs_path_alloc();
 	from_path = fs_path_alloc();
-	if (!from_path)
-		return -ENOMEM;
+	if (!name || !from_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	sctx->send_progress = pm->ino;
-	ret = get_cur_path(sctx, pm->ino, pm->gen, from_path);
+	ret = del_waiting_dir_move(sctx, pm->ino);
+	ASSERT(ret == 0);
+
+	ret = get_first_ref(sctx->parent_root, pm->ino,
+			    &parent_ino, &parent_gen, name);
 	if (ret < 0)
 		goto out;
 
+	if (parent_ino == sctx->cur_ino) {
+		/* child only renamed, not moved */
+		ASSERT(parent_gen == sctx->cur_inode_gen);
+		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen,
+				   from_path);
+		if (ret < 0)
+			goto out;
+		ret = fs_path_add_path(from_path, name);
+		if (ret < 0)
+			goto out;
+	} else {
+		/* child moved and maybe renamed too */
+		sctx->send_progress = pm->ino;
+		ret = get_cur_path(sctx, pm->ino, pm->gen, from_path);
+		if (ret < 0)
+			goto out;
+	}
+
+	fs_path_free(name);
+	name = NULL;
+
 	to_path = fs_path_alloc();
 	if (!to_path) {
 		ret = -ENOMEM;
@@ -2867,9 +2896,6 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	}
 
 	sctx->send_progress = sctx->cur_ino + 1;
-	ret = del_waiting_dir_move(sctx, pm->ino);
-	ASSERT(ret == 0);
-
 	ret = get_cur_path(sctx, pm->ino, pm->gen, to_path);
 	if (ret < 0)
 		goto out;
@@ -2893,6 +2919,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	}
 
 out:
+	fs_path_free(name);
 	fs_path_free(from_path);
 	fs_path_free(to_path);
 	sctx->send_progress = orig_progress;
-- 
1.7.9.5

