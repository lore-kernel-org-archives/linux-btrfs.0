Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46537 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaA3PYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:15 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so1688911eek.27
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:13 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id v1sm23649582eef.9.2014.01.30.07.24.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:13 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 2/7] btrfs: tree_search, search_ioctl: accept varying buffer
Date: Thu, 30 Jan 2014 16:23:58 +0100
Message-Id: <1391095443-20287-3-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rewrite search_ioctl to accept a buffer with varying size

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b1c5b4f..9b66eac 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1854,6 +1854,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
+			       size_t buf_size,
 			       char *buf,
 			       unsigned long *sk_offset,
 			       int *num_found)
@@ -1886,11 +1887,10 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (!key_in_sk(key, sk))
 			continue;
 
-		if (sizeof(sh) + item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
+		if (sizeof(sh) + item_len > buf_size)
 			item_len = 0;
 
-		if (sizeof(sh) + item_len + *sk_offset >
-		    BTRFS_SEARCH_ARGS_BUFSIZE) {
+		if (sizeof(sh) + item_len + *sk_offset > buf_size) {
 			ret = 1;
 			goto out;
 		}
@@ -1937,17 +1937,21 @@ out:
 }
 
 static noinline int search_ioctl(struct inode *inode,
-				 struct btrfs_ioctl_search_args *args)
+				 struct btrfs_ioctl_search_key *sk,
+				 size_t buf_size,
+				 char *buf)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct btrfs_ioctl_search_key *sk = &args->key;
 	struct btrfs_fs_info *info = BTRFS_I(inode)->root->fs_info;
 	int ret;
 	int num_found = 0;
 	unsigned long sk_offset = 0;
 
+	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
+		return -EOVERFLOW;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1981,7 +1985,7 @@ static noinline int search_ioctl(struct inode *inode,
 				ret = 0;
 			goto err;
 		}
-		ret = copy_to_sk(root, path, &key, sk, args->buf,
+		ret = copy_to_sk(root, path, &key, sk, buf_size, buf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
 		if (ret)
@@ -2010,7 +2014,7 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 		return PTR_ERR(args);
 
 	inode = file_inode(file);
-	ret = search_ioctl(inode, args);
+	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
 	kfree(args);
-- 
1.8.5.3

