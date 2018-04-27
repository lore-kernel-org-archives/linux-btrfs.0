Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757664AbeD0JWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:22:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E54D0ACBB
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 09:22:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Fix delalloc inodes invalidation during transaction abort
Date: Fri, 27 Apr 2018 12:21:53 +0300
Message-Id: <1524820914-30864-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1524820914-30864-1-git-send-email-nborisov@suse.com>
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a transaction is aborted btrfs_cleanup_transaction is called to
cleanup all the various in-flight bits and pieces which migth be
active. One of those is delalloc inodes - inodes which have dirty
pages which haven't been persisted yet. Currently the process of
freeing such delalloc inodes in exceptional circumstances such as
transaction abort boiled down to calling btrfs_invalidate_inodes whose
sole job is to invalidate the dentries for all inodes related to a
root. This is in fact wrong and insufficient since such delalloc inodes
will likely have pending pages or ordered-extents and will be linked to
the sb->s_inode_list. This means that unmounting a btrfs instance with
an aborted transaction could potentially lead inodes/their pages
visible to the system long after their superblock has been freed. This
in turn leads to a "use-after-free" situation once page shrink is
triggered. This situation could be simulated by running generic/019
which would cause such inodes to be left hanging, followed by
generic/176 which causes memory pressure and page eviction which lead
to touching the freed super block instance. This situation is
additionally detected by the unmount code of VFS with the following
message:

"VFS: Busy inodes after unmount of Self-destruct in 5 seconds.  Have a nice day..."

Additionally btrfs hits WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
in free_fs_root for the same reason.

This patch aims to rectify the sitaution by doing the following:

1. Change btrfs_destroy_delalloc_inodes so that it calls
invalidate_inode_pages2 for every inode on the delalloc list, this
ensures that all the pages of the inode are released. This function
boils down to calling btrfs_releasepage. During test I observed cases
where inodes on the delalloc list were having an i_count of 0, so this
necessitates using igrab to be sure we are working on a non-freed inode.

2. Since calling btrfs_releasepage might queue delayed iputs move the
call out to btrfs_cleanup_transaction in btrfs_error_commit_super before
calling run_delayed_iputs for the last time. This is necessary to ensure
that delayed iputs are run.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f50786e19a7a..0f88a551862a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3816,6 +3816,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
 	btrfs_free_qgroup_config(fs_info);
+	ASSERT(list_empty(&fs_info->delalloc_roots));
 
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
 		btrfs_info(fs_info, "at unmount delalloc count %lld",
@@ -4123,15 +4124,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 
 static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
 {
+	/* cleanup FS via transaction */
+	btrfs_cleanup_transaction(fs_info);
+
 	mutex_lock(&fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(fs_info);
 	mutex_unlock(&fs_info->cleaner_mutex);
 
 	down_write(&fs_info->cleanup_work_sem);
 	up_write(&fs_info->cleanup_work_sem);
-
-	/* cleanup FS via transaction */
-	btrfs_cleanup_transaction(fs_info);
 }
 
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
@@ -4256,19 +4257,19 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 	list_splice_init(&root->delalloc_inodes, &splice);
 
 	while (!list_empty(&splice)) {
+		struct inode *inode = NULL;
 		btrfs_inode = list_first_entry(&splice, struct btrfs_inode,
 					       delalloc_inodes);
-
-		list_del_init(&btrfs_inode->delalloc_inodes);
-		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-			  &btrfs_inode->runtime_flags);
+		__btrfs_del_delalloc_inode(root, btrfs_inode);
 		spin_unlock(&root->delalloc_lock);
 
-		btrfs_invalidate_inodes(btrfs_inode->root);
-
+		inode = igrab(&btrfs_inode->vfs_inode);
+		if (inode) {
+			invalidate_inode_pages2(inode->i_mapping);
+			iput(inode);
+		}
 		spin_lock(&root->delalloc_lock);
 	}
-
 	spin_unlock(&root->delalloc_lock);
 }
 
@@ -4284,7 +4285,6 @@ static void btrfs_destroy_all_delalloc_inodes(struct btrfs_fs_info *fs_info)
 	while (!list_empty(&splice)) {
 		root = list_first_entry(&splice, struct btrfs_root,
 					 delalloc_root);
-		list_del_init(&root->delalloc_root);
 		root = btrfs_grab_fs_root(root);
 		BUG_ON(!root);
 		spin_unlock(&fs_info->delalloc_root_lock);
-- 
2.7.4

