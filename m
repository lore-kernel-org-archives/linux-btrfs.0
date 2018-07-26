Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbeGZHym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 03:54:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D40C4AD82
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:39:20 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: Add test image to check if btrfs check reports uninitialized rescan as error
Date: Thu, 26 Jul 2018 14:39:01 +0800
Message-Id: <20180726063901.1252-3-wqu@suse.com>
In-Reply-To: <20180726063901.1252-1-wqu@suse.com>
References: <20180726063901.1252-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../no_rescan_kicked_in.img                     | Bin 0 -> 3072 bytes
 .../fsck-tests/035-rescan-not-kicked-in/test.sh |  16 ++++++++++++++++
 2 files changed, 16 insertions(+)
 create mode 100644 tests/fsck-tests/035-rescan-not-kicked-in/no_rescan_kicked_in.img
 create mode 100755 tests/fsck-tests/035-rescan-not-kicked-in/test.sh

diff --git a/tests/fsck-tests/035-rescan-not-kicked-in/no_rescan_kicked_in.img b/tests/fsck-tests/035-rescan-not-kicked-in/no_rescan_kicked_in.img
new file mode 100644
index 0000000000000000000000000000000000000000..b855a72ff1dd7f629472450a67c27202fb21c628
GIT binary patch
literal 3072
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/035-rescan-not-kicked-in/test.sh b/tests/fsck-tests/035-rescan-not-kicked-in/test.sh
new file mode 100755
index 000000000000..7d632653332f
--- /dev/null
+++ b/tests/fsck-tests/035-rescan-not-kicked-in/test.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+# Under certain power loss case, btrfs quota tree can be initialized but
+# rescan not kicked in. (can be reproduced in low possibility in btrfs/166).
+#
+# This test case is to ensure for such special case, btrfs check doesn't report
+# such qgroup difference as error, thus no false alert for btrfs/166.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_check "$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.18.0

