Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbeCTTZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 15:25:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F1A5AF15
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 19:25:30 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/2] btrfs: remove dead create_space_info calls
Date: Tue, 20 Mar 2018 15:25:25 -0400
Message-Id: <20180320192526.4629-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Since commit 2be12ef79 (btrfs: Separate space_info create/update), we've
separated out the creation and updating of the space info structures.
That commit was a straightforward refactoring of the two parts of
update_space_info, but we can go a step further.  Since commits
c59021f84 (Btrfs: fix OOPS of empty filesystem after balance) and
b742bb82f (Btrfs: Link block groups of different raid types), we know
that the space_info structures will be created at mount and there will
only ever be, at most, three of them.

This patch cleans out the create_space_info calls after __find_space_info
returns NULL since __find_space_info *can't* return NULL.

The initial cause for reviewing this was the kobject_add calls from
create_space_info occuring in sites where fs-reclaim wasn't allowed.  Now
we are certain they occur only early in the mount process and are safe.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/extent-tree.c | 16 ++--------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da308774b8a4..ffbb05aa66fa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -952,9 +952,9 @@ struct btrfs_fs_info {
 	struct btrfs_fs_devices *fs_devices;
 
 	/*
-	 * the space_info list is almost entirely read only.  It only changes
-	 * when we add a new raid type to the FS, and that happens
-	 * very rarely.  RCU is used to protect it.
+	 * The space_info list is effectively read only after initial
+	 * setup.  It is populated at mount time and cleaned up after
+	 * all block groups are removed.  RCU is used to protect it.
 	 */
 	struct list_head space_info;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2d5e963fae88..0e9a21230217 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4603,11 +4603,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 		return -ENOSPC;
 
 	space_info = __find_space_info(fs_info, flags);
-	if (!space_info) {
-		ret = create_space_info(fs_info, flags, &space_info);
-		if (ret)
-			return ret;
-	}
+	ASSERT(space_info);
 
 again:
 	spin_lock(&space_info->lock);
@@ -10255,15 +10251,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	 * with its ->space_info set.
 	 */
 	cache->space_info = __find_space_info(fs_info, cache->flags);
-	if (!cache->space_info) {
-		ret = create_space_info(fs_info, cache->flags,
-				       &cache->space_info);
-		if (ret) {
-			btrfs_remove_free_space_cache(cache);
-			btrfs_put_block_group(cache);
-			return ret;
-		}
-	}
+	ASSERT(cache->space_info);
 
 	ret = btrfs_add_block_group_cache(fs_info, cache);
 	if (ret) {
-- 
2.15.1

