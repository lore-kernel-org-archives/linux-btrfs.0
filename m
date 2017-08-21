Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48382 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753092AbdHUJnz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BA83ABED
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/10] btrfs: Remove unused variable
Date: Mon, 21 Aug 2017 12:43:43 +0300
Message-Id: <1503308630-6652-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Src was initially part of 31ff1cd25d37 ("Btrfs: Copy into the log tree in
big batches"), however 16e7549f045d ("Btrfs: incompatible format change to remove hole extents") changed parameters passed to copy_items which made the src 
variable redundant. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ad7f4bab640b..cb29528a8bba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2740,7 +2740,7 @@ static inline void btrfs_remove_log_ctx(struct btrfs_root *root,
 	mutex_unlock(&root->log_mutex);
 }
 
-/* 
+/*
  * Invoked in log mutex context, or be sure there is no other task which
  * can access the list.
  */
@@ -4637,7 +4637,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key min_key;
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
-	struct extent_buffer *src = NULL;
 	LIST_HEAD(logged_list);
 	u64 last_extent = 0;
 	int err = 0;
@@ -4880,7 +4879,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto next_slot;
 		}
 
-		src = path->nodes[0];
 		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
 			ins_nr++;
 			goto next_slot;
-- 
2.7.4

