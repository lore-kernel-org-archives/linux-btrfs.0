Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3KOEZw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 23:25:52 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rAF4PpKj025163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 04:25:52 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAF4PoOF013905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 04:25:51 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAF4PowI023368
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 04:25:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: for mixed group check opt before default raid profile is enforced
Date: Fri, 15 Nov 2013 12:34:39 +0800
Message-Id: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes the regression introduced with the patch

    btrfs-progs: avoid write to the disk before sure to create fs

what happened with this patch is it missed the check to see if the
user has the option set before pushing the defaults.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index ec717be..2156150 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1359,17 +1359,13 @@ int main(int ac, char **av)
 	if (is_vol_small(file)) {
 		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
 		mixed = 1;
-		if (metadata_profile != data_profile) {
-			if (metadata_profile_opt || data_profile_opt) {
-				fprintf(stderr,
-	"With mixed block groups data and metadata profiles must be the same\n");
-				exit(1);
-			}
-		}
 	}
+
 	/*
 	* Set default profiles according to number of added devices.
-	* For mixed groups defaults are single/single.
+	* For mixed groups defaults are single/single
+	* however if metadata_profile_opt || data_profile_opt is set
+	* metadata_profile and data_profile must be same
 	*/
 	if (!mixed) {
 		if (!metadata_profile_opt) {
@@ -1387,8 +1383,13 @@ int main(int ac, char **av)
 				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
 		}
 	} else {
-		metadata_profile = 0;
-		data_profile = 0;
+		if (metadata_profile_opt || data_profile_opt) {
+			if (metadata_profile != data_profile) {
+				fprintf(stderr,
+	"With mixed block groups data and metadata profiles must be the same\n");
+				exit(1);
+			}
+		}
 	}
 
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
-- 
1.7.1

