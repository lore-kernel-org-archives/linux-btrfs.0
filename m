Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53286 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaA0N3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:29:07 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so2256908eek.11
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:29:06 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id o43sm42500302eef.12.2014.01.27.05.29.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:29:05 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2 5/6] btrfs: search_ioctl: direct copy to userspace
Date: Mon, 27 Jan 2014 14:28:31 +0100
Message-Id: <1390829312-814-6-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By copying each found item seperatly to userspace, we only need a small buffer
in the kernel. This allows to run a large search inside of a single call.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 107 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c44fcdd..38403e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1851,7 +1851,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
 			       size_t buf_size,
-			       char *buf,
+			       char __user *buf,
 			       unsigned long *sk_offset,
 			       int *num_found)
 {
@@ -1865,6 +1865,9 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	int slot;
 	int ret = 0;
 
+	char *content_buffer = NULL;
+	unsigned long content_buffer_size = 0;
+
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	nritems = btrfs_header_nritems(leaf);
@@ -1886,7 +1889,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (sizeof(sh) + item_len > buf_size) {
 			if (*num_found) {
 				ret = 1;
-				goto overflow;
+				goto err;
 			}
 
 			item_len = 0;
@@ -1895,7 +1898,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 
 		if (sizeof(sh) + item_len + *sk_offset > buf_size) {
 			ret = 1;
-			goto overflow;
+			goto err;
 		}
 
 		sh.objectid = key->objectid;
@@ -1905,20 +1908,47 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		sh.transid = found_transid;
 
 		/* copy search result header */
-		memcpy(buf + *sk_offset, &sh, sizeof(sh));
+		if (copy_to_user(buf + *sk_offset, &sh, sizeof(sh))) {
+			ret = -EFAULT;
+			goto err;
+		}
+
 		*sk_offset += sizeof(sh);
 
 		if (item_len) {
-			char *p = buf + *sk_offset;
+			/* resize internal buffer if needed */
+			if (content_buffer_size < item_len) {
+				kfree(content_buffer);
+
+				content_buffer_size =
+					ALIGN(item_len, PAGE_SIZE);
+
+				content_buffer = kmalloc_track_caller(
+					content_buffer_size, GFP_KERNEL);
+
+				if (!content_buffer) {
+					content_buffer_size = 0;
+					ret = -ENOMEM;
+					goto err;
+				}
+			}
+
 			/* copy the item */
-			read_extent_buffer(leaf, p,
+			read_extent_buffer(leaf, content_buffer,
 					   item_off, item_len);
+
+			if (copy_to_user(buf + *sk_offset,
+					 content_buffer, item_len)) {
+				ret = -EFAULT;
+				goto err;
+			}
+
 			*sk_offset += item_len;
 		}
 		(*num_found)++;
 
 		if (ret) /* -EOVERFLOW from above */
-			goto overflow;
+			goto err;
 
 		if (*num_found >= sk->nr_items)
 			break;
@@ -1936,14 +1966,25 @@ advance_key:
 		key->objectid++;
 	} else
 		ret = 1;
-overflow:
+err:
+	/*
+	    0: all items from this leaf copied, continue with next
+	    1: more items can be copied, but buffer is too small or all items
+	       were found. Either way, it will stops the loop which iterates to
+	       the next leaf
+	    -EOVERFLOW: item was to large for buffer
+	    -ENOMEM: could not allocate memory for a temporary extent buffer
+	    -EFAULT: could not copy extent buffer back to userspace
+	*/
+	kfree(content_buffer);
+
 	return ret;
 }
 
 static noinline int search_ioctl(struct inode *inode,
 				 struct btrfs_ioctl_search_key *sk,
 				 size_t buf_size,
-				 char *buf
+				 char __user *buf
 				 )
 {
 	struct btrfs_root *root;
@@ -1996,6 +2037,7 @@ static noinline int search_ioctl(struct inode *inode,
 		ret = copy_to_sk(root, path, &key, sk, buf_size, buf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
+
 		if (ret || num_found >= sk->nr_items)
 			break;
 
@@ -2011,34 +2053,39 @@ err:
 static noinline int btrfs_ioctl_tree_search(struct file *file,
 					   void __user *argp)
 {
-	 struct btrfs_ioctl_search_args *args;
-	 struct inode *inode;
-	 int ret;
+	struct btrfs_ioctl_search_args __user *usarg;
+	struct btrfs_ioctl_search_key *sk;
+	struct inode *inode;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = memdup_user(argp, sizeof(*args));
-	if (IS_ERR(args))
-		return PTR_ERR(args);
+	usarg = (struct btrfs_ioctl_search_args __user *)argp;
+
+	sk = memdup_user(&usarg->key, sizeof(*sk));
+	if (IS_ERR(sk))
+		return PTR_ERR(sk);
 
 	inode = file_inode(file);
-	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
+	ret = search_ioctl(inode, sk, sizeof(usarg->buf), usarg->buf);
+	/* the origin ioctl does handle too large results by returning an item
+	* with a len of 0 */
 	if (ret == -EOVERFLOW)
 		ret = 0;
-	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
+	if (ret == 0 && copy_to_user(argp, sk, sizeof(*sk)))
 		ret = -EFAULT;
-	kfree(args);
+	kfree(sk);
 	return ret;
 }
 
 static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 					   void __user *argp)
 {
+	struct btrfs_ioctl_search_args_v2 __user *usarg;
 	struct btrfs_ioctl_search_args_v2 *args;
 	struct inode *inode;
 	int ret;
-	char *buf;
 	size_t buf_size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2049,31 +2096,19 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 	if (IS_ERR(args))
 		return PTR_ERR(args);
 
+	usarg = (struct btrfs_ioctl_search_args_v2 __user *)argp;
+
 	buf_size = args->buf_size;
 
 	if (buf_size < sizeof(struct btrfs_ioctl_search_header)) {
 		kfree(args);
-		return -ENOMEM;
-	}
-
-	/* limit memory */
-	if (buf_size > PAGE_SIZE * 32)
-		buf_size = PAGE_SIZE * 32;
-
-	buf = memdup_user(argp->buf, buf_size);
-	if (IS_ERR(buf)) {
-		kfree(args);
-		return PTR_ERR(buf);
+		return -EOVERFLOW;
 	}
 
 	inode = file_inode(file);
-	ret = search_ioctl(inode, &args->key, buf_size, buf);
-	if (ret == 0 && (
-		copy_to_user(argp, args, sizeof(*args)) ||
-		copy_to_user(argp->buf, buf, buf_size)
-		))
+	ret = search_ioctl(inode, &args->key, buf_size, usarg->buf);
+	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
-	kfree(buf);
 	kfree(args);
 	return ret;
 }
-- 
1.8.5.3

