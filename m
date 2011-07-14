From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 03/16] Btrfs: fix space leak when trimming free extents
Date: Thu, 14 Jul 2011 11:16:32 +0800
Message-ID: <4E1E5F90.50700@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When the end of an extent exceeds the end of the specified range,
the extent will be accidentally truncated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 901585d..cf4bffd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2512,8 +2512,15 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			bytes = min(entry->bytes, end - start);
 			if (bytes < minlen)
 				goto next;
+
 			unlink_free_space(ctl, entry);
-			kmem_cache_free(btrfs_free_space_cachep, entry);
+			if (bytes < entry->bytes) {
+				entry->offset = entry->offset + bytes;
+				entry->bytes = entry->bytes - bytes;
+				link_free_space(ctl, entry);
+			} else {
+				kmem_cache_free(btrfs_free_space_cachep, entry);
+			}
 		}
 
 		spin_unlock(&ctl->tree_lock);
-- 
1.7.3.1
