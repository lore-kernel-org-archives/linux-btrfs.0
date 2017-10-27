Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54482 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJ0H37 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 27 Oct 2017 03:29:59 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 6/8] btrfs-progs: mkfs: Introduce function to insert qgroup info and limit items
Date: Fri, 27 Oct 2017 15:29:34 +0800
Message-Id: <20171027072936.4697-7-wqu@suse.com>
In-Reply-To: <20171027072936.4697-1-wqu@suse.com>
References: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, insert_qgroup_items(), to insert qgroup info
item and qgroup limit item for later mkfs qgroup support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 1d72702414bc..c50e7e74daf1 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -702,6 +702,40 @@ static void update_chunk_allocation(struct btrfs_fs_info *fs_info,
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
2.14.3

