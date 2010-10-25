From: Sage Weil <sage@newdream.net>
Subject: [PATCH 5/6] Btrfs: make SNAP_DESTROY async
Date: Mon, 25 Oct 2010 12:07:41 -0700
Message-ID: <1288033662-21464-6-git-send-email-sage@newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
 <1288033662-21464-3-git-send-email-sage@newdream.net>
 <1288033662-21464-4-git-send-email-sage@newdream.net>
 <1288033662-21464-5-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-5-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

There is no reason to force an immediate commit when deleting a snapshot.
Users have some expectation that space from a deleted snapshot be freed
immediately, but even if we do commit the reclaim is a background process.

If users _do_ want the deletion to be durable, they can call 'sync'.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 679b8a8..9cbda86 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1365,7 +1365,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		BUG_ON(ret);
 	}
 
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_end_transaction(trans, root);
 	BUG_ON(ret);
 	inode->i_flags |= S_DEAD;
 out_up_write:
-- 
1.6.6.1

