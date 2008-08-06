From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 19:45:12 +0100
Message-ID: <1218048312.5111.128.camel@pmac.infradead.org>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
	 <1218034728.5111.77.camel@pmac.infradead.org>
	 <1218035592.15342.78.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218035592.15342.78.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 11:13 -0400, Chris Mason wrote:
> We do need the readdir hack, being able to test on older kernels (say
> 2.6.26) is a big part of attracting and keeping btrfs testers.

Well, those testers don't seem to have been put off so far by the fact
that you can't export it by NFS. But it's easy enough to copy it over.

Added to git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git

From: David Woodhouse <David.Woodhouse@intel.com>
Date: Wed, 6 Aug 2008 19:42:33 +0100
Subject: [PATCH] Implement our own copy of the nfsd readdir hack, for older kernels

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 ctree.h  |    4 ++
 export.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 inode.c  |    8 ++++-
 3 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3694f03..7200178 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1694,6 +1694,7 @@ void btrfs_destroy_inode(struct inode *inode);
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
+int btrfs_real_readdir(struct file *filp, void *dirent, filldir_t filldir);
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root);
 struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
@@ -1709,6 +1710,9 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
 
+/* export.c */
+int btrfs_nfshack_readdir(struct file *filp, void *dirent, filldir_t filldir);
+
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
diff --git a/export.c b/export.c
index 9070674..d152fbc 100644
--- a/export.c
+++ b/export.c
@@ -181,3 +181,97 @@ const struct export_operations btrfs_export_ops = {
 	.fh_to_parent	= btrfs_fh_to_parent,
 	.get_parent	= btrfs_get_parent,
 };
+
+/* Kernels without FS_LOOKUP_IN_READDIR still have the NFS deadlock where
+   nfsd will call the file system's ->lookup() method from within its
+   filldir callback, which in turn was called from the file system's 
+   ->readdir() method. And will deadlock for many file systems. */
+#ifndef FS_LOOKUP_IN_READDIR
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
+int btrfs_nfshack_readdir(struct file *file, void *dirent, filldir_t filldir)
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
diff --git a/inode.c b/inode.c
index 393b7aa..f8b3fde 100644
--- a/inode.c
+++ b/inode.c
@@ -1956,7 +1956,7 @@ static unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+int btrfs_real_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3661,7 +3661,11 @@ static struct inode_operations btrfs_dir_ro_inode_operations = {
 static struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
-	.readdir	= btrfs_readdir,
+#ifdef FS_LOOKUP_IN_READDIR /* NFSd readdir/lookup deadlock is fixed */
+	.readdir	= btrfs_real_readdir,
+#else /* otherwise, we need to work around it ourselves */
+	.readdir	= btrfs_nfshack_readdir,
+#endif
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_ioctl,
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



