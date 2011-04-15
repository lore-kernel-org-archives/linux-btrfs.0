From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] fs: add a ->fsync_nolock file op
Date: Fri, 15 Apr 2011 15:09:41 -0400
Message-ID: <1302894582-24341-2-git-send-email-josef@redhat.com>
References: <1302894582-24341-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1302894582-24341-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This adds the fsync_nolock file operation for filesystems that need a little
more control over how fsync is used.  Any filesystem that uses this is
responsible for their own locking and making sure the data for the range
provided is actually synced out.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 Documentation/filesystems/vfs.txt |    4 ++++
 fs/sync.c                         |    6 +++++-
 include/linux/fs.h                |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 80815ed..fba2064 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -758,6 +758,7 @@ struct file_operations {
 	int (*fsync) (struct file *, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
+	int (*fsync_nolock) (struct file *, loff_t, loff_t, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
 	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
@@ -815,6 +816,9 @@ otherwise noted.
   fasync: called by the fcntl(2) system call when asynchronous
 	(non-blocking) mode is enabled for a file
 
+  fsync_nolock: called by the fsync(2) system call, this is used in lieu of
+	->fsync if your fs does it's own locking for fsync.
+
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
   	commands
 
diff --git a/fs/sync.c b/fs/sync.c
index c38ec16..d0ff770 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -168,11 +168,15 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 	struct address_space *mapping = file->f_mapping;
 	int err, ret;
 
-	if (!file->f_op || !file->f_op->fsync) {
+	if (!file->f_op ||
+	    (!file->f_op->fsync && !file->f_op->fsync_nolock)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
+	if (file->f_op->fsync_nolock)
+		return file->f_op->fsync_nolock(file, start, end, datasync);
+
 	ret = filemap_write_and_wait_range(mapping, start, end);
 
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1b95af3..0764d6a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1553,6 +1553,7 @@ struct file_operations {
 	int (*fsync) (struct file *, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
+	int (*fsync_nolock) (struct file *, loff_t, loff_t, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
-- 
1.7.2.3

