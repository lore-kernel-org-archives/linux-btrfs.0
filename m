From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 03/12] btrfs: Free fully occupied bitmap in cluster
Date: Thu, 27 Jan 2011 16:43:17 +0800
Message-ID: <4D413025.4010404@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If there's no more free space in a bitmap, we should free it.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 850104f..cb0137e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1788,6 +1788,8 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	ret = search_start;
 	bitmap_clear_bits(block_group, entry, ret, bytes);
+	if (entry->bytes == 0)
+		free_bitmap(block_group, entry);
 out:
 	spin_unlock(&cluster->lock);
 	spin_unlock(&block_group->tree_lock);
-- 
1.6.3
