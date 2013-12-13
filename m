Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:57244 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3LMTkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 14:40:02 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so2351622wes.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 11:40:01 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove field tree_mod_seq_elem from btrfs_fs_info struct
Date: Fri, 13 Dec 2013 19:39:54 +0000
Message-Id: <1386963594-16615-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not used anywhere, so just drop it.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7158c97..82fc94e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1462,7 +1462,6 @@ struct btrfs_fs_info {
 	spinlock_t tree_mod_seq_lock;
 	atomic64_t tree_mod_seq;
 	struct list_head tree_mod_seq_list;
-	struct seq_list tree_mod_seq_elem;
 
 	/* this protects tree_mod_log */
 	rwlock_t tree_mod_log_lock;
-- 
1.7.9.5

