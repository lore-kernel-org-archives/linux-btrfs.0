Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34931 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759927AbdEWICT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 04:02:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstests: common: Make _test_mount to include MOUNT_OPTIONS to allow consistent _test_cycle_mount
Date: Tue, 23 May 2017 16:02:05 +0800
Message-ID: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
If using MOUNT_OPTIONS="-o nodatasum" and btrfs to run genierc/142
generic/143 and generic/154, it will cause false alert like:
cp: failed to clone '/mnt/test/test-154/file2' from '/mnt/test/test-154/file1': Invalid argument

[REASON]
It is caused by _test_cycle_mount function, which unmount test device,
but when trying to re-mount it again using _test_mount(), we don't pass
$MOUNT_OPTIONS.

So this makes mount options differs between _test_cycle_mount().

And btrfs doesn't allow different csum flags between reflink source and
destination inodes, so it returns -EINVAL for reflink operation.

[FIX]
Fix it by passing $MOUNT_OPTIONS to _test_mount(), so that
_test_cycle_mount() won't cause different mount options.
So btrfs with "-o nodatasum" mount option can pass generic/14[23]
and generic/154 without false alert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/rc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index ba215961..a591907c 100644
--- a/common/rc
+++ b/common/rc
@@ -522,7 +522,8 @@ _test_mount()
         return $?
     fi
     _test_options mount
-    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
+    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS \
+		$MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
 }
 
 _test_unmount()
-- 
2.13.0



