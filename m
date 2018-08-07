Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727216AbeHGKdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:07 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 94D67ADB9
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:54 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/11] btrfs-progs: mkfs: Introduce function to insert qgroup info and limit items
Date: Tue,  7 Aug 2018 16:19:34 +0800
Message-Id: <20180807081938.21348-8-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, insert_qgroup_items(), to insert qgroup info
item and qgroup limit item for later mkfs qgroup support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index b76462a735cf..c6174a7424cf 100644
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
2.18.0

