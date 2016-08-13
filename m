Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35307 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbcHNKui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 06:50:38 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, torvalds@linux-foundation.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk, y2038@lists.linaro.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH v4 10/26] fs: btrfs: Use ktime_get_real_ts for root ctime
Date: Sat, 13 Aug 2016 15:48:22 -0700
Message-Id: <1471128518-24075-11-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1471128518-24075-1-git-send-email-deepa.kernel@gmail.com>
References: <1471128518-24075-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_root_item maintains the ctime for root updates.
This is not part of vfs_inode.

Since current_time() uses struct inode* as an argument
as Linus suggested, this cannot be used to update root
times unless, we modify the signature to use inode.

Since btrfs uses nanosecond time granularity, it can also
use ktime_get_real_ts directly to obtain timestamp for
the root. It is necessary to use the timespec time api
here because the same btrfs_set_stack_timespec_*() apis
are used for vfs inode times as well. These can be
transitioned to using timespec64 when btrfs internally
changes to use timespec64 as well.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/root-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7fd7e18..212ae51 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -496,10 +496,11 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
 	struct btrfs_root_item *item = &root->root_item;
-	struct timespec ct = current_fs_time(root->fs_info->sb);
+	struct timespec ct;
 
 	spin_lock(&root->root_item_lock);
 	btrfs_set_root_ctransid(item, trans->transid);
+	ktime_get_real_ts(&ct);
 	btrfs_set_stack_timespec_sec(&item->ctime, ct.tv_sec);
 	btrfs_set_stack_timespec_nsec(&item->ctime, ct.tv_nsec);
 	spin_unlock(&root->root_item_lock);
-- 
1.9.1

