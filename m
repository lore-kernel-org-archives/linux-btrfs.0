Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:43017 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaCQCPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 22:15:50 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so3962371wes.4
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 19:15:49 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: part 2, fix incremental send's decision to delay a dir move/rename
Date: Mon, 17 Mar 2014 02:15:28 +0000
Message-Id: <1395022528-27225-1-git-send-email-fdmanana@gmail.com>
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

Steps to reproduce this issue:

      $ umount /mnt
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
building the path string for directory C after its references are processed.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d869079..3aa0d7a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3242,6 +3242,35 @@ static int wait_for_parent_move(struct send_ctx *sctx,
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
+	while (ret == 0 && parent_ino_after > sctx->cur_ino) {
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
+		if (ret < 0)
+			goto out;
+
+		len1 = fs_path_len(path_before);
+		len2 = fs_path_len(path_after);
+		if (parent_ino_before != parent_ino_after || len1 != len2 ||
+		    memcmp(path_before->start, path_after->start, len1))
+			ret = 1;
+	}
+
 out:
 	fs_path_free(path_before);
 	fs_path_free(path_after);
-- 
1.7.10.4

