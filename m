Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29645 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbbH1Dpe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 23:45:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7S3jPWA010434
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 11:45:25 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests: Add testcase filter for misc-tests
Date: Fri, 28 Aug 2015 11:43:56 +0800
Message-ID: <09dc1a986fea9d55b40095632d1efd8f4c050730.1440733418.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add testcase filter for misc-tests, so we can select to run necessary
test cases.

For example:
 # ./misc-tests.sh 002
    [TEST]   002-uuid-rewrite
 #
 # ./misc-tests.sh subvolume
    [TEST]   007-subvolume-sync
 #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/misc-tests.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 1ed8850..f9c1152 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -12,6 +12,8 @@ TEST_MNT=${TEST_MNT:-$TOP/tests/mnt}
 RESULTS="$TOP/tests/misc-tests-results.txt"
 IMAGE="$TOP/tests/test.img"
 
+TEST_FILTER="$1"
+
 source $TOP/tests/common
 
 # Allow child test to use $TOP and $RESULTS
@@ -35,7 +37,7 @@ check_prereq btrfs
 # The tests are driven by their custom script called 'test.sh'
 
 for i in $(find $TOP/tests/misc-tests -maxdepth 1 -mindepth 1 -type d	\
-	${TEST:+-name "$TEST"} | sort)
+	${TEST:+-name "$TEST"} | sort | grep -e "$TEST_FILTER")
 do
 	echo "    [TEST]   $(basename $i)"
 	cd $i
-- 
1.8.5.1

