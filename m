Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31983 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751532AbdFFJz3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:29 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 4/9] btrfs: Verify dir_item in replay_xattr_deletes
Date: Tue, 6 Jun 2017 17:57:03 +0800
Message-ID: <20170606095708.494-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'replay_xattr_deletes' calls 'btrfs_search_slot' to get buffer and
reads name.

Call 'verify_dir_item' to check name_len in 'replay_xattr_deletes'
in avoid of read out of boundary.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 11cf38fb3a49..06c7ceb07282 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2111,6 +2111,7 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path,
 			      const u64 ino)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key search_key;
 	struct btrfs_path *log_path;
 	int i;
@@ -2152,6 +2153,12 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			char *name;
 
+			ret = verify_dir_item(fs_info, path->nodes[0],
+					      path->slots[0], di);
+			if (ret) {
+				ret = -EIO;
+				goto out;
+			}
 			name = kmalloc(name_len, GFP_NOFS);
 			if (!name) {
 				ret = -ENOMEM;
-- 
2.13.0



