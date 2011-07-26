From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Protect the readonly flag of block group
Date: Tue, 26 Jul 2011 11:30:11 +0800
Message-ID: <4E2E34C3.2040203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The access for ro in btrfs_block_group_cache should be protected
because of the racy lock in relocation.

Signed-off-by: Wu Bo <wu.bo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ee6bd5..cc9bf80 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8143,11 +8143,14 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 	u64 num_bytes;
 	int ret = -ENOSPC;
 
-	if (cache->ro)
-		return 0;
-
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
+
+	if (cache->ro) {
+		ret = 0;
+		goto out;
+	}
+
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
 
@@ -8160,7 +8163,7 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 		cache->ro = 1;
 		ret = 0;
 	}
-
+out:
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
 	return ret;
-- 1.7.3.1
