Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58809 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751225AbbB0LRf (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 27 Feb 2015 06:17:35 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, lczerner@redhat.com,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Generic test for file fsync after moving files across directories
Date: Fri, 27 Feb 2015 11:17:15 +0000
Message-Id: <1425035835-5522-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1424980394-12592-1-git-send-email-fdmanana@suse.com>
References: <1424980394-12592-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test file A fsync after moving one other unrelated file B between directories
and fsyncing B's old parent directory before fsyncing the file A. Check that
after a crash all the file A data we fsynced is available.

This test is motivated by an issue discovered in btrfs which caused the file
data to be lost (despite fsync returning success to user space). That btrfs
bug is fixed by the following linux kernel patch:

   Btrfs: fix data loss in the fast fsync path

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated test description after Lukas' review. It was not explicit that
    the file we move across directories is not the same that we fsync and
    test for data loss.

 tests/generic/067     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/067.out |  11 +++++
 tests/generic/group   |   1 +
 3 files changed, 125 insertions(+)
 create mode 100755 tests/generic/067
 create mode 100644 tests/generic/067.out

diff --git a/tests/generic/067 b/tests/generic/067
new file mode 100755
index 0000000..7277c19
--- /dev/null
+++ b/tests/generic/067
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 067
+#
+# Test file A fsync after moving one other unrelated file B between directories
+# and fsyncing B's old parent directory before fsyncing the file A. Check that
+# after a crash all the file A data we fsynced is available.
+#
+# This test is motivated by an issue discovered in btrfs which caused the file
+# data to be lost (despite fsync returning success to user space). That btrfs
+# bug was fixed by the following linux kernel patch:
+#
+#   Btrfs: fix data loss in the fast fsync path
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
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our main test file 'foo', the one we check for data loss.
+# By doing an fsync against our file, it makes btrfs clear the 'needs_full_sync'
+# bit from its flags (btrfs inode specific flags).
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 8K" \
+		-c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now create one other file and 2 directories. We will move this second file
+# from one directory to the other later because it forces btrfs to commit its
+# currently open transaction if we fsync the old parent directory. This is
+# necessary to trigger the data loss bug that affected btrfs.
+mkdir $SCRATCH_MNT/testdir_1
+touch $SCRATCH_MNT/testdir_1/bar
+mkdir $SCRATCH_MNT/testdir_2
+
+# Make sure everything is durably persisted.
+sync
+
+# Write more 8Kb of data to our file.
+$XFS_IO_PROG -c "pwrite -S 0xbb 8K 8K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Move our 'bar' file into a new directory.
+mv $SCRATCH_MNT/testdir_1/bar $SCRATCH_MNT/testdir_2/bar
+
+# Fsync our first directory. Because it had a file moved into some other
+# directory, this made btrfs commit the currently open transaction. This is
+# a condition necessary to trigger the data loss bug.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir_1
+
+# Now fsync our main test file. If the fsync succeeds, we expect the 8Kb of
+# data we wrote previously to be persisted and available if a crash happens.
+# This did not happen with btrfs, because of the transaction commit that
+# happened when we fsynced the parent directory.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Now check that all data we wrote before are available.
+echo "File content after log replay:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/067.out b/tests/generic/067.out
new file mode 100644
index 0000000..f30f6ef
--- /dev/null
+++ b/tests/generic/067.out
@@ -0,0 +1,11 @@
+QA output created by 067
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after log replay:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0020000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+0040000
diff --git a/tests/generic/group b/tests/generic/group
index e5db772..05cc6a9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -69,6 +69,7 @@
 064 auto quick prealloc
 065 metadata auto quick
 066 metadata auto quick
+067 metadata auto quick
 068 other auto freeze dangerous stress
 069 rw udf auto quick
 070 attr udf auto quick stress
-- 
2.1.3

