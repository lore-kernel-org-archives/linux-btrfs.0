Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3LBGCb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 01:02:31 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB262UwY012463
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:31 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262UUt028593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:30 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262UiA006092
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: Turning ON incompat isn't an error
Date: Mon,  2 Dec 2013 14:11:53 +0800
Message-Id: <1385964715-23355-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index de1beed..0843600 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1196,8 +1196,7 @@ static void process_fs_features(u64 flags)
 
 	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
 		if (flags & mkfs_features[i].flag) {
-			fprintf(stderr,
-				"Turning ON incompat feature '%s': %s\n",
+			printf("Turning ON incompat feature '%s': %s\n",
 				mkfs_features[i].name,
 				mkfs_features[i].desc);
 		}
-- 
1.7.1

