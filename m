Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39047 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752362AbbBMMaL (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 13 Feb 2015 07:30:11 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: generic, test fsync after adding hard link differently
Date: Fri, 13 Feb 2015 12:29:49 +0000
Message-Id: <1423830589-31546-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1423778938-24038-1-git-send-email-fdmanana@suse.com>
References: <1423778938-24038-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that we could lose file data, that was previously
fsync'ed successfully, if we end up adding a hard link to our
inode and then persist the fsync log later via an fsync of other
inode for example. This is similar to my previous test, except
that in this test the inode that ends up losing data was created
(with some data) in a transaction different from the one we made
an fsync.

The btrfs issue was fixed by the following linux kernel patch:

   Btrfs: fix fsync data loss after adding hard link to inode

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated two comments with more details about the issue.

 tests/generic/043     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/043.out |  17 ++++++++
 tests/generic/group   |   1 +
 3 files changed, 130 insertions(+)
 create mode 100755 tests/generic/043
 create mode 100644 tests/generic/043.out

diff --git a/tests/generic/043 b/tests/generic/043
new file mode 100755
index 0000000..9de2469
--- /dev/null
+++ b/tests/generic/043
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. 043
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that we could lose file data, that was previously fsync'ed
+# successfully, if we end up adding a hard link to our inode and then persist
+# the fsync log later via an fsync of other inode for example.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#  Btrfs: fix fsync data loss after adding hard link to inode
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
+# Add one hard link to our file. This made btrfs write into the in memory fsync
+# log a special inode with generation 0 and an i_size of 0 too. Note that this
+# didn't update the inode in the fsync log on disk.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link
+
+# Now make sure the in memory fsync log is durably persisted.
+# Creating and fsync'ing another file will do it.
+touch $SCRATCH_MNT/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+
+# As expected, before the crash/power failure, we should be able to read the
+# 12Kb of file data.
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
+# The btrfs fsync log replay code didn't update the i_size of the persisted
+# inode because the inode item in the log had a special generation with a
+# value of 0 (and it couldn't know the correct i_size, since that inode item
+# had a 0 i_size too). This made the last 4Kb of file data inaccessible and
+# effectively lost.
+echo "File content after:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/043.out b/tests/generic/043.out
new file mode 100644
index 0000000..eaf9be5
--- /dev/null
+++ b/tests/generic/043.out
@@ -0,0 +1,17 @@
+QA output created by 043
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0020000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+0030000
+File content after:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0020000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+0030000
diff --git a/tests/generic/group b/tests/generic/group
index 001ec80..d686f2f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -45,6 +45,7 @@
 040 metadata auto quick
 041 metadata auto quick
 042 metadata auto quick
+043 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

