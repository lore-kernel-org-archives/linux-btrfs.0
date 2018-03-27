Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58001 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeC0Su6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:58 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA3FBAC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: remove stale comments about fs_mutex
Date: Tue, 27 Mar 2018 20:48:31 +0200
Message-Id: <bd4c8babec70d7a58c0156ea43d0fb9bf433b0a3.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fs_mutex has been killed in 2008, a213501153fd66e2 ("Btrfs: Replace
the big fs_mutex with a collection of other locks"), still remembered in
some comments.

We don't have any extra needs for locking in the ACL handlers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/acl.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 1ba49ebe67da..700a3dfd3129 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -65,9 +65,6 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-/*
- * Needs to be called with fs_mutex held
- */
 static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 			 struct inode *inode, struct posix_acl *acl, int type)
 {
@@ -127,11 +124,6 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	return ret;
 }
 
-/*
- * btrfs_init_acl is already generally called under fs_mutex, so the locking
- * stuff has been fixed to work with that.  If the locking stuff changes, we
- * need to re-evaluate the acl locking stuff.
- */
 int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		   struct inode *inode, struct inode *dir)
 {
-- 
2.16.2

