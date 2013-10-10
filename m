Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46788 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJCF4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 22:05:56 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, joe@perches.com, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v4] btrfs: Fix memory leakage in the tree-log.c
Date: Wed,  9 Oct 2013 23:01:35 -0300
Message-Id: <1381370495-13702-1-git-send-email-geyslan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When 'dir' is NULL, after calling extref_get_fields(), add_inode_ref()
can be returning without freeing the 'name' pointer.

Added kfree when necessary.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/btrfs/tree-log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..63c0b72 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1169,8 +1169,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			 */
 			if (!dir)
 				dir = read_one_inode(root, parent_objectid);
-			if (!dir)
+			if (!dir) {
+				if (!ret)
+					kfree(name);
 				return -ENOENT;
+			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
 					     &ref_index);
-- 
1.8.4

