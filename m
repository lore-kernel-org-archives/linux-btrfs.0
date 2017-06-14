Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751800AbdFNPnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 11:43:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CAD2AD2A
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2017 15:43:39 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/2] btrfs: account for pinned bytes and bytes_may_use in should_alloc_chunk
Date: Wed, 14 Jun 2017 11:44:26 -0400
Message-Id: <1497455067-6050-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In a heavy write scenario, we can end up with a large number of pinned
bytes.  This can translate into (very) premature ENOSPC because pinned
bytes must be accounted for when allowing a reservation but aren't
accounted for when deciding whether to create a new chunk.

This patch adds the accounting to should_alloc_chunk so that we can
create the chunk.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cb0b924..d027807 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4389,7 +4389,7 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
-	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
+	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned + sinfo->bytes_may_use;
 	u64 thresh;
 
 	if (force == CHUNK_ALLOC_FORCE)
-- 
1.8.5.6

