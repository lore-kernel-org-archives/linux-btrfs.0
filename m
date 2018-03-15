Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37713 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbeCOMgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A58CACBA
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:37 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/8] btrfs: Remove unused parent_level var from btrfs_realloc_node
Date: Thu, 15 Mar 2018 14:36:27 +0200
Message-Id: <1521117389-13712-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added by f2183bde1a91 ("Btrfs: Add BH_Defrag to mark buffers that are
in need of defragging") but obsoleted by 3f157a2fd2ad ("Btrfs: Online
btree defragmentation fixes")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1ef6b67f893a..88a8891ef2ec 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1571,14 +1571,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	int end_slot;
 	int i;
 	int err = 0;
-	int parent_level;
 	int uptodate;
 	u32 blocksize;
 	int progress_passed = 0;
 	struct btrfs_disk_key disk_key;
 
-	parent_level = btrfs_header_level(parent);
-
 	WARN_ON(trans->transaction != fs_info->running_transaction);
 	WARN_ON(trans->transid != fs_info->generation);
 
-- 
2.7.4

