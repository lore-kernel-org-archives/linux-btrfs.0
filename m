Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62161 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751139AbbDCHDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372EDK001958
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/6] btrfs-progs: test-frame: Update variant names
Date: Fri, 3 Apr 2015 15:01:12 +0800
Message-ID: <1428044477-18485-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use upper case variant name for the following variants:
1) top -> TOP
2) script_dir -> SCRIPT_DIR

And change the following variant name:
1) RESULT -> RESULTS

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common                                     | 20 ++++++++++----------
 tests/fsck-tests.sh                              | 24 ++++++++++++------------
 tests/fsck-tests/006-bad-root-items/test.sh      |  6 +++---
 tests/fsck-tests/012-leaf-corruption/test.sh     |  4 ++--
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 16 ++++++++--------
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/tests/common b/tests/common
index 91a73e1..94cf913 100644
--- a/tests/common
+++ b/tests/common
@@ -5,7 +5,7 @@
 
 _fail()
 {
-	echo "$*" | tee -a $RESULT
+	echo "$*" | tee -a $RESULTS
 	exit 1
 }
 
@@ -17,13 +17,13 @@ _not_run()
 
 run_check()
 {
-	echo "############### $@" >> $RESULT 2>&1
-	"$@" >> $RESULT 2>&1 || _fail "failed: $@"
+	echo "############### $@" >> $RESULTS 2>&1
+	"$@" >> $RESULTS 2>&1 || _fail "failed: $@"
 }
 
 check_prereq()
 {
-	if ! [ -f $top/$1 ]; then
+	if ! [ -f $TOP/$1 ]; then
 		_fail "Failed prerequisities: $1";
 	fi
 }
@@ -31,12 +31,12 @@ check_prereq()
 check_image()
 {
 	image=$1
-	echo "testing image $(basename $image)" >> $RESULT
-	$top/btrfs check $image >> $RESULT 2>&1
+	echo "testing image $(basename $image)" >> $RESULTS
+	$TOP/btrfs check $image >> $RESULTS 2>&1
 	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
 
-	run_check $top/btrfs check --repair $image
-	run_check $top/btrfs check $image
+	run_check $TOP/btrfs check --repair $image
+	run_check $TOP/btrfs check $image
 }
 
 check_all_images()
@@ -44,8 +44,8 @@ check_all_images()
 	dir=$1
 	for i in $(find $dir -iname '*.img')
 	do
-		echo "extracting image $(basename $i)" >> $RESULT
-		$top/btrfs-image -r $i $i.restored || \
+		echo "extracting image $(basename $i)" >> $RESULTS
+		$TOP/btrfs-image -r $i $i.restored || \
 			_fail "failed to extract image $i"
 
 		check_image $i.restored
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 54bd353..046b33d 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -5,25 +5,25 @@
 # It's GPL, same as everything else in this tree.
 #
 
-unset top
+unset TOP
 unset LANG
 LANG=C
-script_dir=$(dirname $(realpath $0))
-top=$(realpath $script_dir/../)
+SCRIPT_DIR=$(dirname $(realpath $0))
+TOP=$(realpath $SCRIPT_DIR/../)
 TEST_DEV=${TEST_DEV:-}
-TEST_MNT=${TEST_MNT:-$top/tests/mnt}
-RESULT="$top/tests/fsck-tests-results.txt"
+TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
+RESULTS="$TOP/tests/fsck-tests-results.txt"
 
-source $top/tests/common
+source $TOP/tests/common
 
-# Allow child test to use $top and $RESULT
-export top
-export RESULT
+# Allow child test to use $TOP and $RESULTS
+export TOP
+export RESULTS
 # For custom script needs to verfiy recovery
 export TEST_MNT
 export LANG
 
-rm -f $RESULT
+rm -f $RESULTS
 mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
 
 # test rely on corrupting blocks tool
