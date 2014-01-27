Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48495 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaA0N3J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:29:09 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so2271684eek.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:29:08 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id a8sm36673792eeo.3.2014.01.27.05.29.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:29:07 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2 6/6] btrfs: in tree_search extent buffer lifetime
Date: Mon, 27 Jan 2014 14:28:32 +0100
Message-Id: <1390829312-814-7-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of allocting and releasing a buffer for each leaf, which will be
visited during a search, allocate (and expand) a buffer for the whole search.
This saves a few allocations and deallocations during larger searchs, which
visits more leafs.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 38403e6..ec7d759 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1852,6 +1852,8 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			       struct btrfs_ioctl_search_key *sk,
 			       size_t buf_size,
 			       char __user *buf,
+			       size_t *content_buffer_size,
+			       char **content_buffer,
 			       unsigned long *sk_offset,
 			       int *num_found)
 {
@@ -1865,9 +1867,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	int slot;
 	int ret = 0;
 
-	char *content_buffer = NULL;
-	unsigned long content_buffer_size = 0;
-
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	nritems = btrfs_header_nritems(leaf);
@@ -1917,28 +1916,28 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 
 		if (item_len) {
 			/* resize internal buffer if needed */
-			if (content_buffer_size < item_len) {
-				kfree(content_buffer);
+			if (*content_buffer_size < item_len) {
+				kfree(*content_buffer);
 
-				content_buffer_size =
+				*content_buffer_size =
 					ALIGN(item_len, PAGE_SIZE);
 
-				content_buffer = kmalloc_track_caller(
-					content_buffer_size, GFP_KERNEL);
+				*content_buffer = kmalloc_track_caller(
+					*content_buffer_size, GFP_KERNEL);
 
-				if (!content_buffer) {
-					content_buffer_size = 0;
+				if (!*content_buffer) {
+					*content_buffer_size = 0;
 					ret = -ENOMEM;
 					goto err;
 				}
 			}
 
 			/* copy the item */
-			read_extent_buffer(leaf, content_buffer,
+			read_extent_buffer(leaf, *content_buffer,
 					   item_off, item_len);
 
 			if (copy_to_user(buf + *sk_offset,
-					 content_buffer, item_len)) {
+					 *content_buffer, item_len)) {
 				ret = -EFAULT;
 				goto err;
 			}
@@ -1976,8 +1975,6 @@ err:
 	    -ENOMEM: could not allocate memory for a temporary extent buffer
 	    -EFAULT: could not copy extent buffer back to userspace
 	*/
-	kfree(content_buffer);
-
 	return ret;
 }
 
@@ -1995,6 +1992,9 @@ static noinline int search_ioctl(struct inode *inode,
 	int num_found = 0;
 	unsigned long sk_offset = 0;
 
+	char *content_buffer = NULL;
+	size_t content_buffer_size = 0;
+
 	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
 		return -EOVERFLOW;
 
@@ -2035,6 +2035,7 @@ static noinline int search_ioctl(struct inode *inode,
 			goto err;
 		}
 		ret = copy_to_sk(root, path, &key, sk, buf_size, buf,
+				 &content_buffer_size, &content_buffer,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
 
@@ -2045,6 +2046,8 @@ static noinline int search_ioctl(struct inode *inode,
 	if (ret > 0)
 		ret = 0;
 err:
+	kfree(content_buffer);
+
 	sk->nr_items = num_found;
 	btrfs_free_path(path);
 	return ret;
-- 
1.8.5.3

