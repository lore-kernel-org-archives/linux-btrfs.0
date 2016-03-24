Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbcCXP4p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 11:56:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BCA37AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 15:56:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: mkfs: allow DUP on multidev fs, only warn
Date: Thu, 24 Mar 2016 16:56:13 +0100
Message-Id: <1458834973-3199-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The DUP profile can work on multiple filesystems, the limitation is
rather artificial. Let the user make the decision and print a warning.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index eabc36dca7a1..9bc18d4508fc 100644
--- a/utils.c
+++ b/utils.c
@@ -2484,9 +2484,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 
 	if (dev_cnt > 1 &&
 	    ((metadata_profile | data_profile) & BTRFS_BLOCK_GROUP_DUP)) {
-		fprintf(stderr,
-		    "ERROR: DUP is not allowed when FS has multiple devices\n");
-		return 1;
+		warning("DUP is not recommended on filesystem with multiple devices");
 	}
 	if (metadata_profile & ~allowed) {
 		fprintf(stderr,
-- 
2.7.1

