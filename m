Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45387 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3HUT42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 15:56:28 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 0D2A79A0686
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:56:28 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id 8uA78o1hOfZxEABM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:56:27 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not clear our orphan item runtime flag on eexist
Date: Wed, 21 Aug 2013 15:56:25 -0400
Message-ID: <1377114985-21351-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were unconditionally clearing our runtime flag on the inode on error when
trying to insert an orphan item.  This is wrong in the case of -EEXIST since we
obviously have an orphan item.  This was causing us to not do the correct
cleanup of our orphan items which caused issues on cleanup.  This happens
because currently when truncate fails we just leave the orphan item on there so
it can be cleaned up, so if we go to remove the file later we will hit this
issue.  What we do for truncate isn't right either, but we shouldn't screw this
sort of thing up on error either, so fix this and then I'll fix truncate in a
different patch.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40bb31d..1c86f9d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2950,14 +2950,14 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
-			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-				  &BTRFS_I(inode)->runtime_flags);
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &BTRFS_I(inode)->runtime_flags);
 				btrfs_orphan_release_metadata(inode);
 			}
 			if (ret != -EEXIST) {
+				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+					  &BTRFS_I(inode)->runtime_flags);
 				btrfs_abort_transaction(trans, root, ret);
 				return ret;
 			}
-- 
1.7.7.6

