Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57476 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752500AbdIRHWI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:22:08 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 14/14] btrfs-progs: tests/mkfs: Check error handler for rootdir parameter
Date: Mon, 18 Sep 2017 16:21:39 +0900
Message-Id: <20170918072139.6300-15-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Error handlers for the following case must fail gracefully:
1) No permission to read content of rootdir
2) Too small destination file
3) Non-existent destination file
4) Zero sized destination file

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 .../mkfs-tests/011-rootdir-fail-condition/test.sh  | 82 ++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100755 tests/mkfs-tests/011-rootdir-fail-condition/test.sh

diff --git a/tests/mkfs-tests/011-rootdir-fail-condition/test.sh b/tests/mkfs-tests/011-rootdir-fail-condition/test.sh
new file mode 100755
index 00000000..efdb4e9f
--- /dev/null
+++ b/tests/mkfs-tests/011-rootdir-fail-condition/test.sh
@@ -0,0 +1,82 @@
+#!/bin/bash
+#
+# Check if "mkfs.btrfs --rootdir" exit gracefully for different error cases
+
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
+
+prepare_test_dev 128M 
+check_prereq mkfs.btrfs
+check_global_prereq fallocate
+
+no_permission() {
+	local dir_path
+	local bad_file 
+
+	dir_path=$(mktemp --tmpdir --directory btrfs-progs-mkfs-rootdir.XXXXXX)
+	bad_file="$dir_path/no_read_permission"
+
+	echo "    [TEST/mkfs_rootdir]   error handler for -EPERM"
+	echo "creating test dir at $src_dir" >> "$RESULTS"
+
+	run_check fallocate -l 4k "$bad_file"
+	run_check chmod 000 "$bad_file"
+
+	run_mustfail "no permission to read" "$TOP/mkfs.btrfs" \
+		--rootdir "$dir_path" "$TEST_DEV"
+	rm -rf -- "$dir_path"
+}
+
+too_small_dest() {
+	local dir_path
+	local bad_file 
+
+	dir_path=$(mktemp --tmpdir --directory btrfs-progs-mkfs-rootdir.XXXXXX)
+	bad_file="$dir_path/no_space"
+
+	echo "    [TEST/mkfs_rootdir]   error handler for -ENOSPC"
+	echo "creating test dir at $src_dir" >> "$RESULTS"
+
+	run_check fallocate -l 256M "$bad_file"
+
+	run_mustfail "too small destination file" "$TOP/mkfs.btrfs" \
+		--rootdir "$dir_path" "$TEST_DEV"
+	rm -rf -- "$dir_path"
+}
+
+non_existent_dest() {
+	local dir_path
+	local dest_file
+
+	dir_path=$(mktemp --tmpdir --directory btrfs-progs-mkfs-rootdir.XXXXXX)
+	dest_file=$(mktemp --tmpdir btrfs-progs-mkfs-dest-file.XXXX)
+	run_check rm -- "$dest_file"
+
+	echo "    [TEST/mkfs_rootdir]   error handler for non-existent destination file"
+	echo "creating test dir at $src_dir" >> "$RESULTS"
+
+	run_mustfail "non-existent destination file" "$TOP/mkfs.btrfs" \
+		--rootdir "$dir_path" "$dest_file"
+	rm -rf -- "$dir_path"
+}
+
+zero_sized_dest() {
+	local dir_path
+	local dest_file
+
+	dir_path=$(mktemp --tmpdir --directory btrfs-progs-mkfs-rootdir.XXXXXX)
+	dest_file=$(mktemp --tmpdir btrfs-progs-mkfs-dest-file.XXXX)
+
+	echo "    [TEST/mkfs_rootdir]   error handler for zero-sized destination file"
+	echo "creating test dir at $src_dir" >> "$RESULTS"
+
+	run_mustfail "zero-sized destination file" "$TOP/mkfs.btrfs" \
+		--rootdir "$dir_path" "$dest_file"
+	rm -rf -- "$dir_path"
+	rm -- "$dest_file"
+}
+
+no_permission
+too_small_dest
+non_existent_dest
+zero_sized_dest
-- 
2.14.1

