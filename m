Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53294 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754066AbdIEBYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 21:24:23 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: test/mkfs: Add test case for rootdir parameter
Date: Tue,  5 Sep 2017 10:24:15 +0900
Message-Id: <20170905012415.26687-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test case which checks if -r|--rootdir mount option can handle
softlink/char/block/fifo files.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
changelog:
v2:
  Use mktemp instead of $$
  Use default test device size
  Remove unnecessary global prereq for basic tools like mkdir
  Put option before parameter for rm command
  All suggested by David.
---
 .../009-special-files-for-rootdir/test.sh          | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100755 tests/mkfs-tests/009-special-files-for-rootdir/test.sh

diff --git a/tests/mkfs-tests/009-special-files-for-rootdir/test.sh b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
new file mode 100755
index 00000000..3cf91dee
--- /dev/null
+++ b/tests/mkfs-tests/009-special-files-for-rootdir/test.sh
@@ -0,0 +1,36 @@
+#!/bin/bash
+# Check if --rootdir can handle special files (socket/fifo/char/block) correctly
+#
+# --rootdir had a problem of filling dir items/indexes with wrong type
+# and caused btrfs check to report such error
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper		# For mknod
+prepare_test_dev
+
+# mknod can create FIFO/CHAR/BLOCK file but not SOCK.
+# No neat tool to create socket file, unless using python or similar.
+# So no SOCK is tested here
+check_global_prereq mknod
+
+# Also check regular file
+check_global_prereq dd
+
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+
+run_check mkdir $tmp/dir
+run_check mkdir -p $tmp/dir/in/dir
+run_check mknod $tmp/fifo p
+run_check $SUDO_HELPER mknod $tmp/char c 1 1
+run_check $SUDO_HELPER mknod $tmp/block b 1 1
+run_check dd if=/dev/zero bs=1M count=1 of=$tmp/regular
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -r "$tmp" $TEST_DEV
+
+rm -rf "$tmp"
+
+run_check $SUDO_HELPER "$TOP/btrfs" check $TEST_DEV
-- 
2.14.1

