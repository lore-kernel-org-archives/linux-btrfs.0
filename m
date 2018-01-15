Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35911 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932777AbeAOMb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:31:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A092ADD3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 12:31:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove btrfs_inode::delayed_iput_count
Date: Mon, 15 Jan 2018 14:31:34 +0200
Message-Id: <1516019494-24210-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

delayed_iput_count wa supposed to be used to implement, well, delayed
iput. The idea is that we keep accumulating the number of iputs we do
until eventually the inode is deleted. Turns out we never really
switched the delayed_iput_count from 0 to 1, hence all conditional
code relying on the value of that member being different than 0 was
never executed. This, as it turns out, didn't cause any problem due
to the simple fact that the generic inode's i_count member was always
used to count the number of iputs. So let's just remove the unused
member and all unused code. This patch essentially provides no
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h |  1 -
 fs/btrfs/inode.c       | 17 +++--------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 63f0ccc92a71..f527e99c9f8d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -195,7 +195,6 @@ struct btrfs_inode {
 
 	/* Hook into fs_info->delayed_iputs */
 	struct list_head delayed_iput;
-	long delayed_iput_count;
 
 	/*
 	 * To avoid races between lockless (i_mutex not held) direct IO writes
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 029399593049..2225f613516c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3252,12 +3252,8 @@ void btrfs_add_delayed_iput(struct inode *inode)
 		return;
 
 	spin_lock(&fs_info->delayed_iput_lock);
-	if (binode->delayed_iput_count == 0) {
-		ASSERT(list_empty(&binode->delayed_iput));
-		list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
-	} else {
-		binode->delayed_iput_count++;
-	}
+	ASSERT(list_empty(&binode->delayed_iput));
+	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
 }
 
@@ -3270,13 +3266,7 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
 
 		inode = list_first_entry(&fs_info->delayed_iputs,
 				struct btrfs_inode, delayed_iput);
-		if (inode->delayed_iput_count) {
-			inode->delayed_iput_count--;
-			list_move_tail(&inode->delayed_iput,
-					&fs_info->delayed_iputs);
-		} else {
-			list_del_init(&inode->delayed_iput);
-		}
+		list_del_init(&inode->delayed_iput);
 		spin_unlock(&fs_info->delayed_iput_lock);
 		iput(&inode->vfs_inode);
 		spin_lock(&fs_info->delayed_iput_lock);
@@ -9424,7 +9414,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->dir_index = 0;
 	ei->last_unlink_trans = 0;
 	ei->last_log_commit = 0;
-	ei->delayed_iput_count = 0;
 
 	spin_lock_init(&ei->lock);
 	ei->outstanding_extents = 0;
-- 
2.7.4

