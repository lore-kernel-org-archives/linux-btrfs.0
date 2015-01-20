Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbbATSFi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 13:05:38 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: guihc.fnst@cn.fujitsu.com, quwenruo@cn.fujitsu.com, miaoxie@huawei.com,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs: remove a no-op unfreeze superbock callback
Date: Tue, 20 Jan 2015 19:05:37 +0100
Message-Id: <6db856a9498f4716320fb1442f58dbfd39d442da.1421776294.git.dsterba@suse.cz>
In-Reply-To: <cover.1421776294.git.dsterba@suse.cz>
References: <cover.1421776294.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6f49b2872a64..05fef198ff94 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1958,11 +1958,6 @@ static int btrfs_freeze(struct super_block *sb)
 	return btrfs_commit_transaction(trans, root);
 }
 
-static int btrfs_unfreeze(struct super_block *sb)
-{
-	return 0;
-}
-
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
@@ -2011,7 +2006,6 @@ static const struct super_operations btrfs_super_ops = {
 	.statfs		= btrfs_statfs,
 	.remount_fs	= btrfs_remount,
 	.freeze_fs	= btrfs_freeze,
-	.unfreeze_fs	= btrfs_unfreeze,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
-- 
2.1.3

