Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20770 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751526AbdFAIze (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 04:55:34 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 9/9] btrfs: Verify dir_item 'in iterate_object_props'
Date: Thu, 1 Jun 2017 16:57:16 +0800
Message-ID: <20170601085716.25898-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call 'Verify dir_item' before memcmp_extent_buffer.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/props.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index d6cb155ef7a1..4b23ae5d0e5c 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -164,6 +164,7 @@ static int iterate_object_props(struct btrfs_root *root,
 						 size_t),
 				void *ctx)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	char *name_buf = NULL;
 	char *value_buf = NULL;
@@ -214,6 +215,12 @@ static int iterate_object_props(struct btrfs_root *root,
 			name_ptr = (unsigned long)(di + 1);
 			data_ptr = name_ptr + name_len;
 
+			if (verify_dir_item(fs_info, leaf,
+					    path->slots[0], di)) {
+				ret = -EIO;
+				goto out;
+			}
+
 			if (name_len <= XATTR_BTRFS_PREFIX_LEN ||
 			    memcmp_extent_buffer(leaf, XATTR_BTRFS_PREFIX,
 						 name_ptr,
-- 
2.13.0



