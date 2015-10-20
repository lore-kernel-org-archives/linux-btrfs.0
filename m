Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34505 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbJTLeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 07:34:16 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: btrfs/012: add a regression test for deleting ext2_saved
Date: Tue, 20 Oct 2015 19:34:06 +0800
Message-Id: <1445340846-9774-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs now has changed to delete subvolume/snapshot asynchronously,
which means that after umount, if we've already deleted 'ext2_saved',
rollback can still be completed, which should not.

So this adds a regression test for this.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/012 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/btrfs/012 b/tests/btrfs/012
index d513759..b39dec0 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -112,6 +112,18 @@ diff -r /lib/modules/`uname -r`/ $SCRATCH_MNT/`uname -r`/ 2>&1 | grep -vw "sourc
 
 _scratch_unmount
 
+# Convert it to btrfs, mount it and delete "ext2_saved"
+$BTRFS_CONVERT_PROG $SCRATCH_DEV >> $seqres.full 2>&1 || \
+	_fail "btrfs-convert failed"
+_scratch_mount || _fail "Could not mount new btrfs fs"
+$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/ext2_saved >> $seqres.full 2>&1 ||
+	_fail "failed to delete ext2_saved subvolume"
+_scratch_unmount
+
+# Now restore the ext4 device, expecting a failure
+$BTRFS_CONVERT_PROG -r $SCRATCH_DEV >> $seqres.full 2>&1
+[ $? -eq 1 ] || _fail "Failure is expected, but btrfs-convert returns with rollback complete"
+
 # success, all done
 status=0
 exit
-- 
1.8.2.1

