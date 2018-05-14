Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:61594 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752282AbeENKXg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 06:23:36 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id D9F7B4B3ED6D
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 18:23:29 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: fsck-tests: add test case to check symlinks with odd flags
Date: Mon, 14 May 2018 18:29:22 +0800
Message-ID: <20180514102922.8840-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two bad symlinks in the test case.
One is with immutable attribute.
Another one is with append attribute.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../034-odd-inode-flags/default_case.img         | Bin 0 -> 4096 bytes
 tests/fsck-tests/034-odd-inode-flags/test.sh     |  15 +++++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/fsck-tests/034-odd-inode-flags/default_case.img
 create mode 100755 tests/fsck-tests/034-odd-inode-flags/test.sh

diff --git a/tests/fsck-tests/034-odd-inode-flags/default_case.img b/tests/fsck-tests/034-odd-inode-flags/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..43a2a6f62d5ef3afd77f117b577a56ad6098ed19
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/034-odd-inode-flags/test.sh b/tests/fsck-tests/034-odd-inode-flags/test.sh
new file mode 100755
index 000000000000..2225efb44e0e
--- /dev/null
+++ b/tests/fsck-tests/034-odd-inode-flags/test.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+# In order to confirm that 'btrfs check' supports checking symlinks
+# with immutable/append attributes.
+#
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_mustfail "check should report errors about inode flags" \
+        $SUDO_HELPER "$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.17.0



