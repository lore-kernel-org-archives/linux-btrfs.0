From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not defrag a file partially
Date: Mon, 16 Jan 2012 18:21:13 +0800
Message-ID: <1326709273-30384-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

xfstests 218 complains that btrfs defrags a file partially:
 After: 1
 Write backwards sync, but contiguous - should defrag to 1 extent
 Before: 10
-After: 1
+After: 2

To fix this, we need to set max_to_defrag count properly.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c04f02c..712fb0c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1058,7 +1058,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		i = range->start >> PAGE_CACHE_SHIFT;
 	}
 	if (!max_to_defrag)
-		max_to_defrag = last_index;
+		max_to_defrag = last_index + 1;
 
 	/*
 	 * make writeback starts from i, so the defrag range can be
-- 
1.6.5.2

