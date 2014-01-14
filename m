Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17483 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANLn2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 06:43:28 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0EBhP8L014316
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 19:43:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix transaction abortion when remounting btrfs from RW to RO
Date: Tue, 14 Jan 2014 19:42:20 +0800
Message-Id: <1389699740-21442-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda8
 # mount /dev/sda8 /mnt -o flushoncommit
 # dd if=/dev/zero of=/mnt/data bs=4k count=102400 &
 # mount /dev/sda8 /mnt -o remount, ro

When remounting RW to RO, the logic is to firstly set flag
to RO and then commit transaction, however with option
flushoncommit enabled,we will do RO check within committing
transaction, so we get a transaction abortion here.

Actually,here check is wrong, we should check if FS_STATE_ERROR
is set, fix it.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Suggested-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog v1->v2:
	Miao makes me in the right way as soon as he gets time
	to review this,thanks.
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1ea19ce..7b61ea3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8477,7 +8477,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 {
 	int ret;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
+	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return -EROFS;
 
 	ret = __start_delalloc_inodes(root, delay_iput);
@@ -8503,7 +8503,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
 	struct list_head splice;
 	int ret;
 
-	if (fs_info->sb->s_flags & MS_RDONLY)
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		return -EROFS;
 
 	INIT_LIST_HEAD(&splice);
-- 
1.8.3.1

