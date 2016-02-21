Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33379 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcBUBbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 20:31:23 -0500
From: Simon Quigley <tsimonq2@ubuntu.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Quigley <tsimonq2@ubuntu.com>
Subject: [PATCH 1/3] btrfs: backref: String formatting fixes
Date: Sat, 20 Feb 2016 19:31:12 -0600
Message-Id: <1456018274-7847-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Checkpatch warns about a multi-line string

This fixes that issue and seperates the variables to another line

Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
---
 fs/btrfs/backref.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 956fffa..a2c0595 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1795,9 +1795,9 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		for (cur = 0; cur < btrfs_item_size(eb, item); cur += len) {
 			name_len = btrfs_inode_ref_name_len(eb, iref);
 			/* path must be released before calling iterate()! */
-			pr_debug("following ref at offset %u for inode %llu in "
-				 "tree %llu\n", cur, found_key.objectid,
-				 fs_root->objectid);
+			pr_debug("following ref at offset %u for inode %llu in tree %llu\n",
+				cur, found_key.objectid,
+				fs_root->objectid);
 			ret = iterate(parent, name_len,
 				      (unsigned long)(iref + 1), eb, ctx);
 			if (ret)
-- 
2.7.0

