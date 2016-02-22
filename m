Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:58498 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbcBVADK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:03:10 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 876EF101804F
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 01:03:08 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: delayed-inode: Fixed indentation coding style issue
Date: Mon, 22 Feb 2016 01:03:03 +0100
Message-Id: <1456099383-12018-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use tabs instead of spaces, fixing checkpatch error.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b57daa8..2e25aa54 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1802,7 +1802,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	set_nlink(inode, btrfs_stack_inode_nlink(inode_item));
 	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
-        BTRFS_I(inode)->last_trans = btrfs_stack_inode_transid(inode_item);
+	BTRFS_I(inode)->last_trans = btrfs_stack_inode_transid(inode_item);
 
 	inode->i_version = btrfs_stack_inode_sequence(inode_item);
 	inode->i_rdev = 0;
-- 
2.7.1

