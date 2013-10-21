Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37964 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3JUQFS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 12:05:18 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4B2C59A06B0
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 10:05:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: use -F for mkfs.ext4 in btrfs/012
Date: Mon, 21 Oct 2013 12:05:16 -0400
Message-ID: <1382371516-13720-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed this test was hanging because mkfs.ext4 wanted to make sure it was ok
to mkfs an entire device.  We need -F so it doesn't ask this question.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/012 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/012 b/tests/btrfs/012
index de90149..f7e5da5 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -65,7 +65,7 @@ _require_command $E2FSCK_PROG e2fsck
 rm -f $seqres.full
 
 # Create & populate an ext4 filesystem
-$MKFS_EXT4_PROG -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
+$MKFS_EXT4_PROG -F -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
 	_notrun "Could not create ext4 filesystem"
 # Manual mount so we don't use -t btrfs or selinux context
 mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
-- 
1.8.3.1

