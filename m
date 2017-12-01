Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41435 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751846AbdLAJTx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:53 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08349AD72
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Remove redundant NULL check
Date: Fri,  1 Dec 2017 11:19:43 +0200
Message-Id: <1512119984-12708-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1512119984-12708-1-git-send-email-nborisov@suse.com>
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before returning hole_em in btrfs_get_fiemap_extent we check if it's different
than null. However, by the time this null check is triggered we already know
hole_em is not null because it means it points to the em we found and it
has already been dereferenced.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92d140b06271..9e0473c883ce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7300,9 +7300,8 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 			em->block_start = EXTENT_MAP_DELALLOC;
 			em->block_len = found;
 		}
-	} else if (hole_em) {
+	} else
 		return hole_em;
-	}
 out:
 
 	free_extent_map(hole_em);
-- 
2.7.4

