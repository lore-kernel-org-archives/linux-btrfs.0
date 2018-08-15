Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729454AbeHOSTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:39 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1590AD71
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/7] btrfs: Remove extra reference count bumps in btrfs_compare_trees
Date: Wed, 15 Aug 2018 18:26:55 +0300
Message-Id: <1534346817-9108-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the 2 comparison treees roots are initialised they are private to
the function and already have referencecounts of 1 each. There is no
need to further increment the reference count since the cloned buffers
are already accessed via struct btrfs_path. Eventually the 2 paths
used for comparison are going to be released, effectively disposing of
the cloned buffers.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c3d298580bc9..be0eb26fd4eb 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5413,7 +5413,6 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		ret = -ENOMEM;
 		goto out;
 	}
-	extent_buffer_get(left_path->nodes[left_level]);
 
 	right_level = btrfs_header_level(right_root->commit_root);
 	right_root_level = right_level;
@@ -5424,7 +5423,6 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		ret = -ENOMEM;
 		goto out;
 	}
-	extent_buffer_get(right_path->nodes[right_level]);
 	up_read(&fs_info->commit_root_sem);
 
 	if (left_level == 0)
-- 
2.7.4
