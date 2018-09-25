Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeIYKaS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:18 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 8/9] generic/449 fix fs size for _scratch_mkfs_sized for btrfs
Date: Tue, 25 Sep 2018 12:24:21 +0800
Message-Id: <1537849462-619-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs 256m to create btrfs with default options like non mixed
block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/449 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/449 b/tests/generic/449
index 88f918654b54..21b920bf6a50 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -41,7 +41,7 @@ _require_test
 _require_acls
 _require_attrs
 
-_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount || _fail "mount failed"
 
 TFILE=$SCRATCH_MNT/testfile.$seq
@@ -52,7 +52,7 @@ chmod u+rwx $TFILE
 chmod go-rwx $TFILE
 
 # Try to run out of space so setfacl will fail
-$XFS_IO_PROG -c "pwrite 0 50m" $TFILE >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 256m" $TFILE >>$seqres.full 2>&1
 i=1
 
 # Setting acls on an xfs filesystem will succeed even after running out of
-- 
1.8.3.1
