Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20093 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3KOLC1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 06:02:27 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris.mason@fusionio.com
Subject: [PATCH v2] btrfs-progs: for mixed group check opt before default raid profile is enforced
Date: Fri, 15 Nov 2013 19:11:09 +0800
Message-Id: <1384513869-24525-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
References: <1384490079-19872-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes the regression introduced with the patch

    btrfs-progs: avoid write to the disk before sure to create fs

what happened with this patch is it missed the check to see if the
user has the option set before pushing the defaults.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: accepts G.Baroncelli sugested
     rebased on integration-20131114

 mkfs.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 4e99c16..de1beed 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1375,14 +1375,8 @@ int main(int ac, char **av)
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
 	* For mixed groups defaults are single/single.
@@ -1404,8 +1398,14 @@ int main(int ac, char **av)
 		}
 	} else {
 		u32 best_leafsize = max_t(u32, sysconf(_SC_PAGESIZE), sectorsize);
-		metadata_profile = 0;
-		data_profile = 0;
+
+		if (metadata_profile_opt || data_profile_opt) {
+			if (metadata_profile != data_profile) {
+				fprintf(stderr,
+	"ERROR: With mixed block groups data and metadata profiles must be the same\n");
+				exit(1);
+			}
+		}
 
 		if (!leaf_forced) {
 			leafsize = best_leafsize;
-- 
1.7.1

