Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30012 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbEYJa1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 05:30:27 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t4P9UQfO010173
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:30:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t4P9UQWv002022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:30:26 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t4P9UP6V014954
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:30:26 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 RESEND] Btrfs: add missing free_extent_buffer
Date: Mon, 25 May 2015 17:30:14 +0800
Message-Id: <1432546215-10954-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

read_tree_block may take a reference on the 'eb', a following
free_extent_buffer is necessary.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
This is based on the latest for-linus-4.1.

 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ec3acd..a129254 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7922,6 +7922,7 @@ walk_down:
 			eb = read_tree_block(root, child_bytenr, child_gen);
 			if (!eb || !extent_buffer_uptodate(eb)) {
 				ret = -EIO;
+				free_extent_buffer(eb);
 				goto out;
 			}
 
-- 
2.1.0

