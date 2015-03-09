Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbbCILd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 07:33:28 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: tests, clean up scripts
Date: Mon,  9 Mar 2015 12:33:25 +0100
Message-Id: <1425900805-11010-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename variables, use caps, call true by full path, add quotation to
variables and a few wording fixes.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/common                                 | 43 ++++++++++++++--------------
 tests/fsck-tests/012-leaf-corruption/test.sh | 10 +++----
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/tests/common b/tests/common
index ccdadd5f248e..a35d438efe8f 100644
--- a/tests/common
+++ b/tests/common
@@ -57,26 +57,26 @@ check_all_images()
 # some tests need to mount the recovered image and do verifications call
 # 'setup_root_helper' and then check for have_root_helper == 1 if the test
 # needs to fail otherwise; using sudo by default for now
-_sudo=
-need_validate=-1
-export _sudo
-export need_validate
+SUDO_HELPER=
+NEED_SUDO_VALIDATE=unknown
+export SUDO_HELPER
+export NEED_SUDO_VALIDATE
 root_helper()
 {
 	if [ $UID -eq 0 ]; then
-		$*
+		"$@"
 	else
-		if [ $need_validate -eq 1 ]; then
-			sudo -v -n &> /dev/null || \
-				_not_run "Need validate sudo credential"
-			sudo -n $*
-		elif [ $need_validate -eq 0 ]; then
-			sudo -n true  &> /dev/null || \
-				_not_run "Need validate sudo user setting"
-			sudo -n $*
+		if [ "$NEED_SUDO_VALIDATE" = 'yes' ]; then
+			sudo -v -n &>/dev/null || \
+				_not_run "Need to validate sudo credentials"
+			sudo -n "$@"
+		elif [ "$NEED_SUDO_VALIDATE" = 'no' ]; then
+			sudo -n /bin/true &> /dev/null || \
+				_not_run "Need to validate sudo user settings"
+			sudo -n "$@"
 		else
 			# should not happen
-			_not_run "Need validate root privilege"
+			_not_run "Need to validate root privileges"
 		fi
 	fi
 }
@@ -86,15 +86,16 @@ setup_root_helper()
 	if [ $UID -eq 0 ]; then
 		return
 	fi
-	# Test for old sudo or special setting, which makes sudo -v fails even
-	# user is set NOPASSWD
-	sudo -n true &> /dev/null && need_validate=0
+
+	# Test for old sudo or special settings, which make sudo -v fail even
+	# if user setting is NOPASSWD
+	sudo -n /bin/true &>/dev/null && NEED_SUDO_VALIDATE=no
 
 	# Newer sudo or default sudo setting
-	sudo -v -n &> /dev/null && need_validate=1
+	sudo -v -n &>/dev/null && NEED_SUDO_VALIDATE=yes
 
-	if [ $need_validate -eq -1 ]; then
-		_not_run "Need validate root privilege"
+	if [ "$NEED_SUDO_VALIDATE" = 'yes' ]; then
+		_not_run "Need to validate root privileges"
 	fi
-	_sudo=root_helper
+	SUDO_HELPER=root_helper
 }
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 5873e3fb42e3..8f82fd164d1d 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -55,20 +55,20 @@ check_inode()
 	name=$5
 
 	# Check whether the inode exists
-	exists=$($_sudo find $path -inum $ino)
+	exists=$($SUDO_HELPER find $path -inum $ino)
 	if [ -z "$exists" ]; then
 		_fail "inode $ino not recovered correctly"
 	fi
 
 	# Check inode type
-	found_mode=$(printf "%o" 0x$($_sudo stat $exists -c %f))
+	found_mode=$(printf "%o" 0x$($SUDO_HELPER stat $exists -c %f))
 	if [ $found_mode -ne $mode ]; then
 		echo "$found_mode"
 		_fail "inode $ino modes not recovered"
 	fi
 
 	# Check inode size
-	found_size=$($_sudo stat $exists -c %s)
+	found_size=$($SUDO_HELPER stat $exists -c %s)
 	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
 		_fail "inode $ino size not recovered correctly"
 	fi
@@ -90,7 +90,7 @@ check_leaf_corrupt_no_data_ext()
 		TEST_MNT="$(pwd)/tmp"
 	fi
 	mkdir -p $TEST_MNT || _fail "failed to create mount point"
-	$_sudo mount $image -o ro $TEST_MNT
+	$SUDO_HELPER mount $image -o ro $TEST_MNT
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
@@ -102,7 +102,7 @@ check_leaf_corrupt_no_data_ext()
 			    ${leaf_no_data_ext_list[i + 4]}
 			    ((i+=4))
 	done
-	$_sudo umount $TEST_MNT
+	$SUDO_HELPER umount $TEST_MNT
 }
 
 setup_root_helper
-- 
2.1.3

