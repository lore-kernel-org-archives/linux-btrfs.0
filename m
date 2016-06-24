Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbcFXWPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 337A6ADDC
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 22/31] btrfs: root->fs_info cleanup, io_ctl_init
Date: Fri, 24 Jun 2016 18:15:15 -0400
Message-Id: <1466806524-27508-23-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
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
index 784f003..4660ce4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -513,7 +513,7 @@ struct btrfs_io_ctl {
 	void *cur, *orig;
 	struct page *page;
 	struct page **pages;
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	struct inode *inode;
 	unsigned long size;
 	int index;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5cbfa64..b3face3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -305,7 +305,7 @@ static int readahead_cache(struct inode *inode)
 }
 
 static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
-		       struct btrfs_root *root, int write)
+		       int write)
 {
 	int num_pages;
 	int check_crcs = 0;
@@ -327,7 +327,7 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 		return -ENOMEM;
 
 	io_ctl->num_pages = num_pages;
-	io_ctl->root = root;
+	io_ctl->fs_info = btrfs_sb(inode->i_sb);
 	io_ctl->check_crcs = check_crcs;
 	io_ctl->inode = inode;
 
@@ -450,7 +450,7 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 
 	gen = io_ctl->cur;
 	if (le64_to_cpu(*gen) != generation) {
-		btrfs_err_rl(io_ctl->root->fs_info,
+		btrfs_err_rl(io_ctl->fs_info,
 			"space cache generation (%llu) does not match inode (%llu)",
 				*gen, generation);
 		io_ctl_unmap_page(io_ctl);
@@ -506,7 +506,7 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 			      PAGE_SIZE - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	if (val != crc) {
-		btrfs_err_rl(io_ctl->root->fs_info,
+		btrfs_err_rl(io_ctl->fs_info,
 			"csum mismatch on free space cache");
 		io_ctl_unmap_page(io_ctl);
 		return -EIO;
@@ -725,7 +725,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (!num_entries)
 		return 0;
 
-	ret = io_ctl_init(&io_ctl, inode, root, 0);
+	ret = io_ctl_init(&io_ctl, inode, 0);
 	if (ret)
 		return ret;
 
@@ -1230,7 +1230,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		return -EIO;
 
 	WARN_ON(io_ctl->pages);
-	ret = io_ctl_init(io_ctl, inode, root, 1);
+	ret = io_ctl_init(io_ctl, inode, 1);
 	if (ret)
 		return ret;
 
-- 
2.7.1

