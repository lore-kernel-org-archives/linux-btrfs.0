Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbeIXQSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] generic/015 fix to test the default non-mixed mode
Date: Mon, 24 Sep 2018 18:16:26 +0800
Message-Id: <1537784193-24431-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 97575acd7495 (generic/015: Change the test filesystem size to
101mb), created 101mb FS instead of 100mb FS to make sure we create
a FS which is non mixed mode, which is our default mode.

btrfs-progs commit 18e2663db3e1 (btrfs-progs: Add minimum device size
check) added a more accurate minimum required space to create the btrfs
FS in non mixed mode. Which is at 14294784 bytes.

So this patch changes the FS size to be created by _scratch_sized_mkfs
to 200mb so that we create the FS in non mixed mode.

To test mixed blockgroup its better we set it using the MKFS_OPTIONS
explicitly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/015 | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tests/generic/015 b/tests/generic/015
index 0f4d29800f4f..14941ab6d552 100755
--- a/tests/generic/015
+++ b/tests/generic/015
@@ -37,11 +37,10 @@ _supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
 
-# With filesystems less than 100mb btrfs is created in mixed mode
-# which can lead to slight accounting errors of 1mb. Having the
-# fs be at least 101 mb ensures those errors are within the error
-# tolerance of 1%
-_scratch_mkfs_sized `expr 101 \* 1024 \* 1024` >/dev/null 2>&1 \
+# With filesystems less than ~200mb _scratch_mkfs_sized will create
+# data and metadata mixed mode btrfs, so use 200mb so that we test
+# the default btrfs.
+_scratch_mkfs_sized $((200 * 1024 * 1024)) >> $seqres.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount
 out=$SCRATCH_MNT/fillup.$$
-- 
1.8.3.1
