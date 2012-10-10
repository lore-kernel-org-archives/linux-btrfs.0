Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49917 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2JJOvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 10:51:00 -0400
From: Gabriel de Perthuis <g2p.code@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] Fix a sign bug causing invalid memory access in the ino_paths ioctl.
Date: Wed, 10 Oct 2012 16:50:47 +0200
Message-Id: <1349880647-30358-1-git-send-email-g2p.code@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To see the problem, create many hardlinks to the same file (120 should do it),
then look up paths by inode with:

  ls -i
  btrfs inspect inode-resolve -v $ino /mnt/btrfs

I noticed the memory layout of the fspath->val data had some irregularities
(some unnecessary gaps that stop appearing about halfway),
so I'm not sure there aren't any bugs left in it.

---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 868cf5b..29d05c6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1131,7 +1131,7 @@ char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 	int slot;
 	u64 next_inum;
 	int ret;
-	s64 bytes_left = size - 1;
+	s64 bytes_left = ((s64)size) - 1;
 	struct extent_buffer *eb = eb_in;
 	struct btrfs_key found_key;
 	int leave_spinning = path->leave_spinning;
-- 
1.7.12.117.gdc24c27

