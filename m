Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37976 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbeAJE5E (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 9 Jan 2018 23:57:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH 2/2] btrfs-progs: mkfs-tests: Add test case to check if the first device extent is occupying reserved 0~1M range
Date: Wed, 10 Jan 2018 12:56:48 +0800
Message-Id: <20180110045648.3239-2-wqu@suse.com>
In-Reply-To: <20180110045648.3239-1-wqu@suse.com>
References: <20180110045648.3239-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../mkfs-tests/010-reserved-1M-for-single/test.sh  | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 tests/mkfs-tests/010-reserved-1M-for-single/test.sh

diff --git a/tests/mkfs-tests/010-reserved-1M-for-single/test.sh b/tests/mkfs-tests/010-reserved-1M-for-single/test.sh
new file mode 100755
index 000000000000..1a4936eaf72e
--- /dev/null
+++ b/tests/mkfs-tests/010-reserved-1M-for-single/test.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+# Test if "-m single" or "-M" can cause dev extent to use reserved 1M range
+#
+# Other profiles will cause mkfs.btrfs to allocate new meta/sys chunks
+# using btrfs_alloc_chunk() which won't use 0~1M range, so other profiles
+# are safe.
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+prepare_test_dev
+
+do_one_test ()
+{
+	run_check "$TOP/mkfs.btrfs" -f $@ "$TEST_DEV"
+
+	# Use dev-extent tree to find first device extent
+	first_dev_extent=$(run_check_stdout "$TOP/btrfs" inspect-internal \
+		dump-tree -t device "$TEST_DEV" | \
+		grep -oP '(?<=DEV_EXTENT )[[:digit:]]*' | head -n1)
+
+	if [ -z $first_dev_extent ]; then
+		_fail "Failed to get first device extent"
+	fi
+
+	echo "First dev extent starts at $first_dev_extent" >> "$RESULTS"
+	echo "Reserved range is [0, $(( 1024 * 1024)))" >> "$RESULTS"
+	# First device extent should not start below 1M
+	if [ $first_dev_extent -lt $(( 1024 * 1024 )) ]; then
+		_fail "First device extent occupies reserved 0~1M range"
+	fi
+}
+
+do_one_test "-M"
+do_one_test "-m single"
-- 
2.15.1

