Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48674 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaA3A14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 19:27:56 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so1256647eae.5
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 16:27:55 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id m1sm15319319een.7.2014.01.29.16.27.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 16:27:54 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv3 6/6] btrfs: new ioctl TREE_SEARCH_V2
Date: Thu, 30 Jan 2014 01:27:31 +0100
Message-Id: <1391041651-15689-7-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
References: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new ioctl call allows the user to supply a buffer of varying size in which
a tree search can store its results. This is much more flexible if you want to
receive items which are larger than the current fixed buffer of 3992 bytes or
if you want to fetch more items at once. Items larger than this buffer are for
example some of the type EXTENT_CSUM.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h | 10 ++++++++++
 2 files changed, 50 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6daf23b..7c16492 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2069,6 +2069,44 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	return ret;
 }
 
+static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
+					       void __user *argp)
+{
+	struct btrfs_ioctl_search_args_v2 __user *uarg;
+	struct btrfs_ioctl_search_args_v2 args;
+	struct inode *inode;
+	int ret;
+	size_t buf_size;
+	const size_t buf_limit = 16 * 1024 * 1024;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* copy search header and buffer size */
+	uarg = (struct btrfs_ioctl_search_args_v2 __user *)argp;
+	if (copy_from_user(&args, uarg, sizeof(args)))
+		return -EFAULT;
+
+	buf_size = args.buf_size;
+
+	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
+		return -EOVERFLOW;
+
+	/* limit result size to 16MB */
+	if (buf_size > buf_limit)
+		buf_size = buf_limit;
+
+	inode = file_inode(file);
+	ret = search_ioctl(inode, &args.key, &buf_size, &uarg->buf[0]);
+	if (ret == 0 && copy_to_user(&uarg->key, &args.key, sizeof(args.key)))
+		ret = -EFAULT;
+	else if (ret == -EOVERFLOW &&
+		copy_to_user(&uarg->buf_size, &buf_size, sizeof(buf_size)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 /*
  * Search INODE_REFs to identify path name of 'dirid' directory
  * in a 'tree_id' tree. and sets path name to 'name'.
@@ -4825,6 +4863,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_TREE_SEARCH:
 		return btrfs_ioctl_tree_search(file, argp);
+	case BTRFS_IOC_TREE_SEARCH_V2:
+		return btrfs_ioctl_tree_search_v2(file, argp);
 	case BTRFS_IOC_INO_LOOKUP:
 		return btrfs_ioctl_ino_lookup(file, argp);
 	case BTRFS_IOC_INO_PATHS:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1b8a0f4..beeda99 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -301,6 +301,14 @@ struct btrfs_ioctl_search_args {
 	char buf[BTRFS_SEARCH_ARGS_BUFSIZE];
 };
 
+struct btrfs_ioctl_search_args_v2 {
+	struct btrfs_ioctl_search_key key; /* in/out - search parameters */
+	size_t buf_size;		   /* in - size of buffer
+					    * out - on EOVERFLOW: needed size
+					    *       to store item */
+	char buf[0];                       /* out - found items */
+};
+
 struct btrfs_ioctl_clone_range_args {
   __s64 src_fd;
   __u64 src_offset, src_length;
@@ -553,6 +561,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				struct btrfs_ioctl_defrag_range_args)
 #define BTRFS_IOC_TREE_SEARCH _IOWR(BTRFS_IOCTL_MAGIC, 17, \
 				   struct btrfs_ioctl_search_args)
+#define BTRFS_IOC_TREE_SEARCH_V2 _IOWR(BTRFS_IOCTL_MAGIC, 17, \
+					   struct btrfs_ioctl_search_args_v2)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
-- 
1.8.5.3

