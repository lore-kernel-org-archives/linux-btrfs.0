Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51624 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727795AbeIUNIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 09:08:10 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 059FBAE8F
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 07:20:36 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: relocation: Remove redundant tree level check
Date: Fri, 21 Sep 2018 15:20:30 +0800
Message-Id: <20180921072030.20531-2-wqu@suse.com>
In-Reply-To: <20180921072030.20531-1-wqu@suse.com>
References: <20180921072030.20531-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 581c1760415c ("btrfs: Validate child tree block's level and first
key") has made tree block level check mandatory.

So if tree block level doesn't match, we won't get a valid extent
buffer.
The extra WARN_ON() check can be removed completely.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
  Added tags.
---
 fs/btrfs/relocation.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 94aa148ccde6..a554e7861b6e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2911,7 +2911,6 @@ static int get_tree_block_key(struct btrfs_fs_info *fs_info,
 		free_extent_buffer(eb);
 		return -EIO;
 	}
-	WARN_ON(btrfs_header_level(eb) != block->level);
 	if (block->level == 0)
 		btrfs_item_key_to_cpu(eb, &block->key, 0);
 	else
-- 
2.19.0
