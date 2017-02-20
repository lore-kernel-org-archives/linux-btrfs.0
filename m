Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdBTSZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:25:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CA31AAB2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:25:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: remove BUG_ON from __tree_mod_log_insert
Date: Mon, 20 Feb 2017 19:25:01 +0100
Message-Id: <f4837430011633a26eeb2c1410d20f1f954e2395.1487614974.git.dsterba@suse.com>
In-Reply-To: <cover.1487614974.git.dsterba@suse.com>
References: <cover.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers dereference the 'tm' parameter before it gets to this
function, the NULL check does not make much sense here.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1192bc7d2ee7..2c3c943bfcdc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -453,8 +453,6 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 	struct rb_node *parent = NULL;
 	struct tree_mod_elem *cur;
 
-	BUG_ON(!tm);
-
 	tm->seq = btrfs_inc_tree_mod_seq(fs_info);
 
 	tm_root = &fs_info->tree_mod_log;
-- 
2.10.1

