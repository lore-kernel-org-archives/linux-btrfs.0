Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38209 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3IRUsj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 16:48:39 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 70BEA9A0420
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 14:48:39 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: fix set-default test in btrfs/001
Date: Wed, 18 Sep 2013 16:48:27 -0400
Message-ID: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were actually testing this improperly, there was a bug in the set default
code so we weren't actually honoring the 0 subvolid properly.  To fix this we
need to get the subvolid for the subvol we want to set as the default and use
that in the command.  With this patch we now pass again with the fix for the 0
subvolid.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/001 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/btrfs/001 b/tests/btrfs/001
index 9aa2431..c05d772 100755
--- a/tests/btrfs/001
+++ b/tests/btrfs/001
@@ -77,7 +77,8 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-$BTRFS_UTIL_PROG subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
+subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT subvol)
+$BTRFS_UTIL_PROG subvolume set-default $subvolid $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
-- 
1.8.3.1

