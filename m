Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751472AbdBMObE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:31:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3DE75AD55
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:58 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs: remove pointless rcu protection from btrfs_qgroup_inherit
Date: Mon, 13 Feb 2017 15:30:29 +0100
Message-Id: <72c4fd2f87eca0bc49f3292ce07856cff41536e8.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was never need for RCU protection around reading nodesize or other
fairly constant filesystem data.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 114d6770dc23..052f1410dc14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2189,9 +2189,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		rcu_read_lock();
 		level_size = fs_info->nodesize;
-		rcu_read_unlock();
 	}
 
 	/*
-- 
2.10.1

