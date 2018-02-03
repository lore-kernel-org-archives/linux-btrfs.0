Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51489 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752010AbeBCKyf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Feb 2018 05:54:35 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 2/3] btrfs-progs: Add EXEC represent path of executable file
Date: Sat, 3 Feb 2018 18:54:08 +0800
Message-ID: <1517655249-21410-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517655249-21410-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517655249-21410-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use EXEC instead of TOP to represent the path of excutable file.
EXEC is set to TOP by default, but when there is no excutable file
in TOP, use the path where btrfs is install as EXEC.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/cli-tests.sh                                 |  5 ++
 tests/cli-tests/001-btrfs/test.sh                  | 20 ++++----
 .../cli-tests/002-balance-full-no-filters/test.sh  | 10 ++--
 tests/cli-tests/003-fi-resize-args/test.sh         | 30 +++++------
 .../cli-tests/004-send-parent-multi-subvol/test.sh | 12 ++---
 tests/cli-tests/005-qgroup-show/test.sh            | 14 ++---
 tests/cli-tests/006-qgroup-show-sync/test.sh       | 14 ++---
 tests/cli-tests/007-check-force/test.sh            | 14 ++---
 .../008-subvolume-get-set-default/test.sh          | 20 ++++----
 tests/common                                       | 16 +++---
 tests/common.convert                               |  8 +--
 tests/convert-tests.sh                             |  5 ++
 .../004-ext2-backup-superblock-ranges/test.sh      | 10 ++--
 .../convert-tests/005-delete-all-rollback/test.sh  |  2 +-
 .../007-unsupported-block-sizes/test.sh            |  2 +-
 .../011-reiserfs-delete-all-rollback/test.sh       |  2 +-
 .../015-no-rollback-after-balance/test.sh          |  6 +--
 tests/fsck-tests.sh                                |  5 ++
 tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 12 ++---
 tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
 .../fsck-tests/019-non-skinny-false-alert/test.sh  |  2 +-
 tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
 .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
 tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
 tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
 tests/fsck-tests/024-clear-space-cache/test.sh     | 10 ++--
 tests/fsck-tests/025-file-extents/test.sh          | 14 ++---
 tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
 tests/fsck-tests/027-tree-reloc-tree/test.sh       |  2 +-
 .../028-unaligned-super-dev-sizes/test.sh          |  6 +--
 tests/fuzz-tests.sh                                |  5 ++
 .../fuzz-tests/001-simple-check-unmounted/test.sh  |  2 +-
 tests/fuzz-tests/002-simple-image/test.sh          |  2 +-
 tests/fuzz-tests/003-multi-check-unmounted/test.sh | 12 ++---
 tests/fuzz-tests/004-simple-dump-tree/test.sh      |  2 +-
 tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +-
 tests/fuzz-tests/006-simple-tree-stats/test.sh     |  2 +-
 tests/fuzz-tests/007-simple-super-recover/test.sh  |  2 +-
 tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  2 +-
 tests/fuzz-tests/009-simple-zero-log/test.sh       |  2 +-
 tests/misc-tests.sh                                |  5 ++
 tests/misc-tests/001-btrfstune-features/test.sh    | 10 ++--
 tests/misc-tests/002-uuid-rewrite/test.sh          | 20 ++++----
 tests/misc-tests/003-zero-log/test.sh              | 16 +++---
 tests/misc-tests/004-shrink-fs/test.sh             | 14 ++---
 .../005-convert-progress-thread-crash/test.sh      |  2 +-
 .../misc-tests/006-image-on-missing-device/test.sh | 10 ++--
 tests/misc-tests/007-subvolume-sync/test.sh        | 18 +++----
 tests/misc-tests/008-leaf-crossing-stripes/test.sh |  4 +-
 .../009-subvolume-sync-must-wait/test.sh           | 22 ++++----
 .../010-convert-delete-ext2-subvol/test.sh         | 10 ++--
 tests/misc-tests/011-delete-missing-device/test.sh | 18 +++----
 tests/misc-tests/012-find-root-no-result/test.sh   |  4 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh  | 20 ++++----
 tests/misc-tests/014-filesystem-label/test.sh      | 22 ++++----
 tests/misc-tests/015-dump-super-garbage/test.sh    | 18 +++----
 tests/misc-tests/016-send-clone-src/test.sh        | 12 ++---
 .../017-recv-stream-malformatted/test.sh           |  8 +--
 tests/misc-tests/018-recv-end-of-stream/test.sh    | 60 +++++++++++-----------
 .../019-receive-clones-on-mounted-subvol/test.sh   | 38 +++++++-------
 .../020-fix-superblock-corruption/test.sh          |  8 +--
 tests/misc-tests/021-image-multi-devices/test.sh   |  6 +--
 .../022-filesystem-du-on-empty-subvol/test.sh      | 12 ++---
 .../023-device-usage-with-missing-device/test.sh   | 10 ++--
 .../misc-tests/024-inspect-internal-rootid/test.sh | 24 ++++-----
 tests/misc-tests/025-zstd-compression/test.sh      |  6 +--
 .../026-image-non-printable-chars/test.sh          |  8 +--
 .../027-subvol-list-deleted-toplevel/test.sh       |  6 +--
 tests/mkfs-tests.sh                                |  5 ++
 tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++---
 .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
 .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
 tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  2 +-
 .../005-long-device-name-for-ssd/test.sh           |  4 +-
 tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  4 +-
 .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  6 +--
 .../008-sectorsize-nodesize-combination/test.sh    |  4 +-
 .../009-special-files-for-rootdir/test.sh          |  4 +-
 79 files changed, 390 insertions(+), 356 deletions(-)

diff --git a/tests/cli-tests.sh b/tests/cli-tests.sh
index 16d6afcf..bd77d646 100755
--- a/tests/cli-tests.sh
+++ b/tests/cli-tests.sh
@@ -5,6 +5,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+        EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/cli-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +20,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/cli-tests/001-btrfs/test.sh b/tests/cli-tests/001-btrfs/test.sh
index c680604b..11de0248 100755
--- a/tests/cli-tests/001-btrfs/test.sh
+++ b/tests/cli-tests/001-btrfs/test.sh
@@ -6,13 +6,13 @@ source "$TOP/tests/common"
 check_prereq btrfs
 
 # returns 1
-run_mayfail $TOP/btrfs || true
-run_check "$TOP/btrfs" version
-run_check "$TOP/btrfs" version --
-run_check "$TOP/btrfs" help
-run_check "$TOP/btrfs" help --
-run_check "$TOP/btrfs" help --full
-run_check "$TOP/btrfs" --help
-run_check "$TOP/btrfs" --help --full
-run_check "$TOP/btrfs" --version
-run_check "$TOP/btrfs" --version --help
+run_mayfail $EXEC/btrfs || true
+run_check "$EXEC/btrfs" version
+run_check "$EXEC/btrfs" version --
+run_check "$EXEC/btrfs" help
+run_check "$EXEC/btrfs" help --
+run_check "$EXEC/btrfs" help --full
+run_check "$EXEC/btrfs" --help
+run_check "$EXEC/btrfs" --help --full
+run_check "$EXEC/btrfs" --version
+run_check "$EXEC/btrfs" --version --help
diff --git a/tests/cli-tests/002-balance-full-no-filters/test.sh b/tests/cli-tests/002-balance-full-no-filters/test.sh
index 0475ea73..b65f8bc9 100755
--- a/tests/cli-tests/002-balance-full-no-filters/test.sh
+++ b/tests/cli-tests/002-balance-full-no-filters/test.sh
@@ -10,12 +10,12 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
-run_check $SUDO_HELPER "$TOP/btrfs" balance start --full-balance "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" balance start "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" balance --full-balance "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" balance "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" balance start --full-balance "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" balance start "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" balance --full-balance "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" balance "$TEST_MNT"
 
 run_check_umount_test_dev
diff --git a/tests/cli-tests/003-fi-resize-args/test.sh b/tests/cli-tests/003-fi-resize-args/test.sh
index e4f262b6..07e66e92 100755
--- a/tests/cli-tests/003-fi-resize-args/test.sh
+++ b/tests/cli-tests/003-fi-resize-args/test.sh
@@ -10,37 +10,37 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev 2g
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 # missing the one of the required arguments
 for sep in '' '--'; do
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep "$TEST_MNT" |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep "$TEST_MNT" |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep -128M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep -128M |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep +128M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep +128M |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep 512M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep 512M |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep 1:-128M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep 1:-128M |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep 1:512M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep 1:512M |
 		grep -q "btrfs filesystem resize: too few arguments"
-	run_check_stdout "$TOP/btrfs" filesystem resize $sep 1:+128M |
+	run_check_stdout "$EXEC/btrfs" filesystem resize $sep 1:+128M |
 		grep -q "btrfs filesystem resize: too few arguments"
 done
 
 # valid resize
 for sep in '' '--'; do
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep -128M "$TEST_MNT"
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep +128M "$TEST_MNT"
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep 512M "$TEST_MNT"
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep 1:-128M "$TEST_MNT"
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep 1:512M "$TEST_MNT"
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem resize $sep 1:+128M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep -128M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep +128M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep 512M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep 1:-128M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep 1:512M "$TEST_MNT"
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem resize $sep 1:+128M "$TEST_MNT"
 done
 
 run_check_umount_test_dev
diff --git a/tests/cli-tests/004-send-parent-multi-subvol/test.sh b/tests/cli-tests/004-send-parent-multi-subvol/test.sh
index c1348b50..88e0b2e4 100755
--- a/tests/cli-tests/004-send-parent-multi-subvol/test.sh
+++ b/tests/cli-tests/004-send-parent-multi-subvol/test.sh
@@ -10,23 +10,23 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 here=`pwd`
 cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create subv-parent
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create subv-parent
 run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r subv-parent subv-snap1
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r subv-parent subv-snap1
 run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r subv-parent subv-snap2
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r subv-parent subv-snap2
 run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r subv-parent subv-snap3
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r subv-parent subv-snap3
 
 run_check truncate -s0 "$here"/send.stream
 run_check chmod a+w "$here"/send.stream
-run_check $SUDO_HELPER "$TOP/btrfs" send -f "$here"/send.stream -p subv-snap1 subv-snap2 subv-snap3
+run_check $SUDO_HELPER "$EXEC/btrfs" send -f "$here"/send.stream -p subv-snap1 subv-snap2 subv-snap3
 
 cd "$here" || _fail "cannot chdir back to test directory"
 rm send.stream
diff --git a/tests/cli-tests/005-qgroup-show/test.sh b/tests/cli-tests/005-qgroup-show/test.sh
index d9a91831..ae7c0220 100755
--- a/tests/cli-tests/005-qgroup-show/test.sh
+++ b/tests/cli-tests/005-qgroup-show/test.sh
@@ -10,12 +10,12 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
-run_mayfail "$TOP/btrfs" qgroup show "$TEST_MNT"
-run_mayfail $SUDO_HELPER "$TOP/btrfs" qgroup show "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" quota enable "$TEST_MNT"
-run_mayfail "$TOP/btrfs" qgroup show "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" qgroup show "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" quota disable "$TEST_MNT"
+run_mayfail "$EXEC/btrfs" qgroup show "$TEST_MNT"
+run_mayfail $SUDO_HELPER "$EXEC/btrfs" qgroup show "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" quota enable "$TEST_MNT"
+run_mayfail "$EXEC/btrfs" qgroup show "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" qgroup show "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" quota disable "$TEST_MNT"
 run_check_umount_test_dev
diff --git a/tests/cli-tests/006-qgroup-show-sync/test.sh b/tests/cli-tests/006-qgroup-show-sync/test.sh
index d552b8b9..571d0e56 100755
--- a/tests/cli-tests/006-qgroup-show-sync/test.sh
+++ b/tests/cli-tests/006-qgroup-show-sync/test.sh
@@ -10,21 +10,21 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev 1g
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/Sub"
-run_check $SUDO_HELPER "$TOP/btrfs" quota enable "$TEST_MNT/Sub"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/Sub"
+run_check $SUDO_HELPER "$EXEC/btrfs" quota enable "$TEST_MNT/Sub"
 
 for opt in '' '--' '--sync'; do