@@ -44,7 +44,7 @@ check_prereq btrfs
 #    This is for case btrfs-image can't dump or case needs extra
 #    check/verify
 
-for i in $(find $top/tests/fsck-tests -maxdepth 1 -mindepth 1 -type d | sort)
+for i in $(find $TOP/tests/fsck-tests -maxdepth 1 -mindepth 1 -type d | sort)
 do
 	echo "    [TEST]   $(basename $i)"
 	cd $i
@@ -58,5 +58,5 @@ do
 		# Type 1
 		check_all_images `pwd`
 	fi
-	cd $top
+	cd $TOP
 done
diff --git a/tests/fsck-tests/006-bad-root-items/test.sh b/tests/fsck-tests/006-bad-root-items/test.sh
index 2c0e1c6..bfbfcfc 100755
--- a/tests/fsck-tests/006-bad-root-items/test.sh
+++ b/tests/fsck-tests/006-bad-root-items/test.sh
@@ -1,13 +1,13 @@
 #!/bin/bash
 
-source $top/tests/common
+source $TOP/tests/common
 
-echo "extracting image default_case.tar.xz" >> $RESULT
+echo "extracting image default_case.tar.xz" >> $RESULTS
 tar xJf default_case.tar.xz || \
 	_fail "failed to extract default_case.tar.xz"
 check_image test.img
 
-echo "extracting image skinny_case.tar.xz" >> $RESULT
+echo "extracting image skinny_case.tar.xz" >> $RESULTS
 tar xJf skinny_case.tar.xz || \
 	_fail "failed to extract skinny_case.tar.xz"
 check_image test.img
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 8f82fd1..fe5c226 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $top/tests/common
+source $TOP/tests/common
 
 # Check file list for leaf corruption, no regular/preallocated
 # file extent case.
@@ -34,7 +34,7 @@ leaf_no_data_ext_list=(
 generate_leaf_corrupt_no_data_ext()
 {
 	dest=$1
-	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULT
+	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULTS
 	tar xJf ./no_data_extent.tar.xz || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
 	btrfs-image -r test.img.btrfs-image $dest || \
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 0542c27..cde97db 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $top/tests/common
+source $TOP/tests/common
 
 if [ -z $TEST_DEV ]; then
 	echo "    [NOTRUN] extent tree rebuild, need TEST_DEV variant"
@@ -16,32 +16,32 @@ fi
 test_extent_tree_rebuild()
 {
 	echo "     [TEST]    extent tree rebuild"
-	$top/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
+	$TOP/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
 
 	run_check mount $TEST_DEV $TEST_MNT
 	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
 
 	for i in `seq 1 100`;do
-		$top/btrfs sub snapshot $TEST_MNT \
+		$TOP/btrfs sub snapshot $TEST_MNT \
 			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
 	done
 	run_check umount $TEST_DEV
 
 	# get extent root bytenr
-	extent_root_bytenr=`$top/btrfs-debug-tree -r $TEST_DEV | \
+	extent_root_bytenr=`$TOP/btrfs-debug-tree -r $TEST_DEV | \
 			    grep extent | awk '{print $7}'`
 	if [ -z $extent_root_bytenr ];then
 		_fail "fail to get extent root bytenr"
 	fi
 
 	# corrupt extent root node block
-	run_check $top/btrfs-corrupt-block -l $extent_root_bytenr \
+	run_check $TOP/btrfs-corrupt-block -l $extent_root_bytenr \
 		-b 4096 $TEST_DEV
 
-	$top/btrfs check $TEST_DEV >& /dev/null && \
+	$TOP/btrfs check $TEST_DEV >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $top/btrfs check --init-extent-tree $TEST_DEV
-	run_check $top/btrfs check $TEST_DEV
+	run_check $TOP/btrfs check --init-extent-tree $TEST_DEV
+	run_check $TOP/btrfs check $TEST_DEV
 }
 
 test_extent_tree_rebuild
-- 
2.3.5

