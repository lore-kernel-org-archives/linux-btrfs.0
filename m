Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbcF0Hwk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 03:52:40 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id EFADA4056406
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:52:15 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: convert-test: Add test case for discontinuous hole extent
Date: Mon, 27 Jun 2016 15:50:11 +0800
Message-Id: <20160627075011.24330-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160627075011.24330-1-quwenruo@cn.fujitsu.com>
References: <20160627075011.24330-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For ext* fs containing a large hole(larger than 128M), btrfs-convert
will only insert one 128M hole extent and skip the remaining.

This leads to discontinuous file extents.

Add test case for it, and since it's a pinpoint regression test case, no
combination of convert options nor checksum verification.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests/006-large-hole-extent/test.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100755 tests/convert-tests/006-large-hole-extent/test.sh

diff --git a/tests/convert-tests/006-large-hole-extent/test.sh b/tests/convert-tests/006-large-hole-extent/test.sh
new file mode 100755
index 0000000..d3bc093
--- /dev/null
+++ b/tests/convert-tests/006-large-hole-extent/test.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+# Create a base image with large hole extent, then convert to btrfs,
+# check the converted image.
+# Check if btrfs-convert can handle such large hole.
+# Fast pinpoint regression test. No options combination nor checksum
+# verification
+
+source $TOP/tests/common
+source $TOP/tests/common.convert
+
+setup_root_helper
+prepare_test_dev 512M
+check_prereq btrfs-convert
+
+default_mke2fs="mke2fs -t ext4 -b 4096"
+convert_test_preamble '' 'large hole extent test' 16k "$default_mke2fs"
+convert_test_prep_fs $default_mke2fs
+
+run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file bs=1M \
+	count=1 seek=1024 > /dev/null 2>&1
+
+run_check_umount_test_dev
+convert_test_do_convert 
-- 
2.9.0



