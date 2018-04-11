Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbeDKIVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 04:21:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0C54AB35
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 08:21:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Consolidate error checking for btrfs_alloc_chunk
Date: Wed, 11 Apr 2018 11:21:19 +0300
Message-Id: <1523434880-7799-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1523434880-7799-1-git-send-email-nborisov@suse.com>
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The second if is really a subcase of ret being less than 0. So
introduce a generic if (ret < 0) check, and inside have another if
which explicitly handles the -ENOSPC and any other errors. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5e0c987e8fa8..facc5248d500 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4681,12 +4681,14 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	trans->allocating_chunk = false;
 
 	spin_lock(&space_info->lock);
-	if (ret < 0 && ret != -ENOSPC)
-		goto out;
-	if (ret)
-		space_info->full = 1;
-	else
+	if (ret < 0) {
+		if (ret == -ENOSPC)
+			space_info->full = 1;
+		else
+			goto out;
+	} else {
 		ret = 1;
+	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
 out:
-- 
2.7.4

