From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: fix race between allocate and release extent buffer.
Date: Thu, 04 Feb 2010 16:46:56 +0800
Message-ID: <4B6A8980.206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Increase extent buffer's reference count while holding the lock.
Otherwise it can race with try_release_extent_buffer.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent_io.c 2/fs/btrfs/extent_io.c
--- 1/fs/btrfs/extent_io.c	2010-01-17 15:48:16.770302026 +0800
+++ 2/fs/btrfs/extent_io.c	2010-02-04 16:37:45.704800682 +0800
@@ -3165,10 +3165,9 @@ struct extent_buffer *alloc_extent_buffe
 		spin_unlock(&tree->buffer_lock);
 		goto free_eb;
 	}
-	spin_unlock(&tree->buffer_lock);
-
 	/* add one reference for the tree */
 	atomic_inc(&eb->refs);
+	spin_unlock(&tree->buffer_lock);
 	return eb;
 
 free_eb:
