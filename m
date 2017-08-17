Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41295 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752930AbdHQOE2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 10:04:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1014AC78
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 14:04:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove never-reached WARN_ON
Date: Thu, 17 Aug 2017 17:04:24 +0300
Message-Id: <1502978664-15306-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170817114620.GO2866@twin.jikos.cz>
References: <20170817114620.GO2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a WARN_ON(!var) inside an if branch which is executed (among others)
only when var is true.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 21c78c48e15b..8b32e53236ea 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6755,7 +6755,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 		if (!readonly && return_free_space &&
 		    global_rsv->space_info == space_info) {
 			u64 to_add = len;
-			WARN_ON(!return_free_space);
+
 			spin_lock(&global_rsv->lock);
 			if (!global_rsv->full) {
 				to_add = min(len, global_rsv->size -
@@ -6771,6 +6771,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 				len -= to_add;
 			}
 			spin_unlock(&global_rsv->lock);
+
 			/* Add to any tickets we may have */
 			if (len)
 				space_info_add_new_bytes(fs_info, space_info,
-- 
2.7.4

