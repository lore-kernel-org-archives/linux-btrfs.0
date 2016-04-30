Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29504 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcD3Bdz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 21:33:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u3U1Xr0O028645
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 01:33:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u3U1Xrhd018421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 01:33:53 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u3U1XqSB014016
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 01:33:53 GMT
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Fix BUG_ON condition in scrub_setup_recheck_block()
Date: Fri, 29 Apr 2016 18:33:59 -0700
Message-Id: <1461980039-25200-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

pagev array in scrub_block{} is of size SCRUB_MAX_PAGES_PER_BLOCK.
page_index should be checked with the same to trigger BUG_ON().

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4678f03..376a6dd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1350,7 +1350,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 		recover->bbio = bbio;
 		recover->map_length = mapped_length;
 
-		BUG_ON(page_index >= SCRUB_PAGES_PER_RD_BIO);
+		BUG_ON(page_index >= SCRUB_MAX_PAGES_PER_BLOCK);
 
 		nmirrors = min(scrub_nr_raid_mirrors(bbio), BTRFS_MAX_MIRRORS);
 
-- 
1.9.1

