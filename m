Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33068 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752379AbdDKDZJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:09 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1277247CE23B
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:06 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs-progs: fsck-check: Allow fsck check test to repair in lowmem mode for certain test cases
Date: Tue, 11 Apr 2017 11:26:30 +0800
Message-ID: <20170411032631.24932-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Since lowmem mode can repair certain corruptions (mostly in fs tree),
insert a beacon into each fsck test cases to allow some of them be
tested for lowmem mode.

With this patch, fsck option override will check the beacon file
".lowmem_repairbale" in the same directory of the test image, and if the
beacon exists, then it will also run lowmem mode repair to repair the
image.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common.local | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/common.local b/tests/common.local
index 4f56bb08..af372f16 100644
--- a/tests/common.local
+++ b/tests/common.local
@@ -15,11 +15,23 @@ TEST_ARGS_CHECK=--mode=lowmem
 # gets arguments of a current command and can decide if the argument insertion
 # should happen, eg. if some option combination does not make sense or would
 # break tests
+#
+# Return 0 if we need to skip option override
+# Return 1 if we don't need to skip option override
 _skip_spec()
 {
+	beacon=.lowmem_repairable
+
+	# For loemem repair, only support fs tree repair yet
+	# So we place lowmem repair beacon in the same dir of the
+	# test case
 	if echo "$TEST_ARGS_CHECK" | grep -q 'mode=lowmem' &&
 	   echo "$@" | grep -q -- '--repair'; then
-		return 0
+		dir="$(dirname ${@: -1})"
+		if [ -f ${dir}/${beacon} ]; then
+			return 1;
+		fi
+		return 0;
 	fi
 	return 1
 }
-- 
2.12.0



