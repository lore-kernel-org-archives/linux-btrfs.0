From: Li Dongyang <jerry87905@gmail.com>
Subject: [PATCH] Btrfs: make sure we call recalculate_thresholds() in
 btrfs_remove_free_space()
Date: Fri, 25 Feb 2011 20:16:06 +0800
Message-ID: <20110225121606.GA4248@Archlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

we should recalculate the thresholds everytime when we add/free a bitmap,
make sure we do this in btrfs_remove_free_space() by calling free_bitmap(),Thanks

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/free-space-cache.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a039065..f631817 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1515,12 +1515,12 @@ again:
 	}
 
 	if (info->bytes == bytes) {
-		unlink_free_space(block_group, info);
-		if (info->bitmap) {
-			kfree(info->bitmap);
-			block_group->total_bitmaps--;
+		if (info->bitmap)
+			free_bitmap(block_group, info);
+		else {
+			unlink_free_space(block_group, info);
+			kfree(info);
 		}
-		kfree(info);
 		goto out_lock;
 	}
 
-- 
1.7.4.1

