From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 3/4] xfstests: Changed test 015 to be generic for all filesystems
Date: Fri, 29 Jul 2011 18:07:00 +0200
Message-ID: <9fac26922ffbfbfb153818a3cbfb97d17ff42176.1311953979.git.sbehrens@giantdisaster.de>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1311953979.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Changed the test 015 to be generic for all filesystems and to be
executed for all filesystems.
Replaced the call to _scratch_mkfs_xfs with the XFS specific size
parameter by the generic one for sized filesystem creation which is
_scratch_mkfs_sized.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 015 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/015 b/015
index 8f2be7c..686a211 100755
--- a/015
+++ b/015
@@ -48,13 +48,13 @@ _free()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
 _require_nobigloopfs
 
-_scratch_mkfs_xfs -d size=50m >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
 rm -f $seq.full
-- 
1.7.3.4

