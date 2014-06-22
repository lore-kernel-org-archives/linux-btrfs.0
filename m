Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:53560 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaFVMaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 08:30:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Btrfs: Refactor btrfs_lock_cluster() to kill compiler warning
Date: Sun, 22 Jun 2014 14:30:09 +0200
Message-Id: <1403440209-13370-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/extent-tree.c: In function ‘btrfs_lock_cluster’:
fs/btrfs/extent-tree.c:6399: warning: ‘used_bg’ may be used uninitialized in this function

  - Replace "again: ... goto again;" by standard C "while (1) { ... }",
  - Move block not processed during the first iteration of the loop to the
    end of the loop, which allows to kill the "locked" variable,

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Please review, compile tested only.
---
 fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99c253918208..e151c4a73d7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6397,36 +6397,34 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 		   int delalloc)
 {
 	struct btrfs_block_group_cache *used_bg;
-	bool locked = false;
-again:
+
 	spin_lock(&cluster->refill_lock);
-	if (locked) {
-		if (used_bg == cluster->block_group)
-			return used_bg;
+	while (1) {
+		used_bg = cluster->block_group;
+		if (!used_bg)
+			return NULL;
 
-		up_read(&used_bg->data_rwsem);
-		btrfs_put_block_group(used_bg);
-	}
+		if (used_bg == block_group)
+			return used_bg;
 
-	used_bg = cluster->block_group;
-	if (!used_bg)
-		return NULL;
+		btrfs_get_block_group(used_bg);
 
-	if (used_bg == block_group)
-		return used_bg;
+		if (!delalloc)
+			return used_bg;
 
-	btrfs_get_block_group(used_bg);
+		if (down_read_trylock(&used_bg->data_rwsem))
+			return used_bg;
 
-	if (!delalloc)
-		return used_bg;
+		spin_unlock(&cluster->refill_lock);
+		down_read(&used_bg->data_rwsem);
 
-	if (down_read_trylock(&used_bg->data_rwsem))
-		return used_bg;
+		spin_lock(&cluster->refill_lock);
+		if (used_bg == cluster->block_group)
+			return used_bg;
 
-	spin_unlock(&cluster->refill_lock);
-	down_read(&used_bg->data_rwsem);
-	locked = true;
-	goto again;
+		up_read(&used_bg->data_rwsem);
+		btrfs_put_block_group(used_bg);
+	}
 }
 
 static inline void
-- 
1.9.1

