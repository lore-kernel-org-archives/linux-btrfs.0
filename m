From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 2/4] xfstests: Add support for btrfs in 083, 117, 120 and 192
Date: Thu, 28 Jul 2011 10:27:59 +0200
Message-ID: <5d99a1d3ca548176a2246dff06701277ee11e0d6.1311776403.git.sbehrens@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1311776403.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Added btrfs to the list of supported filesystems for tests 083, 117,
120 and 192. For test 083 also changed to use _scratch_mkfs_sized
instead of _scratch_mks_xfs for all filesystem types except for XFS.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 083 |   12 +++++++++---
 117 |    4 ++--
 120 |    4 ++--
 192 |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/083 b/083
index 7342baa..898d202 100755
--- a/083
+++ b/083
@@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os IRIX Linux
 
 _require_scratch
@@ -72,8 +72,14 @@ workout()
 	umount $SCRATCH_DEV >/dev/null 2>&1
 	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
 	echo ""                                     >>$seq.full
-	_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
-		|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	if [ $FSTYP = xfs ]
+	then
+		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
+			|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	else
+		_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
+			|| _fail "size=$fsz mkfs failed"
+	fi
 	_scratch_mount                              >>$seq.full 2>&1 \
 		|| _fail "mount failed"
 
diff --git a/117 b/117
index dd880cb..92949d0 100755
--- a/117
+++ b/117
@@ -51,7 +51,7 @@ _cleanup()
 . ./common.attr
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os IRIX Linux
 
 _setup_testdir
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
+_scratch_mkfs                               >>$seq.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
     || _fail "mount failed"
diff --git a/120 b/120
index bf1e617..f8d3aad 100755
--- a/120
+++ b/120
@@ -37,11 +37,11 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os Linux IRIX
 
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 
 _compare_access_times()
 {
diff --git a/192 b/192
index d8301d5..0c488ef 100755
--- a/192
+++ b/192
@@ -45,7 +45,7 @@ _access_time()
 
 # real QA test starts here
 
-_supported_fs xfs udf nfs
+_supported_fs xfs udf nfs btrfs
 _supported_os Linux
 #delay=150
 #delay=75
-- 
1.7.3.4

