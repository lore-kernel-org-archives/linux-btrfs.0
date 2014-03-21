Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38481 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbaCUMpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 08:45:52 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so452870wiv.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 05:45:50 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, account for orphan directories when building path strings
Date: Fri, 21 Mar 2014 12:45:39 +0000
Message-Id: <1395405939-8488-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have directories with a pending move/rename operation, we must take into
account any orphan directories that got created before executing the pending
move/rename. Those orphan directories are directories with an inode number higher
then the current send progress and that don't exist in the parent snapshot, they
are created before current progress reaches their inode number, with a generated
name of the form oN-M-I and at the root of the filesystem tree, and later when
progress matches their inode number, moved/renamed to their final location.

Reproducer:

          $ mkfs.btrfs -f /dev/sdd
          $ mount /dev/sdd /mnt

          $ mkdir -p /mnt/a/b/c/d
          $ mkdir /mnt/a/b/e
          $ mv /mnt/a/b/c /mnt/a/b/e/CC
          $ mkdir /mnt/a/b/e/CC/d/f
	  $ mkdir /mnt/a/g

          $ btrfs subvolume snapshot -r /mnt /mnt/snap1
          $ btrfs send /mnt/snap1 -f /tmp/base.send

          $ mkdir /mnt/a/g/h
	  $ mv /mnt/a/b/e /mnt/a/g/h/EE
          $ mv /mnt/a/g/h/EE/CC/d /mnt/a/g/h/EE/DD

          $ btrfs subvolume snapshot -r /mnt /mnt/snap2
          $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send

The second receive command failed with the following error:

    ERROR: rename a/b/e/CC/d -> o264-7-0/EE/DD failed. No such file or directory

A test case for xfstests follows soon.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 143fed3..ab404ff 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3004,7 +3004,6 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	struct fs_path *from_path = NULL;
 	struct fs_path *to_path = NULL;
 	struct fs_path *name = NULL;
-	u64 orig_progress = sctx->send_progress;
 	struct recorded_ref *cur;
 	u64 parent_ino, parent_gen;
 	struct waiting_dir_move *dm = NULL;
@@ -3028,23 +3027,13 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	if (ret < 0)
 		goto out;
 
-	if (parent_ino == sctx->cur_ino) {
-		/* child only renamed, not moved */
-		ASSERT(parent_gen == sctx->cur_inode_gen);
-		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen,
-				   from_path);
-		if (ret < 0)
-			goto out;
-		ret = fs_path_add_path(from_path, name);
-		if (ret < 0)
-			goto out;
-	} else {
-		/* child moved and maybe renamed too */
-		sctx->send_progress = pm->ino;
-		ret = get_cur_path(sctx, pm->ino, pm->gen, from_path);
-		if (ret < 0)
-			goto out;
-	}
+	ret = get_cur_path(sctx, parent_ino, parent_gen,
+			   from_path);
+	if (ret < 0)
+		goto out;
+	ret = fs_path_add_path(from_path, name);
+	if (ret < 0)
+		goto out;
 
 	fs_path_free(name);
 	name = NULL;
@@ -3055,7 +3044,6 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 		goto out;
 	}
 
-	sctx->send_progress = sctx->cur_ino + 1;
 	ret = get_cur_path(sctx, pm->ino, pm->gen, to_path);
 	if (ret < 0)
 		goto out;
@@ -3113,7 +3101,6 @@ out:
 	fs_path_free(name);
 	fs_path_free(from_path);
 	fs_path_free(to_path);
-	sctx->send_progress = orig_progress;
 
 	return ret;
 }
-- 
1.7.10.4

