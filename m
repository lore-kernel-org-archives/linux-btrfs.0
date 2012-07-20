Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43122 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2GTRgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 13:36:45 -0400
Received: by ghrr11 with SMTP id r11so4237209ghr.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 10:36:45 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 2/2] Btrfs: Use common function to check lzo INCOMPAT on defrag.
Date: Fri, 20 Jul 2012 12:36:21 -0500
Message-Id: <1342805781-12162-3-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
References: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When defragmenting with explicit lzo compression, simplify
the check for lzo INCOMPAT by using the new common function
introduced to support remounting with lzo compression.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/ioctl.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 17facea..d5fd69e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1042,11 +1042,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      u64 newer_than, unsigned long max_to_defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_super_block *disk_super;
 	struct file_ra_state *ra = NULL;
 	unsigned long last_index;
 	u64 isize = i_size_read(inode);
-	u64 features;
 	u64 last_len = 0;
 	u64 skip = 0;
 	u64 defrag_end = 0;
@@ -1233,11 +1231,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		mutex_unlock(&inode->i_mutex);
 	}
 
-	disk_super = root->fs_info->super_copy;
-	features = btrfs_super_incompat_flags(disk_super);
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-		btrfs_set_super_incompat_flags(disk_super, features);
+		btrfs_chk_lzo_incompat(root);
 	}
 
 	ret = defrag_count;
-- 
1.7.8.6

