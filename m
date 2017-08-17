Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58972 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750775AbdHQHwe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:52:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8735AF22
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 07:52:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove never-reached WARN_ON
Date: Thu, 17 Aug 2017 10:52:28 +0300
Message-Id: <1502956348-5041-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a WARN_ON(!var) inside an if branch which is executed (among others)
only when var is true.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 21c78c48e15b..8552d550a048 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6755,7 +6755,6 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 		if (!readonly && return_free_space &&
 		    global_rsv->space_info == space_info) {
 			u64 to_add = len;
-			WARN_ON(!return_free_space);
 			spin_lock(&global_rsv->lock);
 			if (!global_rsv->full) {
 				to_add = min(len, global_rsv->size -
-- 
2.7.4

