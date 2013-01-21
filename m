Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46876 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3AUN4C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 08:56:02 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so2956135eei.31
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 05:56:00 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH] Btrfs: fix a regression in balance usage filter
Date: Mon, 21 Jan 2013 15:55:57 +0200
Message-Id: <1358776557-5609-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 3fed40cc ("Btrfs: cleanup duplicated division functions"), which
was merged into 3.8-rc1, has introduced a regression by removing logic
that was guarding us against bad user input.  Bring it back.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 86279c3..b577aee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2614,7 +2614,14 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
 	chunk_used = btrfs_block_group_used(&cache->item);
 
-	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
+	if (bargs->usage == 0)
+		user_thresh = 0;
+	else if (bargs->usage > 100)
+		user_thresh = cache->key.offset;
+	else
+		user_thresh = div_factor_fine(cache->key.offset,
+					      bargs->usage);
+
 	if (chunk_used < user_thresh)
 		ret = 0;
 
-- 
1.7.9.1

