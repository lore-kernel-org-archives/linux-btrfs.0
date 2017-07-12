Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34373 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGLUFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 16:05:32 -0400
Received: by mail-pg0-f43.google.com with SMTP id t186so18135914pgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 13:05:32 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] btrfs-progs: Use '-t btrfs' mount option in tests.
Date: Wed, 12 Jul 2017 13:05:22 -0700
Message-Id: <20170712200522.18830-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without it, mount (at least from util-linux 2.20.1) tries (and
fails) to mount some filesystems as NTFS.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 tests/common                                 | 2 +-
 tests/fsck-tests/012-leaf-corruption/test.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index 7ad436e..bed6009 100644
--- a/tests/common
+++ b/tests/common
@@ -387,7 +387,7 @@ run_check_mount_test_dev()
 		_fail "Invalid \$TEST_MNT: $TEST_MNT"
 	}
 
-	run_check $SUDO_HELPER mount $loop_opt "$@" "$TEST_DEV" "$TEST_MNT"
+	run_check $SUDO_HELPER mount -t btrfs $loop_opt "$@" "$TEST_DEV" "$TEST_MNT"
 }
 
 run_check_umount_test_dev()
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 43b0e6d..fc10a4f 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -90,7 +90,7 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	$SUDO_HELPER mount -o loop "$image" -o ro "$TEST_MNT"
+	$SUDO_HELPER mount -o loop -t btrfs "$image" -o ro "$TEST_MNT"
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
-- 
2.13.2.932.g7449e964c-goog

