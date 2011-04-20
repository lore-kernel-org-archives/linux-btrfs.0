From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Free free_space item properly in btrfs_trim_block_group()
Date: Wed, 20 Apr 2011 16:37:39 +0800
Message-ID: <4DAE9B53.7090504@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: lidongyang@novell.com
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since commit dc89e9824464e91fa0b06267864ceabe3186fd8b, we've changed
to use a specific slab for alocation of free_space items.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 11d2e9c..13c29b1 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2301,7 +2301,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			start = entry->offset;
 			bytes = min(entry->bytes, end - start);
 			unlink_free_space(block_group, entry);
-			kfree(entry);
+			kmem_cache_free(btrfs_free_space_cachep, entry);
 		}
 
 		spin_unlock(&block_group->tree_lock);
-- 1.7.3.1 
