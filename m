From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/5] FS: btrfs, don't touch freed memory
Date: Mon, 29 Jun 2009 18:01:45 +0200
Message-ID: <1246291305-3444-1-git-send-email-jirislaby@gmail.com>
Cc: linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760437AbZF2QCQ@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

worker memory is already freed on one fail path in btrfs_start_workers,
but is still dereferenced. Switch the dereference and kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7f88628..6e4f6c5 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -299,8 +299,8 @@ int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
 					   "btrfs-%s-%d", workers->name,
 					   workers->num_workers + i);
 		if (IS_ERR(worker->task)) {
-			kfree(worker);
 			ret = PTR_ERR(worker->task);
+			kfree(worker);
 			goto fail;
 		}
 
-- 
1.6.3.2
