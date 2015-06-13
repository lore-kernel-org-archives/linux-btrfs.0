Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36058 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbFMNUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 09:20:21 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: use kmem_cache_free when freeing entry in inode cache
Date: Sat, 13 Jun 2015 06:52:56 +0100
Message-Id: <1434174777-14409-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The free space entries are allocated using kmem_cache_zalloc(),
through __btrfs_add_free_space(), therefore we should use
kmem_cache_free() and not kfree() to avoid any confusion and
any potential problem. Looking at the kfree() definition at
mm/slab.c it has the following comment:

  /*
   * (...)
   *
   * Don't free memory not originally allocated by kmalloc()
   * or you will run into trouble.
   */

So better be safe and use kmem_cache_free().

Cc: stable@vger.kernel.org
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index f6a596d..218df70 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -271,7 +271,7 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
 		__btrfs_add_free_space(ctl, info->offset, count);
 free:
 		rb_erase(&info->offset_index, rbroot);
-		kfree(info);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 }
 
-- 
2.1.3

