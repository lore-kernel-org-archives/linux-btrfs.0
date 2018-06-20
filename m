Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbeFTMtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:23 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71867AF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/34] btrfs: Remove fs_info from lookup_extent_backref
Date: Wed, 20 Jun 2018 15:48:52 +0300
Message-Id: <1529498956-4241-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This argument is unused. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aeef5437ec8a..0c4c093201b5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1858,7 +1858,6 @@ void setup_inline_extent_backref(struct btrfs_fs_info *fs_info,
 }
 
 static int lookup_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref **ref_ret,
 				 u64 bytenr, u64 num_bytes, u64 parent,
@@ -6844,9 +6843,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (is_data)
 		skinny_metadata = false;
 
-	ret = lookup_extent_backref(trans, info, path, &iref,
-				    bytenr, num_bytes, parent,
-				    root_objectid, owner_objectid,
+	ret = lookup_extent_backref(trans, path, &iref, bytenr, num_bytes,
+				    parent, root_objectid, owner_objectid,
 				    owner_offset);
 	if (ret == 0) {
 		extent_slot = path->slots[0];
-- 
2.7.4

