Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:35482 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaA3PYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:18 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so1741160ead.27
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:17 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id m9sm10398328eeh.3.2014.01.30.07.24.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:16 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 4/7] btrfs: tree_search, copy_to_sk: return needed size on EOVERFLOW
Date: Thu, 30 Jan 2014 16:24:00 +0100
Message-Id: <1391095443-20287-5-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If an item in tree_search is too large to be stored in the given buffer, return
the needed size (including the header).

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4e32ac2..1180293 100644
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
 				goto out;
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
 			goto out;
 		}
@@ -1953,7 +1954,7 @@ out:
 
 static noinline int search_ioctl(struct inode *inode,
 				 struct btrfs_ioctl_search_key *sk,
-				 size_t buf_size,
+				 size_t *buf_size,
 				 char *buf)
 {
 	struct btrfs_root *root;
@@ -1964,8 +1965,10 @@ static noinline int search_ioctl(struct inode *inode,
 	int num_found = 0;
 	unsigned long sk_offset = 0;
 
-	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
+	if (*buf_size < sizeof(struct btrfs_ioctl_search_header)) {
+		*buf_size = sizeof(struct btrfs_ioctl_search_header);
 		return -EOVERFLOW;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2018,9 +2021,10 @@ err:
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
@@ -2029,8 +2033,10 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
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

