Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31261 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaESRBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:01:41 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4JH1epN019717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:40 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH1dsJ003406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:40 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH1dNF008943
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: usage error should not be logged into system log
Date: Tue, 20 May 2014 01:04:31 +0800
Message-Id: <1400519071-5580-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
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
 fs/btrfs/sysfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 63c2907..f729199 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -374,11 +374,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_root *root = fs_info->fs_root;
 	int ret;
 
-	if (len >= BTRFS_LABEL_SIZE || strchr(buf, '\n')) {
-		pr_err("BTRFS: unable to set label with more than %d bytes\n",
-		       BTRFS_LABEL_SIZE - 1);
+	if (len >= BTRFS_LABEL_SIZE || strchr(buf, '\n'))
 		return -EINVAL;
-	}
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
-- 
1.8.5.3

