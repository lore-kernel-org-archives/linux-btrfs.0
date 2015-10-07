Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49062 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbbJGFNd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 01:13:33 -0400
Subject: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Anna.Schumaker@netapp.com, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Tue, 06 Oct 2015 22:13:23 -0700
Message-ID: <20151007051323.3260.60421.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify the reflink tests to support xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   37 +++++++++++++++++++++++++++++++++++++
 tests/generic/800 |    2 +-
 tests/generic/801 |    2 +-
 tests/generic/802 |    2 +-
 4 files changed, 40 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 3e97060..7e2f140 100644
--- a/common/rc
+++ b/common/rc
@@ -1429,6 +1429,43 @@ _require_scratch_xfs_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the test fs support reflink...
+#
+_require_test_reflink()
+{
+    case $FSTYP in
+    xfs)
+	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
+	;;
+    btrfs)
+        true
+        ;;
+    *)
+        _notrun "Reflink not supported by this filesystem type: $FSTYP"
+        ;;
+    esac
+}
+
+# this test requires the scratch fs support reflink...
+#
+_require_scratch_reflink()
+{
+    case $FSTYP in
+    xfs)
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "$FSTYP does not support reflink"
+	_scratch_unmount
+	;;
+    btrfs)
+        true
+        ;;
+    *)
+        _notrun "Reflink not supported by this filesystem type: $FSTYP"
+        ;;
+    esac
+}
+
 # this test requires the bigalloc feature to be available in mkfs.ext4
 #
 _require_ext4_mkfs_bigalloc()
diff --git a/tests/generic/800 b/tests/generic/800
index a71f11a..954f39d 100755
--- a/tests/generic/800
+++ b/tests/generic/800
@@ -45,7 +45,7 @@ _cleanup()
 . common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/801 b/tests/generic/801
index b21c44b..aedb6e9 100755
--- a/tests/generic/801
+++ b/tests/generic/801
@@ -45,7 +45,7 @@ _cleanup()
 . common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/802 b/tests/generic/802
index afd8513..51d3414 100755
--- a/tests/generic/802
+++ b/tests/generic/802
@@ -43,7 +43,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"

