From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 1/2] Btrfs: fix to search one more bitmap for cluster setup
Date: Thu, 17 Nov 2011 15:04:32 +0800
Message-ID: <4EC4B200.7070709@cn.fujitsu.com>
References: <4EC34767.4010009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC34767.4010009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Suppose there are two bitmaps [0, 256], [256, 512] and one extent
[100, 120] in the free space cache, and we want to setup a cluster
with offset=100, bytes=50.

In this case, there will be only one bitmap [256, 512] in the temporary
bitmaps list, and then setup_cluster_bitmap() won't search bitmap [0, 256].

The cause is, the list is constructed in setup_cluster_no_bitmap(),
and only bitmaps with bitmap_entry->offset >= offset will be added
into the list, and the very bitmap that convers offset has
bitmap_entry->offset <= offset.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

v2: fix a NULL pointer deref.

---
 fs/btrfs/free-space-cache.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 181760f..8f792f4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2453,11 +2453,23 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
 	int ret = -ENOSPC;
+	u64 bitmap_offset = offset_to_bitmap(ctl, offset);
 
 	if (ctl->total_bitmaps == 0)
 		return -ENOSPC;
 
 	/*
+	 * The bitmap that covers offset won't be in the list unless offset
+	 * is just its start offset.
+	 */
+	entry = list_first_entry(bitmaps, struct btrfs_free_space, list);
+	if (entry->offset != bitmap_offset) {
+		entry = tree_search_offset(ctl, bitmap_offset, 1, 0);
+		if (entry && list_empty(&entry->list))
+			list_add(&entry->list, bitmaps);
+	}
+
+	/*
 	 * First check our cached list of bitmaps and see if there is an entry
 	 * here that will work.
 	 */
-- 
1.7.3.1
