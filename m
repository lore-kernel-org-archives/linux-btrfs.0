Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39875 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaA3A1t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 19:27:49 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so1256626eaj.18
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 16:27:48 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id k41sm15291668eey.0.2014.01.29.16.27.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 29 Jan 2014 16:27:47 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv3 2/6] btrfs: copy_to_sk returns EOVERFLOW for too small buffer
Date: Thu, 30 Jan 2014 01:27:27 +0100
Message-Id: <1391041651-15689-3-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
References: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
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
index 6aa79e0..04e1a98 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1887,8 +1887,20 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (!key_in_sk(key, sk))
 			continue;
 
-		if (sizeof(sh) + item_len > buf_size)
+		if (sizeof(sh) + item_len > buf_size) {
+			if (*num_found) {
+				ret = 1;
+				goto overflow;
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
+			goto overflow;
+
 		if (*num_found >= sk->nr_items)
 			break;
 	}
@@ -1990,7 +2005,8 @@ static noinline int search_ioctl(struct inode *inode,
 			break;
 
 	}
-	ret = 0;
+	if (ret > 0)
+		ret = 0;
 err:
 	sk->nr_items = num_found;
 	btrfs_free_path(path);
@@ -2013,6 +2029,14 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 
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

