From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix an oops when deleting snapshots
Date: Tue, 23 Aug 2011 17:01:27 +0800
Message-ID: <1314090087-14731-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can reproduce this oops via the following steps:

$ mkfs.btrfs /dev/sdb7
$ mount /dev/sdb7 /mnt/btrfs
$ for ((i=0; i<3; i++)); do btrfs sub snap /mnt/btrfs /mnt/btrfs/s_$i; done
$ rm -fr /mnt/btrfs/*
$ rm -fr /mnt/btrfs/*

then we'll get
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:2264!
[...]
Call Trace:
 [<ffffffffa05578c7>] btrfs_rmdir+0xf7/0x1b0 [btrfs]
 [<ffffffff81150b95>] vfs_rmdir+0xa5/0xf0
 [<ffffffff81153cc3>] do_rmdir+0x123/0x140
 [<ffffffff81145ac7>] ? fput+0x197/0x260
 [<ffffffff810aecff>] ? audit_syscall_entry+0x1bf/0x1f0
 [<ffffffff81153d0d>] sys_unlinkat+0x2d/0x40
 [<ffffffff8147896b>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffffa054f7b9>] btrfs_orphan_add+0x179/0x1a0 [btrfs]

When it comes to btrfs_lookup_dentry, we may set a snapshot's inode->i_ino
to BTRFS_EMPTY_SUBVOL_DIR_OBJECTID instead of BTRFS_FIRST_FREE_OBJECTID,
while the snapshot's location.objectid remains unchanged.

However, btrfs_ino() does not take this into account, and returns a wrong ino,
and causes the oops.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 502b9e9..d9f99a1 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -176,7 +176,11 @@ static inline u64 btrfs_ino(struct inode *inode)
 {
 	u64 ino = BTRFS_I(inode)->location.objectid;
 
-	if (ino <= BTRFS_FIRST_FREE_OBJECTID)
+	/*
+	 * !ino: btree_inode
+	 * type == BTRFS_ROOT_ITEM_KEY: subvol dir
+	 */
+	if (!ino || BTRFS_I(inode)->location.type == BTRFS_ROOT_ITEM_KEY)
 		ino = inode->i_ino;
 	return ino;
 }
-- 
1.6.5.2

