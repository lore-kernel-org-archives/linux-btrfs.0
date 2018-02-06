Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15939 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751544AbeBFFhj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Feb 2018 00:37:39 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v4 2/3] btrfs-progs: introduce TEST_TOP for resources except binaries
Date: Tue, 6 Feb 2018 13:37:24 +0800
Message-ID: <1517895445-17767-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517895445-17767-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517895445-17767-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use TEST_TOP for tests/common, Documentation, images, and internal
binaries.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/cli-tests.sh                                       | 15 ++++++++++-----
 tests/cli-tests/001-btrfs/test.sh                        |  2 +-
 tests/cli-tests/002-balance-full-no-filters/test.sh      |  2 +-
 tests/cli-tests/003-fi-resize-args/test.sh               |  2 +-
 tests/cli-tests/004-send-parent-multi-subvol/test.sh     |  2 +-
 tests/cli-tests/005-qgroup-show/test.sh                  |  2 +-
 tests/cli-tests/006-qgroup-show-sync/test.sh             |  2 +-
 tests/cli-tests/007-check-force/test.sh                  |  2 +-
 tests/cli-tests/008-subvolume-get-set-default/test.sh    |  2 +-
 tests/common                                             | 16 ++++++++++------
 tests/convert-tests.sh                                   | 15 ++++++++++-----
 tests/convert-tests/001-ext2-basic/test.sh               |  4 ++--
 tests/convert-tests/002-ext3-basic/test.sh               |  4 ++--
 tests/convert-tests/003-ext4-basic/test.sh               |  4 ++--
 .../004-ext2-backup-superblock-ranges/test.sh            |  2 +-
 tests/convert-tests/005-delete-all-rollback/test.sh      |  4 ++--
 tests/convert-tests/006-large-hole-extent/test.sh        |  4 ++--
 tests/convert-tests/007-unsupported-block-sizes/test.sh  |  4 ++--
 tests/convert-tests/008-readonly-image/test.sh           |  4 ++--
 tests/convert-tests/009-common-inode-flags/test.sh       |  4 ++--
 tests/convert-tests/010-reiserfs-basic/test.sh           |  4 ++--
 .../011-reiserfs-delete-all-rollback/test.sh             |  4 ++--
 .../convert-tests/012-reiserfs-large-hole-extent/test.sh |  4 ++--
 .../013-reiserfs-common-inode-flags/test.sh              |  4 ++--
 tests/convert-tests/014-reiserfs-tail-handling/test.sh   |  4 ++--
 .../convert-tests/015-no-rollback-after-balance/test.sh  |  4 ++--
 tests/fsck-tests.sh                                      | 15 ++++++++++-----
 tests/fsck-tests/006-bad-root-items/test.sh              |  2 +-
 tests/fsck-tests/012-leaf-corruption/test.sh             |  2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh         |  4 ++--
 tests/fsck-tests/018-leaf-crossing-stripes/test.sh       |  2 +-
 tests/fsck-tests/019-non-skinny-false-alert/test.sh      |  2 +-
 tests/fsck-tests/020-extent-ref-cases/test.sh            |  2 +-
 .../021-partially-dropped-snapshot-case/test.sh          |  2 +-
 tests/fsck-tests/022-qgroup-rescan-halfway/test.sh       |  2 +-
 tests/fsck-tests/023-qgroup-stack-overflow/test.sh       |  2 +-
 tests/fsck-tests/024-clear-space-cache/test.sh           |  2 +-
 tests/fsck-tests/025-file-extents/test.sh                |  2 +-
 tests/fsck-tests/026-bad-dir-item-name/test.sh           |  2 +-
 tests/fsck-tests/027-tree-reloc-tree/test.sh             |  2 +-
 tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh   |  2 +-
 tests/fuzz-tests.sh                                      | 15 ++++++++++-----
 tests/fuzz-tests/001-simple-check-unmounted/test.sh      |  4 ++--
 tests/fuzz-tests/002-simple-image/test.sh                |  4 ++--
 tests/fuzz-tests/003-multi-check-unmounted/test.sh       |  4 ++--
 tests/fuzz-tests/004-simple-dump-tree/test.sh            |  4 ++--
 tests/fuzz-tests/005-simple-dump-super/test.sh           |  4 ++--
 tests/fuzz-tests/006-simple-tree-stats/test.sh           |  4 ++--
 tests/fuzz-tests/007-simple-super-recover/test.sh        |  4 ++--
 tests/fuzz-tests/008-simple-chunk-recover/test.sh        |  4 ++--
 tests/fuzz-tests/009-simple-zero-log/test.sh             |  4 ++--
 tests/misc-tests.sh                                      | 15 ++++++++++-----
 tests/misc-tests/001-btrfstune-features/test.sh          |  2 +-
 tests/misc-tests/002-uuid-rewrite/test.sh                |  6 +++---
 tests/misc-tests/003-zero-log/test.sh                    |  4 ++--
 tests/misc-tests/004-shrink-fs/test.sh                   |  2 +-
 .../misc-tests/005-convert-progress-thread-crash/test.sh |  2 +-
 tests/misc-tests/006-image-on-missing-device/test.sh     |  2 +-
 tests/misc-tests/007-subvolume-sync/test.sh              |  2 +-
 tests/misc-tests/008-leaf-crossing-stripes/test.sh       |  2 +-
 tests/misc-tests/009-subvolume-sync-must-wait/test.sh    |  2 +-
 tests/misc-tests/010-convert-delete-ext2-subvol/test.sh  |  2 +-
 tests/misc-tests/011-delete-missing-device/test.sh       |  2 +-
 tests/misc-tests/012-find-root-no-result/test.sh         |  2 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh        |  2 +-
 tests/misc-tests/014-filesystem-label/test.sh            |  2 +-
 tests/misc-tests/015-dump-super-garbage/test.sh          |  2 +-
 tests/misc-tests/016-send-clone-src/test.sh              |  2 +-
 tests/misc-tests/017-recv-stream-malformatted/test.sh    |  2 +-
 tests/misc-tests/018-recv-end-of-stream/test.sh          |  2 +-
 .../019-receive-clones-on-mounted-subvol/test.sh         |  4 ++--
 tests/misc-tests/020-fix-superblock-corruption/test.sh   |  2 +-
 tests/misc-tests/021-image-multi-devices/test.sh         |  2 +-
 .../misc-tests/022-filesystem-du-on-empty-subvol/test.sh |  2 +-
 .../023-device-usage-with-missing-device/test.sh         |  2 +-
 tests/misc-tests/024-inspect-internal-rootid/test.sh     |  2 +-
 tests/misc-tests/025-zstd-compression/test.sh            |  2 +-
 tests/misc-tests/026-image-non-printable-chars/test.sh   |  2 +-
 .../misc-tests/027-subvol-list-deleted-toplevel/test.sh  |  2 +-
 tests/mkfs-tests.sh                                      | 15 ++++++++++-----
 tests/mkfs-tests/001-basic-profiles/test.sh              |  2 +-
 .../002-no-force-mixed-on-small-volume/test.sh           |  2 +-
 tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh   |  2 +-
 tests/mkfs-tests/004-rootdir-keeps-size/test.sh          |  4 ++--
 tests/mkfs-tests/005-long-device-name-for-ssd/test.sh    |  2 +-
 tests/mkfs-tests/006-partitioned-loopdev/test.sh         |  2 +-
 tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh     |  2 +-
 .../008-sectorsize-nodesize-combination/test.sh          |  2 +-
 tests/mkfs-tests/009-special-files-for-rootdir/test.sh   |  2 +-
 89 files changed, 181 insertions(+), 147 deletions(-)

