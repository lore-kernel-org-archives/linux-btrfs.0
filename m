Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36470 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbeIXQSS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:18 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] generic/449 fix fs size for _scratch_mkfs_sized for btrfs
Date: Mon, 24 Sep 2018 18:16:32 +0800
Message-Id: <1537784193-24431-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs ~200m to create btrfs with default options like non mixed
block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/449 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/449 b/tests/generic/449
index 88f918654b54..47c219222dde 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -41,7 +41,7 @@ _require_test
 _require_acls
 _require_attrs
 
-_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((200 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount || _fail "mount failed"
 
 TFILE=$SCRATCH_MNT/testfile.$seq
@@ -52,7 +52,7 @@ chmod u+rwx $TFILE
 chmod go-rwx $TFILE
 
 # Try to run out of space so setfacl will fail
-$XFS_IO_PROG -c "pwrite 0 50m" $TFILE >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 200m" $TFILE >>$seqres.full 2>&1
 i=1
 
 # Setting acls on an xfs filesystem will succeed even after running out of
-- 
1.8.3.1
