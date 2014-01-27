Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43630 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaA0N3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:29:02 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so2268501eek.38
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:29:01 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id v7sm42519249eel.2.2014.01.27.05.29.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:29:00 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2 3/6] btrfs: copy_to_sk returns EOVERFLOW for too small buffer
Date: Mon, 27 Jan 2014 14:28:29 +0100
Message-Id: <1390829312-814-4-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
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

