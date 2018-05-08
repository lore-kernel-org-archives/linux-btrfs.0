Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42485 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754193AbeEHGcJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D1C8AF68
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 06/12] btrfs-progs: mkfs: Introduce function to insert qgroup info and limit items
Date: Tue,  8 May 2018 14:31:50 +0800
Message-Id: <20180508063156.24665-7-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, insert_qgroup_items(), to insert qgroup info
item and qgroup limit item for later mkfs qgroup support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index b65b18ddf2f3..67b193960aec 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -709,6 +709,40 @@ static void update_chunk_allocation(struct btrfs_fs_info *fs_info,
 	}
 }
 
+static int insert_qgroup_items(struct btrfs_trans_handle *trans,
+			       struct btrfs_fs_info *fs_info,
+			       u64 qgroupid)
+{
+	struct btrfs_path path;
+	struct btrfs_root *quota_root = fs_info->quota_root;
+	struct btrfs_key key;
+	int ret;
+
+	if (qgroupid >> BTRFS_QGROUP_LEVEL_SHIFT) {
+		error("qgroup level other than 0 is not supported yet");
+		return -ENOTTY;
+	}
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_INFO_KEY;
+	key.offset = qgroupid;
+
+	btrfs_init_path(&path);
+	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
+				      sizeof(struct btrfs_qgroup_info_item));
+	btrfs_release_path(&path);
+	if (ret < 0)
+		return ret;
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_LIMIT_KEY;
+	key.offset = qgroupid;
+	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
+				      sizeof(struct btrfs_qgroup_limit_item));
+	btrfs_release_path(&path);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
-- 
2.17.0

