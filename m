Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34738 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHTIqm (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 20 Aug 2014 04:46:42 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: lists@colorremedies.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v5] Btrfs: send, lower mem requirements for processing xattrs
Date: Wed, 20 Aug 2014 10:45:45 +0100
Message-Id: <1408527945-1652-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407716706-5115-1-git-send-email-fdmanana@suse.com>
References: <1407716706-5115-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maximum xattr size can be up to nearly the leaf size. For an fs with a
leaf size larger than the page size, using kmalloc requires allocating
multiple pages that are contiguous, which might not be possible if
there's heavy memory fragmentation. Therefore fallback to vmalloc if
we fail to allocate with kmalloc. Also start with a smaller buffer size,
since xattr values typically are smaller than a page.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use is_vmalloc_addr() instead of keeping a boolean variable around.
V3: Use krealloc instead of kfree + kmalloc.
V4: Fixed a checkpatch warning about missing blank line after var declaration.
V5: Use kvfree() and pass __GFP_NOWARN to krealloc().

 fs/btrfs/send.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3c63b29..3290da9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1006,11 +1006,13 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	int num;
 	u8 type;
 
-	if (found_key->type == BTRFS_XATTR_ITEM_KEY)
-		buf_len = BTRFS_MAX_XATTR_SIZE(root);
-	else
-		buf_len = PATH_MAX;
-
+	/*
+	 * Start with a small buffer (1 page). If later we end up needing more
+	 * space, which can happen for xattrs on a fs with a leaf size greater
+	 * then the page size, attempt to increase the buffer. Typically xattr
+	 * values are small.
+	 */
+	buf_len = PATH_MAX;
 	buf = kmalloc(buf_len, GFP_NOFS);
 	if (!buf) {
 		ret = -ENOMEM;
@@ -1037,7 +1039,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 				ret = -ENAMETOOLONG;
 				goto out;
 			}
-			if (name_len + data_len > buf_len) {
+			if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root)) {
 				ret = -E2BIG;
 				goto out;
 			}
@@ -1045,12 +1047,34 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 			/*
 			 * Path too long
 			 */
-			if (name_len + data_len > buf_len) {
+			if (name_len + data_len > PATH_MAX) {
 				ret = -ENAMETOOLONG;
 				goto out;
 			}
 		}
 
+		if (name_len + data_len > buf_len) {
+			buf_len = name_len + data_len;
+			if (is_vmalloc_addr(buf)) {
+				vfree(buf);
+				buf = NULL;
+			} else {
+				char *tmp = krealloc(buf, buf_len,
+						     GFP_NOFS | __GFP_NOWARN);
+
+				if (!tmp)
+					kfree(buf);
+				buf = tmp;
+			}
+			if (!buf) {
+				buf = vmalloc(buf_len);
+				if (!buf) {
+					ret = -ENOMEM;
+					goto out;
+				}
+			}
+		}
+
 		read_extent_buffer(eb, buf, (unsigned long)(di + 1),
 				name_len + data_len);
 
@@ -1071,7 +1095,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 	}
 
 out:
-	kfree(buf);
+	kvfree(buf);
 	return ret;
 }
 
-- 
1.9.1

