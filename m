Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32509 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592AbcGULWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 07:22:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u6LBFT6v013088
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 04:22:18 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
	by m0089730.ppops.net with ESMTP id 24aneqj817-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 04:22:18 -0700
Received: from facebook.com (2401:db00:2040:5012:face:0:1:0)	by
 mx-out.facebook.com (10.212.236.89) with ESMTP	id
 625a3c0e4f3511e68c820002c95209d8-9fbecaf0 for <linux-btrfs@vger.kernel.org>;
	Thu, 21 Jul 2016 04:22:18 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix delalloc accounting after copy_from_user faults
Date: Thu, 21 Jul 2016 04:22:18 -0700
Message-ID: <1469100138-2611860-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 56244ef151c3cd11 was almost but not quite enough to fix the
reservation math after btrfs_copy_from_user returned partial copies.

Some users are still seeing warnings in btrfs_destroy_inode, and with a
long enough test run I'm able to trigger them as well.

This patch fixes the accounting math again, bringing it much closer to
the way it was before the sectorsize conversion Chandan did.  The
problem is accounting for the offset into the page/sector when we do a
partial copy.  This one just uses the dirty_sectors variable which
should already be updated properly.

Signed-off-by: Chris Mason <clm@fb.com>
cc: stable@vger.kernel.org # v4.6+
---
 fs/btrfs/file.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f3f61d1..bcfb4a2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1629,13 +1629,11 @@ again:
 		 * managed to copy.
 		 */
 		if (num_sectors > dirty_sectors) {
-			/*
-			 * we round down because we don't want to count
-			 * any partial blocks actually sent through the
-			 * IO machines
-			 */
-			release_bytes = round_down(release_bytes - copied,
-				      root->sectorsize);
+
+			/* release everything except the sectors we dirtied */
+			release_bytes -= dirty_sectors <<
+				root->fs_info->sb->s_blocksize_bits;
+
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
-- 
2.8.0.rc2

