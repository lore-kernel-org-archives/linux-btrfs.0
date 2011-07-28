From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 3/4] xfstests: Add support for btrfs in 015
Date: Thu, 28 Jul 2011 10:28:00 +0200
Message-ID: <bebfc5c98e0fb878f55c1312d8750ce7b7f82e07.1311776403.git.sbehrens@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1311776403.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Added btrfs to the list of supported filesystems for test 015, and
increased free space reporting tolerance to 10% for btrfs.
Replaced the call to _scratch_mkfs_xfs with the XFS specific size
parameter by the generic one for sized filesystem creation which is
_scratch_mkfs_sized.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 015 |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/015 b/015
index 8f2be7c..7020e67 100755
--- a/015
+++ b/015
@@ -48,13 +48,13 @@ _free()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os IRIX Linux
 
 _require_scratch
 _require_nobigloopfs
 
-_scratch_mkfs_xfs -d size=50m >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
 rm -f $seq.full
@@ -120,7 +120,12 @@ fi
 echo "free space after delete $free2" >> $seq.full
 
 echo -n "   !!! "
-_within_tolerance "free space" $free2 $free0 1% -v
+if [ $FSTYP = btrfs ]
+then
+	_within_tolerance "free space" $free2 $free0 10% -v
+else
+	_within_tolerance "free space" $free2 $free0 1% -v
+fi
 
 status=0
 exit
-- 
1.7.3.4

