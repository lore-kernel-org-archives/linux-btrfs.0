Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbbLARLL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 12:11:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1919EACA7
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 17:11:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: drop duplicate prefix from scrub workqueues
Date: Tue,  1 Dec 2015 18:09:12 +0100
Message-Id: <1448989752-13459-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper btrfs_alloc_workqueue will add the "btrfs-" prefix.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2907a77fb1f6..f8f52a61e329 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3685,27 +3685,27 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	if (fs_info->scrub_workers_refcnt == 0) {
 		if (is_dev_replace)
 			fs_info->scrub_workers =
-				btrfs_alloc_workqueue("btrfs-scrub", flags,
+				btrfs_alloc_workqueue("scrub", flags,
 						      1, 4);
 		else
 			fs_info->scrub_workers =
-				btrfs_alloc_workqueue("btrfs-scrub", flags,
+				btrfs_alloc_workqueue("scrub", flags,
 						      max_active, 4);
 		if (!fs_info->scrub_workers)
 			goto fail_scrub_workers;
 
 		fs_info->scrub_wr_completion_workers =
-			btrfs_alloc_workqueue("btrfs-scrubwrc", flags,
+			btrfs_alloc_workqueue("scrubwrc", flags,
 					      max_active, 2);
 		if (!fs_info->scrub_wr_completion_workers)
 			goto fail_scrub_wr_completion_workers;
 
 		fs_info->scrub_nocow_workers =
-			btrfs_alloc_workqueue("btrfs-scrubnc", flags, 1, 0);
+			btrfs_alloc_workqueue("scrubnc", flags, 1, 0);
 		if (!fs_info->scrub_nocow_workers)
 			goto fail_scrub_nocow_workers;
 		fs_info->scrub_parity_workers =
-			btrfs_alloc_workqueue("btrfs-scrubparity", flags,
+			btrfs_alloc_workqueue("scrubparity", flags,
 					      max_active, 2);
 		if (!fs_info->scrub_parity_workers)
 			goto fail_scrub_parity_workers;
-- 
1.8.4.5

