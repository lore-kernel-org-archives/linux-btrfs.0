Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbbLaSZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 13:25:15 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix number of transaction units required to create symlink
Date: Thu, 31 Dec 2015 18:25:08 +0000
Message-Id: <1451586308-29558-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We weren't accounting for the insertion of an inline extent item for the
symlink inode nor that we need to update the parent inode item (through
the call to btrfs_add_nondir()). So fix this by including two more
transaction units.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2ea2e0e..5dbc07a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9660,9 +9660,11 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	/*
 	 * 2 items for inode item and ref
 	 * 2 items for dir items
+	 * 1 item for updating parent inode item
+	 * 1 item for the inline extent item
 	 * 1 item for xattr if selinux is on
 	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans = btrfs_start_transaction(root, 7);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-- 
2.1.3

