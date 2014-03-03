Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCCNbT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 08:31:19 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s23DVIMv016626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:18 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23DVHIV001277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:18 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s23DVH1V001265
	for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 13:31:17 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: remove unused code in full_send_tree
Date: Mon,  3 Mar 2014 21:31:02 +0800
Message-Id: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unnecessary to update key's value, and remove it to keep code clean.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3fe4d6e..a5f9626 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5180,10 +5180,6 @@ static int full_send_tree(struct send_ctx *sctx)
 		if (ret < 0)
 			goto out;
 
-		key.objectid = found_key.objectid;
-		key.type = found_key.type;
-		key.offset = found_key.offset + 1;
-
 		ret = btrfs_next_item(send_root, path);
 		if (ret < 0)
 			goto out;
-- 
1.8.2.1

