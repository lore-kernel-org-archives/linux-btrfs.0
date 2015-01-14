Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbbANRZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 12:25:12 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: teests, use the root helper in 012
Date: Wed, 14 Jan 2015 18:25:09 +0100
Message-Id: <1421256309-8559-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need it to mount/umount, to traverse lost+found and stat the results.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/fsck-tests/012-leaf-corruption/test.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index edf77193a08d..896f717a883c 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -55,20 +55,20 @@ check_inode()
 	name=$5
 
 	# Check whether the inode exists
-	exists=$(find $path -inum $ino)
+	exists=$($sudo find $path -inum $ino)
 	if [ -z "$exists" ]; then
 		_fail "inode $ino not recovered correctly"
 	fi
 
 	# Check inode type
-	found_mode=$(printf "%o" 0x$(stat $exists -c %f))
+	found_mode=$(printf "%o" 0x$($sudo stat $exists -c %f))
 	if [ $found_mode -ne $mode ]; then
 		echo "$found_mode"
 		_fail "inode $ino modes not recovered"
 	fi
 
 	# Check inode size
-	found_size=$(stat $exists -c %s)
+	found_size=$($sudo stat $exists -c %s)
 	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
 		_fail "inode $ino size not recovered correctly"
 	fi
@@ -85,8 +85,8 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	if [ $UID -ne 0 ]; then
-		echo "     [NOTRUN] verify recovery. need root privilege"
+	if [ $have_root_helper -ne 1 ]; then
+		echo "     [NOTRUN] root privileges needed to verify recovery"
 		exit 0
 	fi
 	if [ -z $TEST_MNT ]; then
@@ -94,7 +94,7 @@ check_leaf_corrupt_no_data_ext()
 		TEST_MNT="$(pwd)/tmp"
 	fi
 	mkdir -p $TEST_MNT || _fail "failed to create mount point"
-	mount $image -o ro $TEST_MNT
+	$sudo mount $image -o ro $TEST_MNT
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
@@ -106,9 +106,11 @@ check_leaf_corrupt_no_data_ext()
 			    ${leaf_no_data_ext_list[i + 4]}
 			    ((i+=4))
 	done
-	umount $TEST_MNT
+	$sudo umount $TEST_MNT
 }
 
+setup_root_helper
+
 generate_leaf_corrupt_no_data_ext test.img
 check_image test.img
 check_leaf_corrupt_no_data_ext test.img
-- 
2.1.3

