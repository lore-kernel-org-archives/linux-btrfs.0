Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33541 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbeF0KT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 06:19:59 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com
Subject: [PATCH v1] btrfs: quota: Set rescan progress to (u64)-1 if we hit last leaf
Date: Wed, 27 Jun 2018 18:19:55 +0800
Message-Id: <20180627101955.12034-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf
of extent tree") added a new exit for rescan finish.

However after finishing quota rescan, we set
fs_info->qgroup_rescan_progress to (u64)-1 before we exit through the
original exit path.
While we missed that assignment of (u64)-1 in the new exit path.

The end result is, the quota status item doesn't have the same value.
(-1 vs the last bytenr + 1)
Although it doesn't affect quota accounting, it's still better to keep
the original behavior.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Fixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Commit message update, as the bug only changes the resulting quota status
  item without impacting the behavior.
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

