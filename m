From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 04/12] btrfs: Update stats when allocating from a cluster
Date: Thu, 27 Jan 2011 16:43:38 +0800
Message-ID: <4D41303A.4070705@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When allocating extent entry from a cluster, we should update
the free_space and free_extents fields of the block group.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cb0137e..2974c47 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1843,15 +1843,26 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		entry->offset += bytes;
 		entry->bytes -= bytes;
 
-		if (entry->bytes == 0) {
+		if (entry->bytes == 0)
 			rb_erase(&entry->offset_index, &cluster->root);
-			kfree(entry);
-		}
 		break;
 	}
 out:
 	spin_unlock(&cluster->lock);
 
+	if (!ret)
+		return 0;
+
+	spin_lock(&block_group->tree_lock);
+
+	block_group->free_space -= bytes;
+	if (entry->bytes == 0) {
+		block_group->free_extents--;
+		kfree(entry);
+	}
+
+	spin_unlock(&block_group->tree_lock);
+
 	return ret;
 }
 
-- 
1.6.3
