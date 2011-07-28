From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 1/4] xfstests: Add support for btrfs in 062
Date: Thu, 28 Jul 2011 10:27:58 +0200
Message-ID: <d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1311776403.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Added btrfs to the list of supported filesystems for this test.
Remove output of mkfs since this is specific to mkfs.xfs and now filtered
out.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 062     |    4 ++--
 062.out |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/062 b/062
index 5cb6f92..0f1e98f 100755
--- a/062
+++ b/062
@@ -71,7 +71,7 @@ _create_test_bed()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs xfs udf nfs btrfs
 _supported_os Linux
 
 _require_scratch
@@ -80,7 +80,7 @@ _require_attrs
 rm -f $tmp.backup1 $tmp.backup2 $seq.full
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs > /dev/null || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 _create_test_bed
 
diff --git a/062.out b/062.out
index 73fd628..1d5a094 100644
--- a/062.out
+++ b/062.out
@@ -1,10 +1,4 @@
 QA output created by 062
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** create test bed
 SCRATCH_MNT
 SCRATCH_MNT/dev
-- 
1.7.3.4

