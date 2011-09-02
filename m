From: slyich@gmail.com
Subject: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Fri,  2 Sep 2011 20:01:21 +0300
Message-ID: <1314982881-10754-1-git-send-email-slyich@gmail.com>
References: <20110831001724.1f6225c5@sf>
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110831001724.1f6225c5@sf>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

iput() shouldn't be called for inodes in I_NEW state.
We need to mark inode as constructed first.

WARNING: at fs/inode.c:1309 iput+0x20b/0x210()
Call Trace:
 [<ffffffff8103e7ba>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103e805>] warn_slowpath_null+0x15/0x20
 [<ffffffff810eaf0b>] iput+0x20b/0x210
 [<ffffffff811b96fb>] btrfs_iget+0x1eb/0x4a0
 [<ffffffff811c3ad6>] btrfs_run_defrag_inodes+0x136/0x210
 [<ffffffff811ad55f>] cleaner_kthread+0x17f/0x1a0
 [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff811ad3e0>] ? transaction_kthread+0x280/0x280
 [<ffffffff8105af86>] kthread+0x96/0xa0
 [<ffffffff814336d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105aef0>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff814336d0>] ? gs_change+0xb/0xb

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
Change since Konstantin's patch:
- avoid using explicit destructor for inode, as it can(?)
  be shared among other threads. Use unlock_new_inode()/iput()
  instead. It fixes 100% CPU load after 'sync()' popped-up in
  Konstantin's patch
 fs/btrfs/inode.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..ec4b550 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3952,7 +3952,6 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *new)
 {
 	struct inode *inode;
-	int bad_inode = 0;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
@@ -3968,15 +3967,12 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			if (new)
 				*new = 1;
 		} else {
-			bad_inode = 1;
+			unlock_new_inode(inode);
+			iput(inode);
+			inode = ERR_PTR(-ESTALE);
 		}
 	}
 
-	if (bad_inode) {
-		iput(inode);
-		inode = ERR_PTR(-ESTALE);
-	}
-
 	return inode;
 }
 
-- 
1.7.3.4

