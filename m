Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932234AbeF0Isn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:48:43 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com
Subject: [PATCH] btrfs: quota: Reset rescan progress if we hit last leaf
Date: Wed, 27 Jun 2018 16:48:40 +0800
Message-Id: <20180627084840.32033-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
added a new exit for rescan finish.

However after finishing quota rescan, we set
fs_info->qgroup_rescan_progress to (u64)-1, as qgroup_rescan_progress is also
used to determine whether we should account dirty extents.
Since if dirty extents is after qgroup_rescan_progress, we don't need to
account it as rescan will account them later.

Without properly setting qgroup_rescan_progress to (u64)-1, all later
dirty extents after qgroup_rescan_progress will be ignored, thus
screwing up the whole quota accounting.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Fixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1874a6d2e6f5..99f2b9ce0f15 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2680,8 +2680,10 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		free_extent_buffer(scratch_leaf);
 	}
 
-	if (done && !ret)
+	if (done && !ret) {
 		ret = 1;
+		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
+	}
 	return ret;
 }
 
-- 
2.18.0

