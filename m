Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39268 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbaJPJJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 05:09:03 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] btrfs: regression test for btrfs extent merge
Date: Thu, 16 Oct 2014 17:08:58 +0800
Message-ID: <1413450538-9783-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following kernel commit introduced the bug:
51f395ad btrfs: Use right extent length when inserting overlap extent map.

When btrfs commit race with btrfs_get_extent(), merge_extent_mapping()
may build up a new extent which length overflows and cause extent map
insert fail, causing the caller get a -EEXIST error.

This regression is fixed by the following patches:
btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map
btrfs: Fix the wrong condition judgment about subset extent map

Cc: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>
---
changlog:
v2:
   Remove duplicated variant
   Use _require_fs_space helper
   Use temp file other than temp dir
---
 tests/btrfs/078     | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/078.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 129 insertions(+)
 create mode 100755 tests/btrfs/078
 create mode 100644 tests/btrfs/078.out

diff --git a/tests/btrfs/078 b/tests/btrfs/078
new file mode 100755
index 0000000..78132c3
--- /dev/null
+++ b/tests/btrfs/078
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test No. btrfs/078
+#
+# Do write along with fiemap ioctl.
+# Regression test for the kernel comit:
+# 51f395ad btrfs: Use right extent length when inserting overlap extent map.
+#
+# When calling fiemap(without SYNC flag) and btrfs fs is commiting,
+# it will cause race condition and cause btrfs to generate a wrong extent
+# whose len is overflow and fail to insert into the extent map tree,
+# returning -EEXIST.
+#
+# Fixed by the following patches (not merged in mainline yet):
+# btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map
+# btrfs: Fix the wrong condition judgment about subset extent map
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 Fujitsu All Rights Reserved.
+# Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
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
+	kill $dd_pid &> /dev/null
+	kill $fiemap_pid &> /dev/null
+	wait
+	rm -fr $testfile
+	rm -fr $tmp.* $tmp
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
+_need_to_be_root
+# Since xfs_io's fiemap always use SYNC flag and can't be unset,
+# we must use filefrag to call fiemap without SYNC flag.
+_require_command "/usr/sbin/filefrag"
+_require_xfs_io_command "falloc"
+
+filesize=$((10 * 1024 * 1024 * 1024)) #10G size
+buffersize=$((1024 * 1024)) # 1M bs for dd
+count=$(($filesize / $buffersize))
+testfile=$SCRATCH_MNT/testfile
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+_require_fs_space $SCRATCH_MNT $(($filesize / 1024 / 1024 / 1024))
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile
+
+dd_work() {
+	out=$1
+	dd if=/dev/zero of=$out bs=$buffersize count=$count \
+	   conv=notrunc &> /dev/null
+}
+
+# There is a bug for e2fsprogs, at least in version 1.42.9, filefrag will
+# leak the return value, so we can't judge return value only,
+# but also to filter the output
+_filter_error() {
+	# when filefrag fails FIEMAP ioctl, it will fall back to FIBMAP,
+	# which is not supported by btrfs and will report "FIBMAP: strerr()"
+	# However old e2fsprogs will use wrong errno EINVAL other than ENOTTY
+	# so only grep for "FIBMAP" for max compatibility.
+	grep "FIBMAP"
+}
+
+fiemap_work() {
+	filename=$1
+	while true; do
+		filefrag $filename 2> $tmp.output 1> /dev/null
+		ret=$?
+		err=`cat $tmp.output | _filter_error`
+		if [ $ret -ne 0 -o -n "$err" ]; then
+			kill $dd_pid
+			return 1
+		fi
+	done
+}
+
+dd_work $testfile &
+dd_pid=$!
+fiemap_work $testfile &
+fiemap_pid=$!
+wait $dd_pid
+ddret=$?
+kill $fiemap_pid &> /dev/null
+wait $fiemap_pid
+
+if [ $ddret -ne 0 ]; then
+	echo "Extent merge bug detected"
+	status=1
+	exit
+else
+	echo "Silence is golden"
+	status=0
+	exit
+fi
diff --git a/tests/btrfs/078.out b/tests/btrfs/078.out
new file mode 100644
index 0000000..b8acea8
--- /dev/null
+++ b/tests/btrfs/078.out
@@ -0,0 +1,2 @@
+QA output created by 078
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9adf862..40e7430 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -80,3 +80,4 @@
 075 auto quick subvol
 076 auto quick
 077 auto quick
+078 auto
-- 
2.1.2

