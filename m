Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42399 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbbATJHp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:45 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 1/5] btrfs: Fix the bug that fs_info->pending_changes is never cleared.
Date: Tue, 20 Jan 2015 17:05:33 +0800
Message-ID: <1421744737-16586-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fs_info->pending_changes is never cleared since the original code uses
cmpxchg(&fs_info->pending_changes, 0, 0), which will only clear it if
pending_changes is already 0.

This will cause a lot of problem when mount it with inode_cache mount
option.
If the btrfs is mounted as inode_cache, pending_changes will always be
1, even when the fs is frozen.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a605d4e..e88b59d 100644
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
2.2.2

