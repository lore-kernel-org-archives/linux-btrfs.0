Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65520 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdIRHgJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:36:09 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3.1 11/14] btrfs-progs: tests/mkfs: Add basic test case for rootdir parameter
Date: Mon, 18 Sep 2017 16:35:59 +0900
Message-Id: <20170918073559.6446-1-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-12-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-12-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new test case to check if "--rootdir" option of mkfs.btrfs can
handle the file content, perrmission and xattr correctly.

The new test case reuses the convert facility, and looks just like
convert-tests/001-ext2-basic.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
changelog:
v3.1:
    Cleanup the temporary rootdir directory.
---
 tests/mkfs-tests/010-basic-rootdir/test.sh | 79 ++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100755 tests/mkfs-tests/010-basic-rootdir/test.sh

diff --git a/tests/mkfs-tests/010-basic-rootdir/test.sh b/tests/mkfs-tests/010-basic-rootdir/test.sh
new file mode 100755
index 00000000..49f9b860
--- /dev/null
+++ b/tests/mkfs-tests/010-basic-rootdir/test.sh
@@ -0,0 +1,79 @@
+#!/bin/bash
+# Check basic operations for "mkfs.btrfs --rootdir", including:
+# 1)	Checksum, permission and acl
+#	Should be consistent with source directory
+# 2)	Failure condition
+# 2.1)  Non-existent file/block as destination
+# 2.2)	Too small destination file
+# 2.3)  No privilege to read source directory
+#	All failure condition should fail, but without segfault/backtrace
+
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
+
+setup_root_helper
+prepare_test_dev 512M
+check_prereq mkfs.btrfs
+check_global_prereq dd
+check_global_prereq sed
+
+# Since our test dir will be in /tmp, which is nowadays tmpfs for most
+# distributions, and tmpfs xattr doesn't support user xattr, here we
+# use a special populate_fs() which won't create user xattr.
+#
+# Don't worry, both acl and user xattr is implemented by xattr in btrfs,
+# so "acls" should cover the case.
+populate_tmpfs() {
+	_assert_path "$1"
+
+        for dataset_type in 'small' 'hardlink' 'fast_symlink' 'brokenlink' 'perm' 'sparse' 'acls' 'fifo' 'slow_symlink'; do
+		generate_dataset "$dataset_type" "$1"
+	done
+}
+
+# Basic content checker for difference nodesize/features
+content_test() {
+	local features
+	local nodesize
+	local src_dir
+	local csum_tmp 
+	local perm_tmp 
+	local acl_tmp
+
+	features="$1"
+	nodesize="$2"
+	src_dir=$(mktemp --tmpdir --directory btrfs-progs-mkfs-rootdir.XXXXXXX)
+
+	echo "    [TEST/mkfs_rootdir]   nodesize=$nodesize" "${features:-defaults}"
+	echo "creating test dir at $src_dir" >> "$RESULTS"
+
+	populate_tmpfs "$src_dir"
+	csum_tmp=$(mktemp --tmpdir btrfs-progs-convert.XXXXXXXXXX)
+	perm_tmp=$(mktemp --tmpdir btrfs-progs-convert.permXXXXXX)
+	acl_tmp=$(mktemp --tmpdir btrfs-progs-convert.aclsXXXXXXX)
+	convert_test_gen_checksums "$csum_tmp" "$src_dir"
+	convert_test_perm "$perm_tmp" "$src_dir"
+	convert_test_acl "$acl_tmp" "$src_dir"
+
+	run_check "$TOP/mkfs.btrfs" ${1:+-O "$1"} ${2:+-n "$2"} \
+		"--rootdir" "$src_dir" "$TEST_DEV"
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+	run_check_mount_test_dev
+	convert_test_post_check_checksums "$csum_tmp"
+	convert_test_post_check_permissions "$perm_tmp"
+	convert_test_post_check_acl "$acl_tmp"
+	run_check_umount_test_dev
+
+	rm -- "$csum_tmp"
+	rm -- "$perm_tmp"
+	rm -- "$acl_tmp"
+	run_check $SUDO_HELPER rm -rf -- "$src_dir"
+}
+
+for feature in '' 'extref' 'skinny-metadata' 'no-holes'; do
+	content_test "$feature" 4096
+	content_test "$feature" 8192
+	content_test "$feature" 16384
+	content_test "$feature" 32768
+	content_test "$feature" 65536
+done
-- 
2.14.1

