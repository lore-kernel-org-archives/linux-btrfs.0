Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34660 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752509AbbBMMsO (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 13 Feb 2015 07:48:14 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for fsync followed by truncate and link
Date: Fri, 13 Feb 2015 12:47:54 +0000
Message-Id: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that we could lose file data, that was previously fsync'ed
successfully, if we end up shrinking (via truncate) the file, add a hard
link to our file and then persist the fsync log later via an fsync of
other inode for example. After a power loss our file content wouldn't
match what it had when we last fsync'ed, but instead it had the data
prior to that fsync.

The btrfs issue was fixed by the following linux kernel patch:

  Btrfs: don't remove extents and xattrs when logging new names

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/044     | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/044.out |  18 +++++++
 tests/generic/group   |   1 +
 3 files changed, 150 insertions(+)
 create mode 100755 tests/generic/044
 create mode 100644 tests/generic/044.out

diff --git a/tests/generic/044 b/tests/generic/044
new file mode 100755
index 0000000..95a42cc
--- /dev/null
+++ b/tests/generic/044
@@ -0,0 +1,131 @@
+#! /bin/bash
+# FS QA Test No. 044
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that we could lose file data, that was previously fsync'ed
+# successfully, if we end up shrinking (via truncate) the file, add a hard
+# link to our file and then persist the fsync log later via an fsync of other
+# inode for example. After a power loss our file content wouldn't match
+# what it had when we last fsync'ed, but instead it had the data prior to
+# that fsync.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#  Btrfs: don't remove extents and xattrs when logging new names
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
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our test file with some data.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa -b 8K 0 8K" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Make sure the file is durably persisted.
+sync
+
+# Append some data to our file, to increase its size.
+$XFS_IO_PROG -f -c "pwrite -S 0xcc -b 4K 8K 4K" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Fsync the file, so from this point on if a crash/power failure happens, our
+# new data is guaranteed to be there next time the fs is mounted.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Now shrink our file to 5000 bytes.
+$XFS_IO_PROG -c "truncate 5000" $SCRATCH_MNT/foo
+
+# Now do an expanding truncate to a size larger than what we had when we last
+# fsync'ed our file. This is just to verify that after power failure and
+# replaying the fsync log, our file matches what it was when we last fsync'ed
+# it - 12Kb size, first 8Kb of data had a value of 0xaa and the last 4Kb of
+# data had a value of 0xcc.
+$XFS_IO_PROG -c "truncate 32K" $SCRATCH_MNT/foo
+
+# Add one hard link to our file. This made btrfs drop all of our file's
+# metadata from the fsync log, including the metadata relative to the
+# extent we just wrote and fsync'ed. This change was made only to the fsync
+# log in memory, so adding the hard link alone doesn't change the persisted
+# fsync log. This happened because the previous truncates set the runtime
+# flag BTRFS_INODE_NEEDS_FULL_SYNC in the btrfs inode structure.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link
+
+# Now make sure the in memory fsync log is durably persisted.
+# Creating and fsync'ing another file will do it.
+# After this our persisted fsync log will no longer have metadata for our file
+# foo that points to the extent we wrote and fsync'ed before.
+touch $SCRATCH_MNT/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+
+# As expected, before the crash/power failure, we should be able to see a file
+# with a size of 32Kb, with its first 5000 bytes having the value 0xaa and all
+# the remaining bytes with value 0x00.
+echo "File content before:"
+od -t x1 $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# After mounting the fs again, the fsync log was replayed.
+# The expected result is to see a file with a size of 12Kb, with its first 8Kb
+# of data having the value 0xaa and its last 4Kb of data having a value of 0xcc.
+# The btrfs bug used to leave the file as it used te be as of the last
+# transaction commit - that is, with a size of 8Kb with all bytes having a
+# value of 0xaa.
+echo "File content after:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/044.out b/tests/generic/044.out
new file mode 100644
index 0000000..397dbae
--- /dev/null
+++ b/tests/generic/044.out
@@ -0,0 +1,18 @@
+QA output created by 044
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0011600 aa aa aa aa aa aa aa aa 00 00 00 00 00 00 00 00
+0011620 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0100000
+File content after:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0020000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+0030000
diff --git a/tests/generic/group b/tests/generic/group
index d686f2f..dc16972 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -46,6 +46,7 @@
 041 metadata auto quick
 042 metadata auto quick
 043 metadata auto quick
+044 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

