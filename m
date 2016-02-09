Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23251 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbcBIBMP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 20:12:15 -0500
Subject: [PATCH 03/23] xfstests: make _scratch_mkfs_blocksized usable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 08 Feb 2016 17:12:04 -0800
Message-ID: <20160209011204.23099.75138.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The default mkfs.xfs options contain -b size=4096, so all tests
using _scratch_mkfs_blocksized won't actually run unless those
options are changed.  As we're trying to specificly test 1k
blocks we should always override the default option.

v2: Move the function to common/rc

Signed-off-by: Christoph Hellwig <hch@lst.de>
[darrick.wong@oracle.com: move function to common/rc]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc      |   24 ++++++++++++++++++++++++
 common/reflink |   30 ------------------------------
 2 files changed, 24 insertions(+), 30 deletions(-)


diff --git a/common/rc b/common/rc
index f08cb3a..863d4b3 100644
--- a/common/rc
+++ b/common/rc
@@ -881,6 +881,30 @@ _scratch_mkfs_geom()
     _scratch_mkfs
 }
 
+# Create fs of certain blocksize on scratch device
+# _scratch_mkfs_blocksized blocksize
+_scratch_mkfs_blocksized()
+{
+    blocksize=$1
+
+    re='^[0-9]+$'
+    if ! [[ $blocksize =~ $re ]] ; then
+        _notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
+    fi
+
+    case $FSTYP in
+    xfs)
+	_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
+	;;
+    ext2|ext3|ext4|ocfs2)
+	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	;;
+    *)
+	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
+	;;
+    esac
+}
+
 _scratch_resvblks()
 {
 	case $FSTYP in
diff --git a/common/reflink b/common/reflink
index 8638aba..3d6a8c1 100644
--- a/common/reflink
+++ b/common/reflink
@@ -187,33 +187,3 @@ _dedupe_range() {
 
 	"$XFS_IO_PROG" $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
 }
-
-# Create fs of certain blocksize on scratch device
-# _scratch_mkfs_blocksized blocksize
-_scratch_mkfs_blocksized()
-{
-    blocksize=$1
-
-    re='^[0-9]+$'
-    if ! [[ $blocksize =~ $re ]] ; then
-        _notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
-    fi
-
-    case $FSTYP in
-    xfs)
-	# don't override MKFS_OPTIONS that set a block size.
-	echo $MKFS_OPTIONS |egrep -q "b?size="
-	if [ $? -eq 0 ]; then
-		_scratch_mkfs_xfs
-	else
-		_scratch_mkfs_xfs -b size=$blocksize
-	fi
-	;;
-    ext2|ext3|ext4|ocfs2)
-	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
-	;;
-    *)
-	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
-	;;
-    esac
-}

