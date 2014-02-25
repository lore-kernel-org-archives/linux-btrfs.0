Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:62343 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaBYNqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 08:46:31 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so411254wes.30
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 05:46:30 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add function _require_fssum()
Date: Tue, 25 Feb 2014 13:46:20 +0000
Message-Id: <1393335980-446-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To avoid repeating detection of fssum presence in many btrfs tests, as
suggested by Dave Chinner.

Also exported the variable "here" from the main control script, to avoid
repeating its declaration in every single testcase file. Also removed the
declaration of "here" from btrfs test cases that require the fssum program
only. Removing it from all other test cases will be a separate change.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Exported the variable "here" from the main control file, as suggested by
    Dave Chinner. Like this we avoid declaring it again in the new function
    and in many other places.

 check           |    2 +-
 common/rc       |    6 ++++++
 tests/btrfs/007 |    5 +----
 tests/btrfs/016 |    5 +----
 tests/btrfs/030 |    5 +----
 tests/btrfs/038 |    5 +----
 tests/btrfs/039 |    5 +----
 tests/btrfs/040 |    5 +----
 tests/btrfs/041 |    5 +----
 tests/btrfs/042 |    5 +----
 10 files changed, 15 insertions(+), 33 deletions(-)
 mode change 100644 => 100755 tests/btrfs/016

diff --git a/check b/check
index 268417c..b619f6d 100755
--- a/check
+++ b/check
@@ -32,7 +32,7 @@ diff="diff -u"
 showme=false
 have_test_arg=false
 randomize=false
-here=`pwd`
+export here=`pwd`
 xfile=""
 
 # start the initialisation work now
diff --git a/common/rc b/common/rc
index 5df504c..0f50f49 100644
--- a/common/rc
+++ b/common/rc
@@ -2144,6 +2144,12 @@ _require_cp_reflink()
                _notrun "This test requires a cp with --reflink support."
 }
 
+_require_fssum()
+{
+	FSSUM_PROG=$here/src/fssum
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

