Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:41686 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbeCTGmp (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 20 Mar 2018 02:42:45 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 6/6] btrfs-progs: test/mkfs: Add test case for rootdir inline extent size
Date: Tue, 20 Mar 2018 14:42:29 +0800
Message-Id: <20180320064229.31493-7-wqu@suse.com>
In-Reply-To: <20180320064229.31493-1-wqu@suse.com>
References: <20180320064229.31493-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a test case for mkfs --rootdir, using files with different file
sizes to check if invalid large inline extent could exist.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/014-rootdir-inline-extent/test.sh | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100755 tests/mkfs-tests/014-rootdir-inline-extent/test.sh

diff --git a/tests/mkfs-tests/014-rootdir-inline-extent/test.sh b/tests/mkfs-tests/014-rootdir-inline-extent/test.sh
new file mode 100755
index 000000000000..167ced1e4987
--- /dev/null
+++ b/tests/mkfs-tests/014-rootdir-inline-extent/test.sh
@@ -0,0 +1,47 @@
+#!/bin/bash
+# Regression test for mkfs.btrfs --rootdir with inline file extents
+# For any large inline file extent, btrfs check could already report it
+
+source "$TEST_TOP/common"
+
+check_global_prereq fallocate
+check_prereq mkfs.btrfs
+
+prepare_test_dev
+
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+
+pagesize=$(getconf PAGESIZE)
+create_file()
+{
+	local size=$1
+	# Reuse size as filename
+	run_check fallocate -l $size "$tmp/$size"
+}
+
+test_mkfs_rootdir()
+{
+	nodesize=$1
+	run_check "$TOP/mkfs.btrfs" --nodesize $nodesize -f --rootdir "$tmp" \
+		"$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+}
+
+# Use power of 2 from 512 to 64K (maximum node size) as base file size
+for i in 512 1024 2048 4096 8192 16384 32768; do
+	create_file $(($i - 102))
+	# 101 is the overhead size for max inline extent
+	create_file $(($i - 101))
+	create_file $(($i - 100))
+
+	create_file $(($i - 1))
+	create_file $i
+	create_file $(($i + 1))
+done
+
+for nodesize in 4096 8192 16384 32768 65536; do
+	if [ $nodesize -ge $pagesize ]; then
+		test_mkfs_rootdir $nodesize
+	fi
+done
+rm -rf -- "$tmp"
-- 
2.16.2

