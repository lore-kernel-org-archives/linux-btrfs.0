Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031065AbbDXRMD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 13:12:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D0F3DADAC
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 17:12:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs: fix warnings after changes in btrfs_abort_transaction
Date: Fri, 24 Apr 2015 19:12:01 +0200
Message-Id: <8b4a3592269ab37c9d6213724886431f6e73a810.1429894863.git.dsterba@suse.cz>
In-Reply-To: <cover.1429894863.git.dsterba@suse.cz>
References: <cover.1429894863.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/volumes.c: In function ‘btrfs_create_uuid_tree’:
fs/btrfs/volumes.c:3909:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘long int’ [-Wformat=]
   btrfs_abort_transaction(trans, tree_root,
   ^
  CC [M]  fs/btrfs/ioctl.o
fs/btrfs/ioctl.c: In function ‘create_subvol’:
fs/btrfs/ioctl.c:549:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘long int’ [-Wformat=]
   btrfs_abort_transaction(trans, root, PTR_ERR(new_root));

PTR_ERR returns long, but we're really using 'int' for the error codes
everywhere so just set and use the local variable.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c   | 2 +-
 fs/btrfs/volumes.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b931ba5..75bb2f011f1b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -546,8 +546,8 @@ static noinline int create_subvol(struct inode *dir,
 	key.offset = (u64)-1;
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
 	if (IS_ERR(new_root)) {
-		btrfs_abort_transaction(trans, root, PTR_ERR(new_root));
 		ret = PTR_ERR(new_root);
+		btrfs_abort_transaction(trans, root, ret);
 		goto fail;
 	}
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f74147..029ba2ab5c4b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3906,9 +3906,9 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	uuid_root = btrfs_create_tree(trans, fs_info,
 				      BTRFS_UUID_TREE_OBJECTID);
 	if (IS_ERR(uuid_root)) {
-		btrfs_abort_transaction(trans, tree_root,
-					PTR_ERR(uuid_root));
-		return PTR_ERR(uuid_root);
+		ret = PTR_ERR(uuid_root);
+		btrfs_abort_transaction(trans, tree_root, ret);
+		return ret;
 	}
 
 	fs_info->uuid_root = uuid_root;
-- 
2.1.3

