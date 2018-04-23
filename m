Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbeDWHyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE664AE08
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/5] btrfs: Remove delay_iput parameter from __start_delalloc_inodes
Date: Mon, 23 Apr 2018 10:54:15 +0300
Message-Id: <1524470057-21969-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's always set to 0 so remove it

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 855237737acb..42a2590559df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10189,8 +10189,7 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
-				   int nr)
+static int __start_delalloc_inodes(struct btrfs_root *root, int nr)
 {
 	struct btrfs_inode *binode;
 	struct inode *inode;
@@ -10218,12 +10217,9 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 		}
 		spin_unlock(&root->delalloc_lock);
 
-		work = btrfs_alloc_delalloc_work(inode, delay_iput);
+		work = btrfs_alloc_delalloc_work(inode, 0);
 		if (!work) {
-			if (delay_iput)
-				btrfs_add_delayed_iput(inode);
-			else
-				iput(inode);
+			iput(inode);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -10262,7 +10258,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root)
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		return -EROFS;
 
-	ret = __start_delalloc_inodes(root, 0, -1);
+	ret = __start_delalloc_inodes(root, -1);
 	if (ret > 0)
 		ret = 0;
 	return ret;
@@ -10291,7 +10287,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr)
 			       &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 
-		ret = __start_delalloc_inodes(root, 0, nr);
+		ret = __start_delalloc_inodes(root, nr);
 		btrfs_put_fs_root(root);
 		if (ret < 0)
 			goto out;
-- 
2.7.4

