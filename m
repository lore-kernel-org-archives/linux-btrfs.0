From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 34/66] btrfs: tree-log: wait_for_writer should return void
Date: Mon, 24 Oct 2011 21:03:10 -0400
Message-ID: <20111025010854.470007142@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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



