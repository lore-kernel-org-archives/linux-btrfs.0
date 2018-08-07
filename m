Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbeHGKdP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:15 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16EC0ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:20:02 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/11] btrfs-progs: test/mkfs: Add test case for --rootdir and --quota
Date: Tue,  7 Aug 2018 16:19:38 +0800
Message-Id: <20180807081938.21348-12-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nothing interesting, since such combination can be handled easily by
qgroup-verify.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../mkfs-tests/018-rootdir-with-quota/test.sh | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100755 tests/mkfs-tests/018-rootdir-with-quota/test.sh

diff --git a/tests/mkfs-tests/018-rootdir-with-quota/test.sh b/tests/mkfs-tests/018-rootdir-with-quota/test.sh
new file mode 100755
index 000000000000..97e5f592ade4
--- /dev/null
+++ b/tests/mkfs-tests/018-rootdir-with-quota/test.sh
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
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f -r "$tmp" -Q "$TEST_DEV"
+
+rm -rf -- "$tmp"
+
+# Normal check already includes quota check
+run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+
+# Just in case
+run_check $SUDO_HELPER "$TOP/btrfs" check --qgroup-report "$TEST_DEV"
-- 
2.18.0

