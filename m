Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55134 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751327AbbDCQCd (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 3 Apr 2015 12:02:33 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: test for btrfs transaction abortion on device with discard support
Date: Fri,  3 Apr 2015 17:02:12 +0100
Message-Id: <1428076932-28605-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1427990272-27107-1-git-send-email-fdmanana@suse.com>
References: <1427990272-27107-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test that btrfs' transaction abortion does not corrupt a filesystem
mounted with -o discard nor allows a subsequent fstrim to corrupt the
filesystem (regardless of being mounted with or without -o discard).

This issue was fixed by the following linux kernel patch:

    Btrfs: fix fs corruption on transaction abort if device supports discard
    (commit 678886bdc6378c1cbd5072da2c5a3035000214e3)

Without the corresponding btrfs fix the fs becomes unmountable and fails
like this:

  $ ./check btrfs/089
  FSTYP         -- btrfs
  PLATFORM      -- Linux/x86_64 debian3 3.19.0-btrfs-next-7+
  MKFS_OPTIONS  -- /dev/sdc
  MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

  btrfs/089 2s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad)
      --- tests/btrfs/089.out	2015-04-02 16:46:28.022498841 +0100
      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad	2015-04-02 16:48:05.406195409 +0100
      @@ -1,2 +1,8 @@
       QA output created by 089
      -File content after transaction abort + remount: hello
      +mount: wrong fs type, bad option, bad superblock on /dev/sdc,
      +       missing codepage or helper program, or other error
      +       In some cases useful info is found in syslog - try
      +       dmesg | tail  or so
      +
      ...
      (Run 'diff -u tests/btrfs/089.out /home/fdmanana/git/hub/xfstests/results//btrfs/089.out.bad'  to see the entire diff)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent (see /home/fdmanana/git/hub/xfstests/results//btrfs/089.full)
  Ran: btrfs/089
  Failures: btrfs/089
  Failed 1 of 1 tests

  $ cat /home/fdmanana/git/hub/xfstests/results//btrfs/089.full
  Performing full device TRIM (100.00GiB) ...
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
  (...)

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Added some more comments explaining what's being done and why. Simplified
    some code (cleanups).

 tests/btrfs/089     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/089.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 128 insertions(+)
 create mode 100755 tests/btrfs/089
 create mode 100644 tests/btrfs/089.out

diff --git a/tests/btrfs/089 b/tests/btrfs/089
new file mode 100755
index 0000000..07358b3
--- /dev/null
+++ b/tests/btrfs/089
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. btrfs/089
+#
+# Test that btrfs' transaction abortion does not corrupt a filesystem mounted
+# with -o discard nor allows a subsequent fstrim to corrupt the filesystem
+# (regardless of being mounted with or without -o discard).
+#
+# This issue was fixed by the following linux kernel patch:
+#
+#    Btrfs: fix fs corruption on transaction abort if device supports discard
+#    (commit 678886bdc6378c1cbd5072da2c5a3035000214e3)
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Filipe Manana <fdmanana@suse.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fail_make_request
+_need_to_be_root
+
+SCRATCH_BDEV=`_short_dev $SCRATCH_DEV`
+
+enable_io_failure()
+{
+	echo 100 > $DEBUGFS_MNT/fail_make_request/probability
+	echo 1000 > $DEBUGFS_MNT/fail_make_request/times
+	echo 0 > /sys/kernel/debug/fail_make_request/verbose
+	echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
+}
+
+disable_io_failure()
+{
+	echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
+	echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+	echo 0 > $DEBUGFS_MNT/fail_make_request/times
+}
+
+rm -f $seqres.full
+
+# We will abort a btrfs transaction later, which always produces a warning in
+# dmesg. We do not want the test to fail because of this.
+_disable_dmesg_check
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o discard"
+_require_batched_discard $SCRATCH_MNT
+
+# Create a file, small enough to be inlined in the metadata (btree leaf), and
+# commit the current transaction. The reason to make sure the file data is
+# inlined is to make sure the last sync call we do will flush only metadata
+# extents - a btrfs transaction is not aborted if an error happens when flushing
+# data extents.
+echo -n "hello" > $SCRATCH_MNT/foo
+sync
+
+# Now update the file, which forces a COW operation of the fs root, adding
+# the old root location to the pinned extents list.
+echo -n " world" >> $SCRATCH_MNT/foo
+
+# Now make sure the next transaction commit will abort and turn the fs readonly,
+# unmount the fs, mount it again and verify we can open the file and read its
+# content, which should be what it had when the last superblock was committed
+# (first call to sync), since btrfs is a COW filesystem.
+# Btrfs used to issue a discard operation on the extents in the pinned extents
+# list, resulting in corruption of metadata and data, and used too to return the
+# pinned extents to the free space caches, allowing future fstrim operations to
+# perform a discard operation against the pinned exents. This made the fs
+# unmountable because the btree roots that the superblock points at were written
+# in place (by the discard operations).
+enable_io_failure
+
+# This sync will trigger a commit of the current transaction, which will be
+# aborted because IO will fail for metadata extents (btree nodes/leafs).
+sync
+disable_io_failure
+
+touch $SCRATCH_MNT/bar >>$seqres.full 2>&1 && \
+	echo "Transaction was not aborted, filesystem is not in readonly mode"
+
+# This fstrim operation should not cause discard operations to be performed
+# against extents that were COWed, otherwise the next mount will fail since
+# the btree roots that the superblock points at have their physical areas
+# on disk full of zeroes.
+$FSTRIM_PROG $SCRATCH_MNT
+
+_scratch_remount
+echo "File content after transaction abort + remount: $(cat $SCRATCH_MNT/foo)"
+
+status=0
+exit
diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
new file mode 100644
index 0000000..aebbe2b
--- /dev/null
+++ b/tests/btrfs/089.out
@@ -0,0 +1,2 @@
+QA output created by 089
+File content after transaction abort + remount: hello
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 73ef2ea..83c8ec2 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -91,3 +91,4 @@
 086 auto quick clone
 087 auto quick send
 088 auto quick clone
+089 auto quick metadata
-- 
2.1.3

