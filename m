Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaETGfR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 02:35:17 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4K6ZF9P029810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 06:35:16 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4K6ZFNf017524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 06:35:15 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4K6ZFER017519
	for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 06:35:15 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v2] btrfs: usage error should not be logged into system log
Date: Tue, 20 May 2014 14:38:11 +0800
Message-Id: <1400567891-9571-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400519071-5580-2-git-send-email-anand.jain@oracle.com>
References: <1400519071-5580-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

I have an opinion that system logs /var/log/messages are
valuable info to investigate the real system issues at
the data center. People handling data center issues
do spend a lot time and efforts analyzing messages
files. Having usage error logged into /var/log/messages
is something we should avoid.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v2: rebase

 fs/btrfs/sysfs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ca63fcd..36fae0f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -385,8 +385,6 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 		*pos = '\0';
 
 	if (strlen(label) >= BTRFS_LABEL_SIZE) {
-		pr_err("BTRFS: unable to set label with more than %d bytes\n",
-		       BTRFS_LABEL_SIZE - 1);
 		kfree(label);
 		return -EINVAL;
 	}
-- 
1.7.1

