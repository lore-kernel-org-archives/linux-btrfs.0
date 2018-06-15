Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965626AbeFOLGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:11 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] btrfs-progs: Add support for freespace tree in btrfs_read_fs_root
Date: Fri, 15 Jun 2018 14:05:57 +0300
Message-Id: <1529060762-4372-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1529060762-4372-1-git-send-email-nborisov@suse.com>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For completeness sake add code to btrfs_read_fs_root so that it can
handle the freespace tree.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 8da6e3ce5fc8..9ad826b83b3e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -664,6 +664,9 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_enabled ? fs_info->quota_root :
 				ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
+        return fs_info->free_space_root ? fs_info->free_space_root :
+                                                  ERR_PTR(-ENOENT);
 
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
-- 
2.7.4

