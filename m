Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:24716 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752268AbdJaIoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 04:44:07 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [RFC PATCH 2/3] btrfs-progs: Set EXEC to TOP when it not be defined
Date: Tue, 31 Oct 2017 16:43:35 +0800
Message-ID: <1509439416-51824-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use EXEC instead of TOP when judge whether where is executable files.
And set EXEC to TOP when it is not defined in top level test script.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/cli-tests.sh     |  2 ++
 tests/common           | 18 ++++++++++++------
 tests/convert-tests.sh |  2 ++
 tests/fsck-tests.sh    |  2 ++
 tests/fuzz-tests.sh    |  2 ++
 tests/misc-tests.sh    |  2 ++
 tests/mkfs-tests.sh    |  2 ++
 7 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/tests/cli-tests.sh b/tests/cli-tests.sh
index 16d6afcf..a3da4886 100755
--- a/tests/cli-tests.sh
+++ b/tests/cli-tests.sh
@@ -5,6 +5,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/cli-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +17,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/common b/tests/common
index dec090fe..692ebfd9 100644
--- a/tests/common
+++ b/tests/common
@@ -236,10 +236,16 @@ run_mustfail()
 	fi
 }
 
+# since btrfs-corrupt-block and fssum is never installed defined in Makefile.
+# check btrfs-corrupt-block and fssum in the TOP direcotry.
 check_prereq()
 {
-	if ! [ -f "$TOP/$1" ]; then
-		_fail "Failed prerequisites: $1";
+	if [ "$1" = "btrfs-corrupt-block" -o "$1" = "fssum" ]; then
+		if ! [ -f "$TOP/$1" ]; then
+			_fail "Failed prerequisites: $TOP/$1";
+		fi
+	elif ! [ -f "$EXEC/$1" ]; then
+		_fail "Failed prerequisites: $EXEC/$1";
 	fi
 }
 
@@ -257,11 +263,11 @@ check_image()
 
 	image=$1
 	echo "testing image $(basename $image)" >> "$RESULTS"
-	"$TOP/btrfs" check "$image" >> "$RESULTS" 2>&1
+	"$EXEC/btrfs" check "$image" >> "$RESULTS" 2>&1
 	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
 
-	run_check "$TOP/btrfs" check --repair "$image"
-	run_check "$TOP/btrfs" check "$image"
+	run_check "$EXEC/btrfs" check --repair "$image"
+	run_check "$EXEC/btrfs" check "$image"
 }
 
 # Extract a usable image from packed formats
@@ -306,7 +312,7 @@ extract_image()
 
 	if ! [ -f "$image.restored" ]; then
 		echo "restoring image $(basename $image)" >> "$RESULTS"
-		"$TOP/btrfs-image" -r "$image" "$image.restored" \
+		"$EXEC/btrfs-image" -r "$image" "$image.restored" \
 			&>> "$RESULTS" \
 			|| _fail "failed to restore image $image" >&2
 	fi
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 2a92a58b..c72b0cd7 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -6,6 +6,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/convert-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -18,6 +19,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 15d26c70..6d1428f9 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -5,6 +5,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/fsck-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +17,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/fuzz-tests.sh b/tests/fuzz-tests.sh
index f72385e5..268949d0 100755
--- a/tests/fuzz-tests.sh
+++ b/tests/fuzz-tests.sh
@@ -5,6 +5,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/fuzz-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +17,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 08988016..99696a47 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -5,6 +5,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/misc-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +17,7 @@ export RESULTS
 export LANG
 export TEST_DEV
 export IMAGE
+export EXEC
 
 rm -f "$RESULTS"
 
diff --git a/tests/mkfs-tests.sh b/tests/mkfs-tests.sh
index c8ff8c83..d85bd4ce 100755
--- a/tests/mkfs-tests.sh
+++ b/tests/mkfs-tests.sh
@@ -5,6 +5,7 @@
 LANG=C
 SCRIPT_DIR=$(dirname $(readlink -f "$0"))
 TOP=$(readlink -f "$SCRIPT_DIR/../")
+test -z $EXEC && EXEC=$TOP
 TEST_DEV=${TEST_DEV:-}
 RESULTS="$TOP/tests/mkfs-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -16,6 +17,7 @@ export RESULTS
 export LANG
 export IMAGE
 export TEST_DEV
+export EXEC
 
 rm -f "$RESULTS"
 
-- 
2.13.6



