Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34826 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751539AbeAELRb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:31 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 5D8BC48AEA0A
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Jan 2018 19:17:27 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [v6 16/16] btrfs-progs: add test for offline-scrub
Date: Fri, 5 Jan 2018 19:01:24 +0800
Message-ID: <1515150084-17231-17-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a test for offline-scrub.
The process of this test case:
1)create a filesystem with profile raid10
2)mount the filesystem, create a file in the mount point, and write
some data to the file
3)get the logical address of the file's extent data
4)get the physical address of the logical address
5)overwrite the contents in the physical address
6)use offline scrub to check and repair it

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile                                           |  6 ++-
 tests/scrub-tests.sh                               | 43 +++++++++++++++++++
 tests/scrub-tests/001-offline-scrub-raid10/test.sh | 50 ++++++++++++++++++++++
 3 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100755 tests/scrub-tests.sh
 create mode 100755 tests/scrub-tests/001-offline-scrub-raid10/test.sh

diff --git a/Makefile b/Makefile
index fa3ebc86..0a3060f5 100644
--- a/Makefile
+++ b/Makefile
@@ -322,6 +322,10 @@ test-cli: btrfs
 	@echo "    [TEST]   cli-tests.sh"
 	$(Q)bash tests/cli-tests.sh
 
+test-scrub: btrfs mkfs.btrfs
+	@echo "    [TEST]   scrub-tests.sh"
+	$(Q)bash tests/scrub-tests.sh
+
 test-clean:
 	@echo "Cleaning tests"
 	$(Q)bash tests/clean-tests.sh
@@ -332,7 +336,7 @@ test-inst: all
 		$(MAKE) $(MAKEOPTS) DESTDIR=$$tmpdest install && \
 		$(RM) -rf -- $$tmpdest
 
-test: test-fsck test-mkfs test-convert test-misc test-fuzz test-cli
+test: test-fsck test-mkfs test-convert test-misc test-fuzz test-cli test-scrub
 
 #
 # NOTE: For static compiles, you need to have all the required libs
diff --git a/tests/scrub-tests.sh b/tests/scrub-tests.sh
new file mode 100755
index 00000000..697137f4
--- /dev/null
+++ b/tests/scrub-tests.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# btrfs scrub tests
+
+LANG=C
+SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TOP=$(readlink -f "$SCRIPT_DIR/../")
+TEST_DEV=${TEST_DEV:-}
+RESULTS="$TOP/tests/scrub-tests-results.txt"
+IMAGE="$TOP/tests/test.img"
+
+source "$TOP/tests/common"
+
+export TOP
+export RESULTS
+export LANG
+export IMAGE
+export TEST_DEV
+
+rm -f "$RESULTS"
+
+check_prereq btrfs
+check_kernel_support
+
+# The tests are driven by their custom script called 'test.sh'
+
+for i in $(find "$TOP/tests/scrub-tests" -maxdepth 1 -mindepth 1 -type d	\
+	${TEST:+-name "$TEST"} | sort)
+do
+	echo "    [TEST/scrub]   $(basename $i)"
+	cd "$i"
+	echo "=== Entering $i" >> "$RESULTS"
+	if [ -x test.sh ]; then
+		./test.sh
+		if [ $? -ne 0 ]; then
+			if [[ $TEST_LOG =~ dump ]]; then
+				cat "$RESULTS"
+			fi
+			_fail "test failed for case $(basename $i)"
+		fi
+	fi
+	cd "$TOP"
+done
diff --git a/tests/scrub-tests/001-offline-scrub-raid10/test.sh b/tests/scrub-tests/001-offline-scrub-raid10/test.sh
new file mode 100755
index 00000000..c609d870
--- /dev/null
+++ b/tests/scrub-tests/001-offline-scrub-raid10/test.sh
@@ -0,0 +1,50 @@
+#!/bin/bash
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_prereq btrfs-debug-tree
+check_prereq btrfs-map-logical
+
+setup_root_helper
+
+setup_loopdevs 4
+prepare_loopdevs
+
+dev1=${loopdevs[1]}
+file=$TEST_MNT/file
+
+mkfs_multi()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $@ ${loopdevs[@]}
+}
+
+#create filesystem
+mkfs_multi -d raid10 -m raid10
+run_check $SUDO_HELPER mount -t btrfs $dev1 "$TEST_MNT"
+
+#write some data
+run_check $SUDO_HELPER touch $file
+run_check $SUDO_HELPER dd if=/dev/zero of=$file bs=64K count=1
+run_check sync -f $file
+
+#get the extent data's logical address of $file
+logical=$($SUDO_HELPER $TOP/btrfs-debug-tree -t 5 $dev1 | grep -oP '(?<=byte\s)\d+')
+
+#get the first physical address and device of $file's data
+read physical dev< <($SUDO_HELPER $TOP/btrfs-map-logical -l $logical $dev1| head -1 |cut -d ' ' -f6,8)
+
+#then modify the data
+run_check $SUDO_HELPER dd if=/dev/random of=$dev seek=$(($physical/65536)) bs=64K count=1
+run_check sync -f $file
+
+run_check $SUDO_HELPER umount "$TEST_MNT"
+log=$(run_check_stdout $SUDO_HELPER $TOP/btrfs scrub start --offline $dev1)
+cleanup_loopdevs
+
+#check result
+result=$(echo $log | grep 'len 65536 REPARIED: has corrupted mirror, repaired')
+if [[ -z "$result" ]] ;then
+	_fail "scrub repair faild"
+fi
-- 
2.14.3



