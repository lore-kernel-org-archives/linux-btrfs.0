Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34997 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751678AbaKGUlx (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 7 Nov 2014 15:41:53 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add generic test to verify xattr replace operations are atomic
Date: Fri,  7 Nov 2014 20:40:26 +0000
Message-Id: <1415392826-11606-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test verifies that replacing a xattr's value is an atomic
operation. This is motivated by an issue in btrfs where replacing
a xattr's value wasn't an atomic operation, it consisted of
removing the old value and then inserting the new value in a
btree. This made readers (getxattr and listxattrs) not getting
neither the old nor the new value during a short time window.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/326     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 110 insertions(+)
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out

diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..c110fc0
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FSQA Test No. 326
+#
+# Verify that replacing a xattr's value is an atomic operation.
+# This is motivated by an issue in btrfs where replacing a xattr's value
+# wasn't an atomic operation, it consisted of removing the old value and
+# then inserting the new value in a btree. This made readers (getxattr
+# and listxattrs) not getting neither the old nor the new value during
+# a short time window.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#    Btrfs: make xattr replace operations atomic
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	if [ ! -z $setter_pid ]; then
+		kill $setter_pid &> /dev/null
+	fi
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_attrs
+
+rm -f $seqres.full
+
+xattr_name="user.something"
+xattr_value1="foobar"
+xattr_value2="rabbit_hole"
+
+set_xattr_loop()
+{
+	local name=$1
+
+	local cur_val=$xattr_value1
+	while true; do
+		$SETFATTR_PROG -n $xattr_name -v $cur_val $SCRATCH_MNT/$name
+		if [ "$cur_val" == "$xattr_value1" ]; then
+			cur_val=$xattr_value2
+		else
+			cur_val=$xattr_value1
+		fi
+	done
+}
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+test_file="test_xattr_replace"
+touch $SCRATCH_MNT/$test_file
+$SETFATTR_PROG -n $xattr_name -v $xattr_value1 $SCRATCH_MNT/$test_file
+
+set_xattr_loop $test_file &
+setter_pid=$!
+
+for ((i = 0; i < 1000; i++)); do
+	xattr_val=$($GETFATTR_PROG --absolute-names -n $xattr_name \
+		$SCRATCH_MNT/$test_file | grep "$xattr_name=" | cut -d '=' -f 2)
+	if [ "$xattr_val" != "\"$xattr_value1\"" -a \
+		"$xattr_val" != "\"$xattr_value2\"" ]; then
+		_fail "Missing or unexpected xattr value: $xattr_val"
+	fi
+done
+
+kill $setter_pid &> /dev/null
+unset setter_pid
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..4ac0db5
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,2 @@
+QA output created by 326
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 9c82a6f..01f442d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -152,3 +152,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto quick xattr
-- 
1.9.1

