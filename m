Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753225AbeB0OvP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 09:51:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9CCD8ACED
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 14:51:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: adjust return type of btrfs_getxattr
Date: Tue, 27 Feb 2018 15:48:57 +0100
Message-Id: <8ad4925684be4a3741314527ae9a48f89915bc46.1519742886.git.dsterba@suse.com>
In-Reply-To: <cover.1519742886.git.dsterba@suse.com>
References: <cover.1519742886.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The xattr_handler::get prototype returns int, use it. The only ssize_t
exception is the per-inode listxattr handler.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/xattr.c | 2 +-
 fs/btrfs/xattr.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 414ccbe26c71..e1e8177deb5e 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -33,7 +33,7 @@
 #include "locking.h"
 
 
-ssize_t btrfs_getxattr(struct inode *inode, const char *name,
+int btrfs_getxattr(struct inode *inode, const char *name,
 				void *buffer, size_t size)
 {
 	struct btrfs_dir_item *di;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 96e6f3a304d3..57c638730617 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -23,7 +23,7 @@
 
 extern const struct xattr_handler *btrfs_xattr_handlers[];
 
-ssize_t btrfs_getxattr(struct inode *inode, const char *name,
+int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
 int btrfs_setxattr(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
-- 
2.16.2

