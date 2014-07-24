Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43288 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaGXOsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 10:48:16 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6OEmFXC005071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 14:48:15 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s6OEmEKu026231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 14:48:14 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6OEmDR8007956
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 14:48:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix compressed write corruption on enospc
Date: Thu, 24 Jul 2014 22:48:05 +0800
Message-Id: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When failing to allocate space for the whole compressed extent, we'll
fallback to uncompressed IO, but we've forgotten to redirty the pages
which belong to this compressed extent, and these 'clean' pages will
simply skip 'submit' part and go to endio directly, at last we got data
corruption as we write nothing.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..8ea7610 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -709,6 +709,18 @@ retry:
 				unlock_extent(io_tree, async_extent->start,
 					      async_extent->start +
 					      async_extent->ram_size - 1);
+
+				/*
+				 * we need to redirty the pages if we decide to
+				 * fallback to uncompressed IO, otherwise we
+				 * will not submit these pages down to lower
+				 * layers.
+				 */
+				extent_range_redirty_for_io(inode,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1);
+
 				goto retry;
 			}
 			goto out_free;
-- 
1.8.1.4

