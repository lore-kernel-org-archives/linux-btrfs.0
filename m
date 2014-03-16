Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56371 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaCPUht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 16:37:49 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so3822810wgh.34
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 13:37:48 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] Btrfs: fix incremental send's decision to delay a dir move/rename
Date: Sun, 16 Mar 2014 20:37:26 +0000
Message-Id: <1395002246-3840-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1394983430-20440-1-git-send-email-fdmanana@gmail.com>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's possible to change the parent/child relationship between directories
in such a way that if a child directory has a higher inode number than
its parent, it doesn't necessarily means the child rename/move operation
can be performed immediately. The parent migth have its own rename/move
operation delayed, therefore in this case the child needs to have its
rename/move operation delayed too, and be performed after its new parent's
rename/move.

Steps to reproduce the issue:

      $ umount /mnt
      $ mkfs.btrfs -f /dev/sdd
      $ mount /dev/sdd /mnt

      $ mkdir /mnt/A
      $ mkdir /mnt/B
      $ mkdir /mnt/C
      $ mv /mnt/C /mnt/A
      $ mv /mnt/B /mnt/A/C
      $ mkdir /mnt/A/C/D

      $ btrfs subvolume snapshot -r /mnt /mnt/snap1
      $ btrfs send /mnt/snap1 -f /tmp/base.send

      $ mv /mnt/A/C/D /mnt/A/D2
      $ mv /mnt/A/C/B /mnt/A/D2/B2
      $ mv /mnt/A/C /mnt/A/D2/B2/C2

      $ btrfs subvolume snapshot -r /mnt /mnt/snap2
      $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send

The incremental send caused the kernel code to enter an infinite loop when
building the path string for directory C after its references are processed.

The necessary conditions here are that C has an inode number higher than both
A and B, and B as an higher inode number higher than A, and D has the highest
inode number, that is:
    inode_number(A) < inode_number(B) < inode_number(C) < inode_number(D)

The same issue could happen if after the first snapshot there's any number
of intermediary parent directories between A2 and B2, and between B2 and C2.

A test case for xfstests follows, covering this simple case and more advanced
ones, with files and hard links created inside the directories.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Right version of the patch. Previously sent came from the wrong vm.
V3: The condition needed to check already existed, so just moved it to the
    top, instead of adding it again.

 fs/btrfs/send.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6463691..d869079 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3184,12 +3184,12 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 	struct fs_path *path_after = NULL;
 	int len1, len2;
 
-	if (parent_ref->dir <= sctx->cur_ino)
-		return 0;
-
 	if (is_waiting_for_move(sctx, ino))
 		return 1;
 
+	if (parent_ref->dir <= sctx->cur_ino)
+		return 0;
+
 	ret = get_inode_info(sctx->parent_root, ino, NULL, &old_gen,
 			     NULL, NULL, NULL, NULL);
 	if (ret == -ENOENT)
-- 
1.7.10.4

