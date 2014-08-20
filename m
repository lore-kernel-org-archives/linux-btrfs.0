Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaHTPDR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 11:03:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 181E2AAC1
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 15:03:16 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH -rc2] btrfs: remove stale code after removing ordered operations
Date: Wed, 20 Aug 2014 17:03:14 +0200
Message-Id: <1408546994-4156-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit "btrfs: disable strict file flushes for renames and
truncates" (8d875f95da43c6a8f18f77869f2ef26e9594fecc) left some unused
code and defines.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

This is a cleanup after a 3.17-rc1 patch.

 fs/btrfs/btrfs_inode.h |  8 --------
 fs/btrfs/ctree.h       |  7 -------
 fs/btrfs/inode.c       | 10 ----------
 3 files changed, 25 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 43527fd78825..ee9d37d4f883 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -25,14 +25,6 @@
 #include "ordered-data.h"
 #include "delayed-inode.h"
 
-/*
- * ordered_data_close is set by truncate when a file that used
- * to have good data has been truncated to zero.  When it is set
- * the btrfs file release call will add this inode to the
- * ordered operations list so that we make sure to flush out any
- * new data the application may have written before commit.
- */
-#define BTRFS_INODE_ORDERED_DATA_CLOSE		0
 #define BTRFS_INODE_ORPHAN_META_RESERVED	1
 #define BTRFS_INODE_DUMMY			2
 #define BTRFS_INODE_IN_DEFRAG			3
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e29b614fe93..69cd3262193e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -62,13 +62,6 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
-/*
- * files bigger than this get some pre-flushing when they are added
- * to the ordered operations list.  That way we limit the total
- * work done by the commit
- */
-#define BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT (8 * 1024 * 1024)
-
 /* holds pointers to all of the tree roots */
 #define BTRFS_ROOT_TREE_OBJECTID 1ULL
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03708ef3deef..ded36a4e47a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4545,16 +4545,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		ret = btrfs_update_inode(trans, root, inode);
 		btrfs_end_transaction(trans, root);
 	} else {
-
-		/*
-		 * We're truncating a file that used to have good data down to
-		 * zero. Make sure it gets into the ordered flush list so that
-		 * any new writes get down to disk quickly.
-		 */
-		if (newsize == 0)
-			set_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
-				&BTRFS_I(inode)->runtime_flags);
-
 		/*
 		 * 1 for the orphan item we're going to add
 		 * 1 for the orphan item deletion.
-- 
1.9.0

