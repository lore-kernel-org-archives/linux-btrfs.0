Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57985 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbeFTOf6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:35:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Nikolay Borisov <nborisov@suse.com>, Omar Sandoval <osandov@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] btrfs: use timespec64 for i_otime
Date: Wed, 20 Jun 2018 16:34:34 +0200
Message-Id: <20180620143448.44388-3-arnd@arndb.de>
In-Reply-To: <20180620143448.44388-1-arnd@arndb.de>
References: <20180620143448.44388-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While the regular inode timestamps all use timespec64 now, the
i_otime field is btrfs specific and still needs to be converted
to correctly represent times beyond 2038.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/btrfs_inode.h | 2 +-
 fs/btrfs/inode.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 7e075343daa5..1343ac57b438 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -178,7 +178,7 @@ struct btrfs_inode {
 	struct btrfs_delayed_node *delayed_node;
 
 	/* File creation time. */
-	struct timespec i_otime;
+	struct timespec64 i_otime;
 
 	/* Hook into fs_info->delayed_iputs */
 	struct list_head delayed_iput;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e9482f0db9d0..22dcc8afd38f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5745,7 +5745,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 	inode->i_mtime = current_time(inode);
 	inode->i_atime = inode->i_mtime;
 	inode->i_ctime = inode->i_mtime;
-	BTRFS_I(inode)->i_otime = timespec64_to_timespec(inode->i_mtime);
+	BTRFS_I(inode)->i_otime = inode->i_mtime;
 
 	return inode;
 }
@@ -6349,7 +6349,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	inode->i_mtime = current_time(inode);
 	inode->i_atime = inode->i_mtime;
 	inode->i_ctime = inode->i_mtime;
-	BTRFS_I(inode)->i_otime = timespec64_to_timespec(inode->i_mtime);
+	BTRFS_I(inode)->i_otime = inode->i_mtime;
 
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				  struct btrfs_inode_item);
-- 
2.9.0

