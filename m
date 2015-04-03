Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49036 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751059AbbDCHDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372IUU001970
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] btrfs-progs: fsck-tests: Add fallback TEST_DEV for test case 013
Date: Fri, 3 Apr 2015 15:01:15 +0800
Message-ID: <1428044477-18485-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add fallback TEST_DEV for test case 013.
Fallback to $TOP/tests/test.img.

Now all test cases of btrfs-progs need no extra setting except sudo.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/fsck-tests/013-extent-tree-rebuild/test.sh b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
index 7453ed7..e05a035 100755
--- a/tests/fsck-tests/013-extent-tree-rebuild/test.sh
+++ b/tests/fsck-tests/013-extent-tree-rebuild/test.sh
@@ -6,8 +6,13 @@ check_prereq btrfs-debug-tree
 setup_root_helper
 
 if [ -z $TEST_DEV ]; then
-	echo "    [NOTRUN] extent tree rebuild, need TEST_DEV variant"
-	exit 0
+	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
+		$RESULTS
+	TEST_DEV="$TOP/tests/test.img"
+
+	# Need at least 1G to avoid mixed block group, which extent tree
+	# rebuild doesn't support.
+	run_check truncate -s 1G $TEST_DEV
 fi
 
 if [ -z $TEST_MNT ];then
-- 
2.3.5

