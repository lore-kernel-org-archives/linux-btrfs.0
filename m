From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/6] btrfs: update stats when allocating from a cluster
Date: Mon, 23 Aug 2010 09:23:29 +0800
Message-ID: <4C71CD91.4050703@cn.fujitsu.com>
References: <4C71CD4B.10606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When allocating extent entry from a cluster, we should update
the free_space and free_extents fields of the block group.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 631e14f..20f3141 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1090,15 +1090,26 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
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
1.7.0.1

