Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23846 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751418AbdGNHpf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 03:45:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 7570C46B5263
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 15:45:32 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: fsck-test: case for corrupted dir item name
Date: Fri, 14 Jul 2017 15:47:46 +0800
Message-ID: <20170714074746.28177-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170714074746.28177-1-suy.fnst@cn.fujitsu.com>
References: <20170714074746.28177-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In this test case, all name in dir_item, dir_index, inode_ref
are corrupted to another one.
btrfs check should report errors about the corrupted dir_item but
btrfs can't repair the case now.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../fsck-tests/026-bad-dir-item-name/default_case.img.xz | Bin 0 -> 1924 bytes
 tests/fsck-tests/026-bad-dir-item-name/test.sh           |  13 +++++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 tests/fsck-tests/026-bad-dir-item-name/default_case.img.xz
 create mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh

diff --git a/tests/fsck-tests/026-bad-dir-item-name/default_case.img.xz b/tests/fsck-tests/026-bad-dir-item-name/default_case.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..27e8553f103095170420c0e115cab4bc889c2af5
GIT binary patch
literal 1924
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
K000001X)^)|E<>m

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/026-bad-dir-item-name/test.sh b/tests/fsck-tests/026-bad-dir-item-name/test.sh
new file mode 100755
index 00000000..00a550ce
--- /dev/null
+++ b/tests/fsck-tests/026-bad-dir-item-name/test.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+#
+# confirm whether btrfsck supports to check name and hash mismatch in dir_item
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+
+image=$(extract_image "./default_case.img.xz")
+
+run_mustfail "$TOP/btrfs" check "$image"
+
+rm -f "$image"
-- 
2.13.2



