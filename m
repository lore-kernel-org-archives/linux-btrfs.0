Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754553AbcJEMXP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 08:23:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F6C2ACF7
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 12:23:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove stale comment from btrfs_statfs
Date: Wed,  5 Oct 2016 14:23:06 +0200
Message-Id: <20161005122306.3530-3-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4071fe2bd098..2b852ca4fea5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2076,10 +2076,6 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 thresh = 0;
 	int mixed = 0;
 
-	/*
-	 * holding chunk_mutex to avoid allocating new chunks, holding
-	 * device_list_mutex to avoid the device being removed
-	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
-- 
2.10.0

