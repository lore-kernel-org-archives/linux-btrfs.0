From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 54/99] btrfs: wait_for_writer should return void
Date: Wed, 23 Nov 2011 19:36:27 -0500
Message-ID: <20111124004226.068631771@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 wait_for_writer has no error conditions and should return void. Its
 callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/tree-log.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2c45b3d..aac743b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1964,8 +1964,8 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int wait_for_writer(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root)
+static void wait_for_writer(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
 	while (atomic_read(&root->log_writers)) {
@@ -1978,7 +1978,6 @@ static int wait_for_writer(struct btrfs_trans_handle *trans,
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
-	return 0;
 }
 
 /*



