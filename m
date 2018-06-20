Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753011AbeFTMtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:21 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3F2AAF59
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/34] btrfs: Remove fs_info from remove_extent_data_ref
Date: Wed, 20 Jun 2018 15:48:46 +0300
Message-Id: <1529498956-4241-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction from where the
fs_info can be referenced. No functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1171ad81e5c5..8891eea6fa2c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1383,7 +1383,6 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
-					   struct btrfs_fs_info *fs_info,
 					   struct btrfs_path *path,
 					   int refs_to_drop, int *last_ref)
 {
@@ -1420,7 +1419,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 	num_refs -= refs_to_drop;
 
 	if (num_refs == 0) {
-		ret = btrfs_del_item(trans, fs_info->extent_root, path);
+		ret = btrfs_del_item(trans, trans->fs_info->extent_root, path);
 		*last_ref = 1;
 	} else {
 		if (key.type == BTRFS_EXTENT_DATA_REF_KEY)
@@ -2020,7 +2019,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 		update_inline_extent_backref(fs_info, path, iref,
 					     -refs_to_drop, NULL, last_ref);
 	} else if (is_data) {
-		ret = remove_extent_data_ref(trans, fs_info, path, refs_to_drop,
+		ret = remove_extent_data_ref(trans, path, refs_to_drop,
 					     last_ref);
 	} else {
 		*last_ref = 1;
-- 
2.7.4

