Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46590 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPG5X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 02:57:23 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9G6vMHj010497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:57:22 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9G6vLK5001156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 06:57:21 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9G6vLXF015241
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 01:57:21 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] Btrfs-progs: make use of column_name
Date: Tue, 16 Oct 2012 15:00:46 +0800
Message-Id: <1350370847-20262-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350370847-20262-1-git-send-email-Anand.Jain@oracle.com>
References: <20121009154418.GV4405@twin.jikos.cz>
 <1350370847-20262-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 74782b8..9cfdb35 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1432,7 +1432,7 @@ static void print_all_volume_info_tab_head()
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
 		if (btrfs_list_columns[i].need_print)
-			printf("%s\t", btrfs_list_columns[i].name);
+			printf("%s\t", btrfs_list_columns[i].column_name);
 
 		if (i == BTRFS_LIST_ALL-1)
 			printf("\n");
@@ -1442,7 +1442,7 @@ static void print_all_volume_info_tab_head()
 		memset(barrier, 0, sizeof(barrier));
 
 		if (btrfs_list_columns[i].need_print) {
-			len = strlen(btrfs_list_columns[i].name);
+			len = strlen(btrfs_list_columns[i].column_name);
 			while (len--)
 				strcat(barrier, "-");
 
-- 
1.7.1

