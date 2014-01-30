Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43516 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaA3PYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:22 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so1665941eek.15
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:21 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id k6sm23770984eep.17.2014.01.30.07.24.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:20 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 6/7] btrfs: tree_search, search_ioctl: direct copy to userspace
Date: Thu, 30 Jan 2014 16:24:02 +0100
Message-Id: <1391095443-20287-7-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By copying each found item seperatly to userspace, we do not need extra
buffer in the kernel.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1180293..bab8c67 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1855,7 +1855,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
 			       size_t *buf_size,
-			       char *buf,
+			       char __user *ubuf,
 			       unsigned long *sk_offset,
 			       int *num_found)
 {
@@ -1915,14 +1915,22 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		sh.transid = found_transid;
 
 		/* copy search result header */
-		memcpy(buf + *sk_offset, &sh, sizeof(sh));
+		if (copy_to_user(ubuf + *sk_offset, &sh, sizeof(sh))) {
+			ret = -EFAULT;
+			goto out;
+		}
+
 		*sk_offset += sizeof(sh);
 
 		if (item_len) {
-			char *p = buf + *sk_offset;
+			char __user *up = ubuf + *sk_offset;
 			/* copy the item */
-			read_extent_buffer(leaf, p,
-					   item_off, item_len);
+			if (read_extent_buffer_to_user(leaf, up,
+						       item_off, item_len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+
 			*sk_offset += item_len;
 		}
 		(*num_found)++;
@@ -1949,13 +1957,22 @@ advance_key:
 	} else
 		ret = 1;
 out:
+	/*
+	 *  0: all items from this leaf copied, continue with next
+	 *  1: * more items can be copied, but unused buffer is too small
+	 *     * all items were found
+	 *     Either way, it will stops the loop which iterates to the next
+	 *     leaf
+	 *  -EOVERFLOW: item was to large for buffer
+	 *  -EFAULT: could not copy extent buffer back to userspace
+	 */
 	return ret;
 }
 
 static noinline int search_ioctl(struct inode *inode,
 				 struct btrfs_ioctl_search_key *sk,
 				 size_t *buf_size,
-				 char *buf)
+				 char __user *ubuf)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
@@ -2003,7 +2020,7 @@ static noinline int search_ioctl(struct inode *inode,
 				ret = 0;
 			goto err;
 		}
-		ret = copy_to_sk(root, path, &key, sk, buf_size, buf,
+		ret = copy_to_sk(root, path, &key, sk, buf_size, ubuf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
 		if (ret)
@@ -2021,7 +2038,8 @@ err:
 static noinline int btrfs_ioctl_tree_search(struct file *file,
 					   void __user *argp)
 {
-	struct btrfs_ioctl_search_args *args;
+	struct btrfs_ioctl_search_args __user *uargs;
+	struct btrfs_ioctl_search_key sk;
 	struct inode *inode;
 	int ret;
 	size_t buf_size;
@@ -2029,14 +2047,15 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = memdup_user(argp, sizeof(*args));
-	if (IS_ERR(args))
-		return PTR_ERR(args);
+	uargs = (struct btrfs_ioctl_search_args __user *)argp;
 
-	buf_size = sizeof(args->buf);
+	if (copy_from_user(&sk, &uargs->key, sizeof(sk)))
+		return -EFAULT;
+
+	buf_size = sizeof(uargs->buf);
 
 	inode = file_inode(file);
-	ret = search_ioctl(inode, &args->key, &buf_size, args->buf);
+	ret = search_ioctl(inode, &sk, &buf_size, uargs->buf);
 
 	/*
 	 * In the origin implementation an overflow is handled by returning a
@@ -2045,9 +2064,8 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	if (ret == -EOVERFLOW)
 		ret = 0;
 
-	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
+	if (ret == 0 && copy_to_user(&uargs->key, &sk, sizeof(sk)))
 		ret = -EFAULT;
-	kfree(args);
 	return ret;
 }
 
-- 
1.8.5.3

