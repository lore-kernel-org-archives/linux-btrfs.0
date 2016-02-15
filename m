Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46610 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbcBOUqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 15:46:32 -0500
Subject: [PATCH 3/3] xfs/24[356]: check for -c switch to xfs_io bmap command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 15 Feb 2016 12:46:27 -0800
Message-ID: <20160215204627.7977.93549.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extend _require_xfs_io_command so that we can pass it a command line
argument to look for, and then use new capabililty in the relevant
tests to ensure that bmap knows how to dump CoW fork contents (bmap -c)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc     |    9 +++++++--
 tests/xfs/243 |    1 +
 tests/xfs/245 |    1 +
 tests/xfs/246 |    1 +
 4 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index b11f170..e810062 100644
--- a/common/rc
+++ b/common/rc
@@ -1831,12 +1831,13 @@ _user_do()
 
 _require_xfs_io_command()
 {
-	if [ $# -ne 1 ]
+	if [ -z "$1" ]
 	then
-		echo "Usage: _require_xfs_io_command command" 1>&2
+		echo "Usage: _require_xfs_io_command command [switch]" 1>&2
 		exit 1
 	fi
 	command=$1
+	param=$2
 
 	testfile=$TEST_DIR/$$.xfs_io
 	case $command in
@@ -1866,6 +1867,10 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+
+	test -z "$param" && return
+	$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
+		_notrun "xfs_io $command doesn't support $param"
 }
 
 # check that xfs_db supports a specific command
diff --git a/tests/xfs/243 b/tests/xfs/243
index 629173e..d75cfd8 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -56,6 +56,7 @@ _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
+_require_xfs_io_command "bmap" "-c"
 _require_cp_reflink
 
 rm -f $seqres.full
diff --git a/tests/xfs/245 b/tests/xfs/245
index 6da701d..7f80260 100755
--- a/tests/xfs/245
+++ b/tests/xfs/245
@@ -49,6 +49,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "bmap" "-c"
 _require_cp_reflink
 
 rm -f $seqres.full
diff --git a/tests/xfs/246 b/tests/xfs/246
index 13b0c98..bf471cc 100755
--- a/tests/xfs/246
+++ b/tests/xfs/246
@@ -42,6 +42,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_io_command "bmap" "-c"
 
 rm -f $seqres.full
 

