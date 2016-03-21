Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbcCUHYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:24:22 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH] fstests: _fail the tests if _scratch_mount failed to avoid fully filling root fs
Date: Mon, 21 Mar 2016 15:23:41 +0800
Message-Id: <1458545021-23285-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs failed to mount small fs on ppc64 host with error ENOSPC, even
creating such small fs succeeded, then generic/027 consumed all free
space on root fs not on SCRATCH_DEV and test harness cannot create tmp
files and continue other tests.

Though I think it's a btrfs bug, it's still worth preventing this
situation from happening in the harness, as such tests usually aim to
exercise fs on ENOSPC conditions, there's no point to continue if the
small fs is not mounted.

So I went through all tests that call _scratch_mkfs_sized && could
consume all free space on $SCRATCH_MNT, _fail the test if _scratch_mount
failed.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/027 | 2 +-
 tests/generic/269 | 2 +-
 tests/generic/270 | 2 +-
 tests/generic/274 | 2 +-
 tests/generic/275 | 2 +-
 tests/generic/300 | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/generic/027 b/tests/generic/027
index d2e59d6..e5fdbe9 100755
--- a/tests/generic/027
+++ b/tests/generic/027
@@ -66,7 +66,7 @@ rm -f $seqres.full
 echo "Silence is golden"
 
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
-_scratch_mount
+_scratch_mount || _fail "mount failed"
 
 echo "Reserve 2M space" >>$seqres.full
 $XFS_IO_PROG -f -c "pwrite 0 2m" $SCRATCH_MNT/testfile >>$seqres.full 2>&1
diff --git a/tests/generic/269 b/tests/generic/269
index ee353a5..adc766f 100755
--- a/tests/generic/269
+++ b/tests/generic/269
@@ -68,7 +68,7 @@ _require_scratch
 
 rm -f $seqres.full
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
-_scratch_mount
+_scratch_mount || _fail "mount failed"
 
 if ! _workout; then
 	_scratch_unmount 2>/dev/null
diff --git a/tests/generic/270 b/tests/generic/270
index e6874c9..b0164be 100755
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -82,7 +82,7 @@ _require_scratch
 
 rm -f $seqres.full
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
-_scratch_mount "-o usrquota,grpquota"
+_scratch_mount "-o usrquota,grpquota" || _fail "mount failed"
 chmod 777 $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon -u -g $SCRATCH_MNT 2>/dev/null
diff --git a/tests/generic/274 b/tests/generic/274
index 61ab220..7feca5c 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -58,7 +58,7 @@ rm -f $seqres.full
 
 _scratch_unmount 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
-_scratch_mount
+_scratch_mount || _fail "mount failed"
 
 # Create a 4k file and Allocate 4M past EOF on that file
 $XFS_IO_PROG -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
diff --git a/tests/generic/275 b/tests/generic/275
index 955c4ac..3e5940a 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -55,7 +55,7 @@ rm -f $seqres.full
 
 _scratch_unmount 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
-_scratch_mount
+_scratch_mount || _fail "mount failed"
 
 # this file will get removed to create 256k of free space after ENOSPC
 # conditions are created.
diff --git a/tests/generic/300 b/tests/generic/300
index c187f43..0b2463d 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -143,7 +143,7 @@ _workout()
 _require_fio $fio_config
 
 _scratch_mkfs_sized $FS_SIZE >> $seqres.full 2>&1
-_scratch_mount
+_scratch_mount || _fail "mount failed"
 
 if ! _workout; then
 	_scratch_unmount 2>/dev/null
-- 
2.5.0

