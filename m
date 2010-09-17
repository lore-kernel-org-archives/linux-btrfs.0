From: Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH] Btrfs: fix delalloc checks in clone ioctl
Date: Fri, 17 Sep 2010 15:42:05 -0700
Message-ID: <812cd3a0ede2021247239945ffeb49e2fa421f22.1284763172.git.yehuda@hq.newdream.net>
Cc: sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The lookup_first_ordered_extent() was done on the wrong inode, and the
->delalloc_bytes test was wrong, as the following btrfs_wait_ordered_range()
would only invoke a range write and wouldn't write the entire file data range.
Also, a bad parameter was passed to btrfs_wait_ordered_range().

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/ioctl.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..e09d6f0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1530,13 +1530,15 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
-		ordered = btrfs_lookup_first_ordered_extent(inode, off+len);
-		if (BTRFS_I(src)->delalloc_bytes == 0 && !ordered)
+		ordered = btrfs_lookup_first_ordered_extent(src, off+len);
+		if (!ordered &&
+		    test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
+				   EXTENT_DELALLOC, 0, NULL))
 			break;
 		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-		btrfs_wait_ordered_range(src, off, off+len);
+		btrfs_wait_ordered_range(src, off, len);
 	}
 
 	/* clone data */
-- 
1.5.6.5

