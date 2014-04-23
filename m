Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbaDWLg5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 07:36:57 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3NBalD6001614
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 19:36:47 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] Btrfs: avoid triggering bug_on() when we fail to start inode caching task
Date: Wed, 23 Apr 2014 19:33:34 +0800
Message-ID: <1398252816-30600-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running stress test(including snapshots,balance,fstress), we trigger
the following BUG_ON() which is because we fail to start inode caching task.

[  181.131945] kernel BUG at fs/btrfs/inode-map.c:179!
[  181.137963] invalid opcode: 0000 [#1] SMP
[  181.217096] CPU: 11 PID: 2532 Comm: btrfs Not tainted 3.14.0 #1
[  181.240521] task: ffff88013b621b30 ti: ffff8800b6ada000 task.ti: ffff8800b6ada000
[  181.367506] Call Trace:
[  181.371107]  [<ffffffffa036c1be>] btrfs_return_ino+0x9e/0x110 [btrfs]
[  181.379191]  [<ffffffffa038082b>] btrfs_evict_inode+0x46b/0x4c0 [btrfs]
[  181.387464]  [<ffffffff810b5a70>] ? autoremove_wake_function+0x40/0x40
[  181.395642]  [<ffffffff811dc5fe>] evict+0x9e/0x190
[  181.401882]  [<ffffffff811dcde3>] iput+0xf3/0x180
[  181.408025]  [<ffffffffa03812de>] btrfs_orphan_cleanup+0x1ee/0x430 [btrfs]
[  181.416614]  [<ffffffffa03a6abd>] btrfs_mksubvol.isra.29+0x3bd/0x450 [btrfs]
[  181.425399]  [<ffffffffa03a6cd6>] btrfs_ioctl_snap_create_transid+0x186/0x190 [btrfs]
[  181.435059]  [<ffffffffa03a6e3b>] btrfs_ioctl_snap_create_v2+0xeb/0x130 [btrfs]
[  181.444148]  [<ffffffffa03a9656>] btrfs_ioctl+0xf76/0x2b90 [btrfs]
[  181.451971]  [<ffffffff8117e565>] ? handle_mm_fault+0x475/0xe80
[  181.459509]  [<ffffffff8167ba0c>] ? __do_page_fault+0x1ec/0x520
[  181.467046]  [<ffffffff81185b35>] ? do_mmap_pgoff+0x2f5/0x3c0
[  181.474393]  [<ffffffff811d4da8>] do_vfs_ioctl+0x2d8/0x4b0
[  181.481450]  [<ffffffff811d5001>] SyS_ioctl+0x81/0xa0
[  181.488021]  [<ffffffff81680b69>] system_call_fastpath+0x16/0x1b

We should avoid triggering BUG_ON() here, instead, we output warning messages
and clear inode_cache option.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode-map.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index cc8ca19..8ad529e 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -176,7 +176,11 @@ static void start_caching(struct btrfs_root *root)
 
 	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
 			  root->root_key.objectid);
-	BUG_ON(IS_ERR(tsk)); /* -ENOMEM */
+	if (IS_ERR(tsk)) {
+		btrfs_warn(root->fs_info, "failed to start inode caching task");
+		btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+				"disabling inode map caching");
+	}
 }
 
 int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
-- 
1.9.0

