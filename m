Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754071AbeFTMt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:29 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58139AF59
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 30/34] btrfs: Remove fs_info from remove_extent_backref
Date: Wed, 20 Jun 2018 15:49:12 +0300
Message-Id: <1529498956-4241-31-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced directly from the transaction handle since it's
always valid

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b03fe240da97..47b80297dbc2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1998,7 +1998,6 @@ static int insert_extent_backref(struct btrfs_trans_handle *trans,
 }
 
 static int remove_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
 				 int refs_to_drop, int is_data, int *last_ref)
@@ -2014,7 +2013,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 					     last_ref);
 	} else {
 		*last_ref = 1;
-		ret = btrfs_del_item(trans, fs_info->extent_root, path);
+		ret = btrfs_del_item(trans, trans->fs_info->extent_root, path);
 	}
 	return ret;
 }
@@ -6862,7 +6861,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 #endif
 		if (!found_extent) {
 			BUG_ON(iref);
-			ret = remove_extent_backref(trans, info, path, NULL,
+			ret = remove_extent_backref(trans, path, NULL,
 						    refs_to_drop,
 						    is_data, &last_ref);
 			if (ret) {
@@ -7006,9 +7005,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 		}
 		if (found_extent) {
-			ret = remove_extent_backref(trans, info, path,
-						    iref, refs_to_drop,
-						    is_data, &last_ref);
+			ret = remove_extent_backref(trans, path, iref,
+						    refs_to_drop, is_data,
+						    &last_ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				goto out;
-- 
2.7.4

