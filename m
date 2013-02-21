Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38432 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3BUU1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 15:27:13 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6A6D49A0359
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 13:27:12 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id AhGVGxtcHliySVyj (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 13:27:11 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure NODATACOW also gets NODATASUM set
Date: Thu, 21 Feb 2013 15:34:15 -0500
Message-ID: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported hitting the BUG_ON() in btrfs_finished_ordered_io() where we had
csums on a NOCOW extent.  This can happen if we have NODATACOW set but not
NODATASUM set, which can happen in two cases, either we mount with -o nodatacow
and then write into preallocated space, or chattr +C a directory and move a file
into that directory.  This patch fixes up those two cases and now we should
uniformly have NODATACOW and NODATASUM set always.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40d49da..5d7ceb5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5574,7 +5574,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		if (btrfs_test_opt(root, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 		if (btrfs_test_opt(root, NODATACOW))
-			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
+				BTRFS_INODE_NODATASUM;
 	}
 
 	insert_inode_hash(inode);
@@ -8069,7 +8070,8 @@ static void fixup_inode_flags(struct inode *dir, struct inode *inode)
 	struct btrfs_inode *b_inode = BTRFS_I(inode);
 
 	if (b_dir->flags & BTRFS_INODE_NODATACOW)
-		b_inode->flags |= BTRFS_INODE_NODATACOW;
+		b_inode->flags |= BTRFS_INODE_NODATACOW |
+			BTRFS_INODE_NODATASUM;
 	else
 		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
 
-- 
1.7.7.6

