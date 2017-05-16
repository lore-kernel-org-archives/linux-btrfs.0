Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42915 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752653AbdEPRLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B921AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/10] btrfs: scrub: simplify srrub worker initialization
Date: Tue, 16 May 2017 19:10:50 +0200
Message-Id: <85babda7009e27f63650c37d36f4f135c20708a4.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Minor simplification, merge calls to one.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6c8c4535dc43..59b053feb42e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4026,14 +4026,8 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	int max_active = fs_info->thread_pool_size;
 
 	if (fs_info->scrub_workers_refcnt == 0) {
-		if (is_dev_replace)
-			fs_info->scrub_workers =
-				btrfs_alloc_workqueue(fs_info, "scrub", flags,
-						      1, 4);
-		else
-			fs_info->scrub_workers =
-				btrfs_alloc_workqueue(fs_info, "scrub", flags,
-						      max_active, 4);
+		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
+				flags, is_dev_replace ? 1 : max_active, 4);
 		if (!fs_info->scrub_workers)
 			goto fail_scrub_workers;
 
-- 
2.12.0

