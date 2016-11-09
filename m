Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbcKIREa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:30 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 37179AC34
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/12] btrfs: reada, remove pointless BUG_ON check for fs_info
Date: Wed,  9 Nov 2016 18:04:27 +0100
Message-Id: <fe6a34d6438402135cf0a97b76f49aba9a92bf86.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We dereference fs_info several times, besides that post-mount functions
should never see a NULL fs_info.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 95d526af3fba..c241e1f0422f 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -439,7 +439,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 				/* ignore whether the entry was inserted */
 				radix_tree_delete(&dev->reada_extents, index);
 			}
-			BUG_ON(fs_info == NULL);
 			radix_tree_delete(&fs_info->reada_tree, index);
 			spin_unlock(&fs_info->reada_lock);
 			btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
-- 
2.10.1

