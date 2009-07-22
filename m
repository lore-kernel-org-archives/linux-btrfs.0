From: LiYu <raise.sail@gmail.com>
Subject: [PATCH] btrfs-progs: remove a redundant btrfs_find_block_group()
 call
Date: Wed, 22 Jul 2009 15:18:53 +0800
Message-ID: <4A66BD5D.9060403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


It seem that we have a redundant btrfs_find_block_group() call in extent-tree.c/find_search_start(), is this guess right?

Signed-off-by: Li Yu <raise.sail@gmail.com>

---
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..1c932c2 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -299,7 +299,6 @@ no_cache:
                goto out;
        }
        cache = btrfs_find_block_group(root, cache, last, data, 0);
-       cache = btrfs_find_block_group(root, cache, last, data, 0);
        if (!cache)
                goto no_cache;
 
