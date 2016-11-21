Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:45731 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbcKUFLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 00:11:00 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0E480AC00F8
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2016 14:10:56 +0900 (JST)
Message-Id: <201611210510.AA00020@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 21 Nov 2016 14:10:41 +0900
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, dsterba@suse.cz
Subject: [PATCH v2 2/3] btrfs-progs: test: fix how to make test files in fsck-tests 013
In-Reply-To: <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my test environment, following error was occurred because the size
of /lib/modules/`uname -r`/* is larger than 1GB.

# make test-fsck
    [TEST]   fsck-tests.sh
    [TEST/fsck]   013-extent-tree-rebuild
failed: cp -aR /lib/modules/4.9.0-rc5/ /test/btrfs-progs/tests/mnt
test failed for case 013-extent-tree-rebuild
Makefile:272: recipe for target 'test-fsck' failed
make: *** [test-fsck] Error 1
#

In this test case, 'generate_dataset small' is enough for making the
test files, so I will use 'generate_dataset' instead of 'cp'.

For this, move 'generate_dataset()' from 'common.convert' to 'common'.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: change how to make test files
---
 tests/common                                     | 89 ++++++++++++++++++++++++
 tests/common.convert                             | 89 ------------------------
 tests/fsck-tests/013-extent-tree-rebuild/test.sh |  2 +-
 3 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/tests/common b/tests/common
index c61962d..8b760f7 100644
--- a/tests/common
+++ b/tests/common
@@ -309,6 +309,95 @@ check_kernel_support()
 	return 0
 }
 
+# how many files to create.
+DATASET_SIZE=50
+
+generate_dataset() {
+
+	dataset_type="$1"
+	dirpath=$TEST_MNT/$dataset_type
+	run_check $SUDO_HELPER mkdir -p "$dirpath"
+
+	case $dataset_type in
+		small)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
+				count=1 >/dev/null 2>&1
+			done
+			;;
+
+		hardlink)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
+				run_check $SUDO_HELPER ln "$dirpath/$dataset_type.$num" "$dirpath/hlink.$num"
+			done
+			;;
+
+		fast_symlink)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
+				run_check cd "$dirpath" && \
+					$SUDO_HELPER ln -s "$dataset_type.$num" "$dirpath/slink.$num" && \
+					cd /
+			done
+			;;
+
+		brokenlink)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER ln -s "$dirpath/$dataset_type.$num" "$dirpath/blink.$num"
+			done
+			;;
+
+		perm)
+			for modes in 777 775 755 750 700 666 664 644 640 600 444 440 400 000		\
+				1777 1775 1755 1750 1700 1666 1664 1644 1640 1600 1444 1440 1400 1000	\
+				2777 2775 2755 2750 2700 2666 2664 2644 2640 2600 2444 2440 2400 2000	\
+				4777 4775 4755 4750 4700 4666 4664 4644 4640 4600 4444 4440 4400 4000; do
+				if [[ "$modes" == *9* ]] || [[ "$modes" == *8* ]]
+				then
+					continue;
+				else
+					run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$modes"
+					run_check $SUDO_HELPER chmod "$modes" "$dirpath/$dataset_type.$modes"
+				fi
+			done
+			;;
+
+		sparse)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
+				count=1 >/dev/null 2>&1
+				run_check $SUDO_HELPER truncate -s 500K "$dirpath/$dataset_type.$num"
+				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
+				oflag=append conv=notrunc count=1 >/dev/null 2>&1
+				run_check $SUDO_HELPER truncate -s 800K "$dirpath/$dataset_type.$num"
+			done
+			;;
+
+		acls)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$num"
+				run_check $SUDO_HELPER setfacl -m "u:root:x" "$dirpath/$dataset_type.$num"
+				run_check $SUDO_HELPER setfattr -n user.foo -v "bar$num" "$dirpath/$dataset_type.$num"
+			done
+			;;
+
+		fifo)
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER mkfifo "$dirpath/$dataset_type.$num"
+			done
+			;;
+
+		slow_symlink)
+			long_filename=`date +%s | sha256sum | cut -f1 -d'-'`
+			run_check $SUDO_HELPER touch "$dirpath/$long_filename"
+			for num in $(seq 1 "$DATASET_SIZE"); do
+				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
+			done
+			;;
+	esac
+}
+
 init_env()
 {
 	TEST_MNT="${TEST_MNT:-$TOP/tests/mnt}"
diff --git a/tests/common.convert b/tests/common.convert
index 375d4b5..3481c4d 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -1,95 +1,6 @@
 #!/bin/bash
 # helpers for btrfs-convert tests
 
-# how many files to create.
-DATASET_SIZE=50
-
-generate_dataset() {
-
-	dataset_type="$1"
-	dirpath=$TEST_MNT/$dataset_type
-	run_check $SUDO_HELPER mkdir -p "$dirpath"
-
-	case $dataset_type in
-		small)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
-				count=1 >/dev/null 2>&1
-			done
-			;;
-
-		hardlink)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
-				run_check $SUDO_HELPER ln "$dirpath/$dataset_type.$num" "$dirpath/hlink.$num"
-			done
-			;;
-
-		fast_symlink)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER touch $dirpath/$dataset_type.$num
-				run_check cd "$dirpath" && \
-					$SUDO_HELPER ln -s "$dataset_type.$num" "$dirpath/slink.$num" && \
-					cd /
-			done
-			;;
-
-		brokenlink)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER ln -s "$dirpath/$dataset_type.$num" "$dirpath/blink.$num"
-			done
-			;;
-
-		perm)
-			for modes in 777 775 755 750 700 666 664 644 640 600 444 440 400 000		\
-				1777 1775 1755 1750 1700 1666 1664 1644 1640 1600 1444 1440 1400 1000	\
-				2777 2775 2755 2750 2700 2666 2664 2644 2640 2600 2444 2440 2400 2000	\
-				4777 4775 4755 4750 4700 4666 4664 4644 4640 4600 4444 4440 4400 4000; do
-				if [[ "$modes" == *9* ]] || [[ "$modes" == *8* ]]
-				then
-					continue;
-				else
-					run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$modes"
-					run_check $SUDO_HELPER chmod "$modes" "$dirpath/$dataset_type.$modes"
-				fi
-			done
-			;;
-
-		sparse)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
-				count=1 >/dev/null 2>&1
-				run_check $SUDO_HELPER truncate -s 500K "$dirpath/$dataset_type.$num"
-				run_check $SUDO_HELPER dd if=/dev/urandom of="$dirpath/$dataset_type.$num" bs=10K \
-				oflag=append conv=notrunc count=1 >/dev/null 2>&1
-				run_check $SUDO_HELPER truncate -s 800K "$dirpath/$dataset_type.$num"
-			done
-			;;
-
-		acls)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER touch "$dirpath/$dataset_type.$num"
-				run_check $SUDO_HELPER setfacl -m "u:root:x" "$dirpath/$dataset_type.$num"
-				run_check $SUDO_HELPER setfattr -n user.foo -v "bar$num" "$dirpath/$dataset_type.$num"
-			done
-			;;
-
-		fifo)
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER mkfifo "$dirpath/$dataset_type.$num"
-			done
-			;;
-
-		slow_symlink)
-			long_filename=`date +%s | sha256sum | cut -f1 -d'-'`
-			run_check $SUDO_HELPER touch "$dirpath/$long_filename"
-			for num in $(seq 1 "$DATASET_SIZE"); do
-				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
-			done
-			;;
-	esac
-}
-
 populate_fs() {
 
         for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'fifo' 'slow_symlink'; do
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index f678e29..37bdcd9 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -15,7 +15,7 @@ test_extent_tree_rebuild()
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
 
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER cp -aR /lib/modules/`uname -r`/ $TEST_MNT
+	generate_dataset small
 
 	for i in `seq 1 100`;do
 		run_check $SUDO_HELPER $TOP/btrfs sub snapshot $TEST_MNT \
-- 
2.9.3
