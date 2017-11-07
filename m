Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43889 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933669AbdKGInZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 12/12] btrfs-progs: test/mkfs: Add test case for --rootdir and -R quota
Date: Tue,  7 Nov 2017 16:42:59 +0800
Message-Id: <20171107084259.22367-16-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nothing interesting, since such combination can be handled easily by
qgroup-verify.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/010-rootdir-and-quota/test.sh | 51 ++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100755 tests/mkfs-tests/010-rootdir-and-quota/test.sh

diff --git a/tests/mkfs-tests/010-rootdir-and-quota/test.sh b/tests/mkfs-tests/010-rootdir-and-quota/test.sh
new file mode 100755
index 000000000000..3dae1e8a2068
--- /dev/null
+++ b/tests/mkfs-tests/010-rootdir-and-quota/test.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# Check if runtime feature quota can handle rootdir
+#
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper		# For mknod
+prepare_test_dev 1G		# make it large since we will fill the fs
+
+# mknod can create FIFO/CHAR/BLOCK file but not SOCK.
+# No neat tool to create socket file, unless using python or similar.
+# So no SOCK is tested here
+check_global_prereq mknod
+check_global_prereq dd
+
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+
+run_check mkdir "$tmp/dir"
+run_check mkdir -p "$tmp/dir/in/dir"
+
+# More dir, there is no good way to pump metadata since we have no trigger
+# to enable/disable inline extent data, so here create enough dirs to bump
+# metadata
+run_check mkdir "$tmp/a_lot_of_dirs"
+for i in $(seq -w 0 8192); do
+	run_check mkdir "$tmp/a_lot_of_dirs/dir_$i"
+done
+
+# Then some data
+run_check dd if=/dev/zero bs=1M count=1 of="$tmp/1M"
+run_check dd if=/dev/zero bs=2M count=1 of="$tmp/2M"
+run_check dd if=/dev/zero bs=4M count=1 of="$tmp/4M"
+run_check dd if=/dev/zero bs=8M count=1 of="$tmp/8M"
+
+run_check dd if=/dev/zero bs=1K count=1 of="$tmp/1K"
+run_check dd if=/dev/zero bs=2K count=1 of="$tmp/2K"
+run_check dd if=/dev/zero bs=4K count=1 of="$tmp/4K"
+run_check dd if=/dev/zero bs=8K count=1 of="$tmp/8K"
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -r "$tmp" -R quota "$TEST_DEV"
+
+rm -rf -- "$tmp"
+
+# Normal check already includes quota check
+run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+
+# Just in case
+run_check $SUDO_HELPER "$TOP/btrfs" check --qgroup-report "$TEST_DEV"
-- 
2.15.0

