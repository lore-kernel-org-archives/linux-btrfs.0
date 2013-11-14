Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27090 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3KNLn7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 06:43:59 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rAEBhwVv008187
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 11:43:58 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAEBhvAM029473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 11:43:57 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAEBhvrC029462
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 11:43:57 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix typo in the log message
Date: Thu, 14 Nov 2013 19:52:44 +0800
Message-Id: <1384429964-10433-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3e41097..97fcb73 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -366,7 +366,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	dev_replace->tgtdev = tgt_device;
 
 	printk_in_rcu(KERN_INFO
-		      "btrfs: dev_replace from %s (devid %llu) to %s) started\n",
+		      "btrfs: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
 		        rcu_str_deref(src_device->name),
 		      src_device->devid,
-- 
1.7.1

