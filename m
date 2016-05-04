Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34084 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756896AbcEDBTj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 21:19:39 -0400
Date: Tue, 3 May 2016 21:10:09 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH, maybe WRONG] btrfs: don't let btrfs_recover_relocation get
 stuck waiting for cleaner_kthread to delete a snapshot
Message-ID: <20160504011009.GB15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is one way to fix a long hang during mounts.  There's probably a
better way, but this is the one I've used to get my filesystems up
and running.

We start the cleaner kthread first because the transaction kthread wants
to wake up the cleaner kthread.  We start the transaction kthread next
because everything in btrfs wants transactions.  We do reloc recovery
once the transaction kthread is running.  This means that the cleaner
kthread could already be running when reloc recovery happens (e.g. if a
snapshot delete was started before a crash).

Reloc recovery does not play well with the cleaner kthread, so a mutex
was added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs:
fix race between balance recovery and root deletion" to prevent both
from running at the same time.

The cleaner kthread could already be holding the mutex by the time we
get to btrfs_recover_relocation, and if it is, the mount will be blocked
until at least one snapshot is deleted (possibly more if the mount process
doesn't get the lock right away).  During this time (which could be an
arbitrarily long time on a large/slow filesystem), the mount process is
stuck and the filesystem is unnecessarily inaccessible.

Fix this by locking cleaner_mutex before we start the cleaner_kthread,
and unlocking it when we have finished with it in the mount function.
This allows the mount to proceed to completion before resuming snapshot
deletion.  I'm not sure about the error cases, and the asymmetrical
pthread_mutex_lock/unlocks are just ugly.  Other than that, this patch
works.

An alternative (and possibly better) solution would be to add an extra
check in btrfs_need_cleaner_sleep() for a flag that would be set at the
end of mounting.  This should keep cleaner_kthread sleeping until just
before mount is finished.


---
 fs/btrfs/disk-io.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07c1ad6..af5ea1d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2927,6 +2927,10 @@ retry_root_backup:
 			"too many missing devices, writeable mount should not be allowed\n");
 	}
 
+	/* Hold the cleaner_mutex thread here so that we don't block
+	 * on btrfs_recover_relocation later on.  cleaner_kthread
+	 * blocks on us instead. */
+	mutex_lock(&fs_info->cleaner_mutex);
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
@@ -2986,9 +2990,8 @@ retry_root_backup:
 		if (ret)
 			goto fail_qgroup;
 
-		mutex_lock(&fs_info->cleaner_mutex);
+		/* We grabbed this mutex before we created the cleaner_kthread */
 		ret = btrfs_recover_relocation(tree_root);
-		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
 			printk(KERN_WARNING
 			       "BTRFS: failed to recover relocation\n");
@@ -2996,6 +2999,7 @@ retry_root_backup:
 			goto fail_qgroup;
 		}
 	}
+	mutex_unlock(&fs_info->cleaner_mutex);
 
 	location.objectid = BTRFS_FS_TREE_OBJECTID;
 	location.type = BTRFS_ROOT_ITEM_KEY;
@@ -3079,6 +3083,7 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
 fail_sysfs:
+	mutex_unlock(&fs_info->cleaner_mutex);
 	btrfs_sysfs_remove_one(fs_info);
 
 fail_block_groups:
-- 
2.1.4

