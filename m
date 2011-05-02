From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: Document a mutex lock/unlock sequence
Date: Mon,  2 May 2011 15:49:55 +0200
Message-ID: <1304344195-8986-1-git-send-email-dsterba@suse.cz>
References: <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
Cc: chris.mason@oracle.com, t-itoh@jp.fujitsu.com,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/extent-tree.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a160f11..fba1348 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -756,6 +756,10 @@ again:
 
 			btrfs_release_path(path);
 
+			/*
+			 * Mutex was contended, block until it's released and try
+			 * again
+			 */
 			mutex_lock(&head->mutex);
 			mutex_unlock(&head->mutex);
 			btrfs_put_delayed_ref(&head->node);
@@ -2297,6 +2301,10 @@ again:
 				atomic_inc(&ref->refs);
 
 				spin_unlock(&delayed_refs->lock);
+				/*
+				 * Mutex was contended, block until it's
+				 * released and try again
+				 */
 				mutex_lock(&head->mutex);
 				mutex_unlock(&head->mutex);
 
@@ -2363,6 +2371,10 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
 
 		btrfs_release_path(path);
 
+		/*
+		 * Mutex was contended, block until it's released and let
+		 * caller try again
+		 */
 		mutex_lock(&head->mutex);
 		mutex_unlock(&head->mutex);
 		btrfs_put_delayed_ref(&head->node);
-- 
1.7.5.rc3

