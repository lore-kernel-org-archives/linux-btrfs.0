Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbcFXWP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0CC7AAD9E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/31] btrfs: cleanup, remove prototype for btrfs_find_root_ref
Date: Fri, 24 Jun 2016 18:15:02 -0400
Message-Id: <1466806524-27508-10-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The function isn't implemented anywhere.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b107d1..bff6ce6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2875,9 +2875,6 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq);
 
 /* root-item.c */
-int btrfs_find_root_ref(struct btrfs_root *tree_root,
-			struct btrfs_path *path,
-			u64 root_id, u64 ref_id);
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *tree_root,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
-- 
2.7.1

