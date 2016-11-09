Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51273 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754520AbcKIREf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:35 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE28AADB9
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/12] btrfs: delete unused member from superblock
Date: Wed,  9 Nov 2016 18:04:32 +0100
Message-Id: <30adeca9a1bc9574d2f4a02908551e4bad1f0c1d.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 __bdev' has never been used since
 0b86a832a1f38abec695864ec2eaedc9d2383f1b (2008).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5ae63f4e60df..64c0dc3367bc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -798,7 +798,6 @@ struct btrfs_fs_info {
 	spinlock_t super_lock;
 	struct btrfs_super_block *super_copy;
 	struct btrfs_super_block *super_for_commit;
-	struct block_device *__bdev;
 	struct super_block *sb;
 	struct inode *btree_inode;
 	struct backing_dev_info bdi;
-- 
2.10.1

