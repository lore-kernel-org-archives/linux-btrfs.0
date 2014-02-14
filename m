Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43397 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaBNGQE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 01:16:04 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: btrfs/005: log test result to right path
Date: Fri, 14 Feb 2014 14:14:22 +0800
Message-Id: <1392358462-2574-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should log test results to $reqres.full not $req.full.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/005 | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tests/btrfs/005 b/tests/btrfs/005
index c364e11..7639635 100755
--- a/tests/btrfs/005
+++ b/tests/btrfs/005
@@ -77,14 +77,14 @@ _btrfs_online_defrag()
 	fi
 
 	if [ "$str" != "" ]; then
-		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
+		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file >> $seqres.full 2>&1
 	else
 		if [ "$1" = "1" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file >> $seqres.full 2>&1
 		elif [ "$1" = "2" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir >> $seqres.full 2>&1
 		elif [ "$1" = "3" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT >> $seq.full 2>&1
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT >> $seqres.full 2>&1
 		fi
 	fi
 	ret_val=$?
@@ -134,9 +134,10 @@ _rundefrag()
 # real QA test starts here
 _supported_fs btrfs
 _supported_os Linux
-
-## We require scratch so that we'll have free contiguous space
 _require_scratch
+
+rm -f $seqres.full
+
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 _require_defrag
-- 
1.8.3.1

