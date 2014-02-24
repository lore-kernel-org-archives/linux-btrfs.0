Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35797 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaBXL4e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:56:34 -0500
Received: by mail-wi0-f179.google.com with SMTP id bs8so2930547wib.12
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 03:56:33 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add function _require_fssum()
Date: Mon, 24 Feb 2014 11:56:23 +0000
Message-Id: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To avoid repeating detection of fssum presence in many btrfs tests, as
suggested by Dave Chinner.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 common/rc       |    7 +++++++
 tests/btrfs/007 |    5 +----
 tests/btrfs/016 |    5 +----
 tests/btrfs/030 |    5 +----
 tests/btrfs/038 |    5 +----
 tests/btrfs/039 |    5 +----
 tests/btrfs/040 |    5 +----
 tests/btrfs/041 |    5 +----
 tests/btrfs/042 |    5 +----
 9 files changed, 15 insertions(+), 32 deletions(-)
 mode change 100644 => 100755 tests/btrfs/016

diff --git a/common/rc b/common/rc
index 5df504c..cce05cc 100644
--- a/common/rc
+++ b/common/rc
@@ -2144,6 +2144,13 @@ _require_cp_reflink()
                _notrun "This test requires a cp with --reflink support."
 }
 
+_require_fssum()
+{
+	HERE=`pwd`
+	FSSUM_PROG=$HERE/src/fssum
+	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+}
+
 # Given 2 files, verify that they have the same mapping but different
 # inodes - i.e. an undisturbed reflink
 # Silent if so, make noise if not
diff --git a/tests/btrfs/007 b/tests/btrfs/007
index 5df9ccb..5430613 100755
--- a/tests/btrfs/007
+++ b/tests/btrfs/007
@@ -31,7 +31,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1
 
@@ -52,11 +51,9 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _require_seek_data_hole
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 workout()
diff --git a/tests/btrfs/016 b/tests/btrfs/016
old mode 100644
new mode 100755
index 6faead1..d04c21a
--- a/tests/btrfs/016
+++ b/tests/btrfs/016
@@ -26,7 +26,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 tmp_dir=send_temp_$seq
 
@@ -51,9 +50,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+_require_fssum
 
 _scratch_mkfs > /dev/null 2>&1
 
diff --git a/tests/btrfs/030 b/tests/btrfs/030
index a9f5fb4..a76a410 100755
--- a/tests/btrfs/030
+++ b/tests/btrfs/030
@@ -36,7 +36,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -54,11 +53,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/038 b/tests/btrfs/038
index 8893696..4941d3e 100755
--- a/tests/btrfs/038
+++ b/tests/btrfs/038
@@ -32,7 +32,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -50,11 +49,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/039 b/tests/btrfs/039
index 41e09be..758b23c 100755
--- a/tests/btrfs/039
+++ b/tests/btrfs/039
@@ -35,7 +35,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -53,11 +52,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/040 b/tests/btrfs/040
index 77c4a84..dfd495c 100755
--- a/tests/btrfs/040
+++ b/tests/btrfs/040
@@ -35,7 +35,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -53,11 +52,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/041 b/tests/btrfs/041
index bfc0e4b..a960001 100755
--- a/tests/btrfs/041
+++ b/tests/btrfs/041
@@ -31,7 +31,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -49,11 +48,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/042 b/tests/btrfs/042
index 2bd5147..9aa8967 100755
--- a/tests/btrfs/042
+++ b/tests/btrfs/042
@@ -36,7 +36,6 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-here=`pwd`
 tmp=`mktemp -d`
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -54,11 +53,9 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
+_require_fssum
 _need_to_be_root
 
-FSSUM_PROG=$here/src/fssum
-[ -x $FSSUM_PROG ] || _notrun "fssum not built"
-
 rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
-- 
1.7.9.5

