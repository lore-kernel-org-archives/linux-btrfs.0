From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not mount when we have a sectorsize unequal to PAGE_SIZE
Date: Tue, 3 Apr 2012 09:56:53 +0800
Message-ID: <1333418213-2718-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our code is not ready to cope with a sectorsize that's not equal to PAGE_SIZE.
It will lead to hanging-on while writing something.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..b9866f2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2254,9 +2254,9 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	if (sectorsize < PAGE_SIZE) {
-		printk(KERN_WARNING "btrfs: Incompatible sector size "
-		       "found on %s\n", sb->s_id);
+	if (sectorsize != PAGE_SIZE) {
+		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
+		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
 		goto fail_sb_buffer;
 	}
 
-- 
1.6.5.2

