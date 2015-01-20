Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbbATSFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 13:05:32 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: guihc.fnst@cn.fujitsu.com, quwenruo@cn.fujitsu.com, miaoxie@huawei.com,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: Fix the bug that fs_info->pending_changes is never cleared.
Date: Tue, 20 Jan 2015 19:05:30 +0100
Message-Id: <027da0c9dbad00712b53e26aeb53f3bceb80ab1d.1421776294.git.dsterba@suse.cz>
In-Reply-To: <cover.1421776294.git.dsterba@suse.cz>
References: <cover.1421776294.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Fs_info->pending_changes is never cleared since the original code uses
cmpxchg(&fs_info->pending_changes, 0, 0), which will only clear it if
pending_changes is already 0.

This will cause a lot of problem when mount it with inode_cache mount
option.
If the btrfs is mounted as inode_cache, pending_changes will always be
1, even when the fs is frozen.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a605d4e2f2bc..e88b59d13439 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2118,7 +2118,7 @@ void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
 	unsigned long prev;
 	unsigned long bit;
 
-	prev = cmpxchg(&fs_info->pending_changes, 0, 0);
+	prev = xchg(&fs_info->pending_changes, 0);
 	if (!prev)
 		return;
 
-- 
2.1.3

