Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:43164 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2H3W0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 18:26:22 -0400
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>
Subject: [PATCH 2/3] Btrfs: set journal_info in async trans commit worker
Date: Thu, 30 Aug 2012 15:26:16 -0700
Message-Id: <1346365577-9405-3-git-send-email-sage@inktank.com>
In-Reply-To: <1346365577-9405-1-git-send-email-sage@inktank.com>
References: <1346365577-9405-1-git-send-email-sage@inktank.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We expect current->journal_info to point to the trans handle we are
committing.

Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/btrfs/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index efc41a5..f910a26 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1236,6 +1236,8 @@ static void do_async_commit(struct work_struct *work)
 		&ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 		0, 1, _THIS_IP_);
 
+	current->journal_info = ac->newtrans;
+
 	btrfs_commit_transaction(ac->newtrans, ac->root);
 	kfree(ac);
 }
-- 
1.7.9.5

