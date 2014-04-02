Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39318 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758407AbaDBLzz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 07:55:55 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s32Btrfx025494
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 19:55:53 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix unlock in __start_delalloc_inodes()
Date: Wed, 2 Apr 2014 19:53:32 +0800
Message-ID: <1396439612-6076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fix a regression caused by the following patch:
Btrfs: don't flush all delalloc inodes when we doesn't get s_umount lock

break while loop will make us call @spin_unlock() without
calling @spin_lock() before, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5cb3075..f1e5297 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8481,19 +8481,20 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 			else
 				iput(inode);
 			ret = -ENOMEM;
-			break;
+			goto out;
 		}
 		list_add_tail(&work->list, &works);
 		btrfs_queue_work(root->fs_info->flush_workers,
 				 &work->work);
 		ret++;
 		if (nr != -1 && ret >= nr)
-			break;
+			goto out;
 		cond_resched();
 		spin_lock(&root->delalloc_lock);
 	}
 	spin_unlock(&root->delalloc_lock);
 
+out:
 	list_for_each_entry_safe(work, next, &works, list) {
 		list_del_init(&work->list);
 		btrfs_wait_and_free_delalloc_work(work);
-- 
1.9.0

