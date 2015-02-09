Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6649 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbbBIGLv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 01:11:51 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fsck-test: Add check_sudo to check valid root/sudo privilege
Date: Mon, 9 Feb 2015 14:11:52 +0800
Message-ID: <1423462312-4239-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although fsck-test/012 uses sudo, it uses 'sudo -n', which won't prompt
user to input password and will return 1 if no valid credential is
found.

And this makes test result quite annoying since it fails to mount and
still continue, which will always fail.

This patch introduced the new check_sudo() to check sudo before calling
$sudo. This function will check "sudo -v -n" to get the credential.
And if it fails, then the test will not be run.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common                                 | 18 ++++++++++++++++++
 tests/fsck-tests/012-leaf-corruption/test.sh |  9 +++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/tests/common b/tests/common
index d7d2e9b..56ae0e6 100644
--- a/tests/common
+++ b/tests/common
@@ -62,3 +62,21 @@ setup_root_helper()
 	fi
 	have_root_helper=1
 }
+
+check_sudo()
+{
+	if [ $UID -eq 0 ]; then
+		return 0
+	elif [ $have_root_helper ]; then
+		$sudo -v &> /dev/null
+		return $?
+	else
+		return 1
+	fi
+}
+
+not_run_lack_privlege ()
+{
+	echo "    [NOTRUN] root or valid sudo credential needed"
+	exit 0
+}
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 896f717..7396b05 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -55,12 +55,14 @@ check_inode()
 	name=$5
 
 	# Check whether the inode exists
+	check_sudo || not_run_lack_privlege
 	exists=$($sudo find $path -inum $ino)
 	if [ -z "$exists" ]; then
 		_fail "inode $ino not recovered correctly"
 	fi
 
 	# Check inode type
+	check_sudo || not_run_lack_privlege
 	found_mode=$(printf "%o" 0x$($sudo stat $exists -c %f))
 	if [ $found_mode -ne $mode ]; then
 		echo "$found_mode"
@@ -68,6 +70,7 @@ check_inode()
 	fi
 
 	# Check inode size
+	check_sudo || not_run_lack_privlege
 	found_size=$($sudo stat $exists -c %s)
 	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
 		_fail "inode $ino size not recovered correctly"
@@ -85,15 +88,12 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	if [ $have_root_helper -ne 1 ]; then
-		echo "     [NOTRUN] root privileges needed to verify recovery"
-		exit 0
-	fi
 	if [ -z $TEST_MNT ]; then
 		echo "\$TEST_MNT not set, use $(pwd)/tmp as fallback"
 		TEST_MNT="$(pwd)/tmp"
 	fi
 	mkdir -p $TEST_MNT || _fail "failed to create mount point"
+	check_sudo || not_run_lack_privlege
 	$sudo mount $image -o ro $TEST_MNT
 
 	i=0
@@ -106,6 +106,7 @@ check_leaf_corrupt_no_data_ext()
 			    ${leaf_no_data_ext_list[i + 4]}
 			    ((i+=4))
 	done
+	check_sudo || not_run_lack_privlege
 	$sudo umount $TEST_MNT
 }
 
-- 
2.3.0

