From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3][URGENT] Btrfs: allow future use of type field of struct
 btrfs_free_space_entry
Date: Thu, 29 Dec 2011 17:49:38 +0800
Message-ID: <4EFC37B2.4050009@cn.fujitsu.com>
References: <4EFC378D.7090606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFC378D.7090606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This field indicates if an entry is an extent or a bitmap, and only 2
bits of it are used.

This patch makes the other bits are avaiable for future use without
breaking old kernels. For example, we're going to use one bit to
mark if the free space has been trimmed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

This has to be queued for 3.2, so later patches can affect 3.2-rcX
kernels only.

---
 fs/btrfs/ctree.h            |    4 ++--
 fs/btrfs/free-space-cache.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6738503..ca4eb2d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -278,8 +278,8 @@ struct btrfs_chunk {
 	/* additional stripes go here */
 } __attribute__ ((__packed__));
 
-#define BTRFS_FREE_SPACE_EXTENT	1
-#define BTRFS_FREE_SPACE_BITMAP	2
+#define BTRFS_FREE_SPACE_EXTENT		(1 << 0)
+#define BTRFS_FREE_SPACE_BITMAP		(1 << 1)
 
 struct btrfs_free_space_entry {
 	__le64 offset;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..044c0ec 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -669,7 +669,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			goto free_cache;
 		}
 
-		if (type == BTRFS_FREE_SPACE_EXTENT) {
+		if (type & BTRFS_FREE_SPACE_EXTENT) {
 			spin_lock(&ctl->tree_lock);
 			ret = link_free_space(ctl, e);
 			spin_unlock(&ctl->tree_lock);
@@ -679,7 +679,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-		} else {
+		} else if (type & BTRFS_FREE_SPACE_BITMAP) {
 			BUG_ON(!num_bitmaps);
 			num_bitmaps--;
 			e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
-- 1.7.3.1 
