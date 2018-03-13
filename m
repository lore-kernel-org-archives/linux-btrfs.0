Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:39101 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932435AbeCMB4n (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:43 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 7/7] btrfs-progs: test/mkfs: Add test case for rootdir inline extent size
Date: Tue, 13 Mar 2018 09:56:16 +0800
Message-Id: <20180313015616.6574-8-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a test case for mkfs --rootdir, using files with different file
sizes to check if invalid large inline extent could exist.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/014-rootdir-inline-extent/test.sh | 81 ++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100755 tests/mkfs-tests/014-rootdir-inline-extent/test.sh

diff --git a/tests/mkfs-tests/014-rootdir-inline-extent/test.sh b/tests/mkfs-tests/014-rootdir-inline-extent/test.sh
new file mode 100755
index 000000000000..e0765b0bc4e2
--- /dev/null
+++ b/tests/mkfs-tests/014-rootdir-inline-extent/test.sh
@@ -0,0 +1,81 @@
+#!/bin/bash
+# Regression test for mkfs.btrfs --rootdir with inline file extents
+# For any large inline file extent, btrfs check could already report it
+
+source "$TOP/tests/common"
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
+	# Reuse size and filename
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
+# File sizes is designed to cross differnet node size, so even
+# the sectorsize is not 4K, we can still test it well.
+create_file 512
+create_file 1024
+create_file 2048
+
+create_file 3994
+create_file 3995	# For 4K node size, max inline would be 4k - 101
+create_file 3996
+
+create_file 4095
+create_file 4096
+create_file 4097
+
+create_file 8090
+create_file 8091
+create_file 8092
+
+create_file 8191
+create_file 8192
+create_file 8193
+
+create_file 16282
+create_file 16283
+create_file 16284
+
+create_file 16383
+create_file 16384
+create_file 16385
+
+create_file 32666
+create_file 32667
+create_file 32668
+
+create_file 32767
+create_file 32768
+create_file 32769
+
+create_file 65434
+create_file 65435
+create_file 65436
+
+create_file 65535
+create_file 65536
+create_file 65537
+
+for nodesize in 4096 8192 16384 32768 65536; do
+	if [ $nodesize -ge $pagesize ]; then
+		test_mkfs_rootdir $nodesize
+	fi
+done
+rm -rf -- "$tmp"
-- 
2.16.2

