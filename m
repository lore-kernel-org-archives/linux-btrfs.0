Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbaDOOmF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:42:05 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: assert that send is not in progres before root deletion
Date: Tue, 15 Apr 2014 16:42:03 +0200
Message-Id: <d3b3541addf25947ff6c6fa7b7d2ff3e7f952111.1397572052.git.dsterba@suse.cz>
In-Reply-To: <cover.1397572052.git.dsterba@suse.cz>
References: <cover.1397572052.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC: Miao Xie <miaox@cn.fujitsu.com>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c       |    1 +
 fs/btrfs/transaction.c |   13 -------------
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a385d88bd8d5..3cdb62e7cab8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2352,6 +2352,7 @@ out_unlock:
 		shrink_dcache_sb(root->fs_info->sb);
 		btrfs_invalidate_inodes(dest);
 		d_delete(dentry);
+		ASSERT(dest->send_in_progress == 0);
 
 		/* the last ref */
 		if (dest->cache_inode) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 34cd83184c4a..c2ae9bb1c308 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1977,19 +1977,6 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	}
 	root = list_first_entry(&fs_info->dead_roots,
 			struct btrfs_root, root_list);
-	/*
-	 * Make sure root is not involved in send,
-	 * if we fail with first root, we return
-	 * directly rather than continue.
-	 */
-	spin_lock(&root->root_item_lock);
-	if (root->send_in_progress) {
-		spin_unlock(&fs_info->trans_lock);
-		spin_unlock(&root->root_item_lock);
-		return 0;
-	}
-	spin_unlock(&root->root_item_lock);
-
 	list_del_init(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-- 
1.7.9

