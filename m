Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55942 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3JIX26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 19:28:58 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v2] btrfs: Fix memory leakage in the tree-log.c
Date: Wed,  9 Oct 2013 20:24:34 -0300
Message-Id: <1381361074-28486-1-git-send-email-geyslan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases, add_inode_ref() is returning without freeing
the 'name' pointer.

Added bail out to explicitly call kfree when necessary.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/btrfs/tree-log.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..727d4ff 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1170,13 +1170,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			if (!dir)
 				dir = read_one_inode(root, parent_objectid);
 			if (!dir)
-				return -ENOENT;
+			{
+				ret = -ENOENT;
+				goto bail;
+			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
 					     &ref_index);
 		}
 		if (ret)
-			return ret;
+			goto bail;
 
 		/* if we already have a perfect match, we're done */
 		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
@@ -1214,7 +1217,6 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 		}
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
-		kfree(name);
 		if (log_ref_ver) {
 			iput(dir);
 			dir = NULL;
@@ -1227,6 +1229,9 @@ out:
 	btrfs_release_path(path);
 	iput(dir);
 	iput(inode);
+bail:
+	if (name)
+		kfree(name);
 	return ret;
 }
 
-- 
1.8.4

