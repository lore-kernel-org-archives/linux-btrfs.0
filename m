Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63936 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755373AbcKVIid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:38:33 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 3/3] fstests: btrfs: Add new test case to check scrub recovery and report
Date: Tue, 22 Nov 2016 16:38:11 +0800
Message-Id: <20161122083811.12636-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In fact, desipte the existing btrfs scrub test cases, we didn't even
test if scrub can really recovery data.

Due to the recent exposed several critical RAID56 scrub problem, it's
really needed to test the fundamental function before things get worse
and worse.

This test case add verification for btrfs RAID1/DUP scrub recovery.
As it's the simplest profile, pure mirroring, not stripping nor parity.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/132     | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/132.out | 111 +++++++++++++++++++++++++
 tests/btrfs/group   |   2 +
 3 files changed, 342 insertions(+)
 create mode 100755 tests/btrfs/132
 create mode 100644 tests/btrfs/132.out

diff --git a/tests/btrfs/132 b/tests/btrfs/132
new file mode 100755
index 0000000..3198125
--- /dev/null
+++ b/tests/btrfs/132
@@ -0,0 +1,229 @@
+#! /bin/bash
+# FS QA Test 132
+#
+# Check if pure mirror based btrfs raid profiles(RAID1/DUP) can recover
+# data correctly by scrubbing, and the correctness of the error report
+#
+# We don't have good enough off-line or on-line tool to corrupt on-disk
+# data which can handle extents on different chunks.
+# So here we only create a small file extents, this will restrict the coverage
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
+. ./common/ondisk.btrfs
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Golden output has csum, so no LOAD_FACTOR here
+runtimes=4
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+
+# RAID1 needs at least 2 devices
+_require_scratch_dev_pool 2
+
+stripelen=65536
+# Corrupt mirrors at given logical bytenr
+# Only works if the range is in the first data chunk
+corrupt_one_mirror()
+{
+	local dest_logical=$1
+	local dest_len=$2
+	local devs[]="( $SCRATCH_DEV_POOL )"
+
+	dev=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
+	output=$(_btrfs_get_first_bg_by_type $dev data)
+	if [ -z "$output" ]; then
+		_fail "testcase error: failed to get first data chunk info"
+	fi
+	bg_logical=$(echo $output | awk '{print $1}')
+	bg_len=$(echo $output | awk '{print $2}')
+
+	if [ $dest_logical -ge $(( $bg_logical + $bg_len)) -o \
+	     $(( $dest_logical + $dest_len)) -le $bg_logical ]; then
+	     _fail "testcase error: ondisk layout is out of expect"
+	fi
+
+
+	# Select random stripe (mirror) as corrupt destination
+	dest_stripe=$((RANDOM % 2))
+	output=$(_btrfs_get_chunk_stripe $dev $bg_logical $dest_stripe)
+	if [ -z "$output" ]; then
+		_fail "testcase error: failed to get first data chunk info"
+	fi
+	stripe_devid=$(echo $output | awk '{print $1}')
+	stripe_devid=$(($stripe_devid - 1))
+
+	stripe_offset=$(echo $output | awk '{print $2}')
+
+	real_offset=$(( $dest_logical - $bg_logical + $stripe_offset ))
+	dev=${devs[$(($stripe_devid))]}
+
+	# Corrupt the last stripe using random data
+	$XFS_IO_PROG -c "pwrite -S 0x0000 $real_offset $dest_len" $dev \
+		> /dev/null 2>&1
+}
+
+csum_mirrors()
+{
+	local dest_logical=$1
+	local dest_len=$2
+	local verify_corrupt=$3
+	local csums[]="( 0 0 )"
+
+	dev=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
+	output=$(_btrfs_get_first_bg_by_type $dev data)
+	if [ -z "$output" ]; then
+		_fail "testcase error: failed to get first data chunk info"
+	fi
+	bg_logical=$(echo $output | awk '{print $1}')
+	bg_len=$(echo $output | awk '{print $2}')
+
+	if [ $dest_logical -ge $(( $bg_logical + $bg_len)) -o \
+	     $(( $dest_logical + $dest_len)) -le $bg_logical ]; then
+	     _fail "testcase error: ondisk layout is out of expect"
+	fi
+
+	bg_offset=$(( $dest_logical - $bg_logical ))
+
+	for i in $(seq 0 1); do
+		local devs[]="( $SCRATCH_DEV_POOL )"
+		output=$(_btrfs_get_chunk_stripe $dev $bg_logical $i)
+		if [ -z "$output" ]; then
+			_fail "testcase error: failed to get first data chunk info"
+		fi
+		stripe_devid=$(echo $output | awk '{print $1}')
+		stripe_offset=$(echo $output | awk '{print $2}')
+
+		real_offset=$(( $bg_offset + $stripe_offset ))
+
+		index=$(($stripe_devid - 1))
+		dev=${devs[$index]}
+
+		# xfs_io don't support to read out data into file, must use dd here now
+		csums[$i]=$(dd if=$dev bs=1 count=$dest_len skip=$real_offset \
+			   status=none | md5sum | awk '{print $1}')
+		if [ $verify_corrupt -eq 0 ]; then
+			echo "csum for stripe $i: ${csums[$i]}"
+		fi
+	done
+	if [ $verify_corrupt -ne 0 ]; then
+		if [ ${csums[0]} == ${csums[1]} ]; then
+			_fail "corruption failed"
+		else
+			echo "one of the mirror corrupted"
+			echo
+		fi
+	fi
+}
+
+do_test()
+{
+	profile=$1
+
+	if [ -z "$profile" ]; then
+		_fail "testcase error: profile argument is not given for do_test()"
+	fi
+
+	if [ $profile == "dup" ]; then
+		ndevs=1
+	elif [ $profile == "raid1" ]; then
+		ndevs=2
+	else
+		_fail "testcase error: profile $profile is not supported for this test case"
+	fi
+
+	echo "===Test scrub recovery for profile: $profile==="
+	_scratch_dev_pool_get $ndevs
+	_scratch_pool_mkfs "-m $profile -d $profile" >> $seqres.full 2>&1
+	dev=$(echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $1}') 
+	output=$(_btrfs_get_first_bg_by_type $dev data $profile)
+
+	if [ -z "$output" ]; then
+		_fail "testcase error: unable to get first block group logical"
+	fi
+
+
+	_scratch_mount >> $seqres.full 2>&1
+	_pwrite_byte 0xcdcd 0 $stripelen $SCRATCH_MNT/file > /dev/null 2>&1
+	_scratch_cycle_mount
+	file_logical=$($XFS_IO_PROG -c "fiemap" $SCRATCH_MNT/file | tail -n +2 |
+		awk '{print $3}' | cut -f1 -d\.)
+	file_logical=$(( $file_logical * 512 ))
+	_scratch_unmount
+
+	echo "before csum corruption"
+	csum_mirrors $file_logical $stripelen 0
+	echo ""
+	corrupt_one_mirror $file_logical $stripelen
+
+	# verify the corruption is good
+	csum_mirrors $file_logical $stripelen 1
+
+	_scratch_mount
+	# redirect the output, we will need it for several usage
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT &> $tmp.scrub_output
+	if [ $? -ne 0 ]; then
+		_fail "scrub found un-recoverable error"
+	fi
+	cat $tmp.scrub_output >> $seqres.full
+	csum_errors=$(grep -o "csum=[[:digit:]]*" $tmp.scrub_output | cut -f2 -d=)
+	pagesize=$(getconf PAGESIZE)
+	expected_errors=$(($stripelen / $pagesize))
+	if [ $csum_errors -ne $(($stripelen / $pagesize)) ]; then
+		_fail "incorrect csum error number reported, have=$csum_errors, expected=$expected_errors"
+	fi
+	_scratch_unmount
+
+	echo "after csum corruption and scrub"
+	csum_mirrors $file_logical $stripelen 0
+	echo ""
+	_scratch_dev_pool_put
+}
+
+for i in $(seq 0 $runtimes); do
+	do_test dup
+	do_test raid1
+done
+
+status=0
+exit
diff --git a/tests/btrfs/132.out b/tests/btrfs/132.out
new file mode 100644
index 0000000..362574f
--- /dev/null
+++ b/tests/btrfs/132.out
@@ -0,0 +1,111 @@
+QA output created by 132
+===Test scrub recovery for profile: dup===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: raid1===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: dup===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: raid1===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: dup===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: raid1===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: dup===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: raid1===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: dup===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+===Test scrub recovery for profile: raid1===
+before csum corruption
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
+one of the mirror corrupted
+
+after csum corruption and scrub
+csum for stripe 0: 27c9068d1b51da575a53ad34c57ca5cc
+csum for stripe 1: 27c9068d1b51da575a53ad34c57ca5cc
+
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c090604..61f26ed 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -134,3 +134,5 @@
 129 auto quick send
 130 auto clone send
 131 auto quick
+132 auto scrub
+
-- 
2.7.4



