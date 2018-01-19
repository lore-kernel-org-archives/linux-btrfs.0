Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54933 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeASHZr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 02:25:47 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
Subject: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype validaction check for btrfs_match_dir_item_name
Date: Fri, 19 Jan 2018 15:25:35 +0800
Message-Id: <20180119072536.22286-3-wqu@suse.com>
In-Reply-To: <20180119072536.22286-1-wqu@suse.com>
References: <20180119072536.22286-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_match_dir_item_name() will check if its filetype is valid before
doing search, this makes btrfs-progs unable to locate and remove invalid
dir_index for btrfs_unlink().

This function only affects btrfs_link() and btrfs_unlink() in upper
layer, and normal check can find invalid filetype by itself.

So remove the filetype check is completely safe in this case, and will
enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 dir-item.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/dir-item.c b/dir-item.c
index 462546c0eaf4..e0a0ab4d7a5d 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *root,
 	u16 namelen = BTRFS_NAME_LEN;
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
-	if (type >= BTRFS_FT_MAX) {
-		fprintf(stderr, "invalid dir item type: %d\n",
-		       (int)type);
-		return 1;
-	}
-
 	if (type == BTRFS_FT_XATTR)
 		namelen = XATTR_NAME_MAX;
 
-- 
2.15.1

