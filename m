Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49011 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457AbbCaTTG (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 31 Mar 2015 15:19:06 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: add debugfs file to test transaction aborts
Date: Tue, 31 Mar 2015 20:18:44 +0100
Message-Id: <1427829524-23946-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At the moment we can not reliably and deterministically test that the
transaction abortion code works as expected. For example in the past [1]
we had an issue where that code returned the pinned extents to the free
space caches allowing fstrim to perform a discard against the physical
locations of the extents, and worse, when the fs was mounted with the
option -o discard it explicitly did a discard on each pinned extent.
This resulted in filesystem corruption, leaving the fs unmountable.

This patch adds a debugfs file named abort_transaction, which has a
default value of 0, can only be written by someone with root privileges
and when a non-zero value is written to it, it makes all subsequent
transaction commits fail at the very end (right before writing the new
superblock), which results in a transaction abortion.
This way we can for example write a deterministic fstest for commit [1]
which looks like:

  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _require_btrfs_debugfs "abort_transaction"
  _need_to_be_root

  rm -f $seqres.full

  # We will abort a btrfs transaction later, which always produces a warning in
  # dmesg. We do not want the test to fail because of this.
  _disable_dmesg_check

  _scratch_mkfs >>$seqres.full 2>&1
  _scratch_mount "-o discard"
  _require_batched_discard $SCRATCH_MNT

  # Create a file and commit the current transaction.
  echo -n "hello" > $SCRATCH_MNT/foo
  sync

  # Now update the file, which forces a COW operation of the fs root, adding
  # the old root location to the pinned extents list.
  echo -n " world" >> $SCRATCH_MNT/foo

  # Now abort the current transaction, unmount the fs, mount it again and verify
  # we can open the file and read its content (which should match what it had
  # when the last transaction committed successfully). Btrfs used to issue a
  # discard operation on the extents in the pinned extents list, resulting in
  # corruption of metadata and data, and used too to return the pinned extents
  # to the free space caches, allowing future fstrim operations to perform a
  # discard operation against the pinned exents.
  echo 1 > $BTRFS_DEBUG_FS/abort_transaction
  sync
  echo 0 > $BTRFS_DEBUG_FS/abort_transaction
  $FSTRIM_PROG $SCRATCH_MNT

  _scratch_unmount
  _scratch_mount
  echo "File content after transaction abort + remount: $(cat $SCRATCH_MNT/foo)"

The test's expected output is:

  File content after transaction abort + remount: hello

With patch [1] reverted the test fails with:

  btrfs/088 2s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/088.out.bad)
      --- tests/btrfs/088.out	2015-03-31 19:31:17.558436298 +0100
      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/088.out.bad	2015-03-31 19:58:12.741403640 +0100
      @@ -1,2 +1,8 @@
       QA output created by 088
      -File content after transaction abort + remount: hello
      +mount: wrong fs type, bad option, bad superblock on /dev/sdc,
      +       missing codepage or helper program, or other error
      +       In some cases useful info is found in syslog - try
      +       dmesg | tail  or so
      +
      ...
      (Run 'diff -u tests/btrfs/088.out /home/fdmanana/git/hub/xfstests/results//btrfs/088.out.bad'  to see the entire diff)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent (see /home/fdmanana/git/hub/xfstests/results//btrfs/088.full)

  $ cat /home/fdmanana/git/hub/xfstests/results//btrfs/088.full
  (...)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
  *** fsck.btrfs output ***
  Check tree block failed, want=29573120, have=0
  Check tree block failed, want=29573120, have=0
  Check tree block failed, want=29573120, have=0
  Check tree block failed, want=29573120, have=0
  Check tree block failed, want=29573120, have=0
  read block failed check_tree_block
  Couldn't read tree root
  Couldn't open file system
  *** end fsck.btrfs output

[1] commit 678886bdc637 ("Btrfs: fix fs corruption on transaction abort
                          if device supports discard")

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

If there are no objections to the feature/interface, I will submit a test
for fstests.

 fs/btrfs/sysfs.c       | 11 +++++++++++
 fs/btrfs/sysfs.h       |  2 ++
 fs/btrfs/transaction.c |  9 +++++++++
 3 files changed, 22 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 94edb0a..4b10f3b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -666,6 +666,7 @@ static struct dentry *btrfs_debugfs_root_dentry;
 
 /* Debugging tunables and exported data */
 u64 btrfs_debugfs_test;
+static u32 btrfs_debugfs_abort_transaction;
 
 int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 {
@@ -719,10 +720,20 @@ static int btrfs_init_debugfs(void)
 
 	debugfs_create_u64("test", S_IRUGO | S_IWUGO, btrfs_debugfs_root_dentry,
 			&btrfs_debugfs_test);
+
+	debugfs_create_bool("abort_transaction",
+			    S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+			    btrfs_debugfs_root_dentry,
+			    &btrfs_debugfs_abort_transaction);
 #endif
 	return 0;
 }
 
+bool debugfs_abort_transaction(void)
+{
+	return btrfs_debugfs_abort_transaction != 0;
+}
+
 int btrfs_init_sysfs(void)
 {
 	int ret;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index f7dd298..517dbb3 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -74,4 +74,6 @@ int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *one_device);
 int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
                 struct btrfs_device *one_device);
+
+bool debugfs_abort_transaction(void);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5d8cff8..f514ff9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -32,6 +32,7 @@
 #include "volumes.h"
 #include "dev-replace.h"
 #include "qgroup.h"
+#include "sysfs.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -2029,6 +2030,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto scrub_continue;
 	}
 
+	if (unlikely(debugfs_abort_transaction())) {
+		btrfs_warn(root->fs_info,
+			   "Aborting transaction due to debugfs request.");
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		ret = -EIO;
+		goto scrub_continue;
+	}
+
 	ret = write_ctree_super(trans, root, 0);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
-- 
2.1.3

