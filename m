Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbeEGHsj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 03:48:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2A77CAE95
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 07:48:38 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: misc-tests: Add test case for dump-tree on heavily corrupted leaf
Date: Mon,  7 May 2018 15:46:28 +0800
Message-Id: <20180507074628.1563-2-wqu@suse.com>
In-Reply-To: <20180507074628.1563-1-wqu@suse.com>
References: <20180507074628.1563-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../032-bad-item-ptr/bad_item_ptr.raw.xz       | Bin 0 -> 21964 bytes
 tests/misc-tests/032-bad-item-ptr/test.sh      |  17 +++++++++++++++++
 2 files changed, 17 insertions(+)
 create mode 100644 tests/misc-tests/032-bad-item-ptr/bad_item_ptr.raw.xz
 create mode 100755 tests/misc-tests/032-bad-item-ptr/test.sh

diff --git a/tests/misc-tests/032-bad-item-ptr/bad_item_ptr.raw.xz b/tests/misc-tests/032-bad-item-ptr/bad_item_ptr.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..7cf2e89f443c626ad4947901bf659d5377278b3e
GIT binary patch
literal 21964
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
ABLDyZ

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/032-bad-item-ptr/test.sh b/tests/misc-tests/032-bad-item-ptr/test.sh
new file mode 100755
index 000000000000..3a73b7bb36f5
--- /dev/null
+++ b/tests/misc-tests/032-bad-item-ptr/test.sh
@@ -0,0 +1,17 @@
+#!/bin/bash
+#
+# Verify that btrfs inspect dump-tree won't segfault on heavily corrupted
+# tree leaf
+# Issue: #128
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_check "$TOP/btrfs" inspect dump-tree "$1"
+	run_mustfail "btrfs check failed to detect such corruption" \
+		  "$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.17.0

