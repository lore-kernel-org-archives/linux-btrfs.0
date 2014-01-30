Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35946 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaA3PYQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:16 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so1734164eak.28
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:15 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id 46sm23592770ees.4.2014.01.30.07.24.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:15 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 3/7] btrfs: tree_search, copy_to_sk: return EOVERFLOW for too small buffer
Date: Thu, 30 Jan 2014 16:23:59 +0100
Message-Id: <1391095443-20287-4-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In copy_to_sk, if an item is too large for the given buffer, it now returns
-EOVERFLOW instead of copying a search_header with len = 0. For backward
compatibility for the first item it still copies such a header to the buffer,
but not any other following items, which could have fitted.

tree_search changes -EOVERFLOW back to 0 to behave similiar to the way it
behaved before this patch.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9b66eac..4e32ac2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1887,8 +1887,20 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (!key_in_sk(key, sk))
 			continue;
 
-		if (sizeof(sh) + item_len > buf_size)
+		if (sizeof(sh) + item_len > buf_size) {
+			if (*num_found) {
+				ret = 1;
+				goto out;
+			}
+
+			/*
+			 * return one empty item back for v1, which does not
+			 * handle -EOVERFLOW
+			 */
+
 			item_len = 0;
+			ret = -EOVERFLOW;
+		}
 
 		if (sizeof(sh) + item_len + *sk_offset > buf_size) {
 			ret = 1;
@@ -1914,6 +1926,9 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		}
 		(*num_found)++;
 
+		if (ret) /* -EOVERFLOW from above */
+			goto out;
+
 		if (*num_found >= sk->nr_items) {
 			ret = 1;
 			goto out;
@@ -1992,7 +2007,8 @@ static noinline int search_ioctl(struct inode *inode,
 			break;
 
 	}
-	ret = 0;
+	if (ret > 0)
+		ret = 0;
 err:
 	sk->nr_items = num_found;
 	btrfs_free_path(path);
@@ -2015,6 +2031,14 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 
 	inode = file_inode(file);
 	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
+
+	/*
+	 * In the origin implementation an overflow is handled by returning a
+	 * search header with a len of zero, so reset ret.
+	 */
+	if (ret == -EOVERFLOW)
+		ret = 0;
+
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
 	kfree(args);
-- 
1.8.5.3

