Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:51916 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdIGBsp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 21:48:45 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 92DFBAC0236
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 10:48:35 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: test: add new test for inspect-internal
 rootid
Message-ID: <77cca561-a951-87bf-36f0-4ab7f6de1597@jp.fujitsu.com>
Date: Thu, 7 Sep 2017 10:48:27 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new test checks inspect-internal rootid
 - handle path to subvolume/directory/file as an argument
 - get different id for each subvolume
 - get the expected id for each file/directory (i.e. the same as
	 containing subvolume)

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
change log:
v1 -> v2:
  - Moved category from cli-tests to misc-tests
  - When "inspect-internal rootid" fials, echo messages and exit
  (since _fail() is called in subshell, logging is already done)
  - Add quotes to variables
---
 .../misc-tests/022-inspect-internal-rootid/test.sh | 57 ++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100755 tests/misc-tests/022-inspect-internal-rootid/test.sh

diff --git a/tests/misc-tests/022-inspect-internal-rootid/test.sh b/tests/misc-tests/022-inspect-internal-rootid/test.sh
new file mode 100755
index 0000000..1e10748
--- /dev/null
+++ b/tests/misc-tests/022-inspect-internal-rootid/test.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+#
+# test commands of inspect-internal rootid
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+prepare_test_dev 2g
+
+run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+run_check $SUDO_HELPER chmod a+rw "$TEST_MNT"
+cd "$TEST_MNT"
+
+run_check "$TOP/btrfs" subvolume create sub
+run_check "$TOP/btrfs" subvolume create sub/subsub
+run_check mkdir dir
+run_check touch file1
+run_check touch dir/file2
+run_check touch sub/file3
+
+id1=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid .)
+	|| { echo $id1; exit 1; }
+id2=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub)
+	|| { echo $id2; exit 1; }
+id3=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/subsub)
+	|| { echo $id3; exit 1; }
+id4=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir)
+	|| { echo $id4; exit 1; }
+id5=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid file1)
+	|| { echo $id5; exit 1; }
+id6=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir/file2)
+	|| { echo $id6; exit 1; }
+id7=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/file3)
+	|| { echo $id7; exit 1; }
+
+if ! ([ $id1 -ne $id2 ] && [ $id1 -ne $id3 ] && [ $id2 -ne $id3 ]); then
+	_fail "inspect-internal rootid: each subvolume must have different id"
+fi
+
+if ! ([ $id1 -eq $id4 ] && [ $id1 -eq $id5 ] && [ $id1 -eq $id6 ]); then
+	_fail "inspect-internal rootid: rootid mismatch found"
+fi
+
+if ! ([ $id2 -eq $id7 ]); then
+	_fail "inspect-internal rootid: rootid mismatch found"
+fi
+
+run_mustfail "should fail for non exist file" \
+	"$TOP/btrfs" inspect-internal rootid no_such_file
+run_mustfail "should fail for non btrfs filesystem" \
+	"$TOP/btrfs" inspect-internal rootid /dev/null
+
+cd ..
+run_check_umount_test_dev
-- 
2.9.5

