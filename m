Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38042 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaA0N3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:29:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so2263349eek.33
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:29:04 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id k41sm42524889eey.0.2014.01.27.05.29.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:29:02 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2 4/6] btrfs: new ioctl TREE_SEARCH_V2
Date: Mon, 27 Jan 2014 14:28:30 +0100
Message-Id: <1390829312-814-5-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new ioctl call allows the user to supply a buffer of varying size in which
a tree search can store its results. This is much more flexible if you want to
receive items which are larger than the current fixed buffer of 3992 bytes or
if you want to fetch mor item at once.

Currently the buffer is limited to 32 pages.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c           | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  8 ++++++++
 2 files changed, 56 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9fa222d..c44fcdd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2032,6 +2032,52 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	return ret;
 }
 
+static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
+					   void __user *argp)
+{
+	struct btrfs_ioctl_search_args_v2 *args;
+	struct inode *inode;
+	int ret;
+	char *buf;
+	size_t buf_size;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* copy search header and buffer size */
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+
+	buf_size = args->buf_size;
+
+	if (buf_size < sizeof(struct btrfs_ioctl_search_header)) {
+		kfree(args);
+		return -ENOMEM;
+	}
+
+	/* limit memory */
+	if (buf_size > PAGE_SIZE * 32)
+		buf_size = PAGE_SIZE * 32;
+
+	buf = memdup_user(argp->buf, buf_size);
+	if (IS_ERR(buf)) {
+		kfree(args);
+		return PTR_ERR(buf);
+	}
+
+	inode = file_inode(file);
+	ret = search_ioctl(inode, &args->key, buf_size, buf);
+	if (ret == 0 && (
+		copy_to_user(argp, args, sizeof(*args)) ||
+		copy_to_user(argp->buf, buf, buf_size)
+		))
+		ret = -EFAULT;
+	kfree(buf);
+	kfree(args);
+	return ret;
+}
+
 /*
  * Search INODE_REFs to identify path name of 'dirid' directory
  * in a 'tree_id' tree. and sets path name to 'name'.
@@ -4777,6 +4823,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_TREE_SEARCH:
 		return btrfs_ioctl_tree_search(file, argp);
+	case BTRFS_IOC_TREE_SEARCH_V2:
+		return btrfs_ioctl_tree_search_v2(file, argp);
 	case BTRFS_IOC_INO_LOOKUP:
 		return btrfs_ioctl_ino_lookup(file, argp);
 	case BTRFS_IOC_INO_PATHS:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1b8a0f4..6ba0d0f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -301,6 +301,12 @@ struct btrfs_ioctl_search_args {
 	char buf[BTRFS_SEARCH_ARGS_BUFSIZE];
 };
 
+struct btrfs_ioctl_search_args_v2 {
+	struct btrfs_ioctl_search_key key;
+	size_t buf_size;
+	char buf[0];
+};
+
 struct btrfs_ioctl_clone_range_args {
   __s64 src_fd;
   __u64 src_offset, src_length;
@@ -553,6 +559,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
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

