From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 2/4] xfstests: Changed tests 083, 117, 120 and 192 to be generic for all filesystems
Date: Fri, 29 Jul 2011 18:06:59 +0200
Message-ID: <1bdccf3ff6b9b913faab5caf8f54a8e5980a1345.1311953979.git.sbehrens@giantdisaster.de>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Changed the tests 083, 117, 120 and 192 to be generic for all filesystems
and to be executed for all filesystems.
For test 083 also changed to use _scratch_mkfs_sized instead of
_scratch_mks_xfs for all filesystem types except for XFS.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 083 |   12 +++++++++---
 117 |    4 ++--
 120 |    4 ++--
 192 |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/083 b/083
index 7342baa..441284e 100755
--- a/083
+++ b/083
@@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
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
index dd880cb..fcf0485 100755
--- a/117
+++ b/117
@@ -51,7 +51,7 @@ _cleanup()
 . ./common.attr
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
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
index bf1e617..010a8f3 100755
--- a/120
+++ b/120
@@ -37,11 +37,11 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 
 _compare_access_times()
 {
diff --git a/192 b/192
index d8301d5..4b69147 100755
--- a/192
+++ b/192
@@ -45,7 +45,7 @@ _access_time()
 
 # real QA test starts here
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 #delay=150
 #delay=75
-- 
1.7.3.4

