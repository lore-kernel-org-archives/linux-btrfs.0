Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17617 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727099AbeIQMsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 08:48:15 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 3EF5A4B6EC83
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 15:21:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 1/7] btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
Date: Mon, 17 Sep 2018 15:28:46 +0800
Message-ID: <20180917072852.25831-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The argument index is not used in btrfs_lookup_inode_extref(),
so remove it.
And adjust positions its arguments to make it consistent with
kernel part.

No functional change.

Fixes: 260675657767 ("btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h      | 9 +++++----
 inode-item.c | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/ctree.h b/ctree.h
index 2a2437070ef9..541055a335c2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2710,10 +2710,11 @@ int btrfs_insert_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, struct btrfs_path *path,
 		       struct btrfs_key *location, int mod);
-struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
-		*trans, struct btrfs_path *path, struct btrfs_root *root,
-		u64 ino, u64 parent_ino, u64 index, const char *name,
-		int namelen, int ins_len);
+struct btrfs_inode_extref *
+btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, struct btrfs_path *path,
+			  const char *name, int namelen, u64 ino,
+			  u64 parent_ino, int ins_len);
 int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
diff --git a/inode-item.c b/inode-item.c
index 1cc106670cd4..ca0052bc2f87 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -227,10 +227,11 @@ static int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 	return 0;
 }
 
-struct btrfs_inode_extref *btrfs_lookup_inode_extref(struct btrfs_trans_handle
-		*trans, struct btrfs_path *path, struct btrfs_root *root,
-		u64 ino, u64 parent_ino, u64 index, const char *name,
-		int namelen, int ins_len)
+struct btrfs_inode_extref *
+btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, struct btrfs_path *path,
+			  const char *name, int namelen, u64 ino,
+			  u64 parent_ino, int ins_len)
 {
 	struct btrfs_key key;
 	struct btrfs_inode_extref *extref;
-- 
2.17.1