-	run_check $SUDO_HELPER "$TOP/btrfs" qgroup limit 300M "$TEST_MNT/Sub"
+	run_check $SUDO_HELPER "$EXEC/btrfs" qgroup limit 300M "$TEST_MNT/Sub"
 	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/Sub/file" bs=1M count=200
 
-	run_check $SUDO_HELPER "$TOP/btrfs" qgroup show -re $opt "$TEST_MNT/Sub"
+	run_check $SUDO_HELPER "$EXEC/btrfs" qgroup show -re $opt "$TEST_MNT/Sub"
 
-	run_check $SUDO_HELPER "$TOP/btrfs" qgroup limit none "$TEST_MNT/Sub"
+	run_check $SUDO_HELPER "$EXEC/btrfs" qgroup limit none "$TEST_MNT/Sub"
 	run_check $SUDO_HELPER rm -f "$TEST_MNT/Sub/file"
-	run_check "$TOP/btrfs" filesystem sync "$TEST_MNT/Sub"
+	run_check "$EXEC/btrfs" filesystem sync "$TEST_MNT/Sub"
 done
 
 run_check_umount_test_dev
diff --git a/tests/cli-tests/007-check-force/test.sh b/tests/cli-tests/007-check-force/test.sh
index 12b30205..9d80f435 100755
--- a/tests/cli-tests/007-check-force/test.sh
+++ b/tests/cli-tests/007-check-force/test.sh
@@ -16,17 +16,17 @@ setup_loopdevs 1
 prepare_loopdevs
 TEST_DEV=${loopdevs[1]}
 
-run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 run_mustfail "checking mounted filesystem without --force" \
-	$SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
-run_check $SUDO_HELPER "$TOP/btrfs" check --force "$TEST_DEV"
+	$SUDO_HELPER "$EXEC/btrfs" check "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/btrfs" check --force "$TEST_DEV"
 run_mustfail "checking mounted filesystem with --force --repair" \
-	$SUDO_HELPER "$TOP/btrfs" check --force --repair "$TEST_DEV"
+	$SUDO_HELPER "$EXEC/btrfs" check --force --repair "$TEST_DEV"
 run_check_umount_test_dev
-run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
-run_check $SUDO_HELPER "$TOP/btrfs" check --force "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/btrfs" check "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/btrfs" check --force "$TEST_DEV"
 run_mustfail "--force --repair on unmounted filesystem" \
-	$SUDO_HELPER "$TOP/btrfs" check --force --repair "$TEST_DEV"
+	$SUDO_HELPER "$EXEC/btrfs" check --force --repair "$TEST_DEV"
 
 cleanup_loopdevs
diff --git a/tests/cli-tests/008-subvolume-get-set-default/test.sh b/tests/cli-tests/008-subvolume-get-set-default/test.sh
index 9318002e..c0929691 100755
--- a/tests/cli-tests/008-subvolume-get-set-default/test.sh
+++ b/tests/cli-tests/008-subvolume-get-set-default/test.sh
@@ -3,7 +3,7 @@
 
 check_default_id()
 {
-	id=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" subvolume get-default .) \
+	id=$(run_check_stdout $SUDO_HELPER "$EXEC/btrfs" subvolume get-default .) \
 		|| { echo "$id"; exit 1; }
 	if $(echo "$id" | grep -vq "ID $1"); then
 		_fail "subvolume get-default: default id is not $1, but $id"
@@ -18,30 +18,30 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 cd "$TEST_MNT"
 
 check_default_id 5
 
 # check "subvol set-default <subvolid> <path>"
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub
-id=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub)
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume set-default "$id" .
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create sub
+id=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid sub)
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume set-default "$id" .
 check_default_id "$id"
 
 run_mustfail "set-default to non existent id" \
-	$SUDO_HELPER "$TOP/btrfs" subvolume set-default 100 .
+	$SUDO_HELPER "$EXEC/btrfs" subvolume set-default 100 .
 
 # check "subvol set-default <subvolume>"
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2
-id=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub2)
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume set-default ./sub2
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create sub2
+id=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid sub2)
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume set-default ./sub2
 check_default_id "$id"
 
 run_check $SUDO_HELPER mkdir sub2/dir
 run_mustfail "set-default to normal directory" \
-	$SUDO_HELPER "$TOP/btrfs" subvolume set-default ./sub2/dir
+	$SUDO_HELPER "$EXEC/btrfs" subvolume set-default ./sub2/dir
 
 cd ..
 run_check_umount_test_dev
diff --git a/tests/common b/tests/common
index 734cd171..a8bbd798 100644
--- a/tests/common
+++ b/tests/common
@@ -290,8 +290,12 @@ run_mustfail_stdout()
 
 check_prereq()
 {
-	if ! [ -f "$TOP/$1" ]; then
-		_fail "Failed prerequisites: $1";
+	if [ "$1" = "btrfs-corrupt-block" -o "$1" = "fssum" ]; then
+		if ! [ -f "$TOP/$1" ]; then
+			_fail "Failed prerequisites: $TOP/$1";
+		fi
+	elif ! [ -f "$EXEC/$1" ]; then
+		_fail "Failed prerequisites: $EXEC/$1";
 	fi
 }
 
@@ -309,11 +313,11 @@ check_image()
 
 	image=$1
 	echo "testing image $(basename $image)" >> "$RESULTS"
-	"$TOP/btrfs" check "$image" >> "$RESULTS" 2>&1
+	"$EXEC/btrfs" check "$image" >> "$RESULTS" 2>&1
 	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
 
-	run_check "$TOP/btrfs" check --repair "$image"
-	run_check "$TOP/btrfs" check "$image"
+	run_check "$EXEC/btrfs" check --repair "$image"
+	run_check "$EXEC/btrfs" check "$image"
 }
 
 # Extract a usable image from packed formats
@@ -358,7 +362,7 @@ extract_image()
 
 	if ! [ -f "$image.restored" ]; then
 		echo "restoring image $(basename $image)" >> "$RESULTS"
-		"$TOP/btrfs-image" -r "$image" "$image.restored" \
+		"$EXEC/btrfs-image" -r "$image" "$image.restored" \
 			&>> "$RESULTS" \
 			|| _fail "failed to restore image $image" >&2
 	fi
