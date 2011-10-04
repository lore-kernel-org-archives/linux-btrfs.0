From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 33/65] btrfs: tree-log: wait_for_writer should return void
Date: Mon, 03 Oct 2011 23:23:03 -0400
Message-ID: <20111004032303.703877593@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 wait_for_writer has no error conditions and should return void. Its
 callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/tree-log.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1964,8 +1964,8 @@ static int wait_log_commit(struct btrfs_
 	return 0;
 }
 
-static int wait_for_writer(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root)
+static void wait_for_writer(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
 	while (atomic_read(&root->log_writers)) {
@@ -1978,7 +1978,6 @@ static int wait_for_writer(struct btrfs_
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
-	return 0;
 }
 
 /*


