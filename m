Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750907AbeC0HTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26F65B049
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/10] btrfs-progs: Remove ext_ref param from check_fs_first_inode
Date: Tue, 27 Mar 2018 10:19:27 +0300
Message-Id: <1522135172-8276-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no longer use and can be dropped.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 34519f30a4aa..29c55e202f2b 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4198,7 +4198,7 @@ static int repair_fs_first_inode(struct btrfs_root *root, int err)
  * returns >0 means error
  * returns <0 means fatal error
  */
-static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
+static int check_fs_first_inode(struct btrfs_root *root)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -4290,7 +4290,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 		 * the first inode item in the leaf, if inode item (256) is
 		 * missing we will skip it forever.
 		 */
-		ret = check_fs_first_inode(root, ext_ref);
+		ret = check_fs_first_inode(root);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.7.4