diff --git a/tests/common.convert b/tests/common.convert
index 1be804cf..bc74ff8d 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -139,9 +139,9 @@ convert_test_acl() {
 # $1: features, argument of -O, can be empty
 # $2: nodesize, argument of -N, can be empty
 convert_test_do_convert() {
-	run_check "$TOP/btrfs-convert" ${1:+-O "$1"} ${2:+-N "$2"} "$TEST_DEV"
-	run_check "$TOP/btrfs" check "$TEST_DEV"
-	run_check "$TOP/btrfs" inspect-internal dump-super -Ffa "$TEST_DEV"
+	run_check "$EXEC/btrfs-convert" ${1:+-O "$1"} ${2:+-N "$2"} "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs" inspect-internal dump-super -Ffa "$TEST_DEV"
 }
 
 # post conversion check, verify file permissions.
@@ -222,7 +222,7 @@ convert_test_post_checks_all() {
 convert_test_post_rollback() {
 	local types
 
-	run_check "$TOP/btrfs-convert" --rollback "$TEST_DEV"
+	run_check "$EXEC/btrfs-convert" --rollback "$TEST_DEV"
 	if [ -z "$1" ]; then
 		_fail "missing filesystem type to check"
 	fi
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 2a92a58b..fe1efb95 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -6,6 +6,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+        EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/convert-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -18,6 +22,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
index cf354d40..36f2a85e 100755
--- a/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
+++ b/tests/convert-tests/004-ext2-backup-superblock-ranges/test.sh
@@ -24,16 +24,16 @@ prepare_test_dev
 function check_image() {
 	TEST_DEV="$1"
 	run_check e2fsck -n -f "$TEST_DEV"
-	run_check "$TOP/btrfs-convert" "$TEST_DEV"
-	run_check "$TOP/btrfs" check "$TEST_DEV"
-	run_check "$TOP/btrfs" inspect-internal dump-super "$TEST_DEV"
+	run_check "$EXEC/btrfs-convert" "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs" inspect-internal dump-super "$TEST_DEV"
 
 	run_check_mount_test_dev
 	run_check $SUDO_HELPER e2fsck -n -f "$TEST_MNT/ext2_saved/image"
 	run_check $SUDO_HELPER umount "$TEST_MNT"
 
-	run_check "$TOP/btrfs" check "$TEST_DEV"
-	run_check "$TOP/btrfs-convert" -r "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs-convert" -r "$TEST_DEV"
 	run_check e2fsck -n -f "$TEST_DEV"
 
 	rm -f "$TEST_DEV"
diff --git a/tests/convert-tests/005-delete-all-rollback/test.sh b/tests/convert-tests/005-delete-all-rollback/test.sh
index 31fa2c4b..94fc3652 100755
--- a/tests/convert-tests/005-delete-all-rollback/test.sh
+++ b/tests/convert-tests/005-delete-all-rollback/test.sh
@@ -44,7 +44,7 @@ do_test() {
 	# ext2_saved/image must not be deleted
 	run_mayfail $SUDO_HELPER find "$TEST_MNT"/ -mindepth 1 -path '*ext2_saved' -prune -o -exec rm -vrf "{}" \;
 	cd "$here"
-	run_check "$TOP/btrfs" filesystem sync "$TEST_MNT"
+	run_check "$EXEC/btrfs" filesystem sync "$TEST_MNT"
 	run_check_umount_test_dev
 	convert_test_post_rollback ext4
 
diff --git a/tests/convert-tests/007-unsupported-block-sizes/test.sh b/tests/convert-tests/007-unsupported-block-sizes/test.sh
index ef010202..2f5f2c1f 100755
--- a/tests/convert-tests/007-unsupported-block-sizes/test.sh
+++ b/tests/convert-tests/007-unsupported-block-sizes/test.sh
@@ -18,5 +18,5 @@ for bs in 1024 2048; do
 		count=1 seek=1024 > /dev/null 2>&1
 
 	run_check_umount_test_dev
-	run_mustfail "$bs block converted" "$TOP/btrfs-convert" "$TEST_DEV"
+	run_mustfail "$bs block converted" "$EXEC/btrfs-convert" "$TEST_DEV"
 done
diff --git a/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
index 0b8366c8..59822f6a 100755
--- a/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
+++ b/tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh
@@ -47,7 +47,7 @@ do_test() {
 	# reiserfs_saved/image must not be deleted
 	run_mayfail $SUDO_HELPER find "$TEST_MNT"/ -mindepth 1 -path '*reiserfs_saved' -prune -o -exec rm -vrf "{}" \;
 	cd "$here"
-	run_check "$TOP/btrfs" filesystem sync "$TEST_MNT"
+	run_check "$EXEC/btrfs" filesystem sync "$TEST_MNT"
 	run_check_umount_test_dev
 	convert_test_post_rollback reiserfs
 
diff --git a/tests/convert-tests/015-no-rollback-after-balance/test.sh b/tests/convert-tests/015-no-rollback-after-balance/test.sh
index 47c9c6fa..862cf582 100755
--- a/tests/convert-tests/015-no-rollback-after-balance/test.sh
+++ b/tests/convert-tests/015-no-rollback-after-balance/test.sh
@@ -19,14 +19,14 @@ convert_test_do_convert "" 4096
 run_check_mount_test_dev
 
 # Now the fs is converted, balance it so later rollback should fail
-run_check $SUDO_HELPER "$TOP/btrfs" balance start --full-balance "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" balance start --full-balance "$TEST_MNT"
 run_check_umount_test_dev
 
 # rollback should fail
-run_mustfail "rollback fs after balance" "$TOP/btrfs-convert" -r "$TEST_DEV"
+run_mustfail "rollback fs after balance" "$EXEC/btrfs-convert" -r "$TEST_DEV"
 
 # Ensure the fs and convert image can pass the check
-run_check "$TOP/btrfs" check "$TEST_DEV"
+run_check "$EXEC/btrfs" check "$TEST_DEV"
 
 run_check_mount_test_dev
 run_check $SUDO_HELPER e2fsck -fn "$TEST_MNT/ext2_saved/image"
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 15d26c70..bb0c6d15 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -5,6 +5,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+        EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/fsck-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +20,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index fc10a4ff..ea0cc839 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -40,7 +40,7 @@ generate_leaf_corrupt_no_data_ext()
 	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> "$RESULTS"
 	tar --no-same-owner -xJf ./no_data_extent.tar.xz || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
-	"$TOP/btrfs-image" -r test.img.btrfs-image "$dest" || \
+	"$EXEC/btrfs-image" -r test.img.btrfs-image "$dest" || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
 
 	# leaf at 4206592 and 20905984 contains no regular data
diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index d71c1b2e..178eb2b3 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -12,19 +12,19 @@ prepare_test_dev
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
 {
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 
 	run_check_mount_test_dev
 	generate_dataset small
 
 	for i in `seq 1 100`;do
-		run_check $SUDO_HELPER "$TOP/btrfs" sub snapshot "$TEST_MNT" \
+		run_check $SUDO_HELPER "$EXEC/btrfs" sub snapshot "$TEST_MNT" \
 			"$TEST_MNT/snapaaaaaaa_$i"
 	done
 	run_check_umount_test_dev
 
 	# get extent root bytenr
-	extent_root_bytenr=`$SUDO_HELPER "$TOP/btrfs" inspect-internal dump-tree -r "$TEST_DEV" | \
+	extent_root_bytenr=`$SUDO_HELPER "$EXEC/btrfs" inspect-internal dump-tree -r "$TEST_DEV" | \
 			    grep extent | awk '{print $7}'`
 	if [ -z "$extent_root_bytenr" ];then
 		_fail "fail to get extent root bytenr"
@@ -34,10 +34,10 @@ test_extent_tree_rebuild()
 	run_check $SUDO_HELPER "$TOP/btrfs-corrupt-block" -l "$extent_root_bytenr" \
 		-b 4096 "$TEST_DEV"
 
-	$SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV" >& /dev/null && \
+	$SUDO_HELPER "$EXEC/btrfs" check "$TEST_DEV" >& /dev/null && \
 			_fail "btrfs check should detect failure"
-	run_check $SUDO_HELPER "$TOP/btrfs" check --repair --init-extent-tree "$TEST_DEV"
-	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/btrfs" check --repair --init-extent-tree "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/btrfs" check "$TEST_DEV"
 }
 
 test_extent_tree_rebuild
diff --git a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
index 29eb20b5..395d0c23 100755
--- a/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
+++ b/tests/fsck-tests/018-leaf-crossing-stripes/test.sh
@@ -5,7 +5,7 @@ source "$TOP/tests/common"
 check_prereq btrfs
 
 image=$(extract_image "./default_case.raw.xz")
-run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
+run_check_stdout "$EXEC/btrfs" check "$image" 2>&1 |
 	grep -q "crossing stripe boundary" ||
 	_fail "no expected error message in the output"
 
diff --git a/tests/fsck-tests/019-non-skinny-false-alert/test.sh b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
index 550f2947..bed1290d 100755
--- a/tests/fsck-tests/019-non-skinny-false-alert/test.sh
+++ b/tests/fsck-tests/019-non-skinny-false-alert/test.sh
@@ -16,7 +16,7 @@ source "$TOP/tests/common"
 check_prereq btrfs
 
 image=$(extract_image "./default_case.img.xz")
-run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
+run_check_stdout "$EXEC/btrfs" check "$image" 2>&1 |
 	grep -q "type mismatch with chunk" &&
 	_fail "unexpected error message in the output"
 
diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index 0c4f7848..dc04b950 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -23,7 +23,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_check "$TOP/btrfs" check "$image"
+	run_check "$EXEC/btrfs" check "$image"
 }
 
 check_all_images
diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
index 5d997e24..81b22cb3 100755
--- a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
+++ b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
@@ -11,7 +11,7 @@ check_image()
 	local image
 
 	image=$1
-	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 |
+	run_check_stdout "$EXEC/btrfs" check "$image" 2>&1 |
 		grep -q "Errors found in extent allocation tree or chunk allocation"
 	if [ $? -eq 0 ]; then
 		rm -f "$image"
diff --git a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
index dcdc1b42..07d4d6f2 100755
--- a/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
+++ b/tests/fsck-tests/022-qgroup-rescan-halfway/test.sh
@@ -9,7 +9,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_check_stdout "$TOP/btrfs" check "$image" 2>&1 | \
+	run_check_stdout "$EXEC/btrfs" check "$image" 2>&1 | \
 		grep -q "Counts for qgroup id"
 	if [ $? -eq 0 ]; then
 		_fail "Btrfs check doesn't detect rescan correctly"
diff --git a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
index ebb07f36..77e521d8 100755
--- a/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
+++ b/tests/fsck-tests/023-qgroup-stack-overflow/test.sh
@@ -11,7 +11,7 @@ check_prereq btrfs
 
 check_image()
 {
-	run_check "$TOP/btrfs" check "$1"
+	run_check "$EXEC/btrfs" check "$1"
 }
 
 check_all_images
diff --git a/tests/fsck-tests/024-clear-space-cache/test.sh b/tests/fsck-tests/024-clear-space-cache/test.sh
index 76ebcb6b..c84eebc7 100755
--- a/tests/fsck-tests/024-clear-space-cache/test.sh
+++ b/tests/fsck-tests/024-clear-space-cache/test.sh
@@ -9,7 +9,7 @@ check_prereq mkfs.btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 # Create files that takes at least 3 data chunks, while
@@ -31,17 +31,17 @@ sync
 run_check_umount_test_dev
 
 # Clear space cache and re-check fs
-run_check "$TOP/btrfs" check --clear-space-cache v1 "$TEST_DEV"
-run_check "$TOP/btrfs" check "$TEST_DEV"
+run_check "$EXEC/btrfs" check --clear-space-cache v1 "$TEST_DEV"
+run_check "$EXEC/btrfs" check "$TEST_DEV"
 
 # Manually recheck space cache and super space cache generation
-run_check_stdout "$TOP/btrfs" inspect-internal dump-tree -t root "$TEST_DEV" | \
+run_check_stdout "$EXEC/btrfs" inspect-internal dump-tree -t root "$TEST_DEV" | \
 	grep -q FREE_SPACE
 if [ $? -eq 0 ]; then
 	_fail "clear space cache doesn't clear all space cache"
 fi
 
-run_check_stdout $TOP/btrfs inspect-internal dump-super "$TEST_DEV" |
+run_check_stdout $EXEC/btrfs inspect-internal dump-super "$TEST_DEV" |
 	grep -q 'cache_generation.*18446744073709551615'
 if [ $? -ne 0 ]; then
 	_fail "clear space cache doesn't set cache_generation correctly"
diff --git a/tests/fsck-tests/025-file-extents/test.sh b/tests/fsck-tests/025-file-extents/test.sh
index ebe8a305..a3967a02 100755
--- a/tests/fsck-tests/025-file-extents/test.sh
+++ b/tests/fsck-tests/025-file-extents/test.sh
@@ -17,14 +17,14 @@ prepare_test_dev 128M
 # Lowmem mode can report missing csum due to wrong csum range
 test_paritical_write_into_prealloc()
 {
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 	run_check_mount_test_dev
 
 	run_check $SUDO_HELPER fallocate -l 128K "$TEST_MNT/file"
 	sync
 	run_check $SUDO_HELPER dd conv=notrunc if=/dev/zero of="$TEST_MNT/file" bs=1K count=64
 	run_check_umount_test_dev
-	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
 }
 
 # Inline compressed file extent
@@ -32,12 +32,12 @@ test_paritical_write_into_prealloc()
 # due to too restrict check on inline extent size
 test_compressed_inline_extent()
 {
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 	run_check_mount_test_dev -o compress=lzo,max_inline=2048
 
 	run_check $SUDO_HELPER dd conv=notrunc if=/dev/null of="$TEST_MNT/file" bs=1K count=1
 	run_check_umount_test_dev
-	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
 }
 
 # File extent hole with NO_HOLES incompat feature set.
@@ -46,13 +46,13 @@ test_compressed_inline_extent()
 # false alert
 test_hole_extent_with_no_holes_flag()
 {
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 	run_check_mount_test_dev
 
 	run_check $SUDO_HELPER truncate -s 16K "$TEST_MNT/tmp"
 	run_check_umount_test_dev
-	run_check $SUDO_HELPER "$TOP/btrfstune" -n "$TEST_DEV"
-	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/btrfstune" -n "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
 }
 
 test_paritical_write_into_prealloc
diff --git a/tests/fsck-tests/026-bad-dir-item-name/test.sh b/tests/fsck-tests/026-bad-dir-item-name/test.sh
index a1077a8d..9b1f774b 100755
--- a/tests/fsck-tests/026-bad-dir-item-name/test.sh
+++ b/tests/fsck-tests/026-bad-dir-item-name/test.sh
@@ -8,6 +8,6 @@ check_prereq btrfs
 
 image=$(extract_image "./default_case.img.xz")
 
-run_mustfail "dir_item hash mismatch not found" "$TOP/btrfs" check "$image"
+run_mustfail "dir_item hash mismatch not found" "$EXEC/btrfs" check "$image"
 
 rm -f "$image"
diff --git a/tests/fsck-tests/027-tree-reloc-tree/test.sh b/tests/fsck-tests/027-tree-reloc-tree/test.sh
index afad1e8d..86241a37 100755
--- a/tests/fsck-tests/027-tree-reloc-tree/test.sh
+++ b/tests/fsck-tests/027-tree-reloc-tree/test.sh
@@ -13,7 +13,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_check "$TOP/btrfs" check "$image"
+	run_check "$EXEC/btrfs" check "$image"
 }
 
 check_all_images
diff --git a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
index 6f315fae..0abc6b72 100755
--- a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
+++ b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
@@ -14,11 +14,11 @@ check_all_images
 image=$(extract_image "./dev_and_super_mismatch_unaligned.raw.xz")
 
 # detect and fix
-run_check "$TOP/btrfs" rescue fix-device-size "$image"
+run_check "$EXEC/btrfs" rescue fix-device-size "$image"
 # no problem found
-run_check "$TOP/btrfs" rescue fix-device-size "$image"
+run_check "$EXEC/btrfs" rescue fix-device-size "$image"
 # check if fix-device-size worked
-run_check "$TOP/btrfs" check "$image"
+run_check "$EXEC/btrfs" check "$image"
 # mount test
 run_check_mount_test_dev
 run_check_umount_test_dev
diff --git a/tests/fuzz-tests.sh b/tests/fuzz-tests.sh
index f72385e5..708b7f5f 100755
--- a/tests/fuzz-tests.sh
+++ b/tests/fuzz-tests.sh
@@ -5,6 +5,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+        EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/fuzz-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +20,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/fuzz-tests/001-simple-check-unmounted/test.sh b/tests/fuzz-tests/001-simple-check-unmounted/test.sh
index 98fe7b0c..a5bac06e 100755
--- a/tests/fuzz-tests/001-simple-check-unmounted/test.sh
+++ b/tests/fuzz-tests/001-simple-check-unmounted/test.sh
@@ -12,7 +12,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_mayfail $TOP/btrfs check "$image"
+	run_mayfail $EXEC/btrfs check "$image"
 }
 
 check_all_images $TOP/tests/fuzz-tests/images
diff --git a/tests/fuzz-tests/002-simple-image/test.sh b/tests/fuzz-tests/002-simple-image/test.sh
index 42470ecc..0c2e7084 100755
--- a/tests/fuzz-tests/002-simple-image/test.sh
+++ b/tests/fuzz-tests/002-simple-image/test.sh
@@ -13,7 +13,7 @@ check_image() {
 
 	image=$1
 	truncate -s0 target
-	run_mayfail $TOP/btrfs-image "$image" target
+	run_mayfail $EXEC/btrfs-image "$image" target
 	truncate -s0 target
 }
 
diff --git a/tests/fuzz-tests/003-multi-check-unmounted/test.sh b/tests/fuzz-tests/003-multi-check-unmounted/test.sh
index 9fd7b8aa..8bf5731f 100755
--- a/tests/fuzz-tests/003-multi-check-unmounted/test.sh
+++ b/tests/fuzz-tests/003-multi-check-unmounted/test.sh
@@ -13,12 +13,12 @@ check_image() {
 	local image
 
 	image=$1
-	run_mayfail $TOP/btrfs check -s 1 "$image"
-	run_mayfail $TOP/btrfs check --init-csum-tree "$image"
-	run_mayfail $TOP/btrfs check --init-extent-tree "$image"
-	run_mayfail $TOP/btrfs check --check-data-csum "$image"
-	run_mayfail $TOP/btrfs check --subvol-extents "$image"
-	run_mayfail $TOP/btrfs check --repair "$image"
+	run_mayfail $EXEC/btrfs check -s 1 "$image"
+	run_mayfail $EXEC/btrfs check --init-csum-tree "$image"
+	run_mayfail $EXEC/btrfs check --init-extent-tree "$image"
+	run_mayfail $EXEC/btrfs check --check-data-csum "$image"
+	run_mayfail $EXEC/btrfs check --subvol-extents "$image"
+	run_mayfail $EXEC/btrfs check --repair "$image"
 }
 
 check_all_images $TOP/tests/fuzz-tests/images
diff --git a/tests/fuzz-tests/004-simple-dump-tree/test.sh b/tests/fuzz-tests/004-simple-dump-tree/test.sh
index 89ff214c..09b4cb4d 100755
--- a/tests/fuzz-tests/004-simple-dump-tree/test.sh
+++ b/tests/fuzz-tests/004-simple-dump-tree/test.sh
@@ -10,7 +10,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_mayfail $TOP/btrfs inspect-internal dump-tree "$image"
+	run_mayfail $EXEC/btrfs inspect-internal dump-tree "$image"
 }
 
 check_all_images $TOP/tests/fuzz-tests/images
diff --git a/tests/fuzz-tests/005-simple-dump-super/test.sh b/tests/fuzz-tests/005-simple-dump-super/test.sh
index fbce3d9f..c47034a4 100755
--- a/tests/fuzz-tests/005-simple-dump-super/test.sh
+++ b/tests/fuzz-tests/005-simple-dump-super/test.sh
@@ -10,8 +10,8 @@ check_image() {
 	local image
 
 	image=$1
-	run_mayfail $TOP/btrfs inspect-internal dump-super "$image"
-	run_mayfail $TOP/btrfs inspect-internal dump-super -Ffa "$image"
+	run_mayfail $EXEC/btrfs inspect-internal dump-super "$image"
+	run_mayfail $EXEC/btrfs inspect-internal dump-super -Ffa "$image"
 }
 
 check_all_images $TOP/tests/fuzz-tests/images
diff --git a/tests/fuzz-tests/006-simple-tree-stats/test.sh b/tests/fuzz-tests/006-simple-tree-stats/test.sh
index c3410b06..d9cfe3be 100755
--- a/tests/fuzz-tests/006-simple-tree-stats/test.sh
+++ b/tests/fuzz-tests/006-simple-tree-stats/test.sh
@@ -10,7 +10,7 @@ check_image() {
 	local image
 
 	image=$1
-	run_mayfail $TOP/btrfs inspect-internal tree-stats "$image"
+	run_mayfail $EXEC/btrfs inspect-internal tree-stats "$image"
 }
 
 check_all_images $TOP/tests/fuzz-tests/images
diff --git a/tests/fuzz-tests/007-simple-super-recover/test.sh b/tests/fuzz-tests/007-simple-super-recover/test.sh
index 885cb352..db64a40f 100755
--- a/tests/fuzz-tests/007-simple-super-recover/test.sh
+++ b/tests/fuzz-tests/007-simple-super-recover/test.sh
@@ -11,7 +11,7 @@ check_image() {
 
 	image=$1
 	run_check cp "$image" "$image".scratch
-	run_mayfail $TOP/btrfs rescue super-recover -y -v "$image".scratch
+	run_mayfail $EXEC/btrfs rescue super-recover -y -v "$image".scratch
 	rm -- "$image".scratch
 }
 
diff --git a/tests/fuzz-tests/008-simple-chunk-recover/test.sh b/tests/fuzz-tests/008-simple-chunk-recover/test.sh
index d53453f6..069be218 100755
--- a/tests/fuzz-tests/008-simple-chunk-recover/test.sh
+++ b/tests/fuzz-tests/008-simple-chunk-recover/test.sh
@@ -11,7 +11,7 @@ check_image() {
 
 	image=$1
 	run_check cp "$image" "$image".scratch
-	run_mayfail $TOP/btrfs rescue chunk-recover -y -v "$image".scratch
+	run_mayfail $EXEC/btrfs rescue chunk-recover -y -v "$image".scratch
 	rm -- "$image".scratch
 }
 
diff --git a/tests/fuzz-tests/009-simple-zero-log/test.sh b/tests/fuzz-tests/009-simple-zero-log/test.sh
index 393db3f6..03e1b725 100755
--- a/tests/fuzz-tests/009-simple-zero-log/test.sh
+++ b/tests/fuzz-tests/009-simple-zero-log/test.sh
@@ -11,7 +11,7 @@ check_image() {
 
 	image=$1
 	run_check cp "$image" "$image".scratch
-	run_mayfail $TOP/btrfs rescue zero-log "$image".scratch
+	run_mayfail $EXEC/btrfs rescue zero-log "$image".scratch
 	rm -- "$image".scratch
 }
 
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 08988016..579b7b55 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -5,6 +5,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+        EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/misc-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +20,7 @@ export RESULTS
 export LANG
 export TEST_DEV
 export IMAGE
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/misc-tests/001-btrfstune-features/test.sh b/tests/misc-tests/001-btrfstune-features/test.sh
index bfa7f43e..d49a18f3 100755
--- a/tests/misc-tests/001-btrfstune-features/test.sh
+++ b/tests/misc-tests/001-btrfstune-features/test.sh
@@ -25,17 +25,17 @@ test_feature()
 	tuneopt="$2"
 	sbflag="$3"
 
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $mkfsfeatures $TEST_DEV
-	if run_check_stdout $TOP/btrfs inspect-internal dump-super $TEST_DEV | \
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f $mkfsfeatures $TEST_DEV
+	if run_check_stdout $EXEC/btrfs inspect-internal dump-super $TEST_DEV | \
 			grep -q "$sbflag"; then
 		_fail "FAIL: feature $sbflag must not be set on the base image"
 	fi
-	run_check $TOP/btrfstune $tuneopt $TEST_DEV
-	if ! run_check_stdout $TOP/btrfs inspect-internal dump-super $TEST_DEV | \
+	run_check $EXEC/btrfstune $tuneopt $TEST_DEV
+	if ! run_check_stdout $EXEC/btrfs inspect-internal dump-super $TEST_DEV | \
 			grep -q "$sbflag"; then
 		_fail "FAIL: feature $sbflag not set"
 	fi
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/btrfs check $TEST_DEV
 }
 
 test_feature extref -r EXTENDED_IREF
diff --git a/tests/misc-tests/002-uuid-rewrite/test.sh b/tests/misc-tests/002-uuid-rewrite/test.sh
index fd100fb3..158bda90 100755
--- a/tests/misc-tests/002-uuid-rewrite/test.sh
+++ b/tests/misc-tests/002-uuid-rewrite/test.sh
@@ -13,7 +13,7 @@ get_fs_uuid() {
 	local image
 
 	image="$1"
-	run_check_stdout $TOP/btrfs inspect-internal dump-super "$image" | \
+	run_check_stdout $EXEC/btrfs inspect-internal dump-super "$image" | \
 		grep '^fsid' | awk '{print $2}'
 }
 
@@ -23,18 +23,18 @@ test_uuid_random()
 
 	origuuid=11111111-a101-4031-b29a-379d4f8b7a2d
 
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--uuid $origuuid \
 		--rootdir $TOP/Documentation \
 		$TEST_DEV
-	run_check $TOP/btrfs inspect-internal dump-super "$TEST_DEV"
-	currentfsid=$(run_check_stdout $TOP/btrfstune -f -u $TEST_DEV | \
+	run_check $EXEC/btrfs inspect-internal dump-super "$TEST_DEV"
+	currentfsid=$(run_check_stdout $EXEC/btrfstune -f -u $TEST_DEV | \
 		grep -i 'current fsid:' | awk '{print $3}')
 	if ! [ $currentfsid = $origuuid ]; then
 		_fail "FAIL: current UUID mismatch"
 	fi
-	run_check $TOP/btrfs inspect-internal dump-super "$TEST_DEV"
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $EXEC/btrfs inspect-internal dump-super "$TEST_DEV"
+	run_check $SUDO_HELPER $EXEC/btrfs check $TEST_DEV
 }
 
 test_uuid_user()
@@ -45,19 +45,19 @@ test_uuid_user()
 	origuuid=22222222-d324-4f92-80e9-7658bf3b845f
 	newuuid=33333333-bfc9-4045-9399-a396dc6893b3
 
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--uuid $origuuid \
 		--rootdir $TOP/Documentation \
 		$TEST_DEV
-	run_check $TOP/btrfs inspect-internal dump-super "$TEST_DEV"
-	run_check $TOP/btrfstune -f -U $newuuid \
+	run_check $EXEC/btrfs inspect-internal dump-super "$TEST_DEV"
+	run_check $EXEC/btrfstune -f -U $newuuid \
 		$TEST_DEV
 	# btrfs inspect-internal dump-super is called within get_fs_uuid
 	fsid=$(get_fs_uuid $TEST_DEV)
 	if ! [ $fsid = $newuuid ]; then
 		_fail "FAIL: UUID not rewritten"
 	fi
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/btrfs check $TEST_DEV
 }
 
 test_uuid_random
diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/003-zero-log/test.sh
index e7c5c806..0f3d3cd6 100755
--- a/tests/misc-tests/003-zero-log/test.sh
+++ b/tests/misc-tests/003-zero-log/test.sh
@@ -12,28 +12,28 @@ get_log_root()
 	local image
 
 	image="$1"
-	$TOP/btrfs inspect-internal dump-super "$image" | \
+	$EXEC/btrfs inspect-internal dump-super "$image" | \
 		grep '^log_root\>' | awk '{print $2}'
 }
 get_log_root_level() {
 	local image
 
 	image="$1"
-	$TOP/btrfs inspect-internal dump-super "$image" | \
+	$EXEC/btrfs inspect-internal dump-super "$image" | \
 		grep '^log_root_level' | awk '{print $2}'
 }
 
 test_zero_log()
 {
 	# FIXME: we need an image with existing log_root
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--rootdir $TOP/Documentation \
 		$TEST_DEV
-	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
+	run_check $EXEC/btrfs inspect-internal dump-super $TEST_DEV
 	if [ "$1" = 'standalone' ]; then
-		run_check $TOP/btrfs rescue zero-log $TEST_DEV
+		run_check $EXEC/btrfs rescue zero-log $TEST_DEV
 	else
-		run_check $TOP/btrfs-zero-log $TEST_DEV
+		run_check $EXEC/btrfs-zero-log $TEST_DEV
 	fi
 	log_root=$(get_log_root $TEST_DEV)
 	log_root_level=$(get_log_root $TEST_DEV)
@@ -43,8 +43,8 @@ test_zero_log()
 	if [ "$log_root_level" != 0 ]; then
 		_fail "FAIL: log_root_level not reset"
 	fi
-	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $EXEC/btrfs inspect-internal dump-super $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/btrfs check $TEST_DEV
 }
 
 test_zero_log standalone
diff --git a/tests/misc-tests/004-shrink-fs/test.sh b/tests/misc-tests/004-shrink-fs/test.sh
index 88740358..c3bf7570 100755
--- a/tests/misc-tests/004-shrink-fs/test.sh
+++ b/tests/misc-tests/004-shrink-fs/test.sh
@@ -14,17 +14,17 @@ setup_root_helper
 # Optionally take id of the device to shrink
 shrink_test()
 {
-	min_size=$(run_check_stdout $SUDO_HELPER $TOP/btrfs inspect-internal min-dev-size ${1:+--id $1} $TEST_MNT)
+	min_size=$(run_check_stdout $SUDO_HELPER $EXEC/btrfs inspect-internal min-dev-size ${1:+--id $1} $TEST_MNT)
 	min_size=$(echo $min_size | cut -d ' ' -f 1)
 	echo "min size = ${min_size}" >> $RESULTS
 	if [ -z "$min_size" ]; then
 		_fail "Failed to parse minimum size"
 	fi
-	run_check $SUDO_HELPER $TOP/btrfs filesystem resize $min_size $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem resize $min_size $TEST_MNT
 }
 
 run_check truncate -s 20G $IMAGE
-run_check $TOP/mkfs.btrfs -f $IMAGE
+run_check $EXEC/mkfs.btrfs -f $IMAGE
 run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
 run_check $SUDO_HELPER chmod a+rw $TEST_MNT
 
@@ -35,7 +35,7 @@ done
 
 # Make sure they are persisted (all the chunk, device and block group items
 # added to the chunk/dev/extent trees).
-run_check $TOP/btrfs filesystem sync $TEST_MNT
+run_check $EXEC/btrfs filesystem sync $TEST_MNT
 
 # Now remove 3 of those 1G files. This will result in 3 block groups becoming
 # unused, which will be automatically deleted by the cleaner kthread, and this
@@ -50,9 +50,9 @@ run_check rm -f $TEST_MNT/foo6
 # groups - it could have been sleeping when they became unused. Then wait a bit
 # to allow the cleaner kthread to delete them and then finally ensure the
 # transaction started by the cleaner kthread is committed.
-run_check $TOP/btrfs filesystem sync $TEST_MNT
+run_check $EXEC/btrfs filesystem sync $TEST_MNT
 sleep 3
-run_check $TOP/btrfs filesystem sync $TEST_MNT
+run_check $EXEC/btrfs filesystem sync $TEST_MNT
 
 # Now attempt to get the minimum size we can resize the filesystem to and verify
 # the resize operation succeeds. This size closely matches the sum of the size
@@ -63,7 +63,7 @@ done
 
 # Now convert metadata and system chunks to the single profile and check we are
 # still able to get a correct minimum size and shrink to that size.
-run_check $SUDO_HELPER $TOP/btrfs balance start -mconvert=single \
+run_check $SUDO_HELPER $EXEC/btrfs balance start -mconvert=single \
 	-sconvert=single -f $TEST_MNT
 for ((i = 1; i <= 3; i++)); do
 	shrink_test 1
diff --git a/tests/misc-tests/005-convert-progress-thread-crash/test.sh b/tests/misc-tests/005-convert-progress-thread-crash/test.sh
index bc71e1fd..8ea4f04d 100755
--- a/tests/misc-tests/005-convert-progress-thread-crash/test.sh
+++ b/tests/misc-tests/005-convert-progress-thread-crash/test.sh
@@ -11,5 +11,5 @@ prepare_test_dev
 for ((i = 0; i < 20; i++)); do
 	echo "loop $i" >>$RESULTS
 	mkfs.ext4 -F "$TEST_DEV" &>>$RESULTS || _not_run "mkfs.ext4 failed"
-	run_check $TOP/btrfs-convert "$TEST_DEV"
+	run_check $EXEC/btrfs-convert "$TEST_DEV"
 done
diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
index 2766fb17..4e268378 100755
--- a/tests/misc-tests/006-image-on-missing-device/test.sh
+++ b/tests/misc-tests/006-image-on-missing-device/test.sh
@@ -14,14 +14,14 @@ setup_root_helper
 
 test_image_dump()
 {
-	run_check $SUDO_HELPER $TOP/btrfs check $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs check $dev1
 	# the output file will be deleted
-	run_mayfail $SUDO_HELPER $TOP/btrfs-image $dev1 /tmp/test-img.dump
+	run_mayfail $SUDO_HELPER $EXEC/btrfs-image $dev1 /tmp/test-img.dump
 }
 
 test_run()
 {
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f -d raid1 -m raid1 $dev1 $dev2
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f -d raid1 -m raid1 $dev1 $dev2
 
 	# we need extents to trigger reading from all devices
 	run_check $SUDO_HELPER mount $dev1 $TEST_MNT
@@ -30,13 +30,13 @@ test_run()
 	run_check $SUDO_HELPER umount $TEST_MNT
 
 	test_image_dump
-	run_check $SUDO_HELPER $TOP/btrfs filesystem show $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem show $dev1
 	# create a degraded raid1 filesystem, check must succeed
 	# btrfs-image must not loop
 	run_mayfail wipefs -a $dev2
 	run_check $SUDO_HELPER losetup -d $dev2
 	unset loopdevs[2]
-	run_check $SUDO_HELPER $TOP/btrfs filesystem show $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem show $dev1
 
 	test_image_dump
 }
diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
index 243bb8cc..9a5d5b2f 100755
--- a/tests/misc-tests/007-subvolume-sync/test.sh
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -12,21 +12,21 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
+run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f "$TEST_DEV"
 run_check_mount_test_dev
 
 # to check following thing in both 1 and multiple subvolume case:
 # 1: is subvolume sync loop indefinitely
 # 2: is return value right
 #
-run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol1
-run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol2
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol1
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol2
-run_check $SUDO_HELPER $TOP/btrfs subvolume sync "$TEST_MNT"
+run_check $SUDO_HELPER $EXEC/btrfs subvolume create "$TEST_MNT"/mysubvol1
+run_check $SUDO_HELPER $EXEC/btrfs subvolume create "$TEST_MNT"/mysubvol2
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete "$TEST_MNT"/mysubvol1
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete "$TEST_MNT"/mysubvol2
+run_check $SUDO_HELPER $EXEC/btrfs subvolume sync "$TEST_MNT"
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol
-run_check $SUDO_HELPER $TOP/btrfs subvolume sync "$TEST_MNT"
+run_check $SUDO_HELPER $EXEC/btrfs subvolume create "$TEST_MNT"/mysubvol
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete "$TEST_MNT"/mysubvol
+run_check $SUDO_HELPER $EXEC/btrfs subvolume sync "$TEST_MNT"
 
 run_check_umount_test_dev
diff --git a/tests/misc-tests/008-leaf-crossing-stripes/test.sh b/tests/misc-tests/008-leaf-crossing-stripes/test.sh
index 03818062..367a1e94 100755
--- a/tests/misc-tests/008-leaf-crossing-stripes/test.sh
+++ b/tests/misc-tests/008-leaf-crossing-stripes/test.sh
@@ -15,8 +15,8 @@ A_PRIME_NUM=17
 for ((size = SIZE_FROM; size <= SIZE_END; size += A_PRIME_NUM)); do
 	run_check truncate -s "$size"M "$IMAGE"
 	run_check mkfs.ext4 -F "$IMAGE"
-	run_check $TOP/btrfs-convert "$IMAGE"
-	run_check_stdout $TOP/btrfs check "$IMAGE" 2>&1 |
+	run_check $EXEC/btrfs-convert "$IMAGE"
+	run_check_stdout $EXEC/btrfs check "$IMAGE" 2>&1 |
 		grep -q "crossing stripe boundary" &&
 		_fail "leaf crossing stripes after btrfs-convert"
 done
diff --git a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
index fa3f09ab..a9787431 100755
--- a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
+++ b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
@@ -10,7 +10,7 @@ check_prereq btrfs
 setup_root_helper
 
 prepare_test_dev
-run_check $TOP/mkfs.btrfs -f "$TEST_DEV"
+run_check $EXEC/mkfs.btrfs -f "$TEST_DEV"
 run_check_mount_test_dev
 run_check $SUDO_HELPER chmod a+rw $TEST_MNT
 
@@ -21,30 +21,30 @@ for i in `seq 5`; do
 done
 
 for sn in `seq 4`;do
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot . snap$sn
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot . snap$sn
 	for i in `seq 10`; do
 		run_check dd if=/dev/zero of=snap$sn/file$i bs=1M count=10
 	done
 done
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume list .
-run_check $SUDO_HELPER $TOP/btrfs subvolume list -d .
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list .
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list -d .
 
-idtodel=`run_check_stdout $SUDO_HELPER $TOP/btrfs inspect-internal rootid snap3`
+idtodel=`run_check_stdout $SUDO_HELPER $EXEC/btrfs inspect-internal rootid snap3`
 
 # delete, sync after some time
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete -c snap3
-{ sleep 5; run_check $TOP/btrfs filesystem sync $TEST_MNT; } &
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete -c snap3
+{ sleep 5; run_check $EXEC/btrfs filesystem sync $TEST_MNT; } &
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume sync . $idtodel
+run_check $SUDO_HELPER $EXEC/btrfs subvolume sync . $idtodel
 
-if run_check_stdout $SUDO_HELPER $TOP/btrfs subvolume list -d . |
+if run_check_stdout $SUDO_HELPER $EXEC/btrfs subvolume list -d . |
 		grep -q "ID $idtodel.*DELETED"; then
 	_fail "sync did not wait for the subvolume cleanup"
 fi
 
-run_check $TOP/btrfs filesystem sync $TEST_MNT
-run_check $SUDO_HELPER $TOP/btrfs subvolume list -d .
+run_check $EXEC/btrfs filesystem sync $TEST_MNT
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list -d .
 
 wait
 cd ..
diff --git a/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh b/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
index 7915867c..23da247b 100755
--- a/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
+++ b/tests/misc-tests/010-convert-delete-ext2-subvol/test.sh
@@ -13,13 +13,13 @@ prepare_test_dev
 
 run_check truncate -s 2G "$TEST_DEV"
 run_check mkfs.ext4 -F "$TEST_DEV"
-run_check $TOP/btrfs-convert "$TEST_DEV"
-run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-tree "$TEST_DEV"
+run_check $EXEC/btrfs-convert "$TEST_DEV"
+run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-tree "$TEST_DEV"
 run_check_mount_test_dev
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete -c "$TEST_MNT/ext2_saved"
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete -c "$TEST_MNT/ext2_saved"
 run_check_umount_test_dev
-run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-tree "$TEST_DEV"
-run_check_stdout $TOP/btrfs-convert --rollback "$TEST_DEV" |
+run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-tree "$TEST_DEV"
+run_check_stdout $EXEC/btrfs-convert --rollback "$TEST_DEV" |
 	grep -q 'is it deleted' || _fail "unexpected rollback"
 
 exit 0
diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
index 8a1b14b1..bb6d703b 100755
--- a/tests/misc-tests/011-delete-missing-device/test.sh
+++ b/tests/misc-tests/011-delete-missing-device/test.sh
@@ -10,10 +10,10 @@ setup_root_helper
 
 test_do_mkfs()
 {
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $@ ${loopdevs[@]}
-	run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $dev1
-	run_check $SUDO_HELPER $TOP/btrfs check $dev1
-	run_check $SUDO_HELPER $TOP/btrfs filesystem show
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f $@ ${loopdevs[@]}
+	run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-super $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs check $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem show
 }
 
 test_wipefs()
@@ -22,19 +22,19 @@ test_wipefs()
 	run_check $SUDO_HELPER losetup -d $devtodel
 	unset loopdevs[3]
 	run_check $SUDO_HELPER losetup --all
-	run_check $TOP/btrfs filesystem show
+	run_check $EXEC/btrfs filesystem show
 }
 test_delete_missing()
 {
 	run_check_mount_test_dev -o degraded
-	run_check $SUDO_HELPER $TOP/btrfs filesystem show $TEST_MNT
-	run_check $SUDO_HELPER $TOP/btrfs device delete missing $TEST_MNT
-	run_check $SUDO_HELPER $TOP/btrfs filesystem show $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem show $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs device delete missing $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem show $TEST_MNT
 	run_check_umount_test_dev
 
 	run_check_mount_test_dev
 	local out
-	out="$(run_check_stdout $SUDO_HELPER $TOP/btrfs filesystem show $TEST_MNT)"
+	out="$(run_check_stdout $SUDO_HELPER $EXEC/btrfs filesystem show $TEST_MNT)"
 	if echo "$out" | grep -q -- "$devtodel"; then
 		_fail "device $devtodel not deleted"
 	fi
diff --git a/tests/misc-tests/012-find-root-no-result/test.sh b/tests/misc-tests/012-find-root-no-result/test.sh
index 983a8a1e..e3ed3bdd 100755
--- a/tests/misc-tests/012-find-root-no-result/test.sh
+++ b/tests/misc-tests/012-find-root-no-result/test.sh
@@ -8,10 +8,10 @@ source $TOP/tests/common
 check_prereq btrfs-find-root
 check_prereq btrfs-image
 
-run_check $TOP/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
+run_check $EXEC/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
 	_fail "failed to extract first_meta_chunk.btrfs-image"
 
-result=$(run_check_stdout $TOP/btrfs-find-root test.img | sed '/^Superblock/d')
+result=$(run_check_stdout $EXEC/btrfs-find-root test.img | sed '/^Superblock/d')
 
 if [ -z "$result" ]; then
 	_fail "btrfs-find-root failed to find tree root"
diff --git a/tests/misc-tests/013-subvolume-sync-crash/test.sh b/tests/misc-tests/013-subvolume-sync-crash/test.sh
index cd445961..34e0553d 100755
--- a/tests/misc-tests/013-subvolume-sync-crash/test.sh
+++ b/tests/misc-tests/013-subvolume-sync-crash/test.sh
@@ -11,7 +11,7 @@ check_prereq btrfs
 setup_root_helper
 
 prepare_test_dev
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 run_check $SUDO_HELPER chmod a+rw $TEST_MNT
 
@@ -23,25 +23,25 @@ done
 
 # 128 is minimum
 for sn in `seq 130`;do
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot . snap$sn
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot . snap$sn
 	for i in `seq 10`; do
 		run_check dd if=/dev/zero of=snap$sn/file$i bs=1M count=1
 	done
 done
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume list .
-run_check $SUDO_HELPER $TOP/btrfs subvolume list -d .
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list .
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list -d .
 
-idtodel=`run_check_stdout $SUDO_HELPER $TOP/btrfs inspect-internal rootid snap3`
+idtodel=`run_check_stdout $SUDO_HELPER $EXEC/btrfs inspect-internal rootid snap3`
 
 # delete, sync after some time
-run_check $SUDO_HELPER $TOP/btrfs subvolume delete -c snap*
-{ sleep 5; run_check $TOP/btrfs filesystem sync $TEST_MNT; } &
+run_check $SUDO_HELPER $EXEC/btrfs subvolume delete -c snap*
+{ sleep 5; run_check $EXEC/btrfs filesystem sync $TEST_MNT; } &
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume sync .
+run_check $SUDO_HELPER $EXEC/btrfs subvolume sync .
 
-run_check $TOP/btrfs filesystem sync $TEST_MNT
-run_check $SUDO_HELPER $TOP/btrfs subvolume list -d .
+run_check $EXEC/btrfs filesystem sync $TEST_MNT
+run_check $SUDO_HELPER $EXEC/btrfs subvolume list -d .
 
 wait
 cd ..
diff --git a/tests/misc-tests/014-filesystem-label/test.sh b/tests/misc-tests/014-filesystem-label/test.sh
index 753aa9ea..3b4746ab 100755
--- a/tests/misc-tests/014-filesystem-label/test.sh
+++ b/tests/misc-tests/014-filesystem-label/test.sh
@@ -10,16 +10,16 @@ check_prereq btrfs
 setup_root_helper
 
 prepare_test_dev
-run_check "$TOP/mkfs.btrfs" -L BTRFS-TEST-LABEL -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -L BTRFS-TEST-LABEL -f "$TEST_DEV"
 run_check_mount_test_dev
 run_check $SUDO_HELPER chmod a+rw $TEST_MNT
 
 cd $TEST_MNT
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT
 # shortest label
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT a
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT ''
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT a
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT ''
 
 longlabel=\
 0123456789\
@@ -54,15 +54,15 @@ longlabel=\
 \
 01234
 
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT "$longlabel"
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT "$longlabel"
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT
 # 256, must fail
 run_mustfail "label 256 bytes long succeeded" \
-	$SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT "$longlabel"5
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT
+	$SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT "$longlabel"5
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT
 run_mustfail "label 2 * 255 bytes long succeeded" \
-	$SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT "$longlabel$longlabel"
-run_check $SUDO_HELPER $TOP/btrfs filesystem label $TEST_MNT
+	$SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT "$longlabel$longlabel"
+run_check $SUDO_HELPER $EXEC/btrfs filesystem label $TEST_MNT
 
 cd ..
 
diff --git a/tests/misc-tests/015-dump-super-garbage/test.sh b/tests/misc-tests/015-dump-super-garbage/test.sh
index 33fc8332..5bfa5fa6 100755
--- a/tests/misc-tests/015-dump-super-garbage/test.sh
+++ b/tests/misc-tests/015-dump-super-garbage/test.sh
@@ -6,12 +6,12 @@ source $TOP/tests/common
 
 check_prereq btrfs
 
-run_check $TOP/btrfs inspect-internal dump-super /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -a /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -fa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
-run_check $TOP/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -a /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -fa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
+run_check $EXEC/btrfs inspect-internal dump-super -Ffa /dev/urandom
diff --git a/tests/misc-tests/016-send-clone-src/test.sh b/tests/misc-tests/016-send-clone-src/test.sh
index 2780ebbd..3b3912cd 100755
--- a/tests/misc-tests/016-send-clone-src/test.sh
+++ b/tests/misc-tests/016-send-clone-src/test.sh
@@ -11,27 +11,27 @@ check_prereq btrfs
 setup_root_helper
 
 prepare_test_dev
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 here=`pwd`
 cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume create subv-parent1
+run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv-parent1
 for i in 1 2 3; do
 	run_check $SUDO_HELPER dd if=/dev/zero of=subv-parent1/file1_$i bs=1M count=1
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv-parent1 subv-snap1_$i
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv-parent1 subv-snap1_$i
 done
 
-run_check $SUDO_HELPER $TOP/btrfs subvolume create subv-parent2
+run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv-parent2
 for i in 1 2 3; do
 	run_check $SUDO_HELPER dd if=/dev/zero of=subv-parent2/file2_$i bs=1M count=1
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv-parent2 subv-snap2_$i
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv-parent2 subv-snap2_$i
 done
 
 truncate -s0 "$here"/send-stream.img
 chmod a+w "$here"/send-stream.img
-run_check $SUDO_HELPER $TOP/btrfs send -f "$here"/send-stream.img \
+run_check $SUDO_HELPER $EXEC/btrfs send -f "$here"/send-stream.img \
 	-c subv-snap1_1 -c subv-snap2_1 subv-snap1_[23] subv-snap2_[23]
 
 image=$(extract_image "$here"/multi-clone-src-v4.8.2.stream.xz)
diff --git a/tests/misc-tests/017-recv-stream-malformatted/test.sh b/tests/misc-tests/017-recv-stream-malformatted/test.sh
index d199a72e..e125a377 100755
--- a/tests/misc-tests/017-recv-stream-malformatted/test.sh
+++ b/tests/misc-tests/017-recv-stream-malformatted/test.sh
@@ -10,16 +10,16 @@ check_prereq btrfs
 setup_root_helper
 
 prepare_test_dev
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
-echo -n '' | run_mayfail $SUDO_HELPER "$TOP/btrfs" receive "$TEST_MNT" &&
+echo -n '' | run_mayfail $SUDO_HELPER "$EXEC/btrfs" receive "$TEST_MNT" &&
 	_fail "unexpected: received empty stream"
 
-echo -n '1' | run_mayfail $SUDO_HELPER "$TOP/btrfs" receive "$TEST_MNT" &&
+echo -n '1' | run_mayfail $SUDO_HELPER "$EXEC/btrfs" receive "$TEST_MNT" &&
 	_fail "unexpected: received stream with shrot and corrupted header"
 
-echo -n '12345678901234567' | run_mayfail $SUDO_HELPER "$TOP/btrfs" receive "$TEST_MNT" &&
+echo -n '12345678901234567' | run_mayfail $SUDO_HELPER "$EXEC/btrfs" receive "$TEST_MNT" &&
 	_fail "unexpected: received stream with corrupted header"
 
 run_check_umount_test_dev
diff --git a/tests/misc-tests/018-recv-end-of-stream/test.sh b/tests/misc-tests/018-recv-end-of-stream/test.sh
index 9ca035f7..4742fcd2 100755
--- a/tests/misc-tests/018-recv-end-of-stream/test.sh
+++ b/tests/misc-tests/018-recv-end-of-stream/test.sh
@@ -19,24 +19,24 @@ test_full_empty_stream() {
 	local str
 
 	str="$here/stream-full-empty.stream"
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
 
 	cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume create subv1
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv1
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv1-snap
 
 	truncate -s0 "$str"
 	chmod a+w "$str"
-	run_check $SUDO_HELPER $TOP/btrfs send -f "$str" subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -f "$str" subv1-snap
 
 	cd "$here" || _fail "cannot chdir back to test directory"
 	run_check_umount_test_dev
 
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$str" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$str" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$str"
@@ -46,28 +46,28 @@ test_full_simple_stream() {
 	local str
 
 	str="$here/stream-full-simple.stream"
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
 
 	cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume create subv1
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv1
 	for i in 1 2 3; do
 		run_check $SUDO_HELPER dd if=/dev/zero of=subv1/file1_$i bs=1M count=1
 	done
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv1-snap
 
 	truncate -s0 "$str"
 	chmod a+w "$str"
-	run_check $SUDO_HELPER $TOP/btrfs send -f "$str" subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -f "$str" subv1-snap
 
 	cd "$here" || _fail "cannot chdir back to test directory"
 	run_check_umount_test_dev
 
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$str" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$str" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$str"
@@ -79,27 +79,27 @@ test_incr_empty_stream() {
 
 	fstr="$here/stream-full-empty.stream"
 	istr="$here/stream-incr-empty.stream"
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
 
 	cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume create subv1
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv1-snap
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv2-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv1
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv2-snap
 
 	truncate -s0 "$fstr" "$istr"
 	chmod a+w "$fstr" "$istr"
-	run_check $SUDO_HELPER $TOP/btrfs send -f "$fstr" subv1-snap
-	run_check $SUDO_HELPER $TOP/btrfs send -p subv1-snap -f "$istr" subv2-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -f "$fstr" subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -p subv1-snap -f "$istr" subv2-snap
 
 	cd "$here" || _fail "cannot chdir back to test directory"
 	run_check_umount_test_dev
 
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$fstr" "$TEST_MNT"
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$istr" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$fstr" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$istr" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$fstr" "$istr"
@@ -110,36 +110,36 @@ test_incr_simple_stream() {
 
 	fstr="$here/stream-full-simple.stream"
 	istr="$here/stream-incr-simple.stream"
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
 
 	cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume create subv1
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume create subv1
 	for i in 1 2 3; do
 		run_check $SUDO_HELPER dd if=/dev/zero of=subv1/file1_$i bs=1M count=1
 	done
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv1-snap
 
 	for i in 1 2 3; do
 		run_check $SUDO_HELPER dd if=/dev/urandom of=subv1/file1_$i bs=1M count=1
 	done
 
-	run_check $SUDO_HELPER $TOP/btrfs subvolume snapshot -r subv1 subv2-snap
+	run_check $SUDO_HELPER $EXEC/btrfs subvolume snapshot -r subv1 subv2-snap
 
 	truncate -s0 "$fstr" "$istr"
 	chmod a+w "$fstr" "$istr"
-	run_check $SUDO_HELPER $TOP/btrfs send -f "$fstr" subv1-snap
-	run_check $SUDO_HELPER $TOP/btrfs send -p subv1-snap -f "$istr" subv2-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -f "$fstr" subv1-snap
+	run_check $SUDO_HELPER $EXEC/btrfs send -p subv1-snap -f "$istr" subv2-snap
 
 	cd "$here" || _fail "cannot chdir back to test directory"
 	run_check_umount_test_dev
 
-	run_check $TOP/mkfs.btrfs -f $TEST_DEV
+	run_check $EXEC/mkfs.btrfs -f $TEST_DEV
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$fstr" "$TEST_MNT"
-	run_check $SUDO_HELPER $TOP/btrfs receive "$@" -v -f "$istr" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$fstr" "$TEST_MNT"
+	run_check $SUDO_HELPER $EXEC/btrfs receive "$@" -v -f "$istr" "$TEST_MNT"
 	run_check_umount_test_dev
 
 	run_check rm -f -- "$fstr" "$istr"
diff --git a/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh b/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
index 182b0cf9..30fbde9d 100755
--- a/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
+++ b/tests/misc-tests/019-receive-clones-on-mounted-subvol/test.sh
@@ -20,15 +20,15 @@ rm -rf "$srcdir"
 mkdir -p "$srcdir"
 run_check chmod a+rw "$srcdir"
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 BLOCK_SIZE=$(stat -f -c %S "$TEST_MNT")
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/foo"
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/bar"
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/baz"
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/snap"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/foo"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/bar"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/baz"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/snap"
 
 tr '\000' 'A' < /dev/null |
 	run_check $SUDO_HELPER dd of=$TEST_MNT/foo/file_a bs=$BLOCK_SIZE count=32
@@ -53,23 +53,23 @@ run_check $SUDO_HELPER cp --reflink=always "$TEST_MNT/bar/file_b" "$TEST_MNT/baz
 
 # create snapshots and send streams
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r "$TEST_MNT/foo" "$TEST_MNT/snap/foo.0"
-run_check $SUDO_HELPER "$TOP/btrfs" send -f "$srcdir/foo.0.snap" "$TEST_MNT/snap/foo.0"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r "$TEST_MNT/foo" "$TEST_MNT/snap/foo.0"
+run_check $SUDO_HELPER "$EXEC/btrfs" send -f "$srcdir/foo.0.snap" "$TEST_MNT/snap/foo.0"
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r "$TEST_MNT/bar" "$TEST_MNT/snap/bar.0"
-run_check $SUDO_HELPER "$TOP/btrfs" send -f "$srcdir/bar.0.snap" "$TEST_MNT/snap/bar.0"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r "$TEST_MNT/bar" "$TEST_MNT/snap/bar.0"
+run_check $SUDO_HELPER "$EXEC/btrfs" send -f "$srcdir/bar.0.snap" "$TEST_MNT/snap/bar.0"
 
 run_check $SUDO_HELPER cp --reflink=always "$TEST_MNT/foo/file_a" "$TEST_MNT/foo/file_a.clone"
 run_check $SUDO_HELPER rm -f -- "$TEST_MNT/foo/file_a"
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r "$TEST_MNT/foo" \
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r "$TEST_MNT/foo" \
 	"$TEST_MNT/snap/foo.1"
-run_check $SUDO_HELPER "$TOP/btrfs" send -p "$TEST_MNT/snap/foo.0" -f "$srcdir/foo.1.snap" \
+run_check $SUDO_HELPER "$EXEC/btrfs" send -p "$TEST_MNT/snap/foo.0" -f "$srcdir/foo.1.snap" \
 	"$TEST_MNT/snap/foo.1"
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot -r "$TEST_MNT/baz" \
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot -r "$TEST_MNT/baz" \
 	"$TEST_MNT/snap/baz.0"
-run_check $SUDO_HELPER "$TOP/btrfs" send -p "$TEST_MNT/snap/foo.1" \
+run_check $SUDO_HELPER "$EXEC/btrfs" send -p "$TEST_MNT/snap/foo.1" \
 	-c "$TEST_MNT/snap/bar.0" -f "$srcdir/baz.0.snap" \
 	"$TEST_MNT/snap/baz.0"
 
@@ -100,22 +100,22 @@ run_check $FSSUM_PROG -A -f -w "$srcdir/bar.0.fssum" "$TEST_MNT/snap/bar.0"
 run_check $FSSUM_PROG -A -f -w "$srcdir/baz.0.fssum" "$TEST_MNT/snap/baz.0"
 
 run_check_umount_test_dev
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create "$TEST_MNT/dest"
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create "$TEST_MNT/dest"
 run_check_umount_test_dev
 run_check_mount_test_dev -o subvol=/dest
 
-run_check $SUDO_HELPER "$TOP/btrfs" receive -f "$srcdir/foo.0.snap" "$TEST_MNT"
-run_check $SUDO_HELPER "$TOP/btrfs" receive -f "$srcdir/bar.0.snap" "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" receive -f "$srcdir/foo.0.snap" "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" receive -f "$srcdir/bar.0.snap" "$TEST_MNT"
 
 # if "dest/" is not correctly stripped from the beginning of the path to
 # "foo.0" in the target fs, we would get an error here because the clone source
 # "foo.0/file_a" for "foo.1/file_a.clone" can't be found.
-run_check $SUDO_HELPER "$TOP/btrfs" receive -f "$srcdir/foo.1.snap" "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" receive -f "$srcdir/foo.1.snap" "$TEST_MNT"
 
 # same here, but with send -c instead of -p
-run_check $SUDO_HELPER "$TOP/btrfs" receive -f "$srcdir/baz.0.snap" "$TEST_MNT"
+run_check $SUDO_HELPER "$EXEC/btrfs" receive -f "$srcdir/baz.0.snap" "$TEST_MNT"
 
 run_check $FSSUM_PROG -r "$srcdir/foo.0.fssum" "$TEST_MNT/foo.0"
 run_check $FSSUM_PROG -r "$srcdir/foo.1.fssum" "$TEST_MNT/foo.1"
diff --git a/tests/misc-tests/020-fix-superblock-corruption/test.sh b/tests/misc-tests/020-fix-superblock-corruption/test.sh
index 77c1a5aa..8a55fe36 100755
--- a/tests/misc-tests/020-fix-superblock-corruption/test.sh
+++ b/tests/misc-tests/020-fix-superblock-corruption/test.sh
@@ -14,21 +14,21 @@ FIRST_SUPERBLOCK_OFFSET=65536
 
 test_superblock_restore()
 {
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 
 	# Corrupt superblock checksum
 	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_DEV" \
 	seek="$FIRST_SUPERBLOCK_OFFSET" bs=1 count=4 conv=notrunc
 
 	# Run btrfs check to detect corruption
-	run_mayfail "$TOP/btrfs" check "$TEST_DEV" && \
+	run_mayfail "$EXEC/btrfs" check "$TEST_DEV" && \
 		_fail "btrfs check should detect corruption"
 
 	# Copy backup superblock to primary
-	run_check "$TOP/btrfs-select-super" -s 1 "$TEST_DEV"
+	run_check "$EXEC/btrfs-select-super" -s 1 "$TEST_DEV"
 
 	# Perform btrfs check
-	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check "$EXEC/btrfs" check "$TEST_DEV"
 }
 
 test_superblock_restore
diff --git a/tests/misc-tests/021-image-multi-devices/test.sh b/tests/misc-tests/021-image-multi-devices/test.sh
index abf67f90..de42f43c 100755
--- a/tests/misc-tests/021-image-multi-devices/test.sh
+++ b/tests/misc-tests/021-image-multi-devices/test.sh
@@ -20,14 +20,14 @@ loop2=$(run_check_stdout $SUDO_HELPER losetup --find --show dev2)
 
 # Create the test file system.
 
-run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f $loop1 $loop2
+run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f $loop1 $loop2
 run_check $SUDO_HELPER mount $loop1 "$TEST_MNT"
 run_check $SUDO_HELPER dd bs=1M count=1 if=/dev/zero "of=$TEST_MNT/foobar"
 orig_md5=$(run_check_stdout md5sum "$TEST_MNT/foobar" | cut -d ' ' -f 1)
 run_check $SUDO_HELPER umount "$TEST_MNT"
 
 # Create the image to restore later.
-run_check $SUDO_HELPER "$TOP/btrfs-image" $loop1 "$IMAGE"
+run_check $SUDO_HELPER "$EXEC/btrfs-image" $loop1 "$IMAGE"
 
 # Wipe out the filesystem from the devices, restore the image on a single
 # device, check everything works and file foobar is there and with 1Mb of
@@ -35,7 +35,7 @@ run_check $SUDO_HELPER "$TOP/btrfs-image" $loop1 "$IMAGE"
 run_check $SUDO_HELPER wipefs -a $loop1
 run_check $SUDO_HELPER wipefs -a $loop2
 
-run_check $SUDO_HELPER $TOP/btrfs-image -r "$IMAGE" $loop1
+run_check $SUDO_HELPER $EXEC/btrfs-image -r "$IMAGE" $loop1
 
 run_check $SUDO_HELPER mount $loop1 "$TEST_MNT"
 new_md5=$(run_check_stdout md5sum "$TEST_MNT/foobar" | cut -d ' ' -f 1)
diff --git a/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh b/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
index 72cf076f..301b3a22 100755
--- a/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
+++ b/tests/misc-tests/022-filesystem-du-on-empty-subvol/test.sh
@@ -9,16 +9,16 @@ check_prereq btrfs
 setup_root_helper
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 
 cd "$TEST_MNT"
 
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create test1
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume create test1/test2
-run_check $SUDO_HELPER "$TOP/btrfs" subvolume snapshot test1 test1-snap
-run_check $SUDO_HELPER "$TOP/btrfs" filesystem du -s test1
-run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem du -s test1-snap | \
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create test1
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume create test1/test2
+run_check $SUDO_HELPER "$EXEC/btrfs" subvolume snapshot test1 test1-snap
+run_check $SUDO_HELPER "$EXEC/btrfs" filesystem du -s test1
+run_check_stdout $SUDO_HELPER "$EXEC/btrfs" filesystem du -s test1-snap | \
 	grep -q "ERROR:.*ioctl" && _fail "empty subvolume not handled"
 
 cd ..
diff --git a/tests/misc-tests/023-device-usage-with-missing-device/test.sh b/tests/misc-tests/023-device-usage-with-missing-device/test.sh
index 3c8ba85c..69ad1fc5 100755
--- a/tests/misc-tests/023-device-usage-with-missing-device/test.sh
+++ b/tests/misc-tests/023-device-usage-with-missing-device/test.sh
@@ -12,12 +12,12 @@ setup_root_helper
 test_run()
 {
 	# empty filesystem, with enough redundancy so degraded mount works
-	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -d raid1 -m raid1 $dev1 $dev2
+	run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f -d raid1 -m raid1 $dev1 $dev2
 
 	TEST_DEV="$dev1"
 	run_check_mount_test_dev
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem usage "$TEST_MNT"
-	run_check_stdout $SUDO_HELPER "$TOP/btrfs" device usage "$TEST_MNT" | \
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem usage "$TEST_MNT"
+	run_check_stdout $SUDO_HELPER "$EXEC/btrfs" device usage "$TEST_MNT" | \
 		grep -q "slack.*16\\.00EiB" && _fail
 	run_check_umount_test_dev
 
@@ -26,8 +26,8 @@ test_run()
 	unset loopdevs[2]
 
 	run_check_mount_test_dev -o degraded,ro
-	run_check $SUDO_HELPER "$TOP/btrfs" filesystem usage "$TEST_MNT"
-	run_check_stdout $SUDO_HELPER "$TOP/btrfs" device usage "$TEST_MNT" | \
+	run_check $SUDO_HELPER "$EXEC/btrfs" filesystem usage "$TEST_MNT"
+	run_check_stdout $SUDO_HELPER "$EXEC/btrfs" device usage "$TEST_MNT" | \
 		grep -q "slack.*16\\.00EiB" && _fail
 	run_check_umount_test_dev
 }
diff --git a/tests/misc-tests/024-inspect-internal-rootid/test.sh b/tests/misc-tests/024-inspect-internal-rootid/test.sh
index 40e382bb..baa4e760 100755
--- a/tests/misc-tests/024-inspect-internal-rootid/test.sh
+++ b/tests/misc-tests/024-inspect-internal-rootid/test.sh
@@ -9,31 +9,31 @@ check_prereq btrfs
 
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 run_check $SUDO_HELPER chmod a+rw "$TEST_MNT"
 cd "$TEST_MNT"
 
-run_check "$TOP/btrfs" subvolume create sub
-run_check "$TOP/btrfs" subvolume create sub/subsub
+run_check "$EXEC/btrfs" subvolume create sub
+run_check "$EXEC/btrfs" subvolume create sub/subsub
 run_check mkdir dir
 run_check touch file1
 run_check touch dir/file2
 run_check touch sub/file3
 
-id1=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid .) \
+id1=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid .) \
 	|| { echo $id1; exit 1; }
-id2=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub) \
+id2=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid sub) \
 	|| { echo $id2; exit 1; }
-id3=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/subsub) \
+id3=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid sub/subsub) \
 	|| { echo $id3; exit 1; }
-id4=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir) \
+id4=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid dir) \
 	|| { echo $id4; exit 1; }
-id5=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid file1) \
+id5=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid file1) \
 	|| { echo $id5; exit 1; }
-id6=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid dir/file2) \
+id6=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid dir/file2) \
 	|| { echo $id6; exit 1; }
-id7=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub/file3) \
+id7=$(run_check_stdout "$EXEC/btrfs" inspect-internal rootid sub/file3) \
 	|| { echo $id7; exit 1; }
 
 if ! ([ $id1 -ne $id2 ] && [ $id1 -ne $id3 ] && [ $id2 -ne $id3 ]); then
@@ -49,9 +49,9 @@ if ! ([ $id2 -eq $id7 ]); then
 fi
 
 run_mustfail "should fail for non existent file" \
-	"$TOP/btrfs" inspect-internal rootid no_such_file
+	"$EXEC/btrfs" inspect-internal rootid no_such_file
 run_mustfail "should fail for non-btrfs filesystem" \
-	"$TOP/btrfs" inspect-internal rootid /dev/null
+	"$EXEC/btrfs" inspect-internal rootid /dev/null
 
 cd ..
 run_check_umount_test_dev
diff --git a/tests/misc-tests/025-zstd-compression/test.sh b/tests/misc-tests/025-zstd-compression/test.sh
index e95dcb36..dbf4b745 100755
--- a/tests/misc-tests/025-zstd-compression/test.sh
+++ b/tests/misc-tests/025-zstd-compression/test.sh
@@ -13,7 +13,7 @@ check_dump_tree() {
 	local image=$1
 	local string=$2
 
-	run_check_stdout "$TOP/btrfs" inspect-internal dump-tree "$image" \
+	run_check_stdout "$EXEC/btrfs" inspect-internal dump-tree "$image" \
 		| grep -q "$string" \
 		|| _fail "btrfs inspect-internal dump-tree didn't print $string"
 }
@@ -24,13 +24,13 @@ check_dump_tree "$image" "extent compression 2 (lzo)"
 check_dump_tree "$image" "extent compression 3 (zstd)"
 
 # Check that the filesystem has incompat COMPRESS_ZSTD
-run_check_stdout "$TOP/btrfs" inspect-internal dump-super -f "$image" \
+run_check_stdout "$EXEC/btrfs" inspect-internal dump-super -f "$image" \
 	| grep -q COMPRESS_ZSTD \
 	|| _fail "btrfs inspect-internal dump-super no incompat COMPRESS_ZSTD"
 
 # Create a temporary directory and restore the filesystem
 restore_tmp=$(mktemp --tmpdir -d btrfs-progs-022-zstd-compression.XXXXXXXXXX)
-run_check "$TOP/btrfs" restore "$image" "$restore_tmp"
+run_check "$EXEC/btrfs" restore "$image" "$restore_tmp"
 
 # Expect 3 files
 num_files=$(ls -1 "$restore_tmp" | wc -l)
diff --git a/tests/misc-tests/026-image-non-printable-chars/test.sh b/tests/misc-tests/026-image-non-printable-chars/test.sh
index 8018586f..046ec244 100755
--- a/tests/misc-tests/026-image-non-printable-chars/test.sh
+++ b/tests/misc-tests/026-image-non-printable-chars/test.sh
@@ -9,7 +9,7 @@ check_prereq btrfs
 
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
 run_check $SUDO_HELPER chmod a+rw "$TEST_MNT"
 
@@ -18,9 +18,9 @@ touch "$TEST_MNT/|5gp!"
 
 run_check_umount_test_dev
 
-run_check $SUDO_HELPER "$TOP/btrfs-image" -ss "$TEST_DEV" img
-run_check $SUDO_HELPER "$TOP/btrfs-image" -r img img.restored
-run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-tree img.restored > img.dump
+run_check $SUDO_HELPER "$EXEC/btrfs-image" -ss "$TEST_DEV" img
+run_check $SUDO_HELPER "$EXEC/btrfs-image" -r img img.restored
+run_check_stdout $SUDO_HELPER "$EXEC/btrfs" inspect-internal dump-tree img.restored > img.dump
 
 ch7f=$(echo -en '\x7f')
 if grep -q "$ch7f" img.dump; then
diff --git a/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh b/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
index ee41d71f..4519dc29 100755
--- a/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
+++ b/tests/misc-tests/027-subvol-list-deleted-toplevel/test.sh
@@ -8,11 +8,11 @@ check_prereq btrfs
 
 prepare_test_dev
 
-run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+run_check "$EXEC/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
-run_check_stdout $SUDO_HELPER "$TOP/btrfs" subvolume list "$TEST_MNT" |
+run_check_stdout $SUDO_HELPER "$EXEC/btrfs" subvolume list "$TEST_MNT" |
 	grep -i -q "id 5" && _fail "found toplevel among regular"
-run_check_stdout $SUDO_HELPER "$TOP/btrfs" subvolume list -d "$TEST_MNT" |
+run_check_stdout $SUDO_HELPER "$EXEC/btrfs" subvolume list -d "$TEST_MNT" |
 	grep -i -q "id 5.*DELETED" && _fail "found toplevel among deleted"
 
 run_check_umount_test_dev
diff --git a/tests/mkfs-tests.sh b/tests/mkfs-tests.sh
index c8ff8c83..e246193e 100755
--- a/tests/mkfs-tests.sh
+++ b/tests/mkfs-tests.sh
@@ -5,6 +5,10 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+EXEC=$TOP
+if [ ! -f $TOP/btrfs ]; then
+	EXEC=$(dirname `which btrfs`)
+fi
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/mkfs-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +20,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
index 854ee007..a704daf5 100755
--- a/tests/mkfs-tests/001-basic-profiles/test.sh
+++ b/tests/mkfs-tests/001-basic-profiles/test.sh
@@ -11,17 +11,17 @@ setup_root_helper
 
 test_get_info()
 {
-	run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $dev1
-	run_check $SUDO_HELPER $TOP/btrfs check $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-super $dev1
+	run_check $SUDO_HELPER $EXEC/btrfs check $dev1
 	run_check $SUDO_HELPER mount $dev1 $TEST_MNT
-	run_check $TOP/btrfs filesystem df $TEST_MNT
-	run_check $SUDO_HELPER $TOP/btrfs filesystem usage $TEST_MNT
-	run_check $SUDO_HELPER $TOP/btrfs device usage $TEST_MNT
+	run_check $EXEC/btrfs filesystem df $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs filesystem usage $TEST_MNT
+	run_check $SUDO_HELPER $EXEC/btrfs device usage $TEST_MNT
 	run_check $SUDO_HELPER umount "$TEST_MNT"
 }
 test_do_mkfs()
 {
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f	\
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f	\
 		$@
 }
 
diff --git a/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh b/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
index 37846234..0155bb60 100755
--- a/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
+++ b/tests/mkfs-tests/002-no-force-mixed-on-small-volume/test.sh
@@ -8,5 +8,5 @@ check_prereq mkfs.btrfs
 
 setup_root_helper
 
-mixed=$(run_check_stdout "$TOP/mkfs.btrfs" -b 512M -n 64k -f "$TEST_DEV" | egrep 'Data|Metadata')
+mixed=$(run_check_stdout "$EXEC/mkfs.btrfs" -b 512M -n 64k -f "$TEST_DEV" | egrep 'Data|Metadata')
 echo "$mixed" | grep -q -v 'Data+Metadata:' || _fail "unexpected: created a mixed-bg filesystem"
diff --git a/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh b/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
index 074fc22e..71e523e2 100755
--- a/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
+++ b/tests/mkfs-tests/003-mixed-with-wrong-nodesize/test.sh
@@ -6,6 +6,6 @@ source $TOP/tests/common
 
 check_prereq mkfs.btrfs
 
-run_mayfail "$TOP/mkfs.btrfs" -b 512M -f -M -s 4096 -n 16384 "$TEST_DEV" && _fail
+run_mayfail "$EXEC/mkfs.btrfs" -b 512M -f -M -s 4096 -n 16384 "$TEST_DEV" && _fail
 
 exit 0
diff --git a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
index 7038c8ea..54b3cdb9 100755
--- a/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
+++ b/tests/mkfs-tests/004-rootdir-keeps-size/test.sh
@@ -15,7 +15,7 @@ test_mkfs_with_size() {
 	size="$1"
 	run_check truncate -s$size $TEST_DEV
 	imgsize=$(run_check_stdout stat --format=%s $TEST_DEV)
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f \
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f \
 		--rootdir $TOP/Documentation \
 		$TEST_DEV
 	tmp=$(run_check_stdout stat --format=%s $TEST_DEV)
diff --git a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
index 5bdf50e0..df616b36 100755
--- a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
+++ b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
@@ -30,9 +30,9 @@ echo 0 | run_check $SUDO_HELPER tee $rot
 run_check cat $rot
 
 # test
-run_check_stdout $SUDO_HELPER $TOP/mkfs.btrfs -f $@ $dmdev |
+run_check_stdout $SUDO_HELPER $EXEC/mkfs.btrfs -f $@ $dmdev |
 	grep -q 'SSD detected:.*yes' || _fail 'SSD not detected'
-run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $dmdev
+run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-super $dmdev
 
 # cleanup
 run_check $SUDO_HELPER dmsetup remove $dmname
diff --git a/tests/mkfs-tests/006-partitioned-loopdev/test.sh b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
index 0c77e5cd..533ccfc6 100755
--- a/tests/mkfs-tests/006-partitioned-loopdev/test.sh
+++ b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
@@ -22,8 +22,8 @@ base=$(basename $loopdev)
 
 # expect partitions named like loop0p1 etc
 for looppart in $(ls /dev/$base?*); do
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $looppart
-	run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $looppart
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f $looppart
+	run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-super $looppart
 done
 
 # cleanup
diff --git a/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh b/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
index 3980414f..98aef49a 100755
--- a/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
+++ b/tests/mkfs-tests/007-mix-nodesize-sectorsize/test.sh
@@ -11,9 +11,9 @@ prepare_test_dev
 
 test_mkfs_single()
 {
-	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$@" $TEST_DEV
-	run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $TEST_DEV
-	run_check $SUDO_HELPER $TOP/btrfs check $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/mkfs.btrfs -f "$@" $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/btrfs inspect-internal dump-super $TEST_DEV
+	run_check $SUDO_HELPER $EXEC/btrfs check $TEST_DEV
 }
 
 # default
diff --git a/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh b/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
index 955cd2b1..4ae4650a 100755
--- a/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
+++ b/tests/mkfs-tests/008-sectorsize-nodesize-combination/test.sh
@@ -19,11 +19,11 @@ do_test()
 {
 	sectorsize=$1
 	nodesize=$2
-	run_mayfail $TOP/mkfs.btrfs -f -O $features -n $nodesize -s $sectorsize \
+	run_mayfail $EXEC/mkfs.btrfs -f -O $features -n $nodesize -s $sectorsize \
 		$TEST_DEV
 	ret=$?
 	if [ $ret == 0 ]; then
-		run_check $TOP/btrfs check $TEST_DEV
+		run_check $EXEC/btrfs check $TEST_DEV
 	fi
 	return $ret
 }
diff --git a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
index d327a0d9..23808ef7 100755
--- a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
+++ b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
@@ -29,8 +29,8 @@ run_check $SUDO_HELPER mknod "$tmp/char" c 1 1
 run_check $SUDO_HELPER mknod "$tmp/block" b 1 1
 run_check dd if=/dev/zero bs=1M count=1 of="$tmp/regular"
 
-run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -r "$tmp" "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/mkfs.btrfs" -f -r "$tmp" "$TEST_DEV"
 
 rm -rf -- "$tmp"
 
-run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+run_check $SUDO_HELPER "$EXEC/btrfs" check "$TEST_DEV"
-- 
2.14.3



