Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752360AbdBOV2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D86FCAD55
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:41 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 8/8] btrfs: use btrfs_debug instead of pr_debug in transaction abort
Date: Wed, 15 Feb 2017 16:28:34 -0500
Message-Id: <1487194114-12786-9-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Commit e5d6b12fe14 (Btrfs: don't WARN() in btrfs_transaction_abort() for
IO errors) added a pr_debug call to be printed when a transaction is
aborted with -EIO instead of WARN.  btrfs_debug prints which file system
the message is associated with so let's use that instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 49f520c..0b92432 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3447,7 +3447,8 @@ do {								\
 			"BTRFS: Transaction aborted (error %d)\n",	\
 			(errno));					\
 		} else {						\
-			pr_debug("BTRFS: Transaction aborted (error %d)\n", \
+			btrfs_debug((trans)->fs_info,			\
+				    "Transaction aborted (error %d)\n", \
 				  (errno));			\
 		}						\
 	}							\
-- 
2.7.1

