Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab2EaPIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 11:08:09 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VF89IV023651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:08:09 -0400
Received: from localhost.localdomain.com (vpn-8-248.rdu.redhat.com [10.11.8.248])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4VF89R6007007
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:08:09 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check the return code of btrfs_save_ino_cache
Date: Thu, 31 May 2012 11:08:03 -0400
Message-Id: <1338476883-5338-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In doing my enospc work I would sometimes error out in btrfs_save_ino_cache
which would abort the transaction but we'd still end up with a corrupted
file system.  This is because we don't actually check the return value and
so if somethign goes wrong we just exit out and screw everything up.  This
fixes this particular part.  Thanks,
Btrfs: check the return code of btrfs_save_ino_cache

In doing my enospc work I would sometimes error out in btrfs_save_ino_cache
which would abort the transaction but we'd still end up with a corrupted
file system.  This is because we don't actually check the return value and
so if somethign goes wrong we just exit out and screw everything up.  This
fixes this particular part.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 82b03af..7aed0e8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -823,7 +823,9 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_update_reloc_root(trans, root);
 			btrfs_orphan_commit_root(trans, root);
 
-			btrfs_save_ino_cache(root, trans);
+			err = btrfs_save_ino_cache(root, trans);
+			if (err)
+				goto out;
 
 			/* see comments in should_cow_block() */
 			root->force_cow = 0;
@@ -848,6 +850,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
+out:
 	return err;
 }
 
-- 
1.7.7.6

