Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53821 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdIRHWB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:22:01 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 10/14] btrfs-progs: tests/common: Make checksum, permission and acl check path independent
Date: Mon, 18 Sep 2017 16:21:35 +0900
Message-Id: <20170918072139.6300-11-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

convert_test_gen_checksums(), convert_test_perm() and convert_test_acl()
all uses absolute path, which is good enough for convert test.

However for "mkfs --rootdir" test, we want all above function to use
relative path, making the output path independent.

This patch modified all these functions by:
1) Adding new optional parameter to specify destination directory
   Callers and corresponding checkers also get this new optional parameter
2) Changing directory before generate files list/csum file
   And return to old pwd after work is done.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 tests/common.convert | 91 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 8 deletions(-)

diff --git a/tests/common.convert b/tests/common.convert
index 45174b7e..8a36cba3 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -93,45 +93,92 @@ convert_test_prep_fs() {
 
 # generate md5 checksums of files on $TEST_MNT
 # $1: path where the checksums will be stored
+# $2: (optional) destination directory if we're not using $TEST_MNT
 convert_test_gen_checksums() {
+	local dir_path
+	local csum_file
+	local saved_pwd
+
 	_assert_path "$1"
+	csum_file="$1"
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
 
-	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/test" "bs=$nodesize" \
+	run_check $SUDO_HELPER dd if=/dev/zero of="$dir_path/test" "bs=$nodesize" \
 		count=1 >/dev/null 2>&1
-	run_check_stdout $SUDO_HELPER find "$TEST_MNT" -type f ! -name 'image' -exec md5sum {} \+ > "$1"
+
+	# We change directory into destination, so generated md5sum file won't
+	# include absolute path, making the result path independent.
+	saved_pwd="$(pwd)"
+	run_check cd "$dir_path"
+	run_check_stdout $SUDO_HELPER find . -type f ! -name 'image' -exec md5sum {} \+ \
+		> "$csum_file"
+	run_check cd "$saved_pwd"
 }
+
 # list $TEST_MNT data set file permissions.
 # $1: path where the permissions will be stored
+# $2: (optional) destination directory if we're not using $TEST_MNT
 convert_test_perm() {
 	local PERMTMP
+	local saved_pwd
+	local dir_path
 
 	_assert_path "$1"
 	PERMTMP="$1"
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
 	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
 
-	run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/test" "bs=$nodesize" \
+	run_check $SUDO_HELPER dd if=/dev/zero of="$dir_path/test" "bs=$nodesize" \
 		count=1 >/dev/null 2>&1
-	run_check_stdout $SUDO_HELPER find "$TEST_MNT" -type f ! -name 'image' -fprint "$FILES_LIST"
+
+	# Same as convert_test_gen_checksums(), make output path independent
+	saved_pwd="$(pwd)"
+	run_check cd "$dir_path"
+	run_check_stdout $SUDO_HELPER find . -type f ! -name 'image' -fprint "$FILES_LIST"
 	# Fix directory entries order
 	sort "$FILES_LIST" -o "$FILES_LIST"
 	for file in `cat "$FILES_LIST"` ;do
 		run_check_stdout $SUDO_HELPER getfacl --absolute-names "$file" >> "$PERMTMP"
 	done
+	run_check cd "$saved_pwd"
 	rm -- "$FILES_LIST"
 }
+
 # list acls of files on $TEST_MNT
 # $1: path where the acls will be stored
+# $2: (optional) destination directory if we're not using $TEST_MNT
 convert_test_acl() {
 	local ACLSTMP
+	local dir_path
+	local saved_pwd
+
+	_assert_path "$1"
 	ACLTMP="$1"
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
 	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
 
-	run_check_stdout $SUDO_HELPER find "$TEST_MNT/acls" -type f -fprint "$FILES_LIST"
+	# Make find result and later getfattr output path independent
+	saved_pwd="$(pwd)"
+	run_check cd "$dir_path"
+	run_check_stdout $SUDO_HELPER find "./acls" -type f -fprint "$FILES_LIST"
 	# Fix directory entries order
 	sort "$FILES_LIST" -o "$FILES_LIST"
 	for file in `cat "$FILES_LIST"`;do
 		run_check_stdout $SUDO_HELPER getfattr --absolute-names -d "$file" >> "$ACLTMP"
 	done
+	run_check cd "$saved_pwd"
 	rm -- "$FILES_LIST"
 }
 
@@ -149,11 +196,18 @@ convert_test_do_convert() {
 convert_test_post_check_permissions() {
 	local EXT_PERMTMP
 	local BTRFS_PERMTMP
+	local dir_path
+	local saved_pwd
 
 	_assert_path "$1"
 	EXT_PERMTMP="$1"
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
 	BTRFS_PERMTMP=$(mktemp --tmpdir btrfs-progs-convert.permXXXXXX)
-	convert_test_perm "$BTRFS_PERMTMP"
+	convert_test_perm "$BTRFS_PERMTMP" "$dir_path"
 
 	btrfs_perm=`md5sum "$BTRFS_PERMTMP" | cut -f1 -d' '`
 	ext_perm=`md5sum "$EXT_PERMTMP" | cut -f1 -d' '`
@@ -162,7 +216,7 @@ convert_test_post_check_permissions() {
 	then
 		btrfs_perm_file=`md5sum "$BTRFS_PERMTMP" | cut -f2 -d' '`
 		ext_perm_file=`md5sum "$EXT_PERMTMP" | cut -f2 -d' '`
-		_fail "file permission failed. Mismatched BTRFS:$btrfs_perm_file:$btrfs_perm EXT:$ext_perm_file:$ext_perm"
+		_fail "file permission failed. Mismatched AFTER:$btrfs_perm_file:$btrfs_perm BEFORE:$ext_perm_file:$ext_perm"
 	fi
 
 	rm -- "$BTRFS_PERMTMP"
@@ -172,11 +226,17 @@ convert_test_post_check_permissions() {
 convert_test_post_check_acl() {
 	local EXT_ACLTMP
 	local BTRFS_ACLTMP
+	local dir_path
 
 	_assert_path "$1"
 	EXT_ACLTMP="$1"
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
 	BTRFS_ACLTMP=$(mktemp --tmpdir btrfs-progs-convert.aclsXXXXXXX)
-	convert_test_acl "$BTRFS_ACLTMP"
+	convert_test_acl "$BTRFS_ACLTMP" "$dir_path"
 
 	btrfs_acl=`md5sum "$BTRFS_ACLTMP" | cut -f1 -d' '`
 	ext_acl=`md5sum "$EXT_ACLTMP" | cut -f1 -d' '`
@@ -193,9 +253,24 @@ convert_test_post_check_acl() {
 
 # post conversion checks, verify md5sums
 convert_test_post_check_checksums() {
+	local dir_path
+	local csum_file
+
 	_assert_path "$1"
+	csum_file="$1"
+
+	if [ -z "$2" ]; then
+		dir_path="$TEST_MNT"
+	else
+		dir_path="$2"
+	fi
+
+	# csum file is generated using relative path, change directory
+	saved_pwd="$(pwd)"
+	run_check cd $dir_path
 	run_check_stdout $SUDO_HELPER md5sum -c "$1" |
 		grep -q 'FAILED' && _fail "file validation failed"
+	run_check cd $saved_pwd
 }
 
 # post conversion checks, all three in one call, on an unmounted image
-- 
2.14.1

