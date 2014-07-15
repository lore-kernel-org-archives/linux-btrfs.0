Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaGOHlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 03:41:14 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6F7fD2g005565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:14 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F7fCo8020908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:13 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F7fCpc017290
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: dont break the string
Date: Tue, 15 Jul 2014 16:02:09 +0800
Message-Id: <1405411330-8557-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 52b9a8d..cba4f02 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1336,8 +1336,8 @@ int main(int ac, char **av)
 			case 'b':
 				block_count = parse_size(optarg);
 				if (block_count <= 1024*1024*1024) {
-					printf("SMALL VOLUME: forcing mixed "
-					       "metadata/data groups\n");
+					fprintf(stdout,
+				"SMALL VOLUME: forcing mixed metadata/data groups\n");
 					mixed = 1;
 				}
 				zero_end = 0;
-- 
2.0.0.153.g79dcccc

