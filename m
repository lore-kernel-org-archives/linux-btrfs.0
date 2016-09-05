Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:41407 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932352AbcIETqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 15:46:15 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq1.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bgzYr-0002p8-Fk
        for linux-btrfs@vger.kernel.org; Mon, 05 Sep 2016 21:28:05 +0200
Received: from 31-151-236-204.dynamic.upc.nl ([31.151.236.204] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.82)
        (envelope-from <laks@webminal.org>)
        id 1bgzYh-0005E2-BT
        for linux-btrfs@vger.kernel.org; Mon, 05 Sep 2016 21:28:05 +0200
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id u85JRkHg003098
        for <linux-btrfs@vger.kernel.org>; Mon, 5 Sep 2016 21:27:57 +0200
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id u85JRaO0003091
        for linux-btrfs@vger.kernel.org; Mon, 5 Sep 2016 21:27:36 +0200
Date: Mon, 5 Sep 2016 21:27:36 +0200
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH]btrfs-progs: Post btrfs-convert verify permissions and acls
Message-ID: <20160905192736.GA2999@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/common.convert | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tests/common.convert b/tests/common.convert
index 4e3d49c..67c99b1 100644
--- a/tests/common.convert
+++ b/tests/common.convert
@@ -123,6 +123,38 @@ convert_test_gen_checksums() {
 		count=1 >/dev/null 2>&1
 	run_check_stdout $SUDO_HELPER find $TEST_MNT -type f ! -name 'image' -exec md5sum {} \+ > "$CHECKSUMTMP"
 }
+# list $TEST_MNT data set file permissions.
+# $1: path where the permissions will be stored
+convert_test_perm() {
+	local PERMTMP
+	PERMTMP="$1"
+	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
+
+	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
+		count=1 >/dev/null 2>&1
+	run_check_stdout $SUDO_HELPER find $TEST_MNT -type f ! -name 'image' -fprint $FILES_LIST
+	#Fix directory entries order.
+	sort $FILES_LIST -o $FILES_LIST
+	for file in `cat $FILES_LIST` ;do
+		run_check_stdout $SUDO_HELPER getfacl --absolute-names $file >> "$PERMTMP"
+	done
+	rm $FILES_LIST
+}
+# list acls of files on $TEST_MNT
+# $1: path where the acls will be stored
+convert_test_acl() {
+	local ACLSTMP
+	ACLTMP="$1"
+	FILES_LIST=$(mktemp --tmpdir btrfs-progs-convert.fileslistXXXXXX)
+
+	run_check_stdout $SUDO_HELPER find $TEST_MNT/acls -type f -fprint $FILES_LIST
+	#Fix directory entries order.
+	sort $FILES_LIST -o $FILES_LIST
+	for file in `cat $FILES_LIST`;do
+		run_check_stdout $SUDO_HELPER getfattr --absolute-names -d $file >> "$ACLTMP"
+	done
+	rm $FILES_LIST
+}
 
 # do conversion with given features and nodesize, fsck afterwards
 # $1: features, argument of -O, can be empty
@@ -133,15 +165,68 @@ convert_test_do_convert() {
 	run_check $TOP/btrfs-show-super -Ffa $TEST_DEV
 }
 
+# post conversion check, verify file permissions.
+# $1: file with ext permissions.
+convert_test_post_check_permissions() {
+	local EXT_PERMTMP
+	local BTRFS_PERMTMP
+
+	EXT_PERMTMP="$1"
+	BTRFS_PERMTMP=$(mktemp --tmpdir btrfs-progs-convert.permXXXXXX)
+	convert_test_perm "$BTRFS_PERMTMP"
+
+	btrfs_perm=`md5sum $BTRFS_PERMTMP | cut -f1 -d' '`
+	ext_perm=`md5sum $EXT_PERMTMP | cut -f1 -d' '`
+
+	if [ "$btrfs_perm" != "$ext_perm" ];
+	then
+		btrfs_perm_file=`md5sum $BTRFS_PERMTMP | cut -f2 -d' '`
+		ext_perm_file=`md5sum $EXT_PERMTMP | cut -f2 -d' '`
+		_fail "file permission failed. Mismatched BTRFS:$btrfs_perm_file:$btrfs_perm EXT:$ext_perm_file:$ext_perm"
+	fi
+
+	rm $BTRFS_PERMTMP
+}
+# post conversion check, compare BTRFS file acls against EXT.
+# $1: file with ext acls.
+convert_test_post_check_acl() {
+	local EXT_ACLTMP
+	local BTRFS_ACLTMP
+
+	EXT_ACLTMP="$1"
+	BTRFS_ACLTMP=$(mktemp --tmpdir btrfs-progs-convert.aclsXXXXXXX)
+	convert_test_acl "$BTRFS_ACLTMP"
+
+	btrfs_acl=`md5sum $BTRFS_ACLTMP | cut -f1 -d' '`
+	ext_acl=`md5sum $EXT_ACLTMP | cut -f1 -d' '`
+
+	if [ "$btrfs_acl" != "$ext_acl" ]
+	then
+		btrfs_acl_file=`md5sum $BTRFS_ACLTMP | cut -f2 -d' '`
+		ext_acl_file=`md5sum $EXT_ACLTMP | cut -f2 -d' '`
+		_fail "file acl failed. Mismatched BTRFS:$btrfs_acl_file:$btrfs_acl EXT:$ext_acl_file:$ext_acl"
+	fi
+
+	rm $BTRFS_ACLTMP
+}
 # post conversion checks, verify md5sums
 # $1: file with checksums
+# $2: file with permissions.
+# $3: file with acl entries.
 convert_test_post_check() {
 	local CHECKSUMTMP
+	local EXT_PERMTMP
+	local EXT_ACLTMP
+
 	CHECKSUMTMP="$1"
+	EXT_PERMTMP="$2"
+	EXT_ACLTMP="$3"
 
 	run_check_mount_test_dev
 	run_check_stdout $SUDO_HELPER md5sum -c "$CHECKSUMTMP" |
 		grep -q 'FAILED' && _fail "file validation failed"
+	convert_test_post_check_permissions "$EXT_PERMTMP"
+	convert_test_post_check_acl "$EXT_ACLTMP"
 	run_check_umount_test_dev
 }
 
@@ -161,6 +246,8 @@ convert_test() {
 	local nodesize
 	local msg
 	local CHECKSUMTMP
+	local EXT_PERMTMP
+	local EXT_ACLTMP
 
 	features="$1"
 	msg="$2"
@@ -170,13 +257,19 @@ convert_test() {
 	convert_test_prep_fs "$@"
 	populate_fs
 	CHECKSUMTMP=$(mktemp --tmpdir btrfs-progs-convert.XXXXXXXXXX)
+	EXT_PERMTMP=$(mktemp --tmpdir btrfs-progs-convert.permXXXXXX)
+	EXT_ACLTMP=$(mktemp --tmpdir btrfs-progs-convert.aclsXXXXXXX)
 	convert_test_gen_checksums "$CHECKSUMTMP"
+	convert_test_perm "$EXT_PERMTMP"
+	convert_test_acl "$EXT_ACLTMP"
 
 	run_check_umount_test_dev
 
 	convert_test_do_convert "$features" "$nodesize"
-	convert_test_post_check "$CHECKSUMTMP"
+	convert_test_post_check "$CHECKSUMTMP" "$EXT_PERMTMP" "$EXT_ACLTMP"
 	rm $CHECKSUMTMP
+	rm $EXT_PERMTMP
+	rm $EXT_ACLTMP
 
 	convert_test_post_rollback
 }
-- 
1.9.3

