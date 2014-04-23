Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37720 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752061AbaDWLhE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 07:37:04 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaox@cn.fujitsu.com>, <stable@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] Btrfs: fix inode caching vs tree log
Date: Wed, 23 Apr 2014 19:33:36 +0800
Message-ID: <1398252816-30600-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

Currently, with inode cache enabled, we will reuse its inode id immediately
after unlinking file, we may hit something like following:

|->iput inode
|->return inode id into inode cache
|->create dir,fsync
|->power off

An easy way to reproduce this problem is:

mkfs.btrfs -f /dev/sdb
mount /dev/sdb /mnt -o inode_cache,commit=100
dd if=/dev/zero of=/mnt/data bs=1M count=10 oflag=sync
inode_id=`ls -i /mnt/data | awk '{print $1}'`
rm -f /mnt/data

i=1
while [ 1 ]
do
        mkdir /mnt/dir_$i
        test1=`stat /mnt/dir_$i | grep Inode: | awk '{print $4}'`
        if [ $test1 -eq $inode_id ]
        then
		dd if=/dev/zero of=/mnt/dir_$i/data bs=1M count=1 oflag=sync
		echo b > /proc/sysrq-trigger
	fi
	sleep 1
        i=$(($i+1))
done

mount /dev/sdb /mnt
umount /dev/sdb
btrfs check /dev/sdb

We fix this problem by adding unlinked inode's id into pinned tree,
and we can not reuse them until committing transaction.

Cc: stable@vger.kernel.org
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Regression test will be sent later
---
 fs/btrfs/inode-map.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 8ad529e..86935f5 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -209,24 +209,14 @@ again:
 
 void btrfs_return_ino(struct btrfs_root *root, u64 objectid)
 {
-	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	struct btrfs_free_space_ctl *pinned = root->free_ino_pinned;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return;
-
 again:
 	if (root->cached == BTRFS_CACHE_FINISHED) {
-		__btrfs_add_free_space(ctl, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 	} else {
-		/*
-		 * If we are in the process of caching free ino chunks,
-		 * to avoid adding the same inode number to the free_ino
-		 * tree twice due to cross transaction, we'll leave it
-		 * in the pinned tree until a transaction is committed
-		 * or the caching work is done.
-		 */
-
 		down_write(&root->fs_info->commit_root_sem);
 		spin_lock(&root->cache_lock);
 		if (root->cached == BTRFS_CACHE_FINISHED) {
@@ -238,11 +228,7 @@ again:
 
 		start_caching(root);
 
-		if (objectid <= root->cache_progress ||
-		    objectid >= root->highest_objectid)
-			__btrfs_add_free_space(ctl, objectid, 1);
-		else
-			__btrfs_add_free_space(pinned, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 
 		up_write(&root->fs_info->commit_root_sem);
 	}
-- 
1.9.0

