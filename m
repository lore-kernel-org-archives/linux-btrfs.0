Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39974 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbJVD7u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 23:59:50 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9M3xnLL003837
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:59:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9M3xnm0028417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:59:49 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t9M3xmbi014820
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:59:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix missing init dev list head for dev_list
Date: Thu, 22 Oct 2015 11:58:05 +0800
Message-Id: <1445486285-1232-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index f1e3248..b754686 100644
--- a/utils.c
+++ b/utils.c
@@ -763,6 +763,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	if (!device->name)
 		goto err_nomem;
 
+	INIT_LIST_HEAD(&device->dev_list);
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
 
-- 
2.4.1

