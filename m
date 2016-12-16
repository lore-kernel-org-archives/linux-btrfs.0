Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33735 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759890AbcLPMVi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 07:21:38 -0500
From: Colin King <colin.king@canonical.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix dereference on inode->i_sb before inode null check
Date: Fri, 16 Dec 2016 12:20:56 +0000
Message-Id: <20161216122056.20607-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

inode is being deferenced and then inode is checked to see if it
is null, implying we potentially could have a null pointer deference
on inode.

Found with static analysis by CoverityScan, CID 1389472

Fix this by dereferencing inode only after the inode null check.

Fixes: 0b246afa62b0cf5 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 340d907..b746d2b 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -223,7 +223,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 {
 	struct inode *inode = d_inode(child);
 	struct inode *dir = d_inode(parent);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_path *path;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_inode_ref *iref;
@@ -241,6 +241,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	if (!S_ISDIR(dir->i_mode))
 		return -EINVAL;
 
+	fs_info = btrfs_sb(inode->i_sb);
 	ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
-- 
2.10.2

