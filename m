From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: don't return EINTR
Date: Sat, 14 Apr 2012 14:56:15 +0200
Message-ID: <1334408175-6568-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It is basically a good thing if we are interruptible when waiting for
free space, but the generality in which it is implemented currently
leads to system calls being interruptible that are not documented this
way. For example git can't handle interrupted unlink(), leading to
corrupt repos under space pressure.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..db13e51 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3772,14 +3772,7 @@ again:
 		 */
 		if (current->journal_info)
 			return -EAGAIN;
-		ret = wait_event_interruptible(space_info->wait,
-					       !space_info->flush);
-		/* Must have been interrupted, return */
-		if (ret) {
-			printk(KERN_DEBUG "btrfs: %s returning -EINTR\n", __func__);
-			return -EINTR;
-		}
-
+		wait_event(space_info->wait, !space_info->flush);
 		spin_lock(&space_info->lock);
 	}
 
-- 
1.7.3.4

