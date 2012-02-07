From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] btrfs: Fix typo in free-space-cache.c
Date: Tue,  7 Feb 2012 22:21:45 +0900
Message-ID: <1328620905-1713-1-git-send-email-standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
	standby24x7@gmail.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Correct spelling "cace" to "cache" in
fs/btrfs/free-space-cache.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c2f2059..7f4f302 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1067,7 +1067,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_unlock(&block_group->lock);
 		ret = 0;
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free space cace "
+		printk(KERN_ERR "btrfs: failed to write free space cache "
 		       "for block group %llu\n", block_group->key.objectid);
 #endif
 	}
-- 
1.7.6.5
