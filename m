Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6674 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752796AbdALDxo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 22:53:44 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH v3 3/3] btrfs-progs: fsck-tests/016: lowmem mode check for images
Date: Thu, 12 Jan 2017 11:53:30 +0800
Message-ID: <20170112035330.21376-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170112035330.21376-1-suy.fnst@cn.fujitsu.com>
References: <20170112035330.21376-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since lowmem mode can repair inode nbytes error now, modify this test case
to allow lowmem mode repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
v3: add this patch.
---
 tests/fsck-tests/016-wrong-inode-nbytes/test.sh | 33 +++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 tests/fsck-tests/016-wrong-inode-nbytes/test.sh

diff --git a/tests/fsck-tests/016-wrong-inode-nbytes/test.sh b/tests/fsck-tests/016-wrong-inode-nbytes/test.sh
new file mode 100755
index 0000000..f8466cb
--- /dev/null
+++ b/tests/fsck-tests/016-wrong-inode-nbytes/test.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# check inode nbytes in both normal and lowmem mode
+
+source $TOP/tests/common
+
+check_prereq btrfs
+
+check_image() {
+	local image
+	local image2;
+
+	image=$1
+	image2=$image"_2"
+	cp "$image" "$image2"
+
+	echo "testing image $(basename $image)" >> "$RESULTS"
+	"$TOP/btrfs" check "$image" >> "$RESULTS" 2>&1
+	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
+
+	run_check "$TOP/btrfs" check --repair "$image"
+	run_check "$TOP/btrfs" check "$image"
+
+	echo "testing image $(basename $image2)" >> "$RESULTS"
+	"$TOP/btrfs" check --mode=lowmem "$image2" >> "$RESULTS" 2>&1
+	[ $? -eq 0 ] && _fail "btrfs lowmem check should detected corruption"
+
+	run_check "$TOP/btrfs" check --mode=lowmem --repair "$image2"
+	run_check "$TOP/btrfs" check --mode=lowmem "$image2"
+
+	rm "$image2"
+}
+
+check_all_images
-- 
2.11.0



