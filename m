Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48738 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab2HXSq1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 14:46:27 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id bjoo04J0w48DOO7E (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 12:46:26 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only warn if we hit an error when doing the tree logging
Date: Fri, 24 Aug 2012 14:51:38 -0400
Message-ID: <1345834298-1877-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit this a couple times while working on my fsync patch (all my bugs, not
normal operation), but with my new stuff we could have new errors from cases
I have not encountered, so instead of BUG()'ing we should be WARN()'ing so
that we are notified there is a problem but the user doesn't lose their
data.  We can easily commit the transaction in the case that the tree
logging fails and still be fine, so let's try and be as nice to the user as
possible.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5190cd6..b5b6323 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3346,7 +3346,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 end_trans:
 	dput(old_parent);
 	if (ret < 0) {
-		BUG_ON(ret != -ENOSPC);
+		WARN_ON(ret != -ENOSPC);
 		root->fs_info->last_trans_log_full_commit = trans->transid;
 		ret = 1;
 	}
-- 
1.7.7.6

