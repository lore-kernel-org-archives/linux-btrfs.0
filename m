From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not mount when we have a sectorsize larger than PAGE_SIZE
Date: Mon, 2 Apr 2012 19:28:18 +0800
Message-ID: <1333366098-32341-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our code is not ready to cope with a sectorsize that's larger than PAGE_SIZE.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..08e49d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2104,6 +2104,14 @@ int open_ctree(struct super_block *sb,
 		err = -EINVAL;
 		goto fail_alloc;
 	}
+	if (btrfs_super_sectorsize(disk_super) > PAGE_CACHE_SIZE) {
+		printk(KERN_ERR "BTRFS: couldn't mount because sectorsize(%d)"
+		       " was larger than PAGE_SIZE(%lu)\n",
+		       btrfs_super_sectorsize(disk_super),
+		       (unsigned long long)PAGE_CACHE_SIZE);
+		err = -EINVAL;
+		goto fail_alloc;
+	}
 
 	features = btrfs_super_incompat_flags(disk_super);
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-- 
1.6.5.2

