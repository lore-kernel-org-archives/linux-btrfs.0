Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:39528 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbdK2JQd (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:33 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 7/9] btrfs-progs: tests/mkfs: Introduce test case to check if mkfs rootdir can create new file
Date: Wed, 29 Nov 2017 17:16:02 +0800
Message-Id: <20171129091604.2194-8-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To test regression 460e93f25754 ("btrfs-progs: mkfs: check the status of file at
mkfs").

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/011-rootdir-create-file/test.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100755 tests/mkfs-tests/011-rootdir-create-file/test.sh

diff --git a/tests/mkfs-tests/011-rootdir-create-file/test.sh b/tests/mkfs-tests/011-rootdir-create-file/test.sh
new file mode 100755
index 000000000000..c6f3d74da885
--- /dev/null
+++ b/tests/mkfs-tests/011-rootdir-create-file/test.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+# Regression test for mkfs.btrfs --rootdir on non-exist file
+# Designed behavior is, it should create a new file if destination doesn't exist
+# Regression 460e93f25754 ("btrfs-progs: mkfs: check the status of file at mkfs")
+
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+run_check "$TOP/mkfs.btrfs" -f -r "$TOP/Documentation/" $tmp/new_file
+
+rm -rf -- "$tmp"
-- 
2.15.0

