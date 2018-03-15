Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752043AbeCOMgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73617ADC1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:36 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/8] btrfs: Remove unused root var from relink_file_extents
Date: Thu, 15 Mar 2018 14:36:25 +0200
Message-Id: <1521117389-13712-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added in 38c227d87c49 ("Btrfs: snapshot-aware defrag") but subsequently
made redundant by 0b246afa62b0 ("btrfs: root->fs_info cleanup, add
fs_info convenience variables")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6c08c03fc03c..1e9cceeaf4c4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2772,12 +2772,10 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
 	struct sa_defrag_extent_backref *backref;
 	struct sa_defrag_extent_backref *prev = NULL;
 	struct inode *inode;
-	struct btrfs_root *root;
 	struct rb_node *node;
 	int ret;
 
 	inode = new->inode;
-	root = BTRFS_I(inode)->root;
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
2.7.4

