Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10927 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781AbbCBDnw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Mar 2015 22:43:52 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs-progs: fsck-test: Add check_sudo to check valid root/sudo privilege
Date: Mon, 2 Mar 2015 11:41:50 +0800
Message-ID: <1425267710-416-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although fsck-test/012 uses sudo, it uses 'sudo -n', which won't prompt
user to input password and will return 1 if no valid credential is
found.

And this makes test result quite annoying since it fails to mount and
still continue, which will always fail.

This patch will check 'sudo -v -n' and 'sudo -n true' to determine
whether sudo works fine in different version/settings, since in some
setting/version, 'sudo -v -n' will fail even the user is set NOPASSWD.

Also, remove the 'have_root_helper' variant, since there is a
possibility that sudo credential will timeout during the test and
'have_root_helper' won't help to detect such problem.
New '_sudo' command will do credential check if needed to avoid such
problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add support for old sudo.
  Remove 'have_root_helper' variant
  Integrate 'check_root' into root_helper function.

Cc: David Sterba <dsterba@suse.cz>
Since I can't reproduce the NOPASSWD setting with 'sudo -v -n' failure,
so only UID==0 and need_validate==1 case, would you please test the
need_validate==0 case? 
---
 tests/common                                 | 50 ++++++++++++++++++++++++----
 tests/fsck-tests/012-leaf-corruption/test.sh | 14 +++-----
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/tests/common b/tests/common
index d7d2e9b..ccdadd5 100644
--- a/tests/common
+++ b/tests/common
@@ -9,6 +9,12 @@ _fail()
 	exit 1
 }
 
+_not_run()
+{
+	echo "    [NOTRUN] $*"
+	exit 0
+}
+
 run_check()
 {
 	echo "############### $@" >> $RESULT 2>&1
@@ -51,14 +57,44 @@ check_all_images()
 # some tests need to mount the recovered image and do verifications call
 # 'setup_root_helper' and then check for have_root_helper == 1 if the test
 # needs to fail otherwise; using sudo by default for now
-sudo=
-have_root_helper=0
-export sudo
-export have_root_helper
+_sudo=
+need_validate=-1
+export _sudo
+export need_validate
+root_helper()
+{
+	if [ $UID -eq 0 ]; then
+		$*
+	else
+		if [ $need_validate -eq 1 ]; then
+			sudo -v -n &> /dev/null || \
+				_not_run "Need validate sudo credential"
+			sudo -n $*
+		elif [ $need_validate -eq 0 ]; then
+			sudo -n true  &> /dev/null || \
+				_not_run "Need validate sudo user setting"
+			sudo -n $*
+		else
+			# should not happen
+			_not_run "Need validate root privilege"
+		fi
+	fi
+}
+
 setup_root_helper()
 {
-	if [ $UID != 0 ]; then
-		sudo="sudo --non-interactive"
+	if [ $UID -eq 0 ]; then
+		return
+	fi
+	# Test for old sudo or special setting, which makes sudo -v fails even
+	# user is set NOPASSWD
+	sudo -n true &> /dev/null && need_validate=0
+
+	# Newer sudo or default sudo setting
+	sudo -v -n &> /dev/null && need_validate=1
+
+	if [ $need_validate -eq -1 ]; then
+		_not_run "Need validate root privilege"
 	fi
-	have_root_helper=1
+	_sudo=root_helper
 }
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 896f717..5873e3f 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -55,20 +55,20 @@ check_inode()
 	name=$5
 
 	# Check whether the inode exists
-	exists=$($sudo find $path -inum $ino)
+	exists=$($_sudo find $path -inum $ino)
 	if [ -z "$exists" ]; then
 		_fail "inode $ino not recovered correctly"
 	fi
 
 	# Check inode type
-	found_mode=$(printf "%o" 0x$($sudo stat $exists -c %f))
+	found_mode=$(printf "%o" 0x$($_sudo stat $exists -c %f))
 	if [ $found_mode -ne $mode ]; then
 		echo "$found_mode"
 		_fail "inode $ino modes not recovered"
 	fi
 
 	# Check inode size
-	found_size=$($sudo stat $exists -c %s)
+	found_size=$($_sudo stat $exists -c %s)
 	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
 		_fail "inode $ino size not recovered correctly"
 	fi
@@ -85,16 +85,12 @@ check_inode()
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
-	$sudo mount $image -o ro $TEST_MNT
+	$_sudo mount $image -o ro $TEST_MNT
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
@@ -106,7 +102,7 @@ check_leaf_corrupt_no_data_ext()
 			    ${leaf_no_data_ext_list[i + 4]}
 			    ((i+=4))
 	done
-	$sudo umount $TEST_MNT
+	$_sudo umount $TEST_MNT
 }
 
 setup_root_helper
-- 
2.3.0

