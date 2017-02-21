Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43534 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751508AbdBUIfJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:35:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 79DDA46701DE
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2017 16:34:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 08/12] btrfs-progs: fsck-test: Add test image for lowmem mode block group false alert
Date: Tue, 21 Feb 2017 16:34:34 +0800
Message-ID: <20170221083438.25719-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a minimal image which can reproduce the block group used space
false alert for lowmem mode fsck.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../block_group_item_false_alert.raw.xz                 | Bin 0 -> 47792 bytes
 tests/fsck-tests/020-extent-ref-cases/test.sh           |  15 +++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/block_group_item_false_alert.raw.xz

diff --git a/tests/fsck-tests/020-extent-ref-cases/block_group_item_false_alert.raw.xz b/tests/fsck-tests/020-extent-ref-cases/block_group_item_false_alert.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..559c3fa9e8491f3ce1f424d1baef29853e8fb889
GIT binary patch
literal 47792
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index c2b6a006..5dc5e55d 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -8,16 +8,23 @@
 # * shared_data_ref
 # * no_inline_ref (a extent item without inline ref)
 # * no_skinny_ref
+#
+# Special check for lowmem regression
+# * block_group_item_false_alert
+#   Containing a block group and its first extent at
+#   the beginning of leaf.
+#   Which caused false alert for lowmem mode.
 
 source $TOP/tests/common
 
 check_prereq btrfs
 
-for img in *.img
+for img in *.img *.raw.xz
 do
 	image=$(extract_image $img)
-	run_check_stdout $TOP/btrfs check "$image" 2>&1 |
-		grep -q "Errors found in extent allocation tree or chunk allocation" &&
-		_fail "unexpected error occurred when checking $img"
+
+	# Since the return value bug is already fixed, we don't need
+	# the old grep hack to detect bug.
+	run_check $TOP/btrfs check "$image"
 	rm -f "$image"
 done
-- 
2.11.1



