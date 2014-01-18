Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35967 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaARAQV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:16:21 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so2020242ead.6
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 16:16:20 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id z46sm30832425een.1.2014.01.17.16.16.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 17 Jan 2014 16:16:18 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 3/5] btrfs: copy_to_sk returns EOVERFLOW for too small buffer
Date: Sat, 18 Jan 2014 01:15:51 +0100
Message-Id: <1390004153-4228-4-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390004153-4228-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1390004153-4228-1-git-send-email-Gerhard@Heift.Name>

In copy_to_sk, if an item is too large for the given buffer, it now returns
-EOVERFLOW instead of copying a search_header with len = 0. For backward
compatibility for the first item it still copies such a header to the buffer,
but not any other following items, which could have fitted.

tree_search changes -EOVERFLOW back to 0 to behave similiar to the way it
behaved before this patch.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 919d928..9fa222d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1883,8 +1883,15 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (!key_in_sk(key, sk))
 			continue;
 
-		if (sizeof(sh) + item_len > buf_size)
+		if (sizeof(sh) + item_len > buf_size) {
+			if (*num_found) {
+				ret = 1;
+				goto overflow;
+			}
+
 			item_len = 0;
+			ret = -EOVERFLOW;
+		}
 
 		if (sizeof(sh) + item_len + *sk_offset > buf_size) {
 			ret = 1;
@@ -1910,6 +1917,9 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		}
 		(*num_found)++;
 
+		if (ret) /* -EOVERFLOW from above */
+			goto overflow;
+
 		if (*num_found >= sk->nr_items)
 			break;
 	}
@@ -1990,7 +2000,8 @@ static noinline int search_ioctl(struct inode *inode,
 			break;
 
 	}
-	ret = 0;
+	if (ret > 0)
+		ret = 0;
 err:
 	sk->nr_items = num_found;
 	btrfs_free_path(path);
@@ -2013,6 +2024,8 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 
 	inode = file_inode(file);
 	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
+	if (ret == -EOVERFLOW)
+		ret = 0;
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
 		ret = -EFAULT;
 	kfree(args);
-- 
1.8.5.3

