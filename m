Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:65258 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaA3A1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 19:27:51 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so1240774eei.35
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 16:27:50 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id k41sm15292156eey.0.2014.01.29.16.27.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 16:27:49 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv3 3/6] btrfs: tree_search returns needed size on EOVERFLOW
Date: Thu, 30 Jan 2014 01:27:28 +0100
Message-Id: <1391041651-15689-4-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
References: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If an item in tree_search is too large to be stored in the given buffer, return
the needed size (including the header).

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04e1a98..10b9931 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1854,7 +1854,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
-			       size_t buf_size,
+			       size_t *buf_size,
 			       char *buf,
 			       unsigned long *sk_offset,
 			       int *num_found)
@@ -1887,7 +1887,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (!key_in_sk(key, sk))
 			continue;
 
-		if (sizeof(sh) + item_len > buf_size) {
+		if (sizeof(sh) + item_len > *buf_size) {
 			if (*num_found) {
 				ret = 1;
 				goto overflow;
@@ -1898,11 +1898,12 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			 * handle -EOVERFLOW
 			 */
 
+			*buf_size = sizeof(sh) + item_len;
 			item_len = 0;
 			ret = -EOVERFLOW;
 		}
 
-		if (sizeof(sh) + item_len + *sk_offset > buf_size) {
+		if (sizeof(sh) + item_len + *sk_offset > *buf_size) {
 			ret = 1;
 			goto overflow;
 		}
@@ -1951,7 +1952,7 @@ overflow:
 
 static noinline int search_ioctl(struct inode *inode,
 				 struct btrfs_ioctl_search_key *sk,
-				 size_t buf_size,
+				 size_t *buf_size,
 				 char *buf)
 {
 	struct btrfs_root *root;
@@ -1962,8 +1963,10 @@ static noinline int search_ioctl(struct inode *inode,
 	int num_found = 0;
 	unsigned long sk_offset = 0;
 
-	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
+	if (*buf_size < sizeof(struct btrfs_ioctl_search_header)) {
+		*buf_size = sizeof(struct btrfs_ioctl_search_header);
 		return -EOVERFLOW;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2016,9 +2019,10 @@ err:
 static noinline int btrfs_ioctl_tree_search(struct file *file,
 					   void __user *argp)
 {
-	 struct btrfs_ioctl_search_args *args;
-	 struct inode *inode;
-	 int ret;
+	struct btrfs_ioctl_search_args *args;
+	struct inode *inode;
+	int ret;
+	size_t buf_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2027,8 +2031,10 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	if (IS_ERR(args))
 		return PTR_ERR(args);
 
+	buf_size = sizeof(args->buf);
+
 	inode = file_inode(file);
-	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
+	ret = search_ioctl(inode, &args->key, &buf_size, args->buf);
 
 	/*
 	 * In the origin implementation an overflow is handled by returning a
-- 
1.8.5.3

