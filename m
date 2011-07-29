From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 1/4] xfstests: Changed test 062 to be generic for all filesystems
Date: Fri, 29 Jul 2011 18:06:58 +0200
Message-ID: <95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Changed the test 062 to be generic for all filesystems and to be
executed for all filesystems.
Remove output of mkfs since this is specific to mkfs.xfs and now
filtered out.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 062     |    4 ++--
 062.out |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/062 b/062
index 5cb6f92..a6e4bc8 100755
--- a/062
+++ b/062
@@ -71,7 +71,7 @@ _create_test_bed()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
@@ -80,7 +80,7 @@ _require_attrs
 rm -f $tmp.backup1 $tmp.backup2 $seq.full
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
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

