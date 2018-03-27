Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52203 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbeC0HTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48AA9B046
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/10] btrfs-progs: Drop ext_ref param from check_dir_item
Date: Tue, 27 Mar 2018 10:19:24 +0300
Message-Id: <1522135172-8276-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This parameter is no longer used in this function, so drop it

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index a8a2f76549a2..2c7b270a3ffa 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1188,14 +1188,12 @@ static void print_dir_item_err(struct btrfs_root *root, struct btrfs_key *key,
  * @key:	the key of the INODE_REF/INODE_EXTREF
  * @path:       the path
  * @size:	the st_size of the INODE_ITEM
- * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error occurred.
  * Return DIR_COUNT_AGAIN if the isize of the inode should be recalculated.
  */
 static int check_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
-			  struct btrfs_path *path, u64 *size,
-			  unsigned int ext_ref)
+			  struct btrfs_path *path, u64 *size)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_inode_item *ii;
@@ -2011,7 +2009,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 					imode_to_type(mode), key.objectid,
 					key.offset);
 			}
-			ret = check_dir_item(root, &key, path, &size, ext_ref);
+			ret = check_dir_item(root, &key, path, &size);
 			err |= ret;
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
-- 
2.7.4

