From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/3]  Implement our own copy of the nfsd readdir hack, for
	older kernels
Date: Tue, 12 Aug 2008 14:46:51 +0100
Message-ID: <1218548811.2977.180.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200806290505.31641.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 inode.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/inode.c b/inode.c
index 5344526..faa5543 100644
--- a/inode.c
+++ b/inode.c
@@ -1956,7 +1956,8 @@ static unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int btrfs_real_readdir(struct file *filp, void *dirent,
+			      filldir_t filldir)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -2105,6 +2106,101 @@ err:
 	return ret;
 }
 
+/* Kernels earlier than 2.6.28 still have the NFS deadlock where nfsd
+   will call the file system's ->lookup() method from within its
+   filldir callback, which in turn was called from the file system's
+   ->readdir() method. And will deadlock for many file systems. */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+
+struct nfshack_dirent {
+	u64		ino;
+	loff_t		offset;
+	int		namlen;
+	unsigned int	d_type;
+	char		name[];
+};
+
+struct nfshack_readdir {
+	char		*dirent;
+	size_t		used;
+};
+
+
+
+static int btrfs_nfshack_filldir(void *__buf, const char *name, int namlen,
+			      loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct nfshack_readdir *buf = __buf;
+	struct nfshack_dirent *de = (void *)(buf->dirent + buf->used);
+	unsigned int reclen;
+
+	reclen = ALIGN(sizeof(struct nfshack_dirent) + namlen, sizeof(u64));
+	if (buf->used + reclen > PAGE_SIZE)
+		return -EINVAL;
+
+	de->namlen = namlen;
+	de->offset = offset;
+	de->ino = ino;
+	de->d_type = d_type;
+	memcpy(de->name, name, namlen);
+	buf->used += reclen;
+
+	return 0;
+}
+
+static int btrfs_nfshack_readdir(struct file *file, void *dirent,
+				 filldir_t filldir)
+{
+	struct nfshack_readdir buf;
+	struct nfshack_dirent *de;
+	int err;
+	int size;
+	loff_t offset;
+
+	buf.dirent = (void *)__get_free_page(GFP_KERNEL);
+	if (!buf.dirent)
+		return -ENOMEM;
+
+	offset = file->f_pos;
+
+	while (1) {
+		unsigned int reclen;
+
+		buf.used = 0;
+
+		err = btrfs_real_readdir(file, &buf, btrfs_nfshack_filldir);
+		if (err)
+			break;
+
+		size = buf.used;
+
+		if (!size)
+			break;
+
+		de = (struct nfshack_dirent *)buf.dirent;
+		while (size > 0) {
+			offset = de->offset;
+
+			if (filldir(dirent, de->name, de->namlen, de->offset,
+				    de->ino, de->d_type))
+				goto done;
+			offset = file->f_pos;
+
+			reclen = ALIGN(sizeof(*de) + de->namlen,
+				       sizeof(u64));
+			size -= reclen;
+			de = (struct nfshack_dirent *)((char *)de + reclen);
+		}
+	}
+
+ done:
+	free_page((unsigned long)buf.dirent);
+	file->f_pos = offset;
+
+	return err;
+}
+#endif
+
 int btrfs_write_inode(struct inode *inode, int wait)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3661,7 +3757,11 @@ static struct inode_operations btrfs_dir_ro_inode_operations = {
 static struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
-	.readdir	= btrfs_readdir,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+	.readdir	= btrfs_nfshack_readdir,
+#else /* NFSd readdir/lookup deadlock is fixed */
+	.readdir	= btrfs_real_readdir,
+#endif
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


