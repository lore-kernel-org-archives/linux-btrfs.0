Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729432AbeHOSTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:39 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A26BEAD70
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/7] btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind
Date: Wed, 15 Aug 2018 18:26:54 +0300
Message-Id: <1534346817-9108-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a rewound buffer is created it already has a ref count of 1 and
the dummy flag set. Then another ref is taken bumping the count to 2.
Finally when this buffer is released from btrfs_release_path the extra
reference is decremented by the special handling code in
free_extent_buffer. However, this special code is in fact redundant
sinca ref count of 1 is still correct since the buffer is only
accessed via btrfs_path struct. This paves the way forward of removing
the special handling in free_extent_buffer.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4dc5d4becd49..c3d298580bc9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1310,7 +1310,6 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_tree_read_unlock_blocking(eb);
 	free_extent_buffer(eb);
 
-	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
-- 
2.7.4
