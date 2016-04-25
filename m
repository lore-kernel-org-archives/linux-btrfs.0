Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41173 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbcDZODT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:03:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1AA602011B
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:03:18 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 06B02200DC
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:03:16 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix empty symlink after creating symlink and fsync parent dir
Date: Mon, 25 Apr 2016 05:25:31 +0100
Message-Id: <1461558331-32199-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we create a symlink, fsync its parent directory, crash/power fail and
mount the filesystem, we end up with an empty symlink, which not only is
useless it's also not allowed in linux (the man page symlink(2) is well
explicit about that).  So we just need to make sure to fully log an inode
if it's a symlink, to ensure its inline extent gets logged, ensuring the
same behaviour as ext3, ext4, xfs, reiserfs, f2fs, nilfs2, etc.

Example reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt
  $ mkdir /mnt/testdir
  $ sync
  $ ln -s /mnt/foo /mnt/testdir/bar
  $ xfs_io -c fsync /mnt/testdir
  <power fail>
  $ mount /dev/sdb /mnt
  $ readlink /mnt/testdir/bar
  <empty string>

A test case for fstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4709932..a24a0ba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5158,7 +5158,7 @@ process_leaf:
 			}
 
 			ctx->log_new_dentries = false;
-			if (type == BTRFS_FT_DIR)
+			if (type == BTRFS_FT_DIR || type == BTRFS_FT_SYMLINK)
 				log_mode = LOG_INODE_ALL;
 			btrfs_release_path(path);
 			ret = btrfs_log_inode(trans, root, di_inode,
-- 
2.7.0.rc3

