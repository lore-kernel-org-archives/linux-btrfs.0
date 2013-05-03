Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55333 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934180Ab3ECULi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 16:11:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 196157C041B
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 14:11:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: unmount scratch mnt in test 307
Date: Fri, 3 May 2013 16:11:35 -0400
Message-ID: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So if you have a mount command that doesn't use /etc/mtab then it will spit out
a different device for the mounted device.  So say we have

SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc"

we will turn this into

SCRATCH_DEV="/dev/sda"
SCRATCH_DEV_POOL="/dev/sdb /dev/sdc"

and then when you mkfs this you do _scratch_mkfs $SCRATCH_DEV_POOL which turns
into this

mkfs.btrfs /dev/sdb /dev/sdc /dev/sda

becuase we do

mkfs $* $SCRATCH_DEV

Then btrfs will always show the lowest devid in /proc/mounts to maintain
consistency, so even though we do mount /dev/sda $SCRATCH_MNT, you will see
/dev/sdb as the mounted device in /proc/mounts.  So then say the next test wants
to just use $SCRATCH_DEV, it will do _require_scratchdev which will check to see
if $SCRATCH_DEV is mounted, which it will look like it is not because
/proc/mounts shows /dev/sdb instead of /dev/sda, and so it won't umount
$SCRATCH_MNT, and then that test will fail because we can't mkfs the device
because it is busy.  I reproduced this on a box that doesn't use /etc/mtab by
doing

./check btrfs/307 generic/015

and 015 would fail.  With this patch it passes now.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/307 |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/307 b/tests/btrfs/307
index 87314c6..15157b3 100644
--- a/tests/btrfs/307
+++ b/tests/btrfs/307
@@ -35,6 +35,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
+    umount $SCRATCH_MNT
 }
 
 # get standard environment, filters and checks
-- 
1.7.7.6

