Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49766 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3LBGCf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 01:02:35 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB262XYp027396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:34 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262WeS015767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:33 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262Wg1028798
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: qgroup destroy says create failed
Date: Mon,  2 Dec 2013 14:11:55 +0800
Message-Id: <1385964715-23355-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1385964715-23355-1-git-send-email-anand.jain@oracle.com>
References: <1385964715-23355-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-qgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 5a393bd..957fbc9 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -99,8 +99,8 @@ static int qgroup_create(int create, int argc, char **argv)
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: unable to create quota group: %s\n",
-			strerror(e));
+		fprintf(stderr, "ERROR: unable to %s quota group: %s\n",
+			create ? "create":"destroy", strerror(e));
 		return 1;
 	}
 	return 0;
-- 
1.7.1

