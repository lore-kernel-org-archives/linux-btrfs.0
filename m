Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:63763 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968206AbeFRIiR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E6B2AC0101
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:12 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 5F84ABD65F4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:11 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 20/20] btrfs-progs: test: Add cli-test/010 to check "subvolume list -f" option
Date: Mon, 18 Jun 2018 17:41:08 +0900
Message-ID: <e942f054e17a8db324253a5df85e3acec3859c99.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tests/cli-tests/010-subvolume-list-follow/test.sh | 86 +++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100755 tests/cli-tests/010-subvolume-list-follow/test.sh

diff --git a/tests/cli-tests/010-subvolume-list-follow/test.sh b/tests/cli-tests/010-subvolume-list-follow/test.sh
new file mode 100755
index 00000000..8fb746c6
--- /dev/null
+++ b/tests/cli-tests/010-subvolume-list-follow/test.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
+# test for "subvolume list -f"
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+setup_loopdevs 2
+prepare_loopdevs
+dev1=${loopdevs[1]}
+dev2=${loopdevs[2]}
+
+# test if the ids returned by "sub list" match expected ids
+# $1  ... option for subvolume list
+# $2  ... PATH to be specified by sub list command
+# $3~ ... expected return ids
+test_list()
+{
+	result=$(run_check_stdout $SUDO "$TOP/btrfs" subvolume list $1 "$2" | \
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
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$dev1"
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$dev2"
+
+run_check $SUDO_HELPER mount "$dev1" "$TEST_MNT"
+cd "$TEST_MNT"
+
+# Create some subvolumes and directories
+# <FS_TREE> (id 5)
+#   |- AAA (id 256)
+#   |   |- top
+#   |   |- bbb
+#   |   -- ccc
+#   |
+#   |- BBB (id 258)
+#   -- CCC (id 259)
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create AAA
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create BBB
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create CCC
+run_check $SUDO_HELPER mkdir AAA/top
+run_check $SUDO_HELPER mkdir AAA/bbb
+run_check $SUDO_HELPER mkdir AAA/ccc
+
+test_list "" "." "256 258 259"
+test_list "-f" "." "256 258 259"
+cd ..
+run_check $SUDO_HELPER umount "$TEST_MNT"
+
+# Mount as follows:
+#
+# "TEST_MNT" (AAA)
+#   |- top (FS_TREE)
+#   |   |- AAA
+#   |   |- BBB
+#   |   -- CCC
+#   |
+#   |- bbb (BBB)
+#   -- ccc (CCC)
+run_check $SUDO_HELPER mount -o subvol=AAA "$dev1" "$TEST_MNT"
+run_check $SUDO_HELPER mount "$dev1" "$TEST_MNT/top"
+run_check $SUDO_HELPER mount -o subvol=BBB "$dev1" "$TEST_MNT/bbb"
+run_check $SUDO_HELPER mount -o subvol=CCC "$dev1" "$TEST_MNT/ccc"
+
+cd "$TEST_MNT"
+test_list "" "." "256"
+# With -f option, subvolume AAA/BBB/CCC will be counted twice.
+# Also, it will list FS_TREE (5) if it is mounted below the specified path.
+test_list "-f" "." "5 256 256 258 258 259 259"
+
+cd ..
+run_check $SUDO_HELPER umount -R "$TEST_MNT"
+cleanup_loopdevs
-- 
2.14.4


