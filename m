From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix balance Oops
Date: Fri, 07 Aug 2009 14:14:09 +0800
Message-ID: <4A7BC631.3040106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

invalidate_inode_pages2_range may return -EBUSY occasionally
which results Oops. This patch fixes the issue by moving
invalidate_inode_pages2_range into a loop and keeping calling
it until the return value is not -EBUSY.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
--- 1/fs/btrfs/relocation.c	2009-07-29 10:03:04.367858774 +0800
+++ 2/fs/btrfs/relocation.c	2009-08-07 13:26:43.882147138 +0800
@@ -2553,8 +2553,13 @@ int relocate_inode_pages(struct inode *i
 	last_index = (start + len - 1) >> PAGE_CACHE_SHIFT;
 
 	/* make sure the dirty trick played by the caller work */
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    first_index, last_index);
+	while (1) {
+		ret = invalidate_inode_pages2_range(inode->i_mapping,
+						    first_index, last_index);
+		if (ret != -EBUSY)
+			break;
+		cond_resched();
+	}
 	if (ret)
 		goto out_unlock;
 
