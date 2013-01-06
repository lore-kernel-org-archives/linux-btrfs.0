Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47295 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3AFDkh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 22:40:37 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r063eZ58011974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 03:40:36 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r063eYlG017125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 03:40:35 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r063eY4m009265
	for <linux-btrfs@vger.kernel.org>; Sat, 5 Jan 2013 21:40:34 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use right range to find checksum for compressed extents
Date: Sun,  6 Jan 2013 11:38:22 +0800
Message-Id: <1357443502-380-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For compressed extents, the range of checksum is covered by disk length,
and the disk length is different with ram length, so we need to use disk
length instead to get us the right checksum.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 83186c7..0a3cd61 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3357,6 +3357,11 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	if (skip_csum)
 		return 0;
 
+	if (em->compress_type) {
+		csum_offset = 0;
+		csum_len = block_len;
+	}
+
 	/* block start is already adjusted for the file extent offset. */
 	ret = btrfs_lookup_csums_range(log->fs_info->csum_root,
 				       em->block_start + csum_offset,
-- 
1.7.7.6

