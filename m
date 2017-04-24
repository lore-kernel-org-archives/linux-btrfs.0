Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:34012
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1171376AbdDXNbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:31:24 -0400
Date: Mon, 24 Apr 2017 18:59:40 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: tests: add variable quotation to fsck-tests
Message-ID: <20170424132940.GA11861@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/fsck-tests/006-bad-root-items/test.sh        |  6 +++---
 tests/fsck-tests/012-leaf-corruption/test.sh       | 24 +++++++++++-----------
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 22 ++++++++++----------
 tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  4 ++--
 .../fsck-tests/019-non-skinny-false-alert/test.sh  |  4 ++--
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  4 ++--
 .../021-partially-dropped-snapshot-case/test.sh    |  4 ++--
 tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  4 ++--
 tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  4 ++--
 tests/fsck-tests/024-clear-space-cache/test.sh     | 16 +++++++--------
 tests/fsck-tests/025-file-extents/test.sh          |  2 +-
 tests/fsck-tests/026-check-inode-link/test.sh      |  2 +-
 12 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/tests/fsck-tests/006-bad-root-items/test.sh b/tests/fsck-tests/006-bad-root-items/test.sh
index 8433234..bf3ef78 100755
--- a/tests/fsck-tests/006-bad-root-items/test.sh
+++ b/tests/fsck-tests/006-bad-root-items/test.sh
@@ -1,15 +1,15 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
-echo "extracting image default_case.tar.xz" >> $RESULTS
+echo "extracting image default_case.tar.xz" >> "$RESULTS"
 tar --no-same-owner -xJf default_case.tar.xz || \
 	_fail "failed to extract default_case.tar.xz"
 check_image test.img
 
-echo "extracting image skinny_case.tar.xz" >> $RESULTS
+echo "extracting image skinny_case.tar.xz" >> "$RESULTS"
 tar --no-same-owner -xJf skinny_case.tar.xz || \
 	_fail "failed to extract skinny_case.tar.xz"
 check_image test.img
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index a308727..43b0e6d 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs-image
 
@@ -37,16 +37,16 @@ leaf_no_data_ext_list=(
 generate_leaf_corrupt_no_data_ext()
 {
 	dest=$1
-	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULTS
+	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> "$RESULTS"
 	tar --no-same-owner -xJf ./no_data_extent.tar.xz || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
-	$TOP/btrfs-image -r test.img.btrfs-image $dest || \
+	"$TOP/btrfs-image" -r test.img.btrfs-image "$dest" || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
 
 	# leaf at 4206592 and 20905984 contains no regular data
 	# extent, clear its csum to corrupt the leaf.
 	for x in 4206592 20905984; do
-		dd if=/dev/zero of=$dest bs=1 count=32 conv=notrunc seek=$x \
+		dd if=/dev/zero of="$dest" bs=1 count=32 conv=notrunc seek="$x" \
 			1>/dev/null 2>&1
 	done
 }
@@ -60,21 +60,21 @@ check_inode()
 	name=$5
 
 	# Check whether the inode exists
-	exists=$($SUDO_HELPER find $path -inum $ino)
+	exists=$($SUDO_HELPER find "$path" -inum "$ino")
 	if [ -z "$exists" ]; then
 		_fail "inode $ino not recovered correctly"
 	fi
 
 	# Check inode type
-	found_mode=$(printf "%o" 0x$($SUDO_HELPER stat $exists -c %f))
-	if [ $found_mode -ne $mode ]; then
+	found_mode=$(printf "%o" 0x$($SUDO_HELPER stat "$exists" -c %f))
+	if [ "$found_mode" -ne "$mode" ]; then
 		echo "$found_mode"
 		_fail "inode $ino modes not recovered"
 	fi
 
 	# Check inode size
-	found_size=$($SUDO_HELPER stat $exists -c %s)
-	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
+	found_size=$($SUDO_HELPER stat "$exists" -c %s)
+	if [ $mode -ne 41700 -a "$found_size" -ne "$size" ]; then
 		_fail "inode $ino size not recovered correctly"
 	fi
 
@@ -90,11 +90,11 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	$SUDO_HELPER mount -o loop $image -o ro $TEST_MNT
+	$SUDO_HELPER mount -o loop "$image" -o ro "$TEST_MNT"
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
-		check_inode $TEST_MNT/lost+found \
+		check_inode "$TEST_MNT/lost+found" \
 			    ${leaf_no_data_ext_list[i]} \
 			    ${leaf_no_data_ext_list[i + 1]} \
 			    ${leaf_no_data_ext_list[i + 2]} \
@@ -102,7 +102,7 @@ check_leaf_corrupt_no_data_ext()
 			    ${leaf_no_data_ext_list[i + 4]}
 			    ((i+=4))
 	done
-	$SUDO_HELPER umount $TEST_MNT
+	$SUDO_HELPER umount "$TEST_MNT"
 }
 
 setup_root_helper
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 08c1e50..90fe2e8 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs-corrupt-block
 check_prereq mkfs.btrfs
