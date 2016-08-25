Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31551 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1757633AbcHYFZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 01:25:16 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs-progs: tests: add 021-partially-dropped-snapshot-case
Date: Thu, 25 Aug 2016 13:21:01 +0800
Message-Id: <20160825052101.25864-3-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
References: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 .../dropped-snapshot.img                              | Bin 0 -> 24576 bytes
 .../021-partially-dropped-snapshot-case/test.sh       |  18 ++++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 tests/fsck-tests/021-partially-dropped-snapshot-case/dropped-snapshot.img
 create mode 100755 tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh

diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/dropped-snapshot.img b/tests/fsck-tests/021-partially-dropped-snapshot-case/dropped-snapshot.img
new file mode 100644
index 0000000000000000000000000000000000000000..345ef41980d04f988ff1eb44e14c3cf3eaa34454
GIT binary patch
literal 24576
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
new file mode 100755
index 0000000..eb8d884
--- /dev/null
+++ b/tests/fsck-tests/021-partially-dropped-snapshot-case/test.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+# confirm whether btrfsck supports to check a partially dropped snapshot
+
+source $TOP/tests/common
+
+check_prereq btrfs
+
+for img in *.img
+do
+	image=$(extract_image $img)
+	run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+		grep -q "Errors found in extent allocation tree or chunk allocation"
+	if [ $? -eq 0 ]; then
+		rm -f "$image"
+		_fail "unexpected error occurred when checking $img"
+	fi
+	rm -f "$image"
+done
-- 
2.9.0



