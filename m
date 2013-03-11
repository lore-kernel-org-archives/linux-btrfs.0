Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36965 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 3/5] Convert balance filter parser to use common NcMsPp replication-level parser
Date: Mon, 11 Mar 2013 20:17:26 +0000
Message-Id: <1363033048-17481-4-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
References: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
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

