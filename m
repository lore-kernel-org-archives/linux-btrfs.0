Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52601 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751155AbdEQPiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:38:19 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] btrfs: fix race with relocation recovery and fs_root setup
Date: Wed, 17 May 2017 11:38:34 -0400
Message-Id: <1495035516-3217-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If we have to recover relocation during mount, we'll ultimately have to
evict the orphan inode.  That goes through the reservation dance, where
priority_reclaim_metadata_space and flush_space expect fs_info->fs_root
to be valid.  That's the next thing to be set up during mount, so we
crash, almost always in flush_space trying to join the transaction
but priority_reclaim_metadata_space is possible as well.  This call
path has been problematic in the past WRT whether ->fs_root is valid
yet.  Commit 957780eb278 (Btrfs: introduce ticketed enospc
infrastructure) added new users that are called in the direct path
instead of the async path that had already been worked around.

The thing is that we don't actually need the fs_root, specifically, for
anything.  We either use it to determine whether the root is the
chunk_root for use in choosing an allocation profile or as a root to pass
btrfs_join_transaction before immediately committing it.  Anything that
isn't the chunk root works in the former case and any root works in
the latter.

A simple fix is to use a root we know will always be there: the
extent_root.

Cc: <stable@vger.kernel.org> # v4.8+
Fixes: 957780eb278 (Btrfs: introduce ticketed enospc infrastructure)
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be54776..9894c4e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4834,7 +4834,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	spin_unlock(&delayed_rsv->lock);
 
 commit:
-	trans = btrfs_join_transaction(fs_info->fs_root);
+	trans = btrfs_join_transaction(fs_info->extent_root);
 	if (IS_ERR(trans))
 		return -ENOSPC;
 
@@ -4852,7 +4852,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
 		       u64 orig_bytes, int state)
 {
-	struct btrfs_root *root = fs_info->fs_root;
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_trans_handle *trans;
 	int nr;
 	int ret = 0;
@@ -5052,7 +5052,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	int flush_state = FLUSH_DELAYED_ITEMS_NR;
 
 	spin_lock(&space_info->lock);
-	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->fs_root,
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->extent_root,
 						      space_info);
 	if (!to_reclaim) {
 		spin_unlock(&space_info->lock);
-- 
1.8.5.6

