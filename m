Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbeA2Qqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 11:46:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B290DAC8C
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 16:46:30 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Nikolay Borisov <nborisov@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: btrfs_evict_inode must clear all inodes
Message-ID: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
Date: Mon, 29 Jan 2018 11:46:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_evict_inode must clear all inodes or we'll hit a BUG_ON in evict().

Fixes: 3d48d9810de (btrfs: Handle uninitialised inode eviction)
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5282,6 +5282,7 @@ void btrfs_evict_inode(struct inode *ino
 	trace_btrfs_inode_evict(inode);
 
 	if (!root) {
+		clear_inode(inode);
 		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 		return;
 	}

-- 
Jeff Mahoney
SUSE Labs
