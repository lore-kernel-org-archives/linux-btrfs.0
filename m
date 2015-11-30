Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39908 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751555AbbK3Blt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 20:41:49 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 3A5B44043CFB
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 09:41:34 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: mkfs-tests: Check sectorsize and nodesize combination
Date: Mon, 30 Nov 2015 09:39:30 +0800
Message-Id: <1448847570-9549-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add mkfs selftest for invalid and valid sectorsize/nodesize
combination.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../008-secorsize-nodesize-combination/test.sh     | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100755 tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh

diff --git a/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh b/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh
new file mode 100755
index 0000000..5bc3a48
--- /dev/null
+++ b/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# test variant sectorsize and node size combination
+# including valid ones and invalid ones
+# only do mkfs and fsck check, no mounting check as
+# sub/multi-pagesize is not supported yet.
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+# disable mixed bg to avoid sectorsize == nodesize check
+features="^mixed-bg"
+image_size=1g
+image=image
+
+# caller need to judge whether the combination is valid
+do_test()
+{
+	sectorsize=$1
+	nodesize=$2
+	truncate -s $image_size $image
+	run_mayfail $TOP/mkfs.btrfs -O $features -n $nodesize -s $sectorsize \
+		$image
+	ret=$?
+	if [ $ret == 0 ]; then
+		run_check $TOP/btrfs check $image
+	fi
+	return $ret
+}
+
+# Invalid: Unaligned sectorsize and nodesize
+do_test 8191 8191 && _fail
+
+# Invalid: Aligned sectorsize with unaligned nodesize
+do_test 4k 16385 && _fail
+
+# Invalid: Ungliend sectorsize with aligned nodesize
+do_test 8191 16k && _fail
+
+# Valid: Aligned sectorsize and nodesize
+do_test 4k 16k || _fail
+
+# Invalid: Sectorsize larger than nodesize
+do_test 8k 4k && _fail
+
+# Invalid: too large nodesize
+do_test 16k 128k && _fail
+
+# Valid: large sectorsize
+do_test 64k 64k || _fail
-- 
2.6.2



