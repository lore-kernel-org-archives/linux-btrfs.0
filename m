Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32101 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaG3Luo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 07:50:44 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6UBohKb020341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:44 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBogK6020935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:43 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBogCo024384
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: sysfs label interface should check for read only FS
Date: Wed, 30 Jul 2014 20:04:10 +0800
Message-Id: <1406721850-3387-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
References: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure how this escaped many eyes so far

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 266e201..e815ab2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -377,6 +377,9 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	int ret;
 	size_t p_len;
 
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	/*
 	 * p_len is the len until the first occurrence of either
 	 * '\n' or '\0'
-- 
2.0.0.153.g79dcccc

