Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45081 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbcLBFHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1DF2ABD1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:48 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 08/18] btrfs: root->fs_info cleanup, io_ctl_init
Date: Fri,  2 Dec 2016 00:07:28 -0500
Message-Id: <1480655258-15400-9-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The io_ctl->root member was only being used to access root->fs_info.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h            |  2 +-
 fs/btrfs/free-space-cache.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9a3ca79..15ff880 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -519,7 +519,7 @@ struct btrfs_io_ctl {
 	void *cur, *orig;
 	struct page *page;
 	struct page **pages;
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	struct inode *inode;
 	unsigned long size;
 	int index;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a538133..d2320ee 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -303,7 +303,7 @@ static int readahead_cache(struct inode *inode)
 }
 
 static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
-		       struct btrfs_root *root, int write)
+		       int write)
 {
 	int num_pages;
 	int check_crcs = 0;
@@ -325,7 +325,7 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 		return -ENOMEM;
 
 	io_ctl->num_pages = num_pages;
-	io_ctl->root = root;
+	io_ctl->fs_info = btrfs_sb(inode->i_sb);
 	io_ctl->check_crcs = check_crcs;
 	io_ctl->inode = inode;
 
@@ -448,7 +448,7 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 
 	gen = io_ctl->cur;
 	if (le64_to_cpu(*gen) != generation) {
-		btrfs_err_rl(io_ctl->root->fs_info,
+		btrfs_err_rl(io_ctl->fs_info,
 			"space cache generation (%llu) does not match inode (%llu)",
 				*gen, generation);
 		io_ctl_unmap_page(io_ctl);
@@ -504,7 +504,7 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 			      PAGE_SIZE - offset);
 	btrfs_csum_final(crc, (u8 *)&crc);
 	if (val != crc) {
-		btrfs_err_rl(io_ctl->root->fs_info,
+		btrfs_err_rl(io_ctl->fs_info,
 			"csum mismatch on free space cache");
 		io_ctl_unmap_page(io_ctl);
 		return -EIO;
@@ -722,7 +722,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (!num_entries)
 		return 0;
 
-	ret = io_ctl_init(&io_ctl, inode, root, 0);
+	ret = io_ctl_init(&io_ctl, inode, 0);
 	if (ret)
 		return ret;
 
@@ -1229,7 +1229,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		return -EIO;
 
 	WARN_ON(io_ctl->pages);
-	ret = io_ctl_init(io_ctl, inode, root, 1);
+	ret = io_ctl_init(io_ctl, inode, 1);
 	if (ret)
 		return ret;
 
-- 
2.7.1

