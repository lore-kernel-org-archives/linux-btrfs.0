Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbeCOMgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52BB8AD25
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:37 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/8] btrfs: Remove unused extent_root var from caching_thread
Date: Thu, 15 Mar 2018 14:36:28 +0200
Message-Id: <1521117389-13712-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added by b4570aa994b8 ("btrfs: fix compiling with CONFIG_BTRFS_DEBUG
enabled.") and obsoleted by 2ff7e61e0d30 ("btrfs: take an fs_info
directly when the root is not used otherwise")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1469117a8e37..e15ef42a5d4d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -535,13 +535,11 @@ static noinline void caching_thread(struct btrfs_work *work)
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_caching_control *caching_ctl;
-	struct btrfs_root *extent_root;
 	int ret;
 
 	caching_ctl = container_of(work, struct btrfs_caching_control, work);
 	block_group = caching_ctl->block_group;
 	fs_info = block_group->fs_info;
-	extent_root = fs_info->extent_root;
 
 	mutex_lock(&caching_ctl->mutex);
 	down_read(&fs_info->commit_root_sem);
-- 
2.7.4