diff --git a/tests/cli-tests.sh b/tests/cli-tests.sh
index 16d6afcf..6f021143 100755
--- a/tests/cli-tests.sh
+++ b/tests/cli-tests.sh
@@ -4,13 +4,18 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/cli-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/cli-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -24,7 +29,7 @@ check_kernel_support
 
 # The tests are driven by their custom script called 'test.sh'
 
-for i in $(find "$TOP/tests/cli-tests" -maxdepth 1 -mindepth 1 -type d	\
+for i in $(find "$TEST_TOP/tests/cli-tests" -maxdepth 1 -mindepth 1 -type d	\
 	${TEST:+-name "$TEST"} | sort)
 do
 	name=$(basename "$i")
@@ -40,5 +45,5 @@ do
 			_fail "test failed for case $(basename $i)"
 		fi
 	fi
-	cd "$TOP"
+	cd "$TEST_TOP"
 done
diff --git a/tests/cli-tests/001-btrfs/test.sh b/tests/cli-tests/001-btrfs/test.sh
index c680604b..6e0e875b 100755
--- a/tests/cli-tests/001-btrfs/test.sh
+++ b/tests/cli-tests/001-btrfs/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test commands of btrfs
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/cli-tests/002-balance-full-no-filters/test.sh b/tests/cli-tests/002-balance-full-no-filters/test.sh
index 0475ea73..913f310c 100755
--- a/tests/cli-tests/002-balance-full-no-filters/test.sh
+++ b/tests/cli-tests/002-balance-full-no-filters/test.sh
@@ -2,7 +2,7 @@
 #
 # coverage of balance --full-balance
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/003-fi-resize-args/test.sh b/tests/cli-tests/003-fi-resize-args/test.sh
index e4f262b6..a485ec6b 100755
--- a/tests/cli-tests/003-fi-resize-args/test.sh
+++ b/tests/cli-tests/003-fi-resize-args/test.sh
@@ -2,7 +2,7 @@
 #
 # test parsing of various resize arguments
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/004-send-parent-multi-subvol/test.sh b/tests/cli-tests/004-send-parent-multi-subvol/test.sh
index c1348b50..aca30b2c 100755
--- a/tests/cli-tests/004-send-parent-multi-subvol/test.sh
+++ b/tests/cli-tests/004-send-parent-multi-subvol/test.sh
@@ -2,7 +2,7 @@
 #
 # minimal test for the following syntax: btrfs send -p parent subvol1 subvol2
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/005-qgroup-show/test.sh b/tests/cli-tests/005-qgroup-show/test.sh
index d9a91831..30882e79 100755
--- a/tests/cli-tests/005-qgroup-show/test.sh
+++ b/tests/cli-tests/005-qgroup-show/test.sh
@@ -2,7 +2,7 @@
 #
 # qgroup show behaviour when quotas are not enabled
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/006-qgroup-show-sync/test.sh b/tests/cli-tests/006-qgroup-show-sync/test.sh
index d552b8b9..b3bec1b4 100755
--- a/tests/cli-tests/006-qgroup-show-sync/test.sh
+++ b/tests/cli-tests/006-qgroup-show-sync/test.sh
@@ -2,7 +2,7 @@
 #
 # simple test of qgroup show --sync option
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/007-check-force/test.sh b/tests/cli-tests/007-check-force/test.sh
index 12b30205..2240dcb2 100755
--- a/tests/cli-tests/007-check-force/test.sh
+++ b/tests/cli-tests/007-check-force/test.sh
@@ -2,7 +2,7 @@
 #
 # test 'btrfs check --force' on a mounted filesystem
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/cli-tests/008-subvolume-get-set-default/test.sh b/tests/cli-tests/008-subvolume-get-set-default/test.sh
index 9318002e..ff1c9e78 100755
--- a/tests/cli-tests/008-subvolume-get-set-default/test.sh
+++ b/tests/cli-tests/008-subvolume-get-set-default/test.sh
@@ -10,7 +10,7 @@ check_default_id()
 	fi
 }
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/common b/tests/common
index 734cd171..db697574 100644
--- a/tests/common
+++ b/tests/common
@@ -290,8 +290,12 @@ run_mustfail_stdout()
 
 check_prereq()
 {
-	if ! [ -f "$TOP/$1" ]; then
-		_fail "Failed prerequisites: $1";
+	if [ "$1" = "btrfs-corrupt-block" -o "$1" = "fssum" ]; then
+		if ! [ -f "$TEST_TOP/$1" ]; then
+			_fail "Failed prerequisites: $TEST_TOP/$1";
+		fi
+	elif ! [ -f "$TOP/$1" ]; then
+		_fail "Failed prerequisites: $TOP/$1";
 	fi
 }
 
