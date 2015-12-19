Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbbLSJLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 04:11:11 -0500
Subject: [PATCH 02/11] tests: don't leave cruft behind on the TEST_MNT
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Sat, 19 Dec 2015 01:11:05 -0800
Message-ID: <20151219091105.15320.69176.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't leave cruft behind on the test device's filesystem, so as to
avoid filling it with debris.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/110 |    2 +-
 tests/generic/111 |    2 +-
 tests/generic/115 |    2 +-
 tests/generic/159 |    2 +-
 tests/generic/160 |    2 +-
 tests/xfs/129     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/tests/generic/110 b/tests/generic/110
index 468d859..fffadbc 100755
--- a/tests/generic/110
+++ b/tests/generic/110
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/111 b/tests/generic/111
index 1797233..98077d8 100755
--- a/tests/generic/111
+++ b/tests/generic/111
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/115 b/tests/generic/115
index b5c64ec..6c8d92d 100755
--- a/tests/generic/115
+++ b/tests/generic/115
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.*
+    rm -f $tmp.* "$TESTDIR"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/159 b/tests/generic/159
index 7944267..369663d 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
- #   rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$TESTDIR1"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/160 b/tests/generic/160
index e8c43df..4dfee12 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
- #   rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$TESTDIR1"
 }
 
 # get standard environment, filters and checks
diff --git a/tests/xfs/129 b/tests/xfs/129
index 6279d69..6fb9bac 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -35,7 +35,7 @@ _cleanup()
 {
     cd /
     umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE"
+    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE" "$TEST_DIR/image"
 }
 
 # get standard environment, filters and checks

