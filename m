Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31983 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751527AbdFFJzU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:20 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 7/9] btrfs: Check name_len before read in btrfs_get_name
Date: Tue, 6 Jun 2017 17:57:06 +0800
Message-ID: <20170606095708.494-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In 'btrfs_get_name', it does 'btrfs_search_slot' and reads name from
inode_ref/root_ref.

Call btrfs_is_name_len_valid in btrfs_get_name.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/export.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 87144c9f9593..fa66980726c9 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -282,6 +282,11 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		name_len = btrfs_inode_ref_name_len(leaf, iref);
 	}
 
+	ret = btrfs_is_name_len_valid(leaf, path->slots[0], name_ptr, name_len);
+	if (!ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
 	read_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_free_path(path);
 
-- 
2.13.0