@@ -448,9 +452,9 @@ prepare_test_dev()
 		return;
 	fi
 
-	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
+	echo "\$TEST_DEV not given, use $TEST_TOP/test/test.img as fallback" >> \
 		"$RESULTS"
-	TEST_DEV="$TOP/tests/test.img"
+	TEST_DEV="$TEST_TOP/tests/test.img"
 
 	truncate -s "$size" "$TEST_DEV" || _not_run "create file for loop device failed"
 }
@@ -626,11 +630,11 @@ cleanup_loopdevs()
 
 init_env()
 {
-	TEST_MNT="${TEST_MNT:-$TOP/tests/mnt}"
+	TEST_MNT="${TEST_MNT:-$TEST_TOP/tests/mnt}"
 	export TEST_MNT
 	mkdir -p "$TEST_MNT" || { echo "Failed mkdir -p $TEST_MNT"; exit 1; }
 
-	source $TOP/tests/common.local
+	source $TEST_TOP/tests/common.local
 
 	if [ "$TEST_ENABLE_OVERRIDE" = 'true' -a -n "$RESULTS" ]; then
 		echo "INCLUDE common.local" >> "$RESULTS"
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 2a92a58b..a3517220 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -5,14 +5,19 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/convert-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/convert-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -54,7 +59,7 @@ run_one_test() {
 }
 
 # Test special images
-for i in $(find "$TOP/tests/convert-tests" -maxdepth 1 -mindepth 1 -type d \
+for i in $(find "$TEST_TOP/tests/convert-tests" -maxdepth 1 -mindepth 1 -type d \
 	   ${TEST:+-name "$TEST"} | sort)
 do
 	run_one_test "$i"
diff --git a/tests/convert-tests/001-ext2-basic/test.sh b/tests/convert-tests/001-ext2-basic/test.sh
index af75d948..9e16f1f1 100755
--- a/tests/convert-tests/001-ext2-basic/test.sh
+++ b/tests/convert-tests/001-ext2-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/002-ext3-basic/test.sh b/tests/convert-tests/002-ext3-basic/test.sh
index 233e2d94..745a56cc 100755
--- a/tests/convert-tests/002-ext3-basic/test.sh
+++ b/tests/convert-tests/002-ext3-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/003-ext4-basic/test.sh b/tests/convert-tests/003-ext4-basic/test.sh
index baf6115c..6e05f007 100755
--- a/tests/convert-tests/003-ext4-basic/test.sh
+++ b/tests/convert-tests/003-ext4-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
index cf354d40..4bb7e7f1 100755
--- a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
+++ b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
@@ -10,7 +10,7 @@
 # 4) Overlap file extents
 # 5) Unable to rollback
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-convert
 check_prereq btrfs
diff --git a/tests/convert-tests/005-delete-all-rollback/test.sh b/tests/convert-tests/005-delete-all-rollback/test.sh
index 31fa2c4b..18da82a2 100755
--- a/tests/convert-tests/005-delete-all-rollback/test.sh
+++ b/tests/convert-tests/005-delete-all-rollback/test.sh
@@ -2,8 +2,8 @@
 # create a base image, convert to btrfs, remove all files, rollback the ext4 image
 # note: ext4 only
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/006-large-hole-extent/test.sh b/tests/convert-tests/006-large-hole-extent/test.sh
index 38e97055..94dff64e 100755
--- a/tests/convert-tests/006-large-hole-extent/test.sh
+++ b/tests/convert-tests/006-large-hole-extent/test.sh
@@ -5,8 +5,8 @@
 # Fast pinpoint regression test. No options combination nor checksum
 # verification
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/007-unsupported-block-sizes/test.sh b/tests/convert-tests/007-unsupported-block-sizes/test.sh
index ef010202..511e42ef 100755
--- a/tests/convert-tests/007-unsupported-block-sizes/test.sh
+++ b/tests/convert-tests/007-unsupported-block-sizes/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if block sizes smaller than 4k expectedly fail to convert
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
index 064bc271..1cfc52a2 100755
--- a/tests/convert-tests/008-readonly-image/test.sh
+++ b/tests/convert-tests/008-readonly-image/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if the converted ext2 image is readonly
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/009-common-inode-flags/test.sh b/tests/convert-tests/009-common-inode-flags/test.sh
index 6d159993..efb0d8c6 100755
--- a/tests/convert-tests/009-common-inode-flags/test.sh
+++ b/tests/convert-tests/009-common-inode-flags/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if btrfs-convert can copy common inode flags like SYNC/IMMUTABLE
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/convert-tests/010-reiserfs-basic/test.sh b/tests/convert-tests/010-reiserfs-basic/test.sh
index 87008f15..7b05c0a0 100755
--- a/tests/convert-tests/010-reiserfs-basic/test.sh
+++ b/tests/convert-tests/010-reiserfs-basic/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 if ! check_kernel_support_reiserfs >/dev/null; then
 	_not_run "no reiserfs support"
diff --git a/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
index 0b8366c8..cf805ef9 100755
--- a/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
+++ b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # create a base image, convert to btrfs, remove all files, rollback the reiserfs image
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 if ! check_kernel_support_reiserfs >/dev/null; then
 	_not_run "no reiserfs support"
diff --git a/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh b/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
index dde1b3eb..f6a2348b 100755
--- a/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
+++ b/tests/convert-tests/012-reiserfs-large-hole-extent/test.sh
@@ -5,8 +5,8 @@
 # Fast pinpoint regression test. No options combination nor checksum
 # verification
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 if ! check_kernel_support_reiserfs >/dev/null; then
 	_not_run "no reiserfs support"
diff --git a/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh b/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
index a15240ce..d535d17e 100755
--- a/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
+++ b/tests/convert-tests/013-reiserfs-common-inode-flags/test.sh
@@ -1,8 +1,8 @@
 #!/bin/bash
 # Check if btrfs-convert can copy common inode flags like SYNC/IMMUTABLE
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 if ! check_kernel_support_reiserfs >/dev/null; then
 	_not_run "no reiserfs support"
diff --git a/tests/convert-tests/014-reiserfs-tail-handling/test.sh b/tests/convert-tests/014-reiserfs-tail-handling/test.sh
index 335c0091..c90172dd 100755
--- a/tests/convert-tests/014-reiserfs-tail-handling/test.sh
+++ b/tests/convert-tests/014-reiserfs-tail-handling/test.sh
@@ -6,8 +6,8 @@
 # We use separate inputs for tails and real blocks so we can determine
 # if there was a failure in copying either.
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 if ! check_kernel_support_reiserfs >/dev/null; then
 	_not_run "no reiserfs support"
diff --git a/tests/convert-tests/015-no-rollback-after-balance/test.sh b/tests/convert-tests/015-no-rollback-after-balance/test.sh
index 47c9c6fa..d30b1823 100755
--- a/tests/convert-tests/015-no-rollback-after-balance/test.sh
+++ b/tests/convert-tests/015-no-rollback-after-balance/test.sh
@@ -2,8 +2,8 @@
 # Check if btrfs-convert refuses to rollback the filesystem, and leave the fs
 # and the convert image untouched
 
-source "$TOP/tests/common"
-source "$TOP/tests/common.convert"
+source "$TEST_TOP/tests/common"
+source "$TEST_TOP/tests/common.convert"
 
 setup_root_helper
 prepare_test_dev
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 15d26c70..b05e26f9 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -4,13 +4,18 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/fsck-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/fsck-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -46,7 +51,7 @@ run_one_test() {
 		# Type 1
 		check_all_images
 	fi
-	cd "$TOP"
+	cd "$TEST_TOP"
 }
 
 # Each dir contains one type of error for btrfsck test.
@@ -62,7 +67,7 @@ run_one_test() {
 #    This is for case btrfs-image can't dump or case needs extra
 #    check/verify
 
-for i in $(find "$TOP/tests/fsck-tests" -maxdepth 1 -mindepth 1 -type d	\
+for i in $(find "$TEST_TOP/tests/fsck-tests" -maxdepth 1 -mindepth 1 -type d	\
 	${TEST:+-name "$TEST"} | sort)
 do
 	run_one_test "$i"
diff --git a/tests/fsck-tests/006-bad-root-items/test.sh b/tests/fsck-tests/006-bad-root-items/test.sh
index bf3ef781..9c2e77e8 100755
--- a/tests/fsck-tests/006-bad-root-items/test.sh
+++ b/tests/fsck-tests/006-bad-root-items/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index fc10a4ff..879a6aeb 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-image
 
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index d71c1b2e..ef776d26 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-corrupt-block
 check_prereq mkfs.btrfs
@@ -31,7 +31,7 @@ test_extent_tree_rebuild()
 	fi
 
 	# corrupt extent root node block
-	run_check $SUDO_HELPER "$TOP/btrfs-corrupt-block" -l "$extent_root_bytenr" \
+	run_check $SUDO_HELPER "$TEST_TOP/btrfs-corrupt-block" -l "$extent_root_bytenr" \
 		-b 4096 "$TEST_DEV"
 
 	$SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV" >& /dev/null && \
diff --git a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
index 29eb20b5..22dc032c 100755
--- a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
+++ b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/019-non-skinny-false-alert/test.sh b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
index 550f2947..cd5cda6a 100755
--- a/tests/fsck-tests/019-non-skinny-false-alert/test.sh
+++ b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
@@ -11,7 +11,7 @@
 #
 # a buggy check leads to the above messages
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index 0c4f7848..c6ad79f3 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -15,7 +15,7 @@
 #   the beginning of leaf.
 #   Which caused false alert for lowmem mode.
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
index 5d997e24..273e320d 100755
--- a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
+++ b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
@@ -2,7 +2,7 @@
 # confirm whether 'btrfs check' supports check ing of a partially dropped
 # snapshot
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
index dcdc1b42..e471ae88 100755
--- a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
+++ b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # check whether btrfsck can detect running qgroup rescan
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
index ebb07f36..a44402ca 100755
--- a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
+++ b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
@@ -5,7 +5,7 @@
 # Fixed by patch:
 # btrfs-progs: Fix stack overflow for checking qgroup on tree reloc tree
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/024-clear-space-cache/test.sh b/tests/fsck-tests/024-clear-space-cache/test.sh
index 76ebcb6b..04387ecf 100755
--- a/tests/fsck-tests/024-clear-space-cache/test.sh
+++ b/tests/fsck-tests/024-clear-space-cache/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # confirm that clearing space cache works
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 check_prereq mkfs.btrfs
diff --git a/tests/fsck-tests/025-file-extents/test.sh b/tests/fsck-tests/025-file-extents/test.sh
index ebe8a305..bcdfcd07 100755
--- a/tests/fsck-tests/025-file-extents/test.sh
+++ b/tests/fsck-tests/025-file-extents/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Confirm btrfs check can check file extents without causing false alert
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 check_prereq mkfs.btrfs
diff --git a/tests/fsck-tests/026-bad-dir-item-name/test.sh b/tests/fsck-tests/026-bad-dir-item-name/test.sh
index a1077a8d..c3255254 100755
--- a/tests/fsck-tests/026-bad-dir-item-name/test.sh
+++ b/tests/fsck-tests/026-bad-dir-item-name/test.sh
@@ -2,7 +2,7 @@
 #
 # confirm whether check detects name and hash mismatch in dir_item
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/027-tree-reloc-tree/test.sh b/tests/fsck-tests/027-tree-reloc-tree/test.sh
index afad1e8d..4d40515d 100755
--- a/tests/fsck-tests/027-tree-reloc-tree/test.sh
+++ b/tests/fsck-tests/027-tree-reloc-tree/test.sh
@@ -5,7 +5,7 @@
 # Also due to the short life span of reloc tree, save the as dump example for
 # later usage.
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 
diff --git a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
index 6f315fae..71a2eb2b 100755
--- a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
+++ b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
@@ -3,7 +3,7 @@
 # An image with mis-aligned superblock total_bytes, that will be found and
 # fixed by 'check' or fixed by 'rescue fix-device-size'
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 prepare_test_dev
diff --git a/tests/fuzz-tests.sh b/tests/fuzz-tests.sh
index f72385e5..5ab2dc42 100755
--- a/tests/fuzz-tests.sh
+++ b/tests/fuzz-tests.sh
@@ -4,13 +4,18 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/fuzz-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/fuzz-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -23,7 +28,7 @@ check_prereq btrfs
 
 # The tests are driven by their custom script called 'test.sh'
 
-for i in $(find "$TOP/tests/fuzz-tests" -maxdepth 1 -mindepth 1 -type d	\
+for i in $(find "$TEST_TOP/tests/fuzz-tests" -maxdepth 1 -mindepth 1 -type d	\
 	${TEST:+-name "$TEST"} | sort)
 do
 	name=$(basename "$i")
@@ -39,5 +44,5 @@ do
 			_fail "test failed for case $(basename $i)"
 		fi
 	fi
-	cd "$TOP"
+	cd "$TEST_TOP"
 done
diff --git a/tests/fuzz-tests/001-simple-check-unmounted/test.sh b/tests/fuzz-tests/001-simple-check-unmounted/test.sh
index 98fe7b0c..5768d40f 100755
--- a/tests/fuzz-tests/001-simple-check-unmounted/test.sh
+++ b/tests/fuzz-tests/001-simple-check-unmounted/test.sh
@@ -2,7 +2,7 @@
 
 # iterate over all fuzzed images and run 'btrfs check'
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -15,6 +15,6 @@ check_image() {
 	run_mayfail $TOP/btrfs check "$image"
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/002-simple-image/test.sh b/tests/fuzz-tests/002-simple-image/test.sh
index 42470ecc..9da888ed 100755
--- a/tests/fuzz-tests/002-simple-image/test.sh
+++ b/tests/fuzz-tests/002-simple-image/test.sh
@@ -2,7 +2,7 @@
 
 # iterate over all fuzzed images and run 'btrfs-image'
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs-image
@@ -17,7 +17,7 @@ check_image() {
 	truncate -s0 target
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 rm -- target
 
diff --git a/tests/fuzz-tests/003-multi-check-unmounted/test.sh b/tests/fuzz-tests/003-multi-check-unmounted/test.sh
index 9fd7b8aa..67d22cf7 100755
--- a/tests/fuzz-tests/003-multi-check-unmounted/test.sh
+++ b/tests/fuzz-tests/003-multi-check-unmounted/test.sh
@@ -3,7 +3,7 @@
 # iterate over all fuzzed images and run 'btrfs check', try various options to
 # get more code coverage
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -21,6 +21,6 @@ check_image() {
 	run_mayfail $TOP/btrfs check --repair "$image"
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/004-simple-dump-tree/test.sh b/tests/fuzz-tests/004-simple-dump-tree/test.sh
index 89ff214c..039b5c55 100755
--- a/tests/fuzz-tests/004-simple-dump-tree/test.sh
+++ b/tests/fuzz-tests/004-simple-dump-tree/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -13,6 +13,6 @@ check_image() {
 	run_mayfail $TOP/btrfs inspect-internal dump-tree "$image"
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/005-simple-dump-super/test.sh b/tests/fuzz-tests/005-simple-dump-super/test.sh
index fbce3d9f..0a7ea8bc 100755
--- a/tests/fuzz-tests/005-simple-dump-super/test.sh
+++ b/tests/fuzz-tests/005-simple-dump-super/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -14,6 +14,6 @@ check_image() {
 	run_mayfail $TOP/btrfs inspect-internal dump-super -Ffa "$image"
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/006-simple-tree-stats/test.sh b/tests/fuzz-tests/006-simple-tree-stats/test.sh
index c3410b06..16a34647 100755
--- a/tests/fuzz-tests/006-simple-tree-stats/test.sh
+++ b/tests/fuzz-tests/006-simple-tree-stats/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -13,6 +13,6 @@ check_image() {
 	run_mayfail $TOP/btrfs inspect-internal tree-stats "$image"
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/007-simple-super-recover/test.sh b/tests/fuzz-tests/007-simple-super-recover/test.sh
index 885cb352..f3a207bb 100755
--- a/tests/fuzz-tests/007-simple-super-recover/test.sh
+++ b/tests/fuzz-tests/007-simple-super-recover/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -15,6 +15,6 @@ check_image() {
 	rm -- "$image".scratch
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/008-simple-chunk-recover/test.sh b/tests/fuzz-tests/008-simple-chunk-recover/test.sh
index d53453f6..1d0ebc28 100755
--- a/tests/fuzz-tests/008-simple-chunk-recover/test.sh
+++ b/tests/fuzz-tests/008-simple-chunk-recover/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -15,6 +15,6 @@ check_image() {
 	rm -- "$image".scratch
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/fuzz-tests/009-simple-zero-log/test.sh b/tests/fuzz-tests/009-simple-zero-log/test.sh
index 393db3f6..5878d4a4 100755
--- a/tests/fuzz-tests/009-simple-zero-log/test.sh
+++ b/tests/fuzz-tests/009-simple-zero-log/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 setup_root_helper
 check_prereq btrfs
@@ -15,6 +15,6 @@ check_image() {
 	rm -- "$image".scratch
 }
 
-check_all_images $TOP/tests/fuzz-tests/images
+check_all_images $TEST_TOP/tests/fuzz-tests/images
 
 exit 0
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 08988016..b2f23183 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -4,13 +4,18 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/misc-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/misc-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -31,7 +36,7 @@ check_kernel_support
 
 # The tests are driven by their custom script called 'test.sh'
 
-for i in $(find "$TOP/tests/misc-tests" -maxdepth 1 -mindepth 1 -type d	\
+for i in $(find "$TEST_TOP/tests/misc-tests" -maxdepth 1 -mindepth 1 -type d	\
 	${TEST:+-name "$TEST"} | sort)
 do
 	echo "    [TEST/misc]   $(basename $i)"
@@ -46,5 +51,5 @@ do
 			_fail "test failed for case $(basename $i)"
 		fi
 	fi
-	cd "$TOP"
+	cd "$TEST_TOP"
 done
diff --git a/tests/misc-tests/001-btrfstune-features/test.sh b/tests/misc-tests/001-btrfstune-features/test.sh
index bfa7f43e..59349e21 100755
--- a/tests/misc-tests/001-btrfstune-features/test.sh
+++ b/tests/misc-tests/001-btrfstune-features/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test btrfstune options that enable filesystem features
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfstune
diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
index fd100fb3..dce97971 100755
--- a/tests/misc-tests/002-uuid-rewrite/test.sh
+++ b/tests/misc-tests/002-uuid-rewrite/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test btrfstune uuid rewriting options
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfstune
@@ -25,7 +25,7 @@ test_uuid_random()
 
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
 		--uuid $origuuid \
-		--rootdir $TOP/Documentation \
+		--rootdir $TEST_TOP/Documentation \
 		$TEST_DEV
 	run_check $TOP/btrfs inspect-internal dump-super "$TEST_DEV"
 	currentfsid=$(run_check_stdout $TOP/btrfstune -f -u $TEST_DEV | \
@@ -47,7 +47,7 @@ test_uuid_user()
 
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
 		--uuid $origuuid \
-		--rootdir $TOP/Documentation \
+		--rootdir $TEST_TOP/Documentation \
 		$TEST_DEV
 	run_check $TOP/btrfs inspect-internal dump-super "$TEST_DEV"
 	run_check $TOP/btrfstune -f -U $newuuid \
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index e7c5c806..3fe4eceb 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test zero-log
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
@@ -27,7 +27,7 @@ test_zero_log()
 {
 	# FIXME: we need an image with existing log_root
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
-		--rootdir $TOP/Documentation \
+		--rootdir $TEST_TOP/Documentation \
 		$TEST_DEV
 	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
 	if [ "$1" = 'standalone' ]; then
diff --git a/tests/misc-tests/004-shrink-fs/test.sh b/tests/misc-tests/004-shrink-fs/test.sh
index 88740358..13b3d066 100755
--- a/tests/misc-tests/004-shrink-fs/test.sh
+++ b/tests/misc-tests/004-shrink-fs/test.sh
@@ -4,7 +4,7 @@
 # are able to resize (shrink) it to that size.
 #
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/005-convert-progress-thread-crash/test.sh b/tests/misc-tests/005-convert-progress-thread-crash/test.sh
index bc71e1fd..42b52284 100755
--- a/tests/misc-tests/005-convert-progress-thread-crash/test.sh
+++ b/tests/misc-tests/005-convert-progress-thread-crash/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test convert-thread-conflict
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs-convert
 
diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
index 2766fb17..54dbc53c 100755
--- a/tests/misc-tests/006-image-on-missing-device/test.sh
+++ b/tests/misc-tests/006-image-on-missing-device/test.sh
@@ -4,7 +4,7 @@
 # - btrfs-image must not loop indefinetelly
 # - btrfs-image will expectedly fail to produce the dump
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs-image
 check_prereq mkfs.btrfs
diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
index 243bb8cc..b97b92f3 100755
--- a/tests/misc-tests/007-subvolume-sync/test.sh
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -4,7 +4,7 @@
 # - btrfs subvolume must not loop indefinitely
 # - btrfs subvolume return 0 in normal case
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/008-leaf-crossing-stripes/test.sh b/tests/misc-tests/008-leaf-crossing-stripes/test.sh
index 03818062..97db3c4f 100755
--- a/tests/misc-tests/008-leaf-crossing-stripes/test.sh
+++ b/tests/misc-tests/008-leaf-crossing-stripes/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test if btrfs-convert creates a filesystem without leaf crossing stripes
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs-convert
 check_prereq btrfs
diff --git a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
index fa3f09ab..685e7cfe 100755
--- a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
+++ b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
@@ -2,7 +2,7 @@
 #
 # Verify that subvolume sync waits until the subvolume is cleaned
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh b/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
index 7915867c..ffcc7aee 100755
--- a/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
+++ b/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
@@ -3,7 +3,7 @@
 # verify that convert rollback finds the ext2_subvolume intact and fails if it
 # was partially deleted
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs-convert
 check_prereq btrfs
diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
index 8a1b14b1..16841345 100755
--- a/tests/misc-tests/011-delete-missing-device/test.sh
+++ b/tests/misc-tests/011-delete-missing-device/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # make sure that 'missing' is accepted for device deletion
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/012-find-root-no-result/test.sh b/tests/misc-tests/012-find-root-no-result/test.sh
index 983a8a1e..a74d51dc 100755
--- a/tests/misc-tests/012-find-root-no-result/test.sh
+++ b/tests/misc-tests/012-find-root-no-result/test.sh
@@ -3,7 +3,7 @@
 # recent fs or balanced fs, whose metadata chunk is the first chunk
 # and the only metadata chunk
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs-find-root
 check_prereq btrfs-image
diff --git a/tests/misc-tests/013-subvolume-sync-crash/test.sh b/tests/misc-tests/013-subvolume-sync-crash/test.sh
index cd445961..9d74a0fd 100755
--- a/tests/misc-tests/013-subvolume-sync-crash/test.sh
+++ b/tests/misc-tests/013-subvolume-sync-crash/test.sh
@@ -3,7 +3,7 @@
 # Verify that subvolume sync waits until the subvolume is cleaned and does not
 # crash at the end
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/014-filesystem-label/test.sh b/tests/misc-tests/014-filesystem-label/test.sh
index 753aa9ea..88b81f0f 100755
--- a/tests/misc-tests/014-filesystem-label/test.sh
+++ b/tests/misc-tests/014-filesystem-label/test.sh
@@ -2,7 +2,7 @@
 #
 # test label settings
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/015-dump-super-garbage/test.sh b/tests/misc-tests/015-dump-super-garbage/test.sh
index 33fc8332..33549903 100755
--- a/tests/misc-tests/015-dump-super-garbage/test.sh
+++ b/tests/misc-tests/015-dump-super-garbage/test.sh
@@ -2,7 +2,7 @@
 #
 # let dump-super dump random data, must not crash
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq btrfs
 
diff --git a/tests/misc-tests/016-send-clone-src/test.sh b/tests/misc-tests/016-send-clone-src/test.sh
index 2780ebbd..fdeade37 100755
--- a/tests/misc-tests/016-send-clone-src/test.sh
+++ b/tests/misc-tests/016-send-clone-src/test.sh
@@ -3,7 +3,7 @@
 # test for sending stream size of clone-src option, compare against a send
 # stream generated by buggy version
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/017-recv-stream-malformatted/test.sh b/tests/misc-tests/017-recv-stream-malformatted/test.sh
index d199a72e..b992100f 100755
--- a/tests/misc-tests/017-recv-stream-malformatted/test.sh
+++ b/tests/misc-tests/017-recv-stream-malformatted/test.sh
@@ -2,7 +2,7 @@
 #
 # test receiving stream that's not valid, simple cases
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/018-recv-end-of-stream/test.sh b/tests/misc-tests/018-recv-end-of-stream/test.sh
index 9ca035f7..c08af25c 100755
--- a/tests/misc-tests/018-recv-end-of-stream/test.sh
+++ b/tests/misc-tests/018-recv-end-of-stream/test.sh
@@ -3,7 +3,7 @@
 # end of stream conditions: test that no instructions in a stream are still
 # received, at least the header must be present
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh b/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
index 182b0cf9..3c6e4afd 100755
--- a/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
+++ b/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
@@ -5,7 +5,7 @@
 # have an entry with the same name that corresponds to different inodes in each
 # snapshot.
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
@@ -14,7 +14,7 @@ check_prereq fssum
 setup_root_helper
 prepare_test_dev
 
-FSSUM_PROG="$TOP/fssum"
+FSSUM_PROG="$TEST_TOP/fssum"
 srcdir=./send-test-dir
 rm -rf "$srcdir"
 mkdir -p "$srcdir"
diff --git a/tests/misc-tests/020-fix-superblock-corruption/test.sh b/tests/misc-tests/020-fix-superblock-corruption/test.sh
index 77c1a5aa..ea536507 100755
--- a/tests/misc-tests/020-fix-superblock-corruption/test.sh
+++ b/tests/misc-tests/020-fix-superblock-corruption/test.sh
@@ -2,7 +2,7 @@
 #
 # Corrupt primary superblock and restore it using backup superblock.
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-select-super
 check_prereq btrfs
diff --git a/tests/misc-tests/021-image-multi-devices/test.sh b/tests/misc-tests/021-image-multi-devices/test.sh
index abf67f90..c9495fd9 100755
--- a/tests/misc-tests/021-image-multi-devices/test.sh
+++ b/tests/misc-tests/021-image-multi-devices/test.sh
@@ -2,7 +2,7 @@
 # Test btrfs-image with multiple devices filesystem and verify that restoring
 # the created image works against a single device.
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-image
 check_prereq mkfs.btrfs
diff --git a/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh b/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
index 72cf076f..4502e5bd 100755
--- a/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
+++ b/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
@@ -2,7 +2,7 @@
 #
 # btrfs fi du should handle empty subvolumes (with ino == 2)
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/023-device-usage-with-missing-device/test.sh b/tests/misc-tests/023-device-usage-with-missing-device/test.sh
index 3c8ba85c..1e9e7988 100755
--- a/tests/misc-tests/023-device-usage-with-missing-device/test.sh
+++ b/tests/misc-tests/023-device-usage-with-missing-device/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # check if 'device slack' is reported as zero when a device is missing
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs-image
 check_prereq mkfs.btrfs
diff --git a/tests/misc-tests/024-inspect-internal-rootid/test.sh b/tests/misc-tests/024-inspect-internal-rootid/test.sh
index 40e382bb..84de9174 100755
--- a/tests/misc-tests/024-inspect-internal-rootid/test.sh
+++ b/tests/misc-tests/024-inspect-internal-rootid/test.sh
@@ -2,7 +2,7 @@
 #
 # test commands of inspect-internal rootid
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/025-zstd-compression/test.sh b/tests/misc-tests/025-zstd-compression/test.sh
index e95dcb36..34b942cd 100755
--- a/tests/misc-tests/025-zstd-compression/test.sh
+++ b/tests/misc-tests/025-zstd-compression/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Test zstd compression support on a prebuilt btrfs image
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq btrfs
 check_global_prereq md5sum
diff --git a/tests/misc-tests/026-image-non-printable-chars/test.sh b/tests/misc-tests/026-image-non-printable-chars/test.sh
index 8018586f..f7aac8cb 100755
--- a/tests/misc-tests/026-image-non-printable-chars/test.sh
+++ b/tests/misc-tests/026-image-non-printable-chars/test.sh
@@ -2,7 +2,7 @@
 # check that sanitized names with matching crc do not contain unprintable
 # characters, namely 0x7f
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh b/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
index ee41d71f..262ca43f 100755
--- a/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
+++ b/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # check that the toplevel subvolume is not listed as regular or deleted
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/mkfs-tests.sh b/tests/mkfs-tests.sh
index c8ff8c83..a148138d 100755
--- a/tests/mkfs-tests.sh
+++ b/tests/mkfs-tests.sh
@@ -4,13 +4,18 @@
 
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
+TEST_TOP=$(readlink -f "$SCRIPT_DIR/../")
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+if ! [ -f "$TOP/btrfs" ];then
+	TOP=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
-RESULTS="$TOP/tests/mkfs-tests-results.txt"
-IMAGE="$TOP/tests/test.img"
+RESULTS="$TEST_TOP/tests/mkfs-tests-results.txt"
+IMAGE="$TEST_TOP/tests/test.img"
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
+export TEST_TOP
 export TOP
 export RESULTS
 export LANG
@@ -25,7 +30,7 @@ check_kernel_support
 
 # The tests are driven by their custom script called 'test.sh'
 
-for i in $(find "$TOP/tests/mkfs-tests" -maxdepth 1 -mindepth 1 -type d	\
+for i in $(find "$TEST_TOP/tests/mkfs-tests" -maxdepth 1 -mindepth 1 -type d	\
 	${TEST:+-name "$TEST"} | sort)
 do
 	echo "    [TEST/mkfs]   $(basename $i)"
@@ -40,5 +45,5 @@ do
 			_fail "test failed for case $(basename $i)"
 		fi
 	fi
-	cd "$TOP"
+	cd "$TEST_TOP"
 done
diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
index 854ee007..e84c1d0e 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -2,7 +2,7 @@
 # test various blockgroup profile combinations, use loop devices as block
 # devices
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh b/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
index 37846234..f38468fc 100755
--- a/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
+++ b/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
@@ -2,7 +2,7 @@
 #
 # Verify that we do not force mixed block groups on small volumes anymore
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 
diff --git a/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh b/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
index 074fc22e..34060e25 100755
--- a/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
+++ b/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
@@ -2,7 +2,7 @@
 #
 # Mixed mode needs equal sectorsize and nodesize
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 
diff --git a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
index 7038c8ea..1d7e384b 100755
--- a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
+++ b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # make sure that mkfs.btrfs --rootsize does not change size of the image
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 
@@ -16,7 +16,7 @@ test_mkfs_with_size() {
 	run_check truncate -s$size $TEST_DEV
 	imgsize=$(run_check_stdout stat --format=%s $TEST_DEV)
 	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
-		--rootdir $TOP/Documentation \
+		--rootdir $TEST_TOP/Documentation \
 		$TEST_DEV
 	tmp=$(run_check_stdout stat --format=%s $TEST_DEV)
 	if ! [ "$imgsize" = "$tmp" ]; then
diff --git a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
index 5bdf50e0..8fe2d3be 100755
--- a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
+++ b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # a long device name must pass the SSD test
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 
diff --git a/tests/mkfs-tests/006-partitioned-loopdev/test.sh b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
index 0c77e5cd..ec68f3a9 100755
--- a/tests/mkfs-tests/006-partitioned-loopdev/test.sh
+++ b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # recognize partitioned loop devices
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 if ! losetup --help | grep -q 'partscan'; then
 	_not_run "losetup --partscan not available"
diff --git a/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh b/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
index 3980414f..ef21a29b 100755
--- a/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
+++ b/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # iterate over nodesize and sectorsize combinations
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh b/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
index 955cd2b1..83c59902 100755
--- a/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
+++ b/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
@@ -4,7 +4,7 @@
 # only do mkfs and fsck check, no mounting as
 # sub/multi-pagesize is not supported yet
 
-source $TOP/tests/common
+source $TEST_TOP/tests/common
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
diff --git a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
index d327a0d9..1fcd3cf2 100755
--- a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
+++ b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
@@ -6,7 +6,7 @@
 #
 # Note: sock type is skipped in this test
 
-source "$TOP/tests/common"
+source "$TEST_TOP/tests/common"
 
 check_prereq mkfs.btrfs
 check_prereq btrfs
-- 
2.14.3



