Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbcEQDsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:48:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: tests: add 020-bad-free-space-cache
Date: Tue, 17 May 2016 11:47:58 +0800
Message-Id: <1463456878-17550-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

To test if fsck can detect and clear free space cache error

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../020-bad-free-space-cache/default_case.raw.xz       | Bin 0 -> 164068 bytes
 tests/fsck-tests/020-bad-free-space-cache/test.sh      |  16 ++++++++++++++++
 2 files changed, 16 insertions(+)
 create mode 100644 tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz
 create mode 100755 tests/fsck-tests/020-bad-free-space-cache/test.sh

diff --git a/tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz b/tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..5e08de426c5cc5faa9ccd430432b9c37f4e072ff
GIT binary patch
literal 164068
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
B&L#i=

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-bad-free-space-cache/test.sh b/tests/fsck-tests/020-bad-free-space-cache/test.sh
new file mode 100755
index 0000000..8524d2a
--- /dev/null
+++ b/tests/fsck-tests/020-bad-free-space-cache/test.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+source $TOP/tests/common
+
+check_prereq btrfs
+
+image=$(extract_image "./default_case.raw.xz")
+run_check_stdout $TOP/btrfs check "$image" |\
+	grep -q "csum mismatch on free space cache" ||\
+	_fail "btrfs check didn't detect free space cache error"
+run_check $TOP/btrfs check --clear-space-cache "$image"
+run_check_stdout $TOP/btrfs check "$image" 2>&1 |
+	grep -q "csum mismatch on free space cache" &&
+	_fail "unexpected error message in the output"
+
+rm -f "$image"
-- 
2.8.2



