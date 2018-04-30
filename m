Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:53113 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbeD3GRV (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 30 Apr 2018 02:17:21 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: Add test case to ensure btrfs check return error for corrupted qgroups
Date: Mon, 30 Apr 2018 14:17:00 +0800
Message-Id: <20180430061700.18498-2-wqu@suse.com>
In-Reply-To: <20180430061700.18498-1-wqu@suse.com>
References: <20180430061700.18498-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the test case uses run_mustfail(), which is pretty easy pass due to
other unexpected problems, so here an extra run_check() is added to
ensure we don't only report qgroup error, but also fix it without
problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../032-corrupted-qgroup/qgroup_corrupted.img | Bin 0 -> 3072 bytes
 tests/fsck-tests/032-corrupted-qgroup/test.sh |  19 ++++++++++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 tests/fsck-tests/032-corrupted-qgroup/qgroup_corrupted.img
 create mode 100755 tests/fsck-tests/032-corrupted-qgroup/test.sh

diff --git a/tests/fsck-tests/032-corrupted-qgroup/qgroup_corrupted.img b/tests/fsck-tests/032-corrupted-qgroup/qgroup_corrupted.img
new file mode 100644
index 0000000000000000000000000000000000000000..a19a303534d419fa7660615d0dcf25ad314e7b20
GIT binary patch
literal 3072
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
M0{wko&HnrGZzc7KcK`qY

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/032-corrupted-qgroup/test.sh b/tests/fsck-tests/032-corrupted-qgroup/test.sh
new file mode 100755
index 000000000000..ccecfeac3ca3
--- /dev/null
+++ b/tests/fsck-tests/032-corrupted-qgroup/test.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# To check if btrfs check can handle valid orphan items.
+# Orphan item is a marker for deleted inodes that were open at the time of
+# deletion.  # Orphan inode/root will is not referenced and will have an orphan
+# item, which should not be reported as error.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_mustfail "btrfs check failed to detect qgroup corruption" \
+		     "$TOP/btrfs" check "$1"
+	# Above command can fail due to other bugs, so add extra safe net to
+	# ensure we can fix qgroup without problem.
+	run_check "$TOP/btrfs" check --repair "$1"
+}
+
+check_all_images
-- 
2.17.0

