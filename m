Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34824 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcD1EcS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 00:32:18 -0400
Received: by mail-pa0-f53.google.com with SMTP id iv1so27571119pac.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 21:32:18 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
Subject: [PATCH 2/2] btrfs: add test for replacing a missing device
Date: Wed, 27 Apr 2016 21:31:52 -0700
Message-Id: <dcf5aed04d3a85f33ec99e37fa0a17031c370ece.1461817486.git.osandov@fb.com>
In-Reply-To: <cover.1461817486.git.osandov@fb.com>
References: <cover.1461817486.git.osandov@fb.com>
In-Reply-To: <cover.1461817486.git.osandov@fb.com>
References: <cover.1461817486.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now that _btrfs_get_profile_configs supports replace missing and the
kernel doesn't crash when replacing a missing RAID 5/6 device, test it.
Based on an earlier test from Wang Yanfeng.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/027     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/027.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 122 insertions(+)
 create mode 100755 tests/btrfs/027
 create mode 100644 tests/btrfs/027.out

diff --git a/tests/btrfs/027 b/tests/btrfs/027
new file mode 100755
index 000000000000..f0844a14f8e6
--- /dev/null
+++ b/tests/btrfs/027
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test 027
+#
+# Test replace of a missing device on various data and metadata profiles.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Facebook.  All Rights Reserved.
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
+_supported_fs generic
+_supported_os IRIX Linux
+# we check scratch dev after each loop
+_require_scratch_nocheck
+_require_scratch_dev_pool 5
+_require_scratch_dev_pool_equal_size
+_btrfs_get_profile_configs replace-missing
+_require_command "$WIPEFS_PROG" wipefs
+
+run_test()
+{
+	local mkfs_opts=$1
+	local saved_scratch_dev_pool=$SCRATCH_DEV_POOL
+	local replace_dev=`echo $SCRATCH_DEV_POOL | awk '{print $NF}'`
+
+	echo "Test $mkfs_opts" >>$seqres.full
+
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$replace_dev *##"`
+	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
+	# make sure we created btrfs with desired options
+	if [ $? -ne 0 ]; then
+		echo "mkfs $mkfs_opts failed"
+		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		return
+	fi
+	_scratch_mount >>$seqres.full 2>&1
+
+	local missing_dev=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
+	local missing_dev_id=`$BTRFS_UTIL_PROG fi show $SCRATCH_MNT | grep $missing_dev | awk '{print $2}'`
+
+	# get some data on the filesystem so there's something to replace
+	dd if=/dev/urandom of="$SCRATCH_MNT"/file1 bs=1M count=1 \
+		>>$seqres.full 2>&1
+	dd if=/dev/urandom of="$SCRATCH_MNT"/file2 bs=1M count=2 \
+		>>$seqres.full 2>&1
+	dd if=/dev/urandom of="$SCRATCH_MNT"/file3 bs=1M count=4 \
+		>>$seqres.full 2>&1
+
+	# nuke a device and remount in degraded mode
+	_scratch_unmount
+	$WIPEFS_PROG -a "$missing_dev" >>$seqres.full 2>&1
+	_scratch_mount -o degraded >>$seqres.full 2>&1
+
+	# replace $missing_dev with $replace_dev and scrub it to double-check
+	$BTRFS_UTIL_PROG replace start -B -r $missing_dev_id $replace_dev \
+		$SCRATCH_MNT -f >>$seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "btrfs replace failed"
+		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		return
+	fi
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "btrfs scrub failed"
+		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		return
+	fi
+
+	_scratch_unmount
+	# we called _require_scratch_nocheck instead of _require_scratch
+	# do check after test for each profile config
+	_check_scratch_fs
+	SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+}
+
+echo "Silence is golden"
+for t in "${_btrfs_profile_configs[@]}"; do
+	run_test "$t"
+done
+
+status=0
+exit
diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
new file mode 100644
index 000000000000..ef78cdae50e8
--- /dev/null
+++ b/tests/btrfs/027.out
@@ -0,0 +1,2 @@
+QA output created by 027
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 13aa1e57d61e..90af8fc2d106 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -29,6 +29,7 @@
 024 auto quick compress
 025 auto quick send clone
 026 auto quick compress prealloc
+027 auto replace
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
-- 
2.8.0

