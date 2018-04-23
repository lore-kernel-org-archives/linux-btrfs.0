Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754132AbeDWHyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F02DADFA
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/5] btrfs: Remove delayed_iput parameter from btrfs_start_delalloc_inodes
Date: Mon, 23 Apr 2018 10:54:14 +0300
Message-Id: <1524470057-21969-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's always set to 0, so just remove it and collapse the constant value
to the only function we are passing it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 4 ++--
 fs/btrfs/ioctl.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8c5ab06ccc0a..1ac983270bb7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3198,7 +3198,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct inode *inode, u64 new_size,
 			       u32 min_type);
 
-int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
+int btrfs_start_delalloc_inodes(struct btrfs_root *root);
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 74ea63159b93..855237737acb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10254,7 +10254,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 	return ret;
 }
 
-int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
+int btrfs_start_delalloc_inodes(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -10262,7 +10262,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		return -EROFS;
 
-	ret = __start_delalloc_inodes(root, delay_iput, -1);
+	ret = __start_delalloc_inodes(root, 0, -1);
 	if (ret > 0)
 		ret = 0;
 	return ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ea192378cb3b..f94b70e3525d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -640,7 +640,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	wait_event(root->subv_writers->wait,
 		   percpu_counter_sum(&root->subv_writers->counter) == 0);
 
-	ret = btrfs_start_delalloc_inodes(root, 0);
+	ret = btrfs_start_delalloc_inodes(root);
 	if (ret)
 		goto dec_and_free;
 
-- 
2.7.4

