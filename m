Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:45495 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2GaRJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 13:09:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 30.2 OK) with ESMTP id g042cbo6VAGe4h
	for <linux-btrfs@vger.kernel.org>;
	Tue, 31 Jul 2012 19:09:45 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: remove superblock writing after fatal error
Date: Tue, 31 Jul 2012 19:09:45 +0200
Message-Id: <1343754585-18084-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1343754585-18084-1-git-send-email-sbehrens@giantdisaster.de>
References: <1343754585-18084-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With commit acce952b0, btrfs was changed to flag the filesystem with
BTRFS_SUPER_FLAG_ERROR and switch to read-only mode after a fatal
error happened like a write I/O errors of all mirrors.
In such situations, on unmount, the superblock is written in
btrfs_error_commit_super(). This is done with the intention to be able
to evaluate the error flag on the next mount. A warning is printed
in this case during the next mount and the log tree is ignored.

The issue is that it is possible that the superblock points to a root
that was not written (due to write I/O errors).
The result is that the filesystem cannot be mounted. btrfsck also does
not start and all the other btrfs-progs tools fail to start as well.
However, mount -o recovery is working well and does the right things
to recover the filesystem (i.e., don't use the log root, clear the
free space cache and use the next mountable root that is stored in the
root backup array).

There are four options to handle this issue:
1. Leave it as it is since 'mount -o recovery' is working well.
   Adapt the btrfs-progs tools to allow similar recovery options.
2. Do not write the superblock when BTRFS_SUPER_FLAG_ERROR is set,
   remove the writing of the superblock in btrfs_error_commit_super()
   and the handling of the error flag in the mount function.
3. Set the recovery option automatically when the error flag is
   noticed at mount time and in open_ctree() in the btrfs-progs domain.
4. Improve btrfs_cleanup_transaction() to roll back to the root of the
   previous transaction commit.

This patch implements option number 2.

These lines can be used to reproduce the issue (using /dev/sdm):
SCRATCH_DEV=/dev/sdm
SCRATCH_MNT=/mnt
echo 0 25165824 linear $SCRATCH_DEV 0 | dmsetup create foo
ls -alLF /dev/mapper/foo
mkfs.btrfs /dev/mapper/foo
mount /dev/mapper/foo $SCRATCH_MNT
echo bar > $SCRATCH_MNT/foo
sync
echo 0 25165824 error | dmsetup reload foo
dmsetup resume foo
ls -alF $SCRATCH_MNT
touch $SCRATCH_MNT/1
ls -alF $SCRATCH_MNT
sleep 35
echo 0 25165824 linear $SCRATCH_DEV 0 | dmsetup reload foo
dmsetup resume foo
sleep 1
umount $SCRATCH_MNT
btrfsck /dev/mapper/foo
dmsetup remove foo

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 502b20c..6f08a32 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2531,8 +2531,7 @@ retry_root_backup:
 		goto fail_trans_kthread;
 
 	/* do not make disk changes in broken FS */
-	if (btrfs_super_log_root(disk_super) != 0 &&
-	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
+	if (btrfs_super_log_root(disk_super) != 0) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
@@ -3203,7 +3202,7 @@ int close_ctree(struct btrfs_root *root)
 	 * 2. when btrfs flips readonly just in btrfs_commit_super,
 	 * and in such case, btrfs cannot write sb via btrfs_commit_super,
 	 * and since fs_state has been set BTRFS_SUPER_FLAG_ERROR flag,
-	 * btrfs will cleanup all FS resources first and write sb then.
+	 * btrfs will cleanup all FS resources.
 	 */
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
@@ -3447,8 +3446,6 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 
 int btrfs_error_commit_super(struct btrfs_root *root)
 {
-	int ret;
-
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
@@ -3459,9 +3456,7 @@ int btrfs_error_commit_super(struct btrfs_root *root)
 	/* cleanup FS via transaction */
 	btrfs_cleanup_transaction(root);
 
-	ret = write_ctree_super(NULL, root, 0);
-
-	return ret;
+	return 0;
 }
 
 static void btrfs_destroy_ordered_operations(struct btrfs_root *root)
-- 
1.7.11.4

