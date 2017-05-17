Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751155AbdEQNt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 09:49:56 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, "# v3 . 14+" <stable@vger.kernel.org>
Subject: [PATCH] btrfs: fix memory leak in update_space_info failure path
Date: Wed, 17 May 2017 09:49:37 -0400
Message-Id: <20170517134937.30774-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If we fail to add the space_info kobject, we'll leak the memory
for the percpu counter.

Fixes: 6ab0a2029c (btrfs: publish allocation data in sysfs)
Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be5477676cc8..2f23fd4a08f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3983,6 +3983,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 				    info->space_info_kobj, "%s",
 				    alloc_name(found->flags));
 	if (ret) {
+		percpu_counter_destroy(&found->total_bytes_pinned);
 		kfree(found);
 		return ret;
 	}
-- 
2.11.0

