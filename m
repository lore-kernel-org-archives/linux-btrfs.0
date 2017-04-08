Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33871 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934077AbdDHA6y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:54 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
Subject: [PATCH 07/12] fs: btrfs: Use ktime_get_real_ts for root ctime
Date: Fri,  7 Apr 2017 17:57:05 -0700
Message-Id: <1491613030-11599-8-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
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
---
 fs/btrfs/root-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index a08224e..7d6bc30 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -501,8 +501,9 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
 	struct btrfs_root_item *item = &root->root_item;
-	struct timespec ct = current_fs_time(root->fs_info->sb);
+	struct timespec ct;
 
+	ktime_get_real_ts(&ct);
 	spin_lock(&root->root_item_lock);
 	btrfs_set_root_ctransid(item, trans->transid);
 	btrfs_set_stack_timespec_sec(&item->ctime, ct.tv_sec);
-- 
2.7.4

