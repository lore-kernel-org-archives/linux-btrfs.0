Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52371 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3CIVIL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:08:11 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0007ms-Rx
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:13 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0003Hi-EU
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Convert balance filter parser to use common nCmSpP replication-level parser
Date: Sat,  9 Mar 2013 20:31:09 +0000
Message-Id: <1362861071-12589-4-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance filters are the second location which takes user input of
replication levels. Update this to use the common parser so that we can
provide nCmSpP-style names.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-balance.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index f5dc317..6186963 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -42,23 +42,16 @@ static const char balance_cmd_group_info[] =
 
 static int parse_one_profile(const char *profile, u64 *flags)
 {
-	if (!strcmp(profile, "raid0")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID0;
-	} else if (!strcmp(profile, "raid1")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID1;
-	} else if (!strcmp(profile, "raid10")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID10;
-	} else if (!strcmp(profile, "raid5")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID5;
-	} else if (!strcmp(profile, "raid6")) {
-		*flags |= BTRFS_BLOCK_GROUP_RAID6;
-	} else if (!strcmp(profile, "dup")) {
-		*flags |= BTRFS_BLOCK_GROUP_DUP;
-	} else if (!strcmp(profile, "single")) {
-		*flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-	} else {
+	u64 result;
+
+	result = parse_profile(profile);
+	if (result == (u64)-1) {
 		fprintf(stderr, "Unknown profile '%s'\n", profile);
 		return 1;
+	} else if (result == 0) {
+		*flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	} else {
+		*flags |= result;
 	}
 
 	return 0;
-- 
1.7.10.4

