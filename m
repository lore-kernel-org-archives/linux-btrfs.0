Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbcFQQW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:22:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A9B33AAF4
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 16:22:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: use new error message helper in qgroup_account_snapshot
Date: Fri, 17 Jun 2016 18:23:01 +0200
Message-Id: <bcd1887467541622ed26f2bdbf3096e4b3ff32c6.1466180408.git.dsterba@suse.com>
In-Reply-To: <cover.1466180408.git.dsterba@suse.com>
References: <cover.1466180408.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've renamed btrfs_std_error, this one is left from last merge.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f6e24cb423ae..4e74b5733030 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1385,7 +1385,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	switch_commit_roots(trans->transaction, fs_info);
 	ret = btrfs_write_and_wait_transaction(trans, src);
 	if (ret)
-		btrfs_std_error(fs_info, ret,
+		btrfs_handle_fs_error(fs_info, ret,
 			"Error while writing out transaction for qgroup");
 
 out:
-- 
2.7.1

