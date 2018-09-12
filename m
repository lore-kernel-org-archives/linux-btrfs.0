Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43377 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id f66-v6so829294plb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:11 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 1/6] btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
Date: Wed, 12 Sep 2018 19:20:38 +0000
Message-Id: <20180912192046.5861-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
References: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

The argument index is not used in btrfs_lookup_inode_extref(),
so remove it.
And adjust positions its arguments to make it consistent with
kernel part.

No functional change.

Fixes: 260675657767 ("btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 ctree.h      | 6 +++---
 inode-item.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 4719962df67d..e7f6c5df95f1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2708,9 +2708,9 @@ int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, struct btrfs_path *path,
 		       struct btrfs_key *location, int mod);
 struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
-		*trans, struct btrfs_path *path, struct btrfs_root *root,
-		u64 ino, u64 parent_ino, u64 index, const char *name,
-		int namelen, int ins_len);
+		*trans, struct btrfs_root *root, struct btrfs_path *path,
+		const char *name, int namelen, u64 ino, u64 parent_ino,
+		int ins_len);
 int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
diff --git a/inode-item.c b/inode-item.c
index 1cc106670cd4..461557cb83d6 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -228,9 +228,9 @@ static int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 }
 
 struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
-		*trans, struct btrfs_path *path, struct btrfs_root *root,
-		u64 ino, u64 parent_ino, u64 index, const char *name,
-		int namelen, int ins_len)
+		*trans, struct btrfs_root *root, struct btrfs_path *path,
+		const char *name, int namelen, u64 ino, u64 parent_ino,
+		int ins_len)
 {
 	struct btrfs_key key;
 	struct btrfs_inode_extref *extref;
-- 
2.18.0
