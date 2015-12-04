Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34779 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbLDIRK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 03:17:10 -0500
Received: by pfbg73 with SMTP id g73so23333627pfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 00:17:09 -0800 (PST)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Naohiro Aota <naota@elisp.net>
Subject: [PATCH 1/3] btrfs-progs: test: umount if confirmation failed
Date: Fri,  4 Dec 2015 14:37:25 +0900
Message-Id: <1449207447-1203-2-git-send-email-naota@elisp.net>
In-Reply-To: <1449207447-1203-1-git-send-email-naota@elisp.net>
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a check in check_inode() failed, the test should umount test target
file system. This commit add clean up umount line in failure path.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 tests/fsck-tests/012-leaf-corruption/test.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 6e23145..bfdd0ea 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -57,6 +57,7 @@ check_inode()
 	# Check whether the inode exists
 	exists=$($SUDO_HELPER find $path -inum $ino)
 	if [ -z "$exists" ]; then
+		$SUDO_HELPER umount $TEST_MNT
 		_fail "inode $ino not recovered correctly"
 	fi
 
@@ -64,17 +65,20 @@ check_inode()
 	found_mode=$(printf "%o" 0x$($SUDO_HELPER stat $exists -c %f))
 	if [ $found_mode -ne $mode ]; then
 		echo "$found_mode"
+		$SUDO_HELPER umount $TEST_MNT
 		_fail "inode $ino modes not recovered"
 	fi
 
 	# Check inode size
 	found_size=$($SUDO_HELPER stat $exists -c %s)
 	if [ $mode -ne 41700 -a $found_size -ne $size ]; then
+		$SUDO_HELPER umount $TEST_MNT
 		_fail "inode $ino size not recovered correctly"
 	fi
 
 	# Check inode name
 	if [ "$(basename $exists)" != "$name" ]; then
+		$SUDO_HELPER umount $TEST_MNT
 		_fail "inode $ino name not recovered correctly"
 	else
 		return 0
-- 
2.6.3

