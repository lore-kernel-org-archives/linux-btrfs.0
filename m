Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48401 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753206AbdHUJn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:57 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D1B1ABF8
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/10] btrfs: Rework error handling of add_extent_mapping in __btrfs_alloc_chunk
Date: Mon, 21 Aug 2017 12:43:49 +0300
Message-Id: <1503308630-6652-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the code executes add_extent_mapping and if it is successful it links
the new mapping, it then proceeds to unlock the extent mapping tree and check
for failure and handle them. Instead, rework the code to only perform a single
check if add_extent_mapping has failed and handle it, otherwise the code
continues in a linear fashion. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d024f1b07282..0324c1eec19d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4813,16 +4813,16 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	em_tree = &info->mapping_tree.map_tree;
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em, 0);
-	if (!ret) {
-		list_add_tail(&em->list, &trans->transaction->pending_chunks);
-		refcount_inc(&em->refs);
-	}
-	write_unlock(&em_tree->lock);
 	if (ret) {
+		write_unlock(&em_tree->lock);
 		free_extent_map(em);
 		goto error;
 	}
 
+	list_add_tail(&em->list, &trans->transaction->pending_chunks);
+	refcount_inc(&em->refs);
+	write_unlock(&em_tree->lock);
+
 	ret = btrfs_make_block_group(trans, info, 0, type, start, num_bytes);
 	if (ret)
 		goto error_del_extent;
-- 
2.7.4

