Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:16632 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdIEFx3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 01:53:29 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D8F0FAC00B7
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Sep 2017 14:53:21 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: test: add new test for inspect-internal rootid
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Message-ID: <f7b5fe23-1339-aa57-a60d-c878d151bff3@jp.fujitsu.com>
Date: Tue, 5 Sep 2017 14:53:15 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new test checks inspect-internal rootid
 - handle path to subvolume/directory/file as an argument
 - get different id for each subvolume
 - get the expected id for each file/directory
  (i.e. the same as containing subvolume)

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 .../cli-tests/007-inspect-internal-rootid/test.sh  | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100755 tests/cli-tests/007-inspect-internal-rootid/test.sh

diff --git a/tests/cli-tests/007-inspect-internal-rootid/test.sh b/tests/cli-tests/007-inspect-internal-rootid/test.sh
new file mode 100755
index 0000000..a7105c7
--- /dev/null
+++ b/tests/cli-tests/007-inspect-internal-rootid/test.sh
@@ -0,0 +1,50 @@
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
+run_check $SUDO_HELPER chmod a+rw $TEST_MNT
+cd $TEST_MNT
+
+run_check "$TOP/btrfs" subvolume create sub
+run_check "$TOP/btrfs" subvolume create sub/subsub
+run_check mkdir dir
+run_check touch file1
+run_check touch dir/file2
+run_check touch sub/file3
+
+id1=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid .)          || exit
+id2=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub)        || exit
+id3=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/subsub) || exit
+id4=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir)        || exit
+id5=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid file1)      || exit
+id6=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir/file2)  || exit
+id7=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/file3)  || exit
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

