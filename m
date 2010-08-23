From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/6] btrfs: free fully occupied bitmap in cluster
Date: Mon, 23 Aug 2010 09:23:16 +0800
Message-ID: <4C71CD84.1000809@cn.fujitsu.com>
References: <4C71CD4B.10606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If there's no more free space in a bitmap, we should free it,
otherwise seems it won't get freed until we free the block group.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 017fd55..631e14f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1035,6 +1035,8 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	ret = search_start;
 	bitmap_clear_bits(block_group, entry, ret, bytes);
+	if (entry->bytes == 0)
+		free_bitmap(block_group, entry);
 out:
 	spin_unlock(&cluster->lock);
 	spin_unlock(&block_group->tree_lock);
-- 
1.7.0.1
