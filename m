Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbeC0HTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8DD64B047
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/10] btrfs-progs: Drop ext_ref argument from check_inode_item
Date: Tue, 27 Mar 2018 10:19:25 +0300
Message-Id: <1522135172-8276-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can derive this argument from root->fs_info and also make it local
to the sole switch case it's used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 2c7b270a3ffa..e26e9bdf3bb3 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1918,13 +1918,10 @@ static bool has_orphan_item(struct btrfs_root *root, u64 ino)
  * 2. check inode ref/extref
  * 3. check dir item/index
  *
- * @ext_ref:	the EXTENDED_IREF feature
- *
  * Return 0 if no error occurred.
  * Return >0 for error or hit the traversal is done(by error bitmap)
  */
-static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
-			    unsigned int ext_ref)
+static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 {
 	struct extent_buffer *node;
 	struct btrfs_inode_item *ii;
@@ -1993,6 +1990,9 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 			err |= ret;
 			break;
 		case BTRFS_INODE_EXTREF_KEY:
+		{
+			bool ext_ref = btrfs_fs_incompat(root->fs_info,
+							 EXTENDED_IREF);
 			if (key.type == BTRFS_INODE_EXTREF_KEY && !ext_ref)
 				warning("root %llu EXTREF[%llu %llu] isn't supported",
 					root->objectid, key.objectid,
@@ -2001,6 +2001,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 						 mode);
 			err |= ret;
 			break;
+		}
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
 			if (!dir) {
@@ -2171,7 +2172,7 @@ static int process_one_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	path->slots[0] = i;
 
 again:
-	err |= check_inode_item(root, path, ext_ref);
+	err |= check_inode_item(root, path);
 
 	/* modify cur since check_inode_item may change path */
 	cur = path->nodes[0];
-- 
2.7.4

