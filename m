Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932207AbdERDj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 29/32] btrfs-progs: Remove block size members in btrfs_root
Date: Thu, 18 May 2017 11:38:54 +0800
Message-ID: <20170518033857.15002-30-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Finally, we can get rid of per tree block size members now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h   | 9 ---------
 disk-io.c | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/ctree.h b/ctree.h
index 84298c7b..602c9562 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1166,15 +1166,6 @@ struct btrfs_root {
 	u64 objectid;
 	u64 last_trans;
 
-	/* data allocations are done in sectorsize units */
-	u32 sectorsize;
-
-	/* node allocations are done in nodesize units */
-	u32 nodesize;
-
-	/* leaf allocations are done in nodesize units */
-	u32 stripesize;
-
 	int ref_cows;
 	int track_dirty;
 
diff --git a/disk-io.c b/disk-io.c
index 89e35c92..553073a4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -481,9 +481,6 @@ void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 {
 	root->node = NULL;
 	root->commit_root = NULL;
-	root->sectorsize = fs_info->sectorsize;
-	root->nodesize = fs_info->nodesize;
-	root->stripesize = fs_info->stripesize;
 	root->ref_cows = 0;
 	root->track_dirty = 0;
 
-- 
2.13.0



