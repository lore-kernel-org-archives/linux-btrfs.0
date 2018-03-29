Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48830 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeC2B06 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 28 Mar 2018 21:26:58 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: tests/mkfs: Test if mkfs.btrfs --rootdir can handle broken soft link well
Date: Thu, 29 Mar 2018 09:26:44 +0800
Message-Id: <20180329012644.17822-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../016-rootdir-bad-symbolic-link/test.sh          | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100755 tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh

diff --git a/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh b/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh
new file mode 100755
index 000000000000..d12efa629042
--- /dev/null
+++ b/tests/mkfs-tests/016-rootdir-bad-symbolic-link/test.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+# Regression test for mkfs.btrfs --rootdir with bad symbolic link
+# (points to non-existing location)
+#
+# Since mkfs.btrfs --rootdir will just create symbolic link other than
+# follow it, we shouldn't hit any problem
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+
+prepare_test_dev
+
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+
+non_existing="/no/such/file"
+
+if [ -f "$non_existing" ]; then
+	# Some smartass don't want to this test case to run
+	_not_run "Some one created $non_exist, which is not expect to exist"
+fi
+
+run_check ln -sf "$non_existing" "$tmp/foobar"
+
+run_check "$TOP/mkfs.btrfs" -f --rootdir "$tmp" "$TEST_DEV"
+run_check "$TOP/btrfs" check "$TEST_DEV"
-- 
2.16.2

