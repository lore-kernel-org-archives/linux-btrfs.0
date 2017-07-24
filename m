Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34075 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752669AbdGXSAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:00:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B40B5AB1E
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 18:00:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: drop chunk locks at the end of close_ctree
Date: Mon, 24 Jul 2017 19:59:10 +0200
Message-Id: <735d65098454d7a85b190de1fcaa46a87544b6b3.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The pinned chunks might be left over so we clean them but at this point
of close_ctree, there's noone to race with, the locking can be removed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a1cb2ad6d19..c1b49bf0752d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3995,7 +3995,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
-	mutex_lock(&fs_info->chunk_mutex);
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
@@ -4004,7 +4003,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		list_del_init(&em->list);
 		free_extent_map(em);
 	}
-	mutex_unlock(&fs_info->chunk_mutex);
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
-- 
2.13.0

