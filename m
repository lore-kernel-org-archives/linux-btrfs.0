Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752983AbeFTMtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:21 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5CBCBAF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/34] btrfs: Remove fs_info argument from insert_extent_backref
Date: Wed, 20 Jun 2018 15:48:45 +0300
Message-Id: <1529498956-4241-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5fc44c2e3e18..1171ad81e5c5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1990,7 +1990,6 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 }
 
 static int insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 u64 bytenr, u64 parent, u64 root_objectid,
 				 u64 owner, u64 offset, int refs_to_add)
@@ -2254,8 +2253,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* now insert the actual backref */
-	ret = insert_extent_backref(trans, fs_info, path, bytenr, parent,
-				    root_objectid, owner, offset, refs_to_add);
+	ret = insert_extent_backref(trans, path, bytenr, parent, root_objectid,
+				    owner, offset, refs_to_add);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 out:
-- 
2.7.4

