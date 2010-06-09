From: Nikanth Karthikesan <knikanth@novell.com>
Subject: [PATCH][RFC] Complex filesystem operations: split and join
Date: Wed, 9 Jun 2010 20:35:46 +0530
Message-ID: <201006092035.46481.knikanth@novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I had a need to split a file into smaller files on a thumb drive with n=
o
free space on it or anywhere else in the system. When the filesystem
supports sparse files(truncate_range), I could create files, while
punching holes in the original file. But when the underlying fs is FAT,
I couldn't. Also why should we do needless I/O, when all I want is to
split/join files. i.e., all the data are already on the disk, under the
same filesystem. I just want to do some metadata changes.

So, I added two inode operations, namely split and join, that lets me
tell the OS, that all I want is meta-data changes. And the file-system
can avoid doing lots of I/O, when only metadata changes are needed.

sys_split(fd1, n, fd2)
1. Attach the data of file after n bytes in fd1 to fd2.
2. Truncate fd1 to n bytes.

Roughly can be thought of as equivalent of following commands:
1. dd if=3Dfile1 of=3Dfile2 skip=3Dn
2. truncate -c -s n file1

sys_join(fd1, fd2)
1. Extend fd1 with data of fd2
2. Truncate fd2 to 0.

Roughly can be thought of as equivalent of following commands:
1. dd if=3Dfile2 of=3Dfile1 seek=3D`filesize file1`
2. truncate -c -s 0 file2

Attached is the patch that adds these new syscalls and support for them
to the FAT filesystem.

I guess, this approach can be extended to splice() kind of call, betwee=
n
files, instead of pipes. On a COW fs, splice could simply setup blocks
as shared between files, instead of doing I/O. It would be a kind of
explicit online data-deduplication. Later when a file modifies any of
those blocks, we copy blocks. i.e., COW.

Thanks
Nikanth

p.s: Strangely fibrils and syslets came to my mind, when thinking along
these lines. But, I guess fibrils or syslets are not really related to
this.



=46rom: Nikanth Karthikesan <knikanth@suse.de>
Subject: vfs and vfat: add filesystem operations: split and join

Add 2 new inode_operation, namely sys_split and sys_join, with the
following semantics.

sys_split(fd1, n, fd2)
1. Attach the data of file after n bytes in fd1 to fd2.
2. Truncate fd1 to n bytes.

sys_join(fd1, fd2)
1. Extend fd1 with data of fd2
2. Truncate fd2 to 0.

These avoid doing unnecessary I/O that would be needed when the same
should be accompolished using only read,write,truncate. Also using
read/write would require temporary additional free space on filesystems
that do not support sparse files. The files should belong to the same
super block.

The split should be on a cluster boundary, i.e., it should be a multipl=
e
of cluster size i.e., filesystem block-size. And for join the size of
destination file should be a multiple of filesystem block size i.e., FA=
T
cluster size. Also the syscalls are added only to x86_64, for now.

Some performance numbers of splitting a file into half of its size and
then concatenating it back together using and not using these syscalls.

filesize     Using sys_split & sys_join        Using read/write
 1GB                 0.080                        56.557
 2GB                 0.117                       116.140
 3GB                 0.112                       144.658

All numbers are seconds.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---


diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/un=
istd_64.h
index ff4307b..0b9bdf8 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,10 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueu=
einfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_split				300
+__SYSCALL(__NR_split, sys_split)
+#define __NR_join				301
+__SYSCALL(__NR_join, sys_join)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 990dfae..81e426c 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -453,7 +453,118 @@ out:
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
=20
+/*
+ * Join the cluster chain of tail_inode to the end of head_inode.
+ */
+int fat_join(struct inode *head_inode, struct inode *tail_inode)
+{
+	struct super_block *sb =3D head_inode->i_sb;
+	struct msdos_sb_info *sbi =3D MSDOS_SB(sb);
+	int nr_cluster;
+	int ret =3D 0;
+
+	nr_cluster =3D head_inode->i_size >> sbi->cluster_bits;
+	if (nr_cluster << sbi->cluster_bits !=3D head_inode->i_size) {
+		return -EINVAL;
+	}
+
+	nr_cluster =3D tail_inode->i_size >> sbi->cluster_bits;
+
+	fat_cache_inval_inode(head_inode);
+	fat_cache_inval_inode(tail_inode);
+
+	ret =3D fat_chain_add(head_inode, MSDOS_I(tail_inode)->i_start, nr_cl=
uster);
+	if (ret)
+		goto out;
+
+	MSDOS_I(tail_inode)->i_start =3D MSDOS_I(tail_inode)->i_logstart =3D =
0;
+	ret =3D simple_setsize(head_inode, head_inode->i_size + tail_inode->i=
_size);
+	if (ret)
+		goto out;
+	head_inode->i_blocks =3D ((head_inode->i_size + tail_inode->i_size)>>=
 sbi->cluster_bits) << (sbi->cluster_bits - 9);
+	ret =3D simple_setsize(tail_inode, 0);
+	tail_inode->i_blocks =3D 0;
+out:
+	mark_inode_dirty(head_inode);
+	mark_inode_dirty(tail_inode);
+
+	return ret;
+}
+
+/*
+ * Split the cluster chain of head_inode after length/cluster_size clu=
sters
+ * And attach the remaining chain to tail_inode.
+ */
+int fat_split(struct inode *head_inode, loff_t new_length, struct inod=
e *tail_inode)
+{
+	struct super_block *sb =3D head_inode->i_sb;
+	struct msdos_sb_info *sbi =3D MSDOS_SB(sb);
+	int ret =3D 0, new_fclus, last;
+	int nr_cluster;
+	struct fat_entry fatent;
+
+	nr_cluster =3D new_length >> sbi->cluster_bits;=20
+	if (nr_cluster << sbi->cluster_bits !=3D new_length)
+		return -EINVAL;
+
+	fat_cache_inval_inode(head_inode);
+	fat_cache_inval_inode(tail_inode);
+
+	last =3D new_fclus =3D 0;
+	if (MSDOS_I(head_inode)->i_start) {
+		int fclus, dclus, last_clus;
+		loff_t oldsize, newsize;
+		struct msdos_sb_info *sbi =3D MSDOS_SB(sb);
+
+		ret =3D fat_get_cluster(head_inode, nr_cluster - 1, &fclus, &dclus);
+		last_clus =3D dclus;
+
+		if (ret < 0)=20
+			goto out;
+
+		if (ret =3D=3D FAT_ENT_EOF) {
+			ret =3D -1;
+			goto out;
+		}
+
+		ret =3D fat_get_cluster(head_inode, nr_cluster, &fclus, &dclus);
+
+		if (ret < 0)=20
+			goto out;
+
+		if (ret =3D=3D FAT_ENT_EOF) {
+			ret =3D -1;
+			goto out;
+		}
+
+		oldsize=3D head_inode->i_size;
+		newsize =3D nr_cluster * sbi->sec_per_clus * 512;
+
+		fatent_init(&fatent);
+		ret =3D fat_ent_read(head_inode, &fatent, last_clus);
+		ret =3D fat_ent_write(head_inode, &fatent, FAT_ENT_EOF, 1);
+		fatent_brelse(&fatent);
+
+		ret =3D simple_setsize(head_inode, newsize);
+		head_inode->i_blocks =3D nr_cluster << (sbi->cluster_bits - 9);
+
+		MSDOS_I(tail_inode)->i_logstart =3D
+		MSDOS_I(tail_inode)->i_start =3D cpu_to_le32(dclus);
+		ret =3D simple_setsize(tail_inode, oldsize - newsize);
+		tail_inode->i_blocks =3D ((oldsize - newsize) >> sbi->cluster_bits) =
<< (sbi->cluster_bits - 9);
+
+		ret =3D 0;
+	}
+out:
+	mark_inode_dirty(head_inode);
+	mark_inode_dirty(tail_inode);
+
+	return ret;
+}
+
 const struct inode_operations fat_file_inode_operations =3D {
 	.setattr	=3D fat_setattr,
 	.getattr	=3D fat_getattr,
+	.split		=3D fat_split,
+	.join		=3D fat_join,
 };
diff --git a/fs/open.c b/fs/open.c
index 5463266..0d1bfc0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -938,6 +938,146 @@ SYSCALL_DEFINE2(creat, const char __user *, pathn=
ame, int, mode)
 #endif
