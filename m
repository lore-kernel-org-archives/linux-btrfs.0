Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47004 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbaLYBeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:34:15 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1Xjqk020158
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:33:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: New btrfsck test infrastructure
Date: Thu, 25 Dec 2014 09:32:11 +0800
Message-ID: <1419471135-10878-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the old btrfsck test infrastructure (btrfs-image dump or xz raw
dump) to the new test infrastructure.

1) Test case layout
The new infrastructure is dir based, each dir is one test type, and can
contain multiple images/scripts for different corner cases.
So layout will be the following:
btrfs-progs
	|-tests
	    |-fsck-tests
		|-001-SOME-CORRUPT-TYPE
			|-IMAGE-FOR-CASE1
			|-IMAGE-FOR-CASE2

2) Test case image types
Only 2 types for test case images.
a) btrfs-image dump
   This one is the simplest case, one only needs to add the image to
   corresponding dir.

b) custom script
   This one is for all the resting cases which can't fit btrfs-image,
   like csum error or script can generate the image (this reduces the
   size obviously and good for review)
   The old binary dump also belongs to this type, so need to add script
   to extract them.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common        | 49 ++++++++++++++++++++++++++
 tests/fsck-tests.sh | 99 +++++++++++++++++++++++++++--------------------------
 2 files changed, 99 insertions(+), 49 deletions(-)
 create mode 100644 tests/common
 mode change 100644 => 100755 tests/fsck-tests.sh

diff --git a/tests/common b/tests/common
new file mode 100644
index 0000000..80a5381
--- /dev/null
+++ b/tests/common
@@ -0,0 +1,49 @@
+#!/bin/bash
+#
+# Common routines for all tests
+#
+
+_fail()
+{
+	echo "$*" | tee -a $RESULT
+	exit 1
+}
+
+run_check()
+{
+	echo "############### $@" >> $RESULT 2>&1
+	"$@" >> $RESULT 2>&1 || _fail "failed: $@"
+}
+
+check_prereq()
+{
+	if ! [ -f $top/$1 ]; then
+		_fail "Failed prerequisities: $1";
+	fi
+}
+
+check_image()
+{
+	image=$1
+	echo "testing image $(basename $image)" >> $RESULT
+	$top/btrfs check $image >> $RESULT 2>&1
+	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
+
+	run_check $top/btrfs check --repair $image
+	run_check $top/btrfs check $image
+}
+
+check_all_images()
+{
+	dir=$1
+	for i in $(find $dir -iname '*.img')
+	do
+		echo "extracting image $(basename $i)" >> $RESULT
+		$top/btrfs-image -r $i $i.restored || \
+			_fail "failed to extract image $i"
+
+		check_image $i.restored
+
+		rm $i.restored
+	done
+}
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
old mode 100644
new mode 100755
index 24fb109..a992b45
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -5,60 +5,60 @@
 # It's GPL, same as everything else in this tree.
 #
 
-here=`pwd`
-TEST_DEV=
-TEST_MNT=
-RESULT="fsck-tests-results.txt"
-
-_fail()
-{
-	echo "$*" | tee -a $RESULT
-	exit 1
-}
-
-run_check()
-{
-	echo "############### $@" >> $RESULT 2>&1
-	"$@" >> $RESULT 2>&1 || _fail "failed: $@"
-}
-
-check_prereq()
-{
-	if ! [ -f $here/$1 ]; then
-		_fail "Failed prerequisities: $1";
-	fi
-}
+unset top
+unset LANG
+LANG=C
+script_dir=$(dirname $(realpath $0))
+top=$(realpath $script_dir/../)
+TEST_DEV=${TEST_DEV:-}
+TEST_MNT=${TEST_MNT:-$top/tests/mnt}
+RESULT="$top/tests/fsck-tests-results.txt"
+
+source $top/tests/common
+
+# Allow child test to use $top and $RESULT
+export top
+export RESULT
+# For custom script needs to verfiy recovery
+export TEST_MNT
+export LANG
 
 rm -f $RESULT
+mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
 
 # test rely on corrupting blocks tool
 check_prereq btrfs-corrupt-block
 check_prereq btrfs-image
 check_prereq btrfs
 
-# Some broken filesystem images are kept as .img files, created by the tool
-# btrfs-image, and others are kept as .tar.xz files that contain raw filesystem
-# image (the backing file of a loop device, as a sparse file). The reason for
-# keeping some as tarballs of raw images is that for these cases btrfs-image
-# isn't able to preserve all the (bad) filesystem structure for some reason.
-for i in $(find $here/tests/fsck-tests -name '*.img' -o -name '*.tar.xz' | sort)
+# Each dir contains one type of error for btrfsck test.
+# Each dir must be one of the following 2 types:
+# 1) Only btrfs-image dump
+#    Only contains one or several btrfs-image dumps (.img)
+#    Each image will be tested by generic test routine
+#    (btrfsck --repair and btrfsck).
+#    This is for case that btree-healthy images.
+# 2) Custom test script
+#    This dir contains test.sh which will do custom image
+#    generation/check/verification.
+#    This is for case btrfs-image can't dump or case needs extra
+#    check/verify
+
+for i in $(find $top/tests/fsck-tests -maxdepth 1 -mindepth 1 -type d | sort)
 do
 	echo "     [TEST]    $(basename $i)"
-	echo "testing image $i" >> $RESULT
-
-	extension=${i#*.}
-
-	if [ $extension == "img" ]; then
-		run_check $here/btrfs-image -r $i test.img
+	cd $i
+	if [ -x test.sh ]; then
+		# Type 2
+		./test.sh
+		if [ $? -ne 0 ]; then
+			_fail "test failed for case $(basename $i)"
+		fi
 	else
-		run_check tar xJf $i
+		# Type 1
+		check_all_images `pwd`
 	fi
-
-	$here/btrfs check test.img >> $RESULT 2>&1
-	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
-
-	run_check $here/btrfs check --repair test.img
-	run_check $here/btrfs check test.img
+	cd $top
 done
 
 if [ -z $TEST_DEV ] || [ -z $TEST_MNT ];then
@@ -70,31 +70,32 @@ fi
 test_extent_tree_rebuild()
 {
 	echo "     [TEST]    extent tree rebuild"
-	$here/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
+	$top/mkfs.btrfs -f $TEST_DEV >> /dev/null 2>&1 || _fail "fail to mkfs"
 
 	run_check mount $TEST_DEV $TEST_MNT
 	cp -aR /lib/modules/`uname -r`/ $TEST_MNT 2>&1
 
 	for i in `seq 1 100`;do
-		$here/btrfs sub snapshot $TEST_MNT \
+		$top/btrfs sub snapshot $TEST_MNT \
 			$TEST_MNT/snapaaaaaaa_$i >& /dev/null
 	done
 	run_check umount $TEST_DEV
 
 	# get extent root bytenr
-	extent_root_bytenr=`$here/btrfs-debug-tree -r $TEST_DEV | grep extent | awk '{print $7}'`
+	extent_root_bytenr=`$top/btrfs-debug-tree -r $TEST_DEV | \
+			    grep extent | awk '{print $7}'`
 	if [ -z $extent_root_bytenr ];then
 		_fail "fail to get extent root bytenr"
 	fi
 
 	# corrupt extent root node block
-	run_check $here/btrfs-corrupt-block -l $extent_root_bytenr \
+	run_check $top/btrfs-corrupt-block -l $extent_root_bytenr \
 		-b 4096 $TEST_DEV
 
-	$here/btrfs check $TEST_DEV >& /dev/null && \
+	$top/btrfs check $TEST_DEV >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $here/btrfs check --init-extent-tree $TEST_DEV
-	run_check $here/btrfs check $TEST_DEV
+	run_check $top/btrfs check --init-extent-tree $TEST_DEV
+	run_check $top/btrfs check $TEST_DEV
 }
 
 test_extent_tree_rebuild
-- 
2.2.1

