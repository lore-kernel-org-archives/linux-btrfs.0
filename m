Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327AbbDCHD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:27 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372J5h001976
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] btrfs-progs: convert-tests: Add check for converted btrfs with regular file extent.
Date: Fri, 3 Apr 2015 15:01:17 +0800
Message-ID: <1428044477-18485-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for previous patch "btrfs-progs: convert: Make
ext*_image file obey datacsum setting."

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 7652a6c..42cbeb6 100644
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -9,7 +9,6 @@ unset LANG
 LANG=C
 SCRIPT_DIR=$(dirname $(realpath $0))
 TOP=$(realpath $SCRIPT_DIR/../)
-TEST_DEV=${TEST_DEV:-}
 TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
 RESULTS="$TOP/tests/convert-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
@@ -18,6 +17,8 @@ source $TOP/tests/common
 
 rm -f $RESULTS
 
+setup_root_helper
+
 convert_test() {
 	echo "    [TEST]   $1"
 	nodesize=$2
@@ -27,6 +28,13 @@ convert_test() {
 	run_check rm -f $IMAGE
 	run_check truncate -s 256M $IMAGE
 	run_check $* -F $IMAGE
+
+	# create a file to check btrfs-convert can convert regular file
+	# correct
+	run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
+	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
+		count=1 1>/dev/null 2>&1
+	run_check $SUDO_HELPER umount $TEST_MNT
 	run_check $TOP/btrfs-convert -N "$nodesize" $IMAGE
 	run_check $TOP/btrfs check $IMAGE
 }
-- 
2.3.5

