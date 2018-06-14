Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752551AbeFNGa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jun 2018 02:30:57 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3] fstests: btrfs: Test if btrfs will corrupt nodatasum compressed extent when replacing device
Date: Thu, 14 Jun 2018 14:30:53 +0800
Message-Id: <20180614063053.8780-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a long existing bug (from 2012) but exposed by a reporter
recently, that when compressed extent without data csum get written to
device-replace target device, the written data is in fact uncompressed data
other than the original compressed data.

And since btrfs still consider the data is compressed and will try to read it
as compressed, it can cause read error.

The root cause is located, and fix already sent.
"btrfs: scrub: Don't use inode pages for device replace".

Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
----
changelog:
v2:
  Now the fix patch is no longer RFC.
  Remove _require_test as we don't really touch it.
  Add comment on the mount cycle.
  Add the test to group 'volume'.
v3:
  Use latest template.
  Rebased to latest upstream base.
---
 tests/btrfs/165     | 76 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/165.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/btrfs/165
 create mode 100644 tests/btrfs/165.out

diff --git a/tests/btrfs/165 b/tests/btrfs/165
new file mode 100755
index 000000000000..eb9bb61c9ea3
--- /dev/null
+++ b/tests/btrfs/165
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 165
+#
+# Test if btrfs will corrupt compressed data extent without data csum
+# by replacing it with uncompressed data, when doing device replace.
+#
+# This could be fixed by the following patch:
+# "btrfs: scrub: Don't use inode pages for device replace"
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 2
+_require_scratch_dev_pool_equal_size
+
+_scratch_dev_pool_get 1
+_spare_dev_get
+_scratch_pool_mkfs >> $seqres.full 2>&1
+
+# Create nodatasum inode
+_scratch_mount "-o nodatasum"
+touch $SCRATCH_MNT/nodatasum_file
+_scratch_remount "datasum,compress"
+_pwrite_byte 0xcd 0 128K $SCRATCH_MNT/nodatasum_file > /dev/null
+
+# Write the compressed data back to disk
+sync
+
+# Replace the device
+_run_btrfs_util_prog replace start -Bf 1 $SPARE_DEV $SCRATCH_MNT
+
+# Unmount to drop all cache so next read will read from disk
+_scratch_unmount
+_mount $SPARE_DEV $SCRATCH_MNT
+
+# Now the EXTENT_DATA item still marks the extent as compressed,
+# but the on-disk data is uncompressed, thus reading it as compressed
+# will definitely cause EIO.
+cat $SCRATCH_MNT/nodatasum_file > /dev/null
+
+_scratch_unmount
+_spare_dev_put
+_scratch_dev_pool_put
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/165.out b/tests/btrfs/165.out
new file mode 100644
index 000000000000..94ec17dc1075
--- /dev/null
+++ b/tests/btrfs/165.out
@@ -0,0 +1,2 @@
+QA output created by 165
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 35354de2ea6f..91a1ebadae7c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -167,3 +167,4 @@
 162 auto quick volume
 163 auto quick volume
 164 auto quick volume
+165 auto quick replace volume
-- 
2.17.1

