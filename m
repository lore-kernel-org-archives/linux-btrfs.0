Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34459 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaIUEma (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 00:42:30 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so2824344pad.35
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 21:42:29 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] btrfs: fix ABBA deadlock in btrfs_dev_replace_finishing()
Date: Sun, 21 Sep 2014 12:41:49 +0800
Message-Id: <1411274509-10230-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_map_bio() first calls btrfs_bio_counter_inc_blocked() which checks
fs state and increase bio_counter, then calls __btrfs_map_block() which
will take the dev_replace lock.

On the other hand, btrfs_dev_replace_finishing() takes dev_replace lock
first then set fs state to BTRFS_FS_STATE_DEV_REPLACING and waits for
bio_counter to be zero.

The deadlock can be reproduced easily by running replace and fsstress at
the same time, e.g.

mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
mount /dev/sdb1 /mnt/btrfs
fsstress -d /mnt/btrfs -n 100 -p 2 -l 0 & # fsstress from ltp supports -l option
i=0
while btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs && \
      btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs; do
	echo "=== loop $i ==="
	let i=$i+1
done

This was introduced by

c404e0d Btrfs: fix use-after-free in the finishing procedure of the device replace

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

Tested by the reproducer and xfstests, no new failure found.

But I found kmem_cache leak if I remove btrfs module after my new test case[1],
which does fsstress & replace & subvolume create/mount/umount/delete at the same
time.

BUG btrfs_extent_state (Tainted: G    B         ): Objects remaining in btrfs_extent_state on kmem_cache_close()
......
kmem_cache_destroy btrfs_extent_state: Slab cache still has objects
CPU: 3 PID: 9503 Comm: modprobe Tainted: G    B          3.17.0-rc5+ #12
Hardware name: Hewlett-Packard ProLiant DL388eGen8, BIOS P73 06/01/2012
 0000000000000000 000000008dd09c52 ffff880411c37eb0 ffffffff81642f7a
 ffff8800b9a19300 ffff880411c37ed0 ffffffff8118ce89 0000000000000000
 ffffffffa05dcd20 ffff880411c37ee0 ffffffffa056a80f ffff880411c37ef0
Call Trace:
 [<ffffffff81642f7a>] dump_stack+0x45/0x56
 [<ffffffff8118ce89>] kmem_cache_destroy+0xf9/0x100
 [<ffffffffa056a80f>] extent_io_exit+0x1f/0x50 [btrfs]
 [<ffffffffa05c3ae3>] exit_btrfs_fs+0x2c/0x549 [btrfs]
 [<ffffffff810efda2>] SyS_delete_module+0x162/0x200
 [<ffffffff81013bb7>] ? do_notify_resume+0x97/0xb0
 [<ffffffff8164af69>] system_call_fastpath+0x16/0x1b

The test would hang before the fix. I'm not sure if it's related to the fix
(seems not), please help review.

Thanks,
Eryu Guan

[1] http://www.spinics.net/lists/linux-btrfs/msg37625.html

 fs/btrfs/dev-replace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..5dfd292 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -510,6 +510,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&root->fs_info->chunk_mutex);
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	btrfs_rm_dev_replace_blocked(fs_info);
 	btrfs_dev_replace_lock(dev_replace);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
@@ -567,12 +568,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	btrfs_kobj_rm_device(fs_info, src_device);
 	btrfs_kobj_add_device(fs_info, tgt_device);
 
-	btrfs_rm_dev_replace_blocked(fs_info);
-
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
 
-	btrfs_rm_dev_replace_unblocked(fs_info);
-
 	/*
 	 * this is again a consistent state where no dev_replace procedure
 	 * is running, the target device is part of the filesystem, the
@@ -581,6 +578,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * belong to this filesystem.
 	 */
 	btrfs_dev_replace_unlock(dev_replace);
+	btrfs_rm_dev_replace_unblocked(fs_info);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	mutex_unlock(&root->fs_info->chunk_mutex);
 
-- 
1.8.3.1

