Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46972 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932242AbeCMB4n (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:43 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 6/7] btrfs-progs: test/convert: Add test case for invalid large inline data extent
Date: Tue, 13 Mar 2018 09:56:15 +0800
Message-Id: <20180313015616.6574-7-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../016-invalid-large-inline-extent/test.sh        | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100755 tests/convert-tests/016-invalid-large-inline-extent/test.sh

diff --git a/tests/convert-tests/016-invalid-large-inline-extent/test.sh b/tests/convert-tests/016-invalid-large-inline-extent/test.sh
new file mode 100755
index 000000000000..f37c7c09d2e7
--- /dev/null
+++ b/tests/convert-tests/016-invalid-large-inline-extent/test.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# Check if btrfs-convert refuses to rollback the filesystem, and leave the fs
+# and the convert image untouched
+
+source "$TEST_TOP/common"
+source "$TEST_TOP/common.convert"
+
+setup_root_helper
+prepare_test_dev
+check_prereq btrfs-convert
+check_global_prereq mke2fs
+
+convert_test_prep_fs ext4 mke2fs -t ext4 -b 4096
+
+# Create a 6K file, which should not be inlined
+run_check $SUDO_HELPER dd if=/dev/zero bs=2k count=3 of="$TEST_MNT/file1"
+
+run_check_umount_test_dev
+
+# convert_test_do_convert() will call btrfs check, which should expose any
+# invalid inline extent with too large size
+convert_test_do_convert
-- 
2.16.2

