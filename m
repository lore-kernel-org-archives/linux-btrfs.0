Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27885 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbbIWHUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:20:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8N7KSsp027990
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 15:20:28 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/3] btrfs-progs: tests: Introduce misc-tests/008-leaf-across-stripes
Date: Wed, 23 Sep 2015 15:19:06 +0800
Message-ID: <2b9521b025a849e20411d5390d176bd3664291bf.1442992715.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
References: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To check is btrfs-convert create bad filesystem with
leaf across stripes.

It is happened in progs version <=v4.1.2, and fixed by patch titled:
btrfs: convert: Avoid allocating metadata extent crossing stripe boundary
which was merged in v4.2.

Notice thar this testcase can not report error in old version of
btrfs-progs, because "btrfs check" can't check this type of error
in those version, but we have another testcase in fsck-tests, to
check is "btrfs check" support this check.

So, use above 2 testcase together can check out leaf-across-stripes
bug in all version.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/misc-tests/008-leaf-across-stripes/test.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100755 tests/misc-tests/008-leaf-across-stripes/test.sh

diff --git a/tests/misc-tests/008-leaf-across-stripes/test.sh b/tests/misc-tests/008-leaf-across-stripes/test.sh
new file mode 100755
index 0000000..cd426a9
--- /dev/null
+++ b/tests/misc-tests/008-leaf-across-stripes/test.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+# test btrfs-convert create filesystem without leaf across stripes
+
+source $TOP/tests/common
+
+check_prereq btrfs-convert
+check_prereq btrfs
+
+# In my test, it happened in 514M~560M, 737M~769M, 929M~917M,
+# and HAVE_ERROR=((size + 1) / 2) % 2 if size >= 970
+#
+SIZE_FROM=514
+SIZE_END=560
+A_PRIME_NUM=17
+for ((size = SIZE_FROM; size <= SIZE_END; size += A_PRIME_NUM)); do
+	run_check truncate -s "$size"M "$IMAGE"
+	run_check mkfs.ext4 -F "$IMAGE"
+	run_check $TOP/btrfs-convert "$IMAGE"
+	$TOP/btrfs check "$IMAGE" 2>&1 | grep "crossing stripe boundary" &&
+		_fail "leaf across stripes in btrfs-convert"
+done
+
+exit 0
-- 
1.8.5.1

