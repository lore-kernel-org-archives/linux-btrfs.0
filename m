From: Sage Weil <sage@newdream.net>
Subject: [PATCH 1/3] Btrfs: fix delalloc checks in clone ioctl
Date: Tue, 19 Oct 2010 15:22:10 -0700
Message-ID: <1287526932-28369-2-git-send-email-sage@newdream.net>
References: <1287526932-28369-1-git-send-email-sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287526932-28369-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Yehuda Sadeh <yehuda@hq.newdream.net>

The lookup_first_ordered_extent() was done on the wrong inode, and the 
->delalloc_bytes test was wrong, as the following 
btrfs_wait_ordered_range() would only invoke a range write and wouldn't 
write the entire file data range. Also, a bad parameter was passed to 
btrfs_wait_ordered_range().

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/ioctl.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..3471b22 100644
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
+		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
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
1.7.0.4

