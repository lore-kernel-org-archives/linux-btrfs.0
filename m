Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:43691 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932202AbeCSHdy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:33:54 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4AE4EAC00AB
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:33:51 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 73171BD64E9
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:33:50 +0900 (JST)
Subject: [RFC PATCH v3 7/7] btrfs-porgs: test: Add cli-test/009 to check
 subvolume list for both root and normal user
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Message-ID: <af5add92-e00a-fd66-875f-a773f8030f3b@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:33:47 +0900
MIME-Version: 1.0
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/cli-tests/009-subvolume-list/test.sh | 136 +++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100755 tests/cli-tests/009-subvolume-list/test.sh

diff --git a/tests/cli-tests/009-subvolume-list/test.sh b/tests/cli-tests/009-subvolume-list/test.sh
new file mode 100755
index 00000000..ac00a697
--- /dev/null
+++ b/tests/cli-tests/009-subvolume-list/test.sh
@@ -0,0 +1,136 @@
+#!/bin/bash
+# test for "subvolume list" both for root and normal user
+
+source "$TEST_TOP/common"
+
+check_testuser
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev
+
+
+# test if the ids returned by "sub list" match expected ids
+# $1  ... indicate run as root or test user
+# $2  ... PATH to be specified by sub list command
+# $3~ ... expected return ids
+test_list()
+{
+	local SUDO
+	if [ $1 -eq 1 ]; then
+		SUDO=$SUDO_HELPER
+	else
+		SUDO="sudo -u progs-test"
+	fi
+
+	result=$(run_check_stdout $SUDO "$TOP/btrfs" subvolume list "$2" | \
+		awk '{print $2}' | xargs | sort -n)
+
+	shift
+	shift
+	expected=($(echo "$@" | tr " " "\n" | sort -n))
+	expected=$(IFS=" "; echo "${expected[*]}")
+
+	if [ "$result" != "$expected" ]; then
+		echo "result  : $result"
+		echo "expected: $expected"
+		_fail "ids returned by sub list does not match expected ids"
+	fi
+}
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check_mount_test_dev
+cd "$TEST_MNT"
+
+# create subvolumes and directories and make some non-readable
+# by user 'progs-test'
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub1
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub1/subsub1
+run_check $SUDO_HELPER mkdir sub1/dir
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2
+run_check $SUDO_HELPER mkdir -p sub2/dir/dirdir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2/dir/subsub2
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2/dir/dirdir/subsubX
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3/subsub3
+run_check $SUDO_HELPER mkdir sub3/dir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub3/dir/subsubY
+run_check $SUDO_HELPER chmod o-r sub3
+
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4/subsub4
+run_check $SUDO_HELPER mkdir sub4/dir
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub4/dir/subsubZ
+run_check $SUDO_HELPER setfacl -m u:progs-test:- sub4/dir
+
+run_check $SUDO_HELPER touch "file"
+
+# expected result for root:
+#
+# ID 257 gen 9 top level 5 path sub1
+# ID 258 gen 8 top level 257 path sub1/subsub1
+# ID 259 gen 11 top level 5 path sub2
+# ID 260 gen 10 top level 259 path sub2/dir/subsub2
+# ID 261 gen 11 top level 259 path sub2/dir/dirdir/subsubX
+# ID 262 gen 15 top level 5 path sub3
+# ID 263 gen 13 top level 262 path sub3/subsub3
+# ID 264 gen 14 top level 262 path sub3/dir/subsubY
+# ID 265 gen 17 top level 5 path sub4
+# ID 266 gen 16 top level 265 path sub4/subsub4
+# ID 267 gen 17 top level 265 path sub4/dir/subsubZ
+
+# check for root for both absolute/relative path
+# always returns all subvolumes
+all=$(seq 257 267)
+test_list 1 "$TEST_MNT" "${all[@]}"
+test_list 1 "$TEST_MNT/sub1" "${all[@]}"
+test_list 1 "$TEST_MNT/sub1/dir" "${all[@]}"
+test_list 1 "$TEST_MNT/sub2" "${all[@]}"
+test_list 1 "$TEST_MNT/sub2/dir" "${all[@]}"
+test_list 1 "$TEST_MNT/sub3" "${all[@]}"
+test_list 1 "$TEST_MNT/sub4" "${all[@]}"
+run_mustfail "should fail for file" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume list "$TEST_MNT/file"
+
+test_list 1 "." "${all[@]}"
+test_list 1 "sub1" "${all[@]}"
+test_list 1 "sub1/dir" "${all[@]}"
+test_list 1 "sub2" "${all[@]}"
+test_list 1 "sub2/dir" "${all[@]}"
+test_list 1 "sub3" "${all[@]}"
+test_list 1 "sub4" "${all[@]}"
+run_mustfail "should fail for file" \
+	$SUDO_HELPER "$TOP/btrfs" subvolume list "file"
+
+# check for normal user for both absolute/relative path
+# only returns subvolumes under specified path
+test_list 0 "$TEST_MNT" "257 258 259 260 261 262 265 266"
+test_list 0 "$TEST_MNT/sub1" "257 258"
+test_list 0 "$TEST_MNT/sub1/dir" ""
+test_list 0 "$TEST_MNT/sub2" "259 260 261"
+test_list 0 "$TEST_MNT/sub2/dir" "260 261"
+run_mustfail "should raise permission error" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "$TEST_MNT/sub3"
+test_list 0 "$TEST_MNT/sub4" "265 266"
+run_mustfail "should raise permission error" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "$TEST_MNT/sub4/dir"
+run_mustfail "should fail for file" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "$TEST_MNT/file"
+
+test_list 0 "." "257 258 259 260 261 262 265 266"
+test_list 0 "sub1/dir" ""
+test_list 0 "sub2" "259 260 261"
+test_list 0 "sub2/dir" "260 261"
+run_mustfail "should raise permission error" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "sub3"
+test_list 0 "sub4" "265 266"
+run_mustfail "should raise permission error" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "sub4/dir"
+run_mustfail "should fail for file" \
+	sudo -u progs-test "$TOP/btrfs" subvolume list "file"
+
+cd ..
+run_check_umount_test_dev
-- 
2.14.3


