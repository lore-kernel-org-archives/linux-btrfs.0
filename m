Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57682 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3GBTRV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 15:17:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 20C527C0692
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jul 2013 13:17:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: make the scratch device for generic/256 slightly larger
Date: Tue, 2 Jul 2013 15:17:18 -0400
Message-ID: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is similar to a previous fix I sent.  1 gig makes us do mixed file block
groups for btrfs, so these enospc tests will usually fail because we don't have
space for metadata, which is the case for this test.  So jack the size up to
1.5gig so that btrfs can do its normal thing and pass the test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/256 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/256 b/tests/generic/256
index 4a53da8..cfe7237 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -165,7 +165,7 @@ _test_full_fs_punch()
 
 # Make a small file system to fill
 umount $SCRATCH_DEV &> /dev/null
-_scratch_mkfs_sized $(( 1024 * 1024 * 1024 )) &> /dev/null
+_scratch_mkfs_sized $(( 1536 * 1024 * 1024 )) &> /dev/null
 _scratch_mount
 # Test must be able to write files with non-root permissions
 chmod 777 $SCRATCH_MNT
-- 
1.7.7.6

