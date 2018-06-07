Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38612 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752873AbeFGGtm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 02:49:42 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 3/3] btrfs-progs: fsck-tests: add test case to check symlinks with bad flags
Date: Thu, 7 Jun 2018 14:55:42 +0800
Message-ID: <20180607065542.17273-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
References: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two bad symlinks in the test case.  One is with immutable
attribute.  Another one is with append attribute.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 .../034-bad-inode-flags/default_case.img         | Bin 0 -> 4096 bytes
 tests/fsck-tests/034-bad-inode-flags/test.sh     |  15 +++++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/fsck-tests/034-bad-inode-flags/default_case.img
 create mode 100755 tests/fsck-tests/034-bad-inode-flags/test.sh

diff --git a/tests/fsck-tests/034-bad-inode-flags/default_case.img b/tests/fsck-tests/034-bad-inode-flags/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..beb5e02e37c0af2c838008964538a4e28d442049
GIT binary patch
literal 4096
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
PY1%LE6WAy44<zt6YgYym

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/034-bad-inode-flags/test.sh b/tests/fsck-tests/034-bad-inode-flags/test.sh
new file mode 100755
index 000000000000..4bdc2bf0376c
--- /dev/null
+++ b/tests/fsck-tests/034-bad-inode-flags/test.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+# In order to confirm that 'btrfs check' supports checking symlinks
+# with immutable/append attributes that are not possible to set by standard
+# syscall or ioctl so they're handled as corruption
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
2.17.1



