From: Amerigo Wang <amwang@redhat.com>
Subject: [Patch v2] btrfs: use file_remove_suid() after i_mutex is held
Date: Mon, 6 Jul 2009 03:18:29 -0400
Message-ID: <20090706072043.6555.13669.sendpatchset@localhost.localdomain>
Cc: Jeff Mahoney <jeffm@suse.com>, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Arjan <arjan@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org,
	Sven Wegener <sven.wegener@stealer.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


V1 -> V2:
Move kmalloc() before mutex_lock(), suggested by Arjan.

file_remove_suid() should be called with i_mutex held,
file_update_time() too. So move them after mutex_lock().

Plus, check the return value of kmalloc().

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Arjan <arjan@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>
Cc: Sven Wegener <sven.wegener@stealer.net>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>

---
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7c3cd24..09ef5d6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	if (count == 0)
 		goto out_nolock;
 
+	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		goto out_nolock;
+
+	mutex_lock(&inode->i_mutex);
+
 	err = file_remove_suid(file);
 	if (err)
-		goto out_nolock;
+		goto out;
 	file_update_time(file);
 
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
-
-	mutex_lock(&inode->i_mutex);
 	BTRFS_I(inode)->sequence++;
 	first_index = pos >> PAGE_CACHE_SHIFT;
 	last_index = (pos + count) >> PAGE_CACHE_SHIFT;
