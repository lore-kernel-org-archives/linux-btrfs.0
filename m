Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49180 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaCRRzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 13:55:19 -0400
Received: by mail-wi0-f176.google.com with SMTP id hr14so4059714wib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 10:55:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: part 2, fix incremental send's decision to delay a dir move/rename
Date: Tue, 18 Mar 2014 17:55:09 +0000
Message-Id: <1395165310-24621-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1395022528-27225-1-git-send-email-fdmanana@gmail.com>
References: <1395022528-27225-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For an incremental send, fix the process of determining whether the directory
inode we're currently processing needs to have its move/rename operation delayed.

We were ignoring the fact that if the inode's new immediate ancestor has a higher
inode number than ours but wasn't renamed/moved, we might still need to delay our
move/rename, because some other ancestor directory higher in the hierarchy might
have an inode number higher than ours *and* was renamed/moved too - in this case
we have to wait for rename/move of that ancestor to happen before our current
directory's rename/move operation.

Simple steps to reproduce this issue:

      $ mkfs.btrfs -f /dev/sdd
      $ mount /dev/sdd /mnt

      $ mkdir -p /mnt/a/x1/x2
      $ mkdir /mnt/a/Z
      $ mkdir -p /mnt/a/x1/x2/x3/x4/x5

      $ btrfs subvolume snapshot -r /mnt /mnt/snap1
      $ btrfs send /mnt/snap1 -f /tmp/base.send

      $ mv /mnt/a/x1/x2/x3 /mnt/a/Z/X33
      $ mv /mnt/a/x1/x2 /mnt/a/Z/X33/x4/x5/X22

      $ btrfs subvolume snapshot -r /mnt /mnt/snap2
      $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send

The incremental send caused the kernel code to enter an infinite loop when
building the path string for directory Z after its references are processed.

A more complex scenario:

      $ mkfs.btrfs -f /dev/sdd
      $ mount /dev/sdd /mnt

      $ mkdir -p /mnt/a/b/c/d
      $ mkdir /mnt/a/b/c/d/e
      $ mkdir /mnt/a/b/c/d/f
      $ mv /mnt/a/b/c/d/e /mnt/a/b/c/d/f/E2
      $ mkdir /mmt/a/b/c/g
      $ mv /mnt/a/b/c/d /mnt/a/b/D2

      $ btrfs subvolume snapshot -r /mnt /mnt/snap1
      $ btrfs send /mnt/snap1 -f /tmp/base.send

      $ mkdir /mnt/a/o
      $ mv /mnt/a/b/c/g /mnt/a/b/D2/f/G2
      $ mv /mnt/a/b/D2 /mnt/a/b/dd
      $ mv /mnt/a/b/c /mnt/a/C2
      $ mv /mnt/a/b/dd/f /mnt/a/o/FF
      $ mv /mnt/a/b /mnt/a/o/FF/E2/BB

      $ btrfs subvolume snapshot -r /mnt /mnt/snap2
      $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added missing error handling and fixed typo in commit message.
V3: Updated the algorithm to deal with more complex cases, hopefully all
    cases are nailed down now.

 fs/btrfs/send.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d869079..5d757ee 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2916,7 +2916,7 @@ static void free_waiting_dir_move(struct send_ctx *sctx,
 	kfree(dm);
 }
 
-static int add_pending_dir_move(struct send_ctx *sctx, u64 parent_ino)
+static int add_pending_dir_move(struct send_ctx *sctx, u64 ino, u64 parent_ino)
 {
 	struct rb_node **p = &sctx->pending_dir_moves.rb_node;
 	struct rb_node *parent = NULL;
@@ -2929,7 +2929,7 @@ static int add_pending_dir_move(struct send_ctx *sctx, u64 parent_ino)
 	if (!pm)
 		return -ENOMEM;
 	pm->parent_ino = parent_ino;
-	pm->ino = sctx->cur_ino;
+	pm->ino = ino;
 	pm->gen = sctx->cur_inode_gen;
 	INIT_LIST_HEAD(&pm->list);
 	INIT_LIST_HEAD(&pm->update_refs);
@@ -3183,6 +3183,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	struct fs_path *path_before = NULL;
 	struct fs_path *path_after = NULL;
 	int len1, len2;
+	int register_upper_dirs;
 
 	if (is_waiting_for_move(sctx, ino))
 		return 1;
@@ -3242,6 +3243,54 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	}
 	ret = 0;
 
+	/*
+	 * Ok, our new most direct ancestor has a higher inode number but
+	 * wasn't moved/renamed. So maybe some of the new ancestors higher in
+	 * the hierarchy have an higher inode number too *and* were renamed
+	 * or moved - in this case we need to wait for the ancestor's rename
+	 * or move operation before we can do the move/rename for the current
+	 * inode.
+	 */
+	register_upper_dirs = 0;
+again:
+	while ((ret == 0 || register_upper_dirs) &&
+	       parent_ino_after > sctx->cur_ino) {
+		ino = parent_ino_after;
+		fs_path_reset(path_before);
+		fs_path_reset(path_after);
+
+		ret = get_first_ref(sctx->send_root, ino, &parent_ino_after,
+				    NULL, path_after);
+		if (ret < 0)
+			goto out;
+		ret = get_first_ref(sctx->parent_root, ino, &parent_ino_before,
+				    NULL, path_before);
+		if (ret == -ENOENT) {
+			ret = 0;
+			break;
+		} else if (ret < 0) {
+			goto out;
+		}
+
+		len1 = fs_path_len(path_before);
+		len2 = fs_path_len(path_after);
+		if (parent_ino_before != parent_ino_after || len1 != len2 ||
+		    memcmp(path_before->start, path_after->start, len1)) {
+			ret = 1;
+			if (register_upper_dirs) {
+				break;
+			} else {
+				register_upper_dirs = 1;
+				parent_ino_after = parent_ref->dir;
+				goto again;
+			}
+		} else if (register_upper_dirs) {
+			ret = add_pending_dir_move(sctx, ino, parent_ino_after);
+			if (ret < 0 && ret != -EEXIST)
+				goto out;
+		}
+	}
+
 out:
 	fs_path_free(path_before);
 	fs_path_free(path_after);
@@ -3407,7 +3456,8 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 					goto out;
 				if (ret) {
 					ret = add_pending_dir_move(sctx,
-								   cur->dir);
+							       sctx->cur_ino,
+							       cur->dir);
 					*pending_move = 1;
 				} else {
 					ret = send_rename(sctx, valid_path,
-- 
1.7.10.4

