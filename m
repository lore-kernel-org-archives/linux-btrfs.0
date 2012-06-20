Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2FTKfM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 06:35:12 -0400
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        chris.mason@fusionio.com, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: allow cross-subvolume file clone
Date: Wed, 20 Jun 2012 12:35:12 +0200
Message-Id: <1340188512-5761-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Lift the EXDEV condition and allow different root trees for files being
cloned, then pass source inode's root when searching for extents.
Cloning is not allowed to cross vfsmounts, ie. when two subvolumes from
one filesystem are mounted separately.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00fd8b5..9e89255 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2352,6 +2352,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		goto out_drop_write;
 	}
 
+	ret = -EXDEV;
+	if (src_file->f_path.mnt != file->f_path.mnt)
+		goto out_fput;
+
 	src = src_file->f_dentry->d_inode;
 
 	ret = -EINVAL;
@@ -2372,7 +2376,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		goto out_fput;
 
 	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
+	if (src->i_sb != inode->i_sb)
 		goto out_fput;
 
 	ret = -ENOMEM;
@@ -2446,13 +2450,14 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
+				0, 0);
 		if (ret < 0)
 			goto out;
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(root, path);
+			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
-- 
1.7.10

