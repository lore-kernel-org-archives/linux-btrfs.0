Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38566 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbFAGUk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 02:20:40 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t516Kd8R021200
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:20:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t516Kdj4003095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:20:39 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t516Kd8f000951
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:20:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add info about list-all to the help
Date: Mon,  1 Jun 2015 14:20:24 +0800
Message-Id: <1433139624-732-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs -O list-all is a good options to list features,
publish it in the help.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 14e0fed..c16aeb9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -281,7 +281,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-s|--sectorsize SIZE    min block allocation (may not mountable by current kernel)\n");
 	fprintf(stderr, "\t-r|--rootdir DIR        the source directory\n");
 	fprintf(stderr, "\t-K|--nodiscard          do not perform whole device TRIM\n");
-	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features\n");
+	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features, use '-O list-all' to list features\n");
 	fprintf(stderr, "\t-U|--uuid UUID          specify the filesystem UUID\n");
 	fprintf(stderr, "\t-V|--version            print the mkfs.btrfs version and exit\n");
 	fprintf(stderr, "%s\n", PACKAGE_STRING);
-- 
2.4.1

