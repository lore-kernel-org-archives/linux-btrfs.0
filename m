Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36459 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754112AbeDBJSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 05:18:48 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id BE27D48AE783
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Apr 2018 17:18:40 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: rename btrfs_get_block_group_info and make it static
Date: Mon, 2 Apr 2018 17:24:11 +0800
Message-ID: <20180402092411.14960-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function btrfs_get_block_group_info() was introduced by the
commit 5af3e8cce8b7 ("Btrfs: make filesystem read-only when submitting
 barrier fails") which used it in disk-io.c.

However, the function is only called in ioctl.c now.
Its parameter type btrfs_ioctl_space_info* is only for ioctl.

So, make it static and rename it to be original name
get_block_group_info.

No functional change.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 2 --
 fs/btrfs/ioctl.c | 8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0eb55825862a..e69ef37efbc1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3253,8 +3253,6 @@ int btrfs_is_empty_uuid(u8 *uuid);
 int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      struct btrfs_ioctl_defrag_range_args *range,
 		      u64 newer_than, unsigned long max_pages);
-void btrfs_get_block_group_info(struct list_head *groups_list,
-				struct btrfs_ioctl_space_info *space);
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 			       struct btrfs_ioctl_balance_args *bargs);
 ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4ba793f25c3a..184001ffe38c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4047,8 +4047,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	return ret;
 }
 
-void btrfs_get_block_group_info(struct list_head *groups_list,
-				struct btrfs_ioctl_space_info *space)
+static void get_block_group_info(struct list_head *groups_list,
+				 struct btrfs_ioctl_space_info *space)
 {
 	struct btrfs_block_group_cache *block_group;
 
@@ -4164,8 +4164,8 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 		down_read(&info->groups_sem);
 		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
 			if (!list_empty(&info->block_groups[c])) {
-				btrfs_get_block_group_info(
-					&info->block_groups[c], &space);
+				get_block_group_info(&info->block_groups[c],
+						     &space);
 				memcpy(dest, &space, sizeof(space));
 				dest++;
 				space_args.total_spaces++;
-- 
2.16.3