@@ -12,32 +12,32 @@ prepare_test_dev 1G
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
 {
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
 
 	run_check_mount_test_dev
 	generate_dataset small
 
 	for i in `seq 1 100`;do
-		run_check $SUDO_HELPER $TOP/btrfs sub snapshot $TEST_MNT \
-			$TEST_MNT/snapaaaaaaa_$i
+		run_check $SUDO_HELPER "$TOP/btrfs" sub snapshot "$TEST_MNT" \
+			"$TEST_MNT/snapaaaaaaa_$i"
 	done
 	run_check_umount_test_dev
 
 	# get extent root bytenr
-	extent_root_bytenr=`$SUDO_HELPER $TOP/btrfs inspect-internal dump-tree -r $TEST_DEV | \
+	extent_root_bytenr=`$SUDO_HELPER "$TOP/btrfs" inspect-internal dump-tree -r "$TEST_DEV" | \
 			    grep extent | awk '{print $7}'`
-	if [ -z $extent_root_bytenr ];then
+	if [ -z "$extent_root_bytenr" ];then
 		_fail "fail to get extent root bytenr"
 	fi
 
 	# corrupt extent root node block
-	run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -l $extent_root_bytenr \
-		-b 4096 $TEST_DEV
+	run_check $SUDO_HELPER "$TOP/btrfs-corrupt-block" -l "$extent_root_bytenr" \
+		-b 4096 "$TEST_DEV"
 
-	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
+	$SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV" >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $SUDO_HELPER $TOP/btrfs check --repair --init-extent-tree $TEST_DEV
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $SUDO_HELPER "$TOP/btrfs" check --repair --init-extent-tree "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
 }
 
 test_extent_tree_rebuild
diff --git a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
index c453ab5..29eb20b 100755
--- a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
+++ b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
@@ -1,11 +1,11 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
 image=$(extract_image "./default_case.raw.xz")
-run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
 	grep -q "crossing stripe boundary" ||
 	_fail "no expected error message in the output"
 
diff --git a/tests/fsck-tests/019-non-skinny-false-alert/test.sh b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
index a7f8e86..550f294 100755
--- a/tests/fsck-tests/019-non-skinny-false-alert/test.sh
+++ b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
@@ -11,12 +11,12 @@
 #
 # a buggy check leads to the above messages
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
 image=$(extract_image "./default_case.img.xz")
-run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
 	grep -q "type mismatch with chunk" &&
 	_fail "unexpected error message in the output"
 
diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index 5dc5e55..ea7b345 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -15,7 +15,7 @@
 #   the beginning of leaf.
 #   Which caused false alert for lowmem mode.
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
@@ -25,6 +25,6 @@ do
 
 	# Since the return value bug is already fixed, we don't need
 	# the old grep hack to detect bug.
-	run_check $TOP/btrfs check "$image"
+	run_check "$TOP/btrfs" check "$image"
 	rm -f "$image"
 done
diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
index eb8d884..379f5c9 100755
--- a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
+++ b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
@@ -1,14 +1,14 @@
 #!/bin/bash
 # confirm whether btrfsck supports to check a partially dropped snapshot
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
 for img in *.img
 do
 	image=$(extract_image $img)
-	run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
 		grep -q "Errors found in extent allocation tree or chunk allocation"
 	if [ $? -eq 0 ]; then
 		rm -f "$image"
diff --git a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
index 1dc8f8f..dcdc1b4 100755
--- a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
+++ b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # check whether btrfsck can detect running qgroup rescan
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
@@ -9,7 +9,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_check_stdout $TOP/btrfs check "$image" 2>&1 | \
+	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 | \
 		grep -q "Counts for qgroup id"
 	if [ $? -eq 0 ]; then
 		_fail "Btrfs check doesn't detect rescan correctly"
diff --git a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
index a304eac..ebb07f3 100755
--- a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
+++ b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
@@ -5,13 +5,13 @@
 # Fixed by patch:
 # btrfs-progs: Fix stack overflow for checking qgroup on tree reloc tree
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 
 check_image()
 {
-	run_check $TOP/btrfs check "$1"
+	run_check "$TOP/btrfs" check "$1"
 }
 
 check_all_images
diff --git a/tests/fsck-tests/024-clear-space-cache/test.sh b/tests/fsck-tests/024-clear-space-cache/test.sh
index 2945ae8..e44191b 100755
--- a/tests/fsck-tests/024-clear-space-cache/test.sh
+++ b/tests/fsck-tests/024-clear-space-cache/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # confirm that clearing space cache works
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 check_prereq mkfs.btrfs
@@ -9,21 +9,21 @@ check_prereq mkfs.btrfs
 setup_root_helper
 prepare_test_dev 1G
 
-run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
 run_check_mount_test_dev
 
 # Create files that takes at least 3 data chunks, while
 # can still be removed to create free space inside one chunk.
 
 for i in $(seq 0 6); do
-	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file_${i} bs=1M \
+	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/file_${i}" bs=1M \
 		count=64 > /dev/null 2>&1
 done
 sync
 
 # Remove file 1 3 5 to create holes
 for i in 1 3 5; do
-	run_check $SUDO_HELPER rm $TEST_MNT/file_${i}
+	run_check $SUDO_HELPER rm "$TEST_MNT/file_${i}"
 done
 
 sync
@@ -31,17 +31,17 @@ sync
 run_check_umount_test_dev
 
 # Clear space cache and re-check fs
-run_check $TOP/btrfs check --clear-space-cache v1 $TEST_DEV
-run_check $TOP/btrfs check $TEST_DEV
+run_check "$TOP/btrfs" check --clear-space-cache v1 "$TEST_DEV"
+run_check "$TOP/btrfs" check "$TEST_DEV"
 
 # Manually recheck space cache and super space cache generation
-run_check_stdout $TOP/btrfs inspect-internal dump-tree -t root $TEST_DEV | \
+run_check_stdout "$TOP/btrfs" inspect-internal dump-tree -t root "$TEST_DEV" | \
 	grep -q FREE_SPACE
 if [ $? -eq 0 ]; then
 	_fail "clear space cache doesn't clear all space cache"
 fi
 
-run_check_stdout $TOP/btrfs inspect-internal dump-super $TEST_DEV |
+run_check_stdout $TOP/btrfs inspect-internal dump-super "$TEST_DEV" |
 	grep -q 'cache_generation.*18446744073709551615'
 if [ $? -ne 0 ]; then
 	_fail "clear space cache doesn't set cache_generation correctly"
diff --git a/tests/fsck-tests/025-file-extents/test.sh b/tests/fsck-tests/025-file-extents/test.sh
index 290464e..e4bc424 100755
--- a/tests/fsck-tests/025-file-extents/test.sh
+++ b/tests/fsck-tests/025-file-extents/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Confirm btrfs check can check file extents without causing false alert
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs
 check_prereq mkfs.btrfs
diff --git a/tests/fsck-tests/026-check-inode-link/test.sh b/tests/fsck-tests/026-check-inode-link/test.sh
index 3a7a3c1..ad2c37e 100755
--- a/tests/fsck-tests/026-check-inode-link/test.sh
+++ b/tests/fsck-tests/026-check-inode-link/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # verify that 'btrfs check --repair' fixes corrupted inode nlink field
 
-source $TOP/tests/common
+source "$TOP/tests/common"
 
 check_prereq btrfs-corrupt-block
 check_prereq mkfs.btrfs
-- 
2.7.4

