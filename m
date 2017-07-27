Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751113AbdG0Pqs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:46:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04B8CAD6A
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 15:46:47 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/5] btrfs-progs: tests: fix typo in convert-tests/008-readonly-image
Date: Thu, 27 Jul 2017 11:47:22 -0400
Message-Id: <20170727154723.2208-5-jeffm@suse.com>
In-Reply-To: <20170727154723.2208-1-jeffm@suse.com>
References: <20170727154723.2208-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The dd in convert-tests/008-readonly-image is expected to fail, so
there being a typo in the file name has gone unnoticed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 tests/convert-tests/008-readonly-image/test.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
index 27c9373..cc846fa 100755
--- a/tests/convert-tests/008-readonly-image/test.sh
+++ b/tests/convert-tests/008-readonly-image/test.sh
@@ -14,9 +14,10 @@ convert_test_prep_fs $default_mke2fs
 run_check_umount_test_dev
 convert_test_do_convert
 run_check_mount_test_dev
+run_check e2fsck -n "$TEST_MNT/ext2_saved/image"
 
 # It's expected to fail
-$SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/ext2_save/image" bs=1M count=1 \
+$SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/ext2_saved/image" bs=1M count=1 \
 	&> /dev/null
 if [ $? -ne 1 ]; then
 	echo "after convert ext2_save/image is not read-only"
@@ -24,3 +25,4 @@ if [ $? -ne 1 ]; then
 fi
 run_check_umount_test_dev
 convert_test_post_rollback
+
-- 
2.11.0

