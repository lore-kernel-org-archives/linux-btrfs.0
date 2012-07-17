Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2GQKST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 06:18:19 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: create root directory with 755 permissions
Date: Tue, 17 Jul 2012 12:18:10 +0200
Message-Id: <1342520290-23803-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's what all other mkfs do and there's no reason for 0555.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index aade9e2..cfe7c49 100644
--- a/utils.c
+++ b/utils.c
@@ -614,7 +614,7 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_size(&inode_item, 0);
 	btrfs_set_stack_inode_nlink(&inode_item, 1);
 	btrfs_set_stack_inode_nbytes(&inode_item, root->leafsize);
-	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0555);
+	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0755);
 	btrfs_set_stack_timespec_sec(&inode_item.atime, now);
 	btrfs_set_stack_timespec_nsec(&inode_item.atime, 0);
 	btrfs_set_stack_timespec_sec(&inode_item.ctime, now);
-- 
1.7.9

