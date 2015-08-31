Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbbHaFGX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 01:06:23 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V568Jv020003
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 13:06:08 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/4] btrfs-progs: tests: Introduce init_env to initialize common env variant
Date: Mon, 31 Aug 2015 13:04:36 +0800
Message-ID: <d52589ea31baac23ebb0eae3b0950503d5c5d6e8.1440997237.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For example, $TEST_DIR is common used in severial tests, and have
duplicated code for initialize.

These duplicated code not only benifits harddisk vendor, but have
inconsistent details, as:
  convert-tests.sh: lack of mkdir
  fsck-tests/012-leaf-corruption/test.sh: unnecessary mkdir
  fsck-tests/013-extent-tree-rebuild/test.sh: unnecessary init
  misc-tests/XXX ...
And severial error message:
  _fail "unable to create mount point on $TEST_MNT"
  _fail "failed to create mount point"
  ...

This patch move initizlizaton of $TEST_DIR to common init_env(),
to avoid above problem, and init_env() can be used to add more
things in future.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common                                     | 7 +++++++
 tests/convert-tests.sh                           | 1 -
 tests/fsck-tests.sh                              | 3 ---
 tests/fsck-tests/012-leaf-corruption/test.sh     | 1 -
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 5 -----
 tests/misc-tests.sh                              | 3 ---
 tests/misc-tests/001-btrfstune-features/test.sh  | 5 -----
 tests/misc-tests/002-uuid-rewrite/test.sh        | 5 -----
 tests/misc-tests/003-zero-log/test.sh            | 5 -----
 9 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/tests/common b/tests/common
index cf463e8..c597915 100644
--- a/tests/common
+++ b/tests/common
@@ -171,3 +171,10 @@ prepare_test_dev()
 	truncate -s "$size" "$TEST_DEV" || _not_run "create file for loop device failed"
 }
 
+init_env()
+{
+	TEST_MNT="${TEST_MNT:-$TOP/tests/mnt}"
+	export TEST_MNT
+	mkdir -p "$TEST_MNT" || { echo "Failed mkdir -p $TEST_MNT"; exit 1; }
+}
+init_env
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index b395e25..68c03dc 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -9,7 +9,6 @@ unset LANG
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f $0))
 TOP=$(readlink -f $SCRIPT_DIR/../)
-TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
 RESULTS="$TOP/tests/convert-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
 
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 73538fe..b910e85 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -11,7 +11,6 @@ LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f $0))
 TOP=$(readlink -f $SCRIPT_DIR/../)
 TEST_DEV=${TEST_DEV:-}
-TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
 RESULTS="$TOP/tests/fsck-tests-results.txt"
 
 source $TOP/tests/common
@@ -20,11 +19,9 @@ source $TOP/tests/common
 export TOP
 export RESULTS
 # For custom script needs to verfiy recovery
-export TEST_MNT
 export LANG
 
 rm -f $RESULTS
-mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
 
 # test rely on corrupting blocks tool
 check_prereq btrfs-corrupt-block
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index f8701ad..a37ceda 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -85,7 +85,6 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	mkdir -p $TEST_MNT || _fail "failed to create mount point"
 	$SUDO_HELPER mount -o loop $image -o ro $TEST_MNT
 
 	i=0
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 88a66cc..b7909d2 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -7,11 +7,6 @@ check_prereq mkfs.btrfs
 setup_root_helper
 prepare_test_dev 1G
 
-if [ -z $TEST_MNT ];then
-	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
-	exit 0
-fi
-
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
 {
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index f9c1152..d04416b 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -8,7 +8,6 @@ LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f $0))
 TOP=$(readlink -f $SCRIPT_DIR/../)
 TEST_DEV=${TEST_DEV:-}
-TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
 RESULTS="$TOP/tests/misc-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
 
@@ -20,13 +19,11 @@ source $TOP/tests/common
 export TOP
 export RESULTS
 # For custom script needs to verfiy recovery
-export TEST_MNT
 export LANG
 # For tests that only use a loop device
 export IMAGE
 
 rm -f $RESULTS
-mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
 
 # test rely on corrupting blocks tool
 check_prereq btrfs-corrupt-block
diff --git a/tests/misc-tests/001-btrfstune-features/test.sh b/tests/misc-tests/001-btrfstune-features/test.sh
index ea33954..836e8d3 100755
--- a/tests/misc-tests/001-btrfstune-features/test.sh
+++ b/tests/misc-tests/001-btrfstune-features/test.sh
@@ -9,11 +9,6 @@ check_prereq mkfs.btrfs
 setup_root_helper
 prepare_test_dev
 
-if [ -z $TEST_MNT ];then
-	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
-	exit 0
-fi
-
 # test whether fsck can rebuild a corrupted extent tree
 # parameters:
 # - option for mkfs.btrfs -O, empty for defaults
diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
index bffa9b8..9b103aa 100755
--- a/tests/misc-tests/002-uuid-rewrite/test.sh
+++ b/tests/misc-tests/002-uuid-rewrite/test.sh
@@ -9,11 +9,6 @@ check_prereq mkfs.btrfs
 check_prereq btrfstune
 prepare_test_dev
 
-if [ -z $TEST_MNT ];then
-	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
-	exit 0
-fi
-
 get_fs_uuid() {
 	local image
 
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index edab5db..b650930 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -8,11 +8,6 @@ check_prereq mkfs.btrfs
 check_prereq btrfs
 prepare_test_dev
 
-if [ -z $TEST_MNT ];then
-	echo "    [NOTRUN] extent tree rebuild, need TEST_MNT variant"
-	exit 0
-fi
-
 get_log_root()
 {
 	local image
-- 
1.8.5.1

