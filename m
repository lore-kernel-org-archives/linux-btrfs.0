Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbCMGYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 02:24:44 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t2D6OhJq029511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 06:24:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t2D6Ogmi026063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 06:24:43 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t2D6Ogxx020429
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2015 06:24:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix comp_oper to get right order
Date: Fri, 13 Mar 2015 14:24:38 +0800
Message-Id: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Case (oper1->seq > oper2->seq) should differ with case (oper1->seq < oper2->seq).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
This typo was hiden in a big patch, so we need to work harder on review.

 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 97159a8..058c79e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1259,7 +1259,7 @@ static int comp_oper(struct btrfs_qgroup_operation *oper1,
 	if (oper1->seq < oper2->seq)
 		return -1;
 	if (oper1->seq > oper2->seq)
-		return -1;
+		return 1;
 	if (oper1->ref_root < oper2->ref_root)
 		return -1;
 	if (oper1->ref_root > oper2->ref_root)
-- 
1.8.1.4