=20
 /*
+ * Only vfat supports this, so interface might need changes.
+ *
+ * -1: length should be a multiple of filesystem block size
+ *     i.e., vfat cluster size.
+ * -2: Hacky whacky code. (Hackweek.. Yay)
+ * -3: Error paths not verified.
+ * ...
+ * -=E2=88=9E: Idea not validated with experts
+ */
+SYSCALL_DEFINE2(join, unsigned int, fd_dst, unsigned int, fd_src)
+{
+	int ret =3D 0;
+	struct inode *src_inode;
+	struct inode *dst_inode;
+	struct file *src_f;
+	struct file *dst_f;
+
+	src_f =3D fget(fd_src);
+	if (!src_f)
+		return -EINVAL;
+	dst_f =3D fget(fd_dst);
+	if (!dst_f) {
+		fput(src_f);
+		return -EINVAL;
+	}
+
+	src_inode =3D src_f->f_path.dentry->d_inode;
+	dst_inode =3D dst_f->f_path.dentry->d_inode;
+
+	if (!dst_inode->i_op->join) {
+		ret =3D -ENOTSUPP;
+		goto out;
+	}
+
+	if (src_inode->i_ino < dst_inode->i_ino) {
+		mutex_lock(&src_inode->i_mutex);
+		mutex_lock(&dst_inode->i_mutex);
+	} else {
+		mutex_lock(&dst_inode->i_mutex);
+		mutex_lock(&src_inode->i_mutex);
+	}
+
+	if (!(src_f->f_mode & FMODE_WRITE) || !(dst_f->f_mode & FMODE_WRITE))=
 {
+		ret =3D -EPERM;
+		goto out;
+	}
+
+	if (dst_inode->i_sb !=3D src_inode->i_sb) {
+		ret =3D -ENOTSUPP;
+		goto out;
+	}
+
+	ret =3D dst_inode->i_op->join(dst_inode, src_inode);
+out:
+	if (src_inode->i_ino < dst_inode->i_ino) {
+		mutex_unlock(&dst_inode->i_mutex);
+		mutex_unlock(&src_inode->i_mutex);
+	} else {
+		mutex_unlock(&src_inode->i_mutex);
+		mutex_unlock(&dst_inode->i_mutex);
+	}
+	fput(src_f);
+	fput(dst_f);
+	return ret;
+}
+
+/*
+ * Only vfat supports this, so interface might need changes.
+ *
+ * -1: length should be a multiple of filesystem block size
+ *     i.e., vfat cluster size.
+ * -2: Hacky whacky code. (Hackweek.. Yay)
+ * -3: Error paths not verified.
+ * ...
+ * -=E2=88=9E: Idea not validated with experts
+ */
+SYSCALL_DEFINE3(split, unsigned int, fd_src, loff_t, length, unsigned =
int, fd_dst)
+{
+	int ret =3D 0;
+	struct inode *head_inode;
+	struct inode *tail_inode;
+	struct file *f1;
+	struct file *f2;
+
+	f1 =3D fget(fd_src);
+	if (!f1)
+		return -EINVAL;
+	f2 =3D fget(fd_dst);
+	if (!f2) {
+		fput(f1);
+		return -EINVAL;
+	}
+
+	head_inode =3D f1->f_path.dentry->d_inode;
+	tail_inode =3D f2->f_path.dentry->d_inode;
+
+	if (head_inode->i_ino < tail_inode->i_ino) {
+		mutex_lock(&head_inode->i_mutex);
+		mutex_lock(&tail_inode->i_mutex);
+	} else {
+		mutex_lock(&tail_inode->i_mutex);
+		mutex_lock(&head_inode->i_mutex);
+	}
+
+	if (!head_inode->i_op->split) {
+		ret =3D -ENOTSUPP;
+		goto out;
+	}
+
+	if (!(f2->f_mode & FMODE_WRITE) || !(f1->f_mode & FMODE_WRITE)) {
+		ret =3D -EPERM;
+		goto out;
+	}
+=09
+	if (head_inode->i_size < length || tail_inode->i_size !=3D 0) {
+		ret =3D -EINVAL;=09
+		goto out;
+	}
+
+	if (head_inode->i_sb !=3D tail_inode->i_sb) {
+		ret =3D -ENOTSUPP;
+		goto out;
+	}
+
+	ret =3D head_inode->i_op->split(head_inode, length, tail_inode);
+out:
+	if (head_inode->i_ino < tail_inode->i_ino) {
+		mutex_unlock(&tail_inode->i_mutex);
+		mutex_unlock(&head_inode->i_mutex);
+	} else {
+		mutex_unlock(&head_inode->i_mutex);
+		mutex_unlock(&tail_inode->i_mutex);
+	}
+
+	fput(f1);
+	fput(f2);
+	return ret;
+}
+
+/*
  * "id" is the POSIX thread ID. We use the
  * files pointer for this..
  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3428393..4206bb8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1539,6 +1539,8 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*split)(struct inode *, loff_t, struct inode *);
+	int (*join)(struct inode *, struct inode *);
 };
=20
 struct seq_file;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a1a86a5..b71e81a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -512,6 +512,8 @@ asmlinkage long sys_sendfile64(int out_fd, int in_f=
d,
 asmlinkage long sys_readlink(const char __user *path,
 				char __user *buf, int bufsiz);
 asmlinkage long sys_creat(const char __user *pathname, int mode);
+asmlinkage long sys_split(unsigned int fd_src, loff_t length, unsigned=
 int fd_dst);
+asmlinkage long sys_join(unsigned int fd_dst, unsigned int fd_src);
 asmlinkage long sys_open(const char __user *filename,
 				int flags, int mode);
 asmlinkage long sys_close(unsigned int fd);
