Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27753 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbEYJQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 05:16:52 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t4P9GoBs005694
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:16:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t4P9GnqE031550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:16:50 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t4P9GnOt027505
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015 09:16:49 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add missing free_extent_buffer
Date: Mon, 25 May 2015 17:16:40 +0800
Message-Id: <1432545400-31871-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

read_tree_block may take a reference on the 'eb', a following
free_extent_buffer is necessary.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b353ad..bb8a221 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7649,6 +7649,7 @@ walk_down:
 			eb = read_tree_block(root, child_bytenr, child_gen);
 			if (!eb || !extent_buffer_uptodate(eb)) {
 				ret = -EIO;
+				free_extent_buffer(eb);
 				goto out;
 			}
 
-- 
2.1.0

