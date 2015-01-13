Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47363 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726AbbAMQbU (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 13 Jan 2015 11:31:20 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: add generic test for fsync on inode with many hard links
Date: Tue, 13 Jan 2015 16:31:03 +0000
Message-Id: <1421166664-15208-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue in btrfs was that adding a new hard link to an inode that
already had a large number of hardlinks and fsync the inode, would
make the fsync log replay code update the inode with a wrong link count
(smaller than the correct value). This resulted later in dangling
directory index entries, after removing most of the hard links
(correct_value - wrong_value), that were visible to user space but it
was impossible to delete them or do any other operation on them (since
they pointed to an inode that didn't exist anymore, resulting in -ESTALE
errors).

The btrfs issue was fixed by the following linux kernel patch:

   Btrfs: fix fsync when extend references are added to an inode

This issue was present in btrfs since the extrefs (extend references)
feature was added (2012).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/040     | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/040.out |   4 ++
 tests/generic/group   |   1 +
 3 files changed, 135 insertions(+)
 create mode 100755 tests/generic/040
 create mode 100644 tests/generic/040.out

diff --git a/tests/generic/040 b/tests/generic/040
new file mode 100755
index 0000000..5f10f48
--- /dev/null
+++ b/tests/generic/040
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 040
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue in btrfs was that adding a new hard link to an inode that already
+# had a large number of hardlinks and fsync the inode, would make the fsync
+# log replay code update the inode with a wrong link count (smaller than the
+# correct value). This resulted later in dangling directory index entries,
+# after removing most of the hard links (correct_value - wrong_value), that
+# were visible to user space but it was impossible to delete them or do
+# any other operation on them (since they pointed to an inode that didn't
+# exist anymore, resulting in -ESTALE errors).
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#    Btrfs: fix fsync when extend references are added to an inode
+#
+# This issue was present in btrfs since the extrefs (extend references)
+# feature was added (2012).
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
+# If the test filesystem is btrfs, make sure we create a filesystem with
+# the extend references (extrefs) feature enabled (it's enabled by default
+# in recent versions of btrfs-progs).
+if [ "$FSTYP" = "btrfs" ]; then
+	_scratch_mkfs "-O extref" >> $seqres.full 2>&1
+else
+	_scratch_mkfs >> $seqres.full 2>&1
+fi
+
+_init_flakey
+_mount_flakey
+
+# Create a test file with 3001 hard links. This number is large enough to
+# make btrfs start using extrefs at some point even if the fs has the maximum
+# possible leaf/node size (64Kb).
+echo "hello world" > $SCRATCH_MNT/foo
+for i in `seq 1 3000`; do
+	ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_`printf "%04d" $i`
+done
+
+# Make sure all metadata and data are durably persisted.
+sync
+
+# Add one more link to the inode that ends up being a btrfs extref and fsync
+# the inode.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_3001
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss. This makes sure the next mount
+# will see an fsync log and will replay that log.
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Now after the fsync log replay btrfs left our inode with a wrong link count N,
+# which was smaller than the correct link count M (N < M).
+# So after removing N hard links, the remaining M - N directory entries were
+# still visible to user space but it was impossible to do anything with them
+# because they pointed to an inode that didn't exist anymore. This resulted in
+# stale file handle errors (-ESTALE) when accessing those dentries for example.
+#
+# So remove all hard links except the first one and then attempt to read the
+# file, to verify we don't get an -ESTALE error when accessing the inode.
+#
+# The btrfs fsck tool also detected the incorrect inode link count and it
+# reported an error message like the following:
+#
+# root 5 inode 257 errors 2001, no inode item, link count wrong
+#   unresolved ref dir 256 index 2978 namelen 13 name foo_link_2976 filetype 1 errors 4, no inode ref
+#
+# The fstests framework automatically calls fsck after a test is run, so we
+# don't need to call fsck explicitly here.
+
+echo "Link count before rm foo_link_*: $(stat --format=%h $SCRATCH_MNT/foo)"
+rm -f $SCRATCH_MNT/foo_link_*
+echo "Link count after rm foo_link_*: $(stat --format=%h $SCRATCH_MNT/foo)"
+cat $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/040.out b/tests/generic/040.out
new file mode 100644
index 0000000..e4095da
--- /dev/null
+++ b/tests/generic/040.out
@@ -0,0 +1,4 @@
+QA output created by 040
+Link count before rm foo_link_*: 3002
+Link count after rm foo_link_*: 1
+hello world
diff --git a/tests/generic/group b/tests/generic/group
index 6af5a1a..0ea8916 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -42,6 +42,7 @@
 037 metadata auto quick
 038 auto stress
 039 metadata auto quick
+040 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

