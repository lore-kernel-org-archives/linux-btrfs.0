Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbaKNKdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 614D9AD1E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 10:33:11 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] btrfs: switch inode_cache option handling to pending changes
Date: Fri, 14 Nov 2014 11:33:11 +0100
Message-Id: <7e1876aca815029d5c3023a66a91e249eca3e533.1415894837.git.dsterba@suse.cz>
In-Reply-To: <cover.1415894837.git.dsterba@suse.cz>
References: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The pending mount option(s) now share namespace and bits with the normal
options, and the existing one for (inode_cache) is unset unconditionally
at each transaction commit.

Introduce a separate namespace for pending changes and enhance the
descriptions of the intended change to use separate bits for each
action.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |  4 +++-
 fs/btrfs/disk-io.c     |  4 ----
 fs/btrfs/inode-map.c   |  2 +-
 fs/btrfs/super.c       |  4 ++--
 fs/btrfs/transaction.c | 19 ++++++++++++-------
 5 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f30b061ef77d..1c9157e4ab0c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2098,7 +2098,6 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
-#define	BTRFS_MOUNT_CHANGE_INODE_CACHE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
@@ -2131,6 +2130,9 @@ struct btrfs_ioctl_defrag_range_args {
  * transaction commit)
  */
 
+#define BTRFS_PENDING_SET_INODE_MAP_CACHE	(0)
+#define BTRFS_PENDING_CLEAR_INODE_MAP_CACHE	(1)
+
 #define btrfs_test_pending(info, opt)	\
 	test_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
 #define btrfs_set_pending(info, opt)	\
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fd80c0d98421..6b406e3f3abe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2830,10 +2830,6 @@ retry_root_backup:
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
-	/* Set the real inode map cache flag */
-	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
-		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
-
 	/*
 	 * Mount does not set all options immediatelly, we can do it now and do
 	 * not have to wait for transaction commit
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 83d646bd2e4b..4ebd5ebb1ea1 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -178,7 +178,7 @@ static void start_caching(struct btrfs_root *root)
 			  root->root_key.objectid);
 	if (IS_ERR(tsk)) {
 		btrfs_warn(root->fs_info, "failed to start inode caching task");
-		btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+		btrfs_clear_pending_and_info(root->fs_info, INODE_MAP_CACHE,
 				"disabling inode map caching");
 	}
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1da16d59e115..65c75d9e9750 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -642,11 +642,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					     "disabling disk space caching");
 			break;
 		case Opt_inode_cache:
-			btrfs_set_and_info(root, CHANGE_INODE_CACHE,
+			btrfs_set_pending_and_info(info, INODE_MAP_CACHE,
 					   "enabling inode map caching");
 			break;
 		case Opt_noinode_cache:
-			btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+			btrfs_clear_pending_and_info(info, INODE_MAP_CACHE,
 					     "disabling inode map caching");
 			break;
 		case Opt_clear_cache:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7a4024a55e5c..703238ed7337 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1842,14 +1842,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	/*
-	 * Since the transaction is done, we should set the inode map cache flag
-	 * before any other comming transaction.
+	 * Since the transaction is done, we can apply the pending changes
+	 * before the next transaction.
 	 */
-	if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
-		btrfs_set_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
-	else
-		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
-
 	btrfs_apply_pending_changes(root->fs_info);
 
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
@@ -2031,6 +2026,16 @@ void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
 	if (!prev)
 		return;
 
+	bit = 1 << BTRFS_PENDING_SET_INODE_MAP_CACHE;
+	if (prev & bit)
+		btrfs_set_opt(fs_info->mount_opt, INODE_MAP_CACHE);
+	prev &= ~bit;
+
+	bit = 1 << BTRFS_PENDING_CLEAR_INODE_MAP_CACHE;
+	if (prev & bit)
+		btrfs_clear_opt(fs_info->mount_opt, INODE_MAP_CACHE);
+	prev &= ~bit;
+
 	if (prev)
 		btrfs_warn(fs_info,
 			"unknown pending changes left 0x%lx, ignoring", prev);
-- 
1.8.4.5

